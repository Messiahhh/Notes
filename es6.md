### ES6和事件循环

#### 一、JavaScript是单线程的，而浏览器是多线程的(解析JavaScript的主线程和其他的工作线程)

前半句应该很好理解，那后半句又是什么意思呢？

那么我们先来想象一下，**如果浏览器只有一条主线程**（用来解析JS）会怎么样。

```javascript
console.log("1")
Ajax("...", function (res) {
    console.log("2")
})
console.log("3")
```

如果只有主线程，那么会先输出１，**一定时间**后接收到响应，再依次输出２、３。而这里的一段时间，就造成了浏览器的阻塞。而事实我们也是清楚的，浏览器会先依次输出１、３，等接收到响应后再输出２，现实情况是并不会发生所谓的阻塞，这就是浏览器的工作线程的功劳。

这里先简单解释一下，当我们的主线程执行到AJAX的时候，I/O操作其实是交给了一个工作线程来处理的，这条工作线程专门用来处理AJAX，而主线程继续执行AJAX下方的代码，当工作线程中得知响应被接收了，就会通知主线程执行回调函数。（注：准确说是先放进任务队列中，晚点说）

因此回调函数的定义也就明确了，由工作线程通知主线程，在某个时间点会调用的函数，虽然大部分情况回调函数都是作为函数参数的存在，但也存在例外，比如

```
xhr.onreadystatechange = function () {
    
}
```

所以严谨来说不能说回调函数就是作为函数参数的函数。



我们再来考虑如何用callback封装一个AJAX。

```
function AJAX(callback) {
    let xhr = new XMLHttpRequest()
    xhr.onreadystatechange = function () {
        if (xhr.readyState === 4 && xhr.status === 200) {
            let res = JSON.parse(xhr.responseText)
            callback(res)
        }
    }
    xhr.open('', '', true)
    xhr.send()
}

Ajax(function (res) {
    console.log(res)
})
```

我们设外部函数自身是执行Ａ操作，内部函数是在执行Ｂ操作，那么从逻辑上看，　我们先进行了Ａ操作，在未来的某个时刻，通过回调的方式进行了Ｂ操作，因此从逻辑上是一种先后的关系。但我们实际的代码中，Ａ和Ｂ操作却是内外的包含关系，不符合直觉，特别是多层嵌套后代码难以审查维护，也就是俗称的回调地狱。所以我们需要一种优雅的方式来写异步。



用Promise改写AJAX。

```javascript
function Ajax() {
    return new Promise((resolve, reject) => {
        let xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4 && xhr.status === 200) {
                let res = JSON.parse(xhr.responseText)
                resolve(res)
            }
        }
        xhr.open('', '', true)
        xhr.send()
    })
}

Ajax().then((data) => {
    console.log(data)
}) 
```

通过Promise的方式，Ａ和Ｂ就形成了一前一后的关系，仿佛是同步的方式来写异步。

不过人们觉得全都是then，语义上比较模糊。刚好此时又出现了Generator，虽然Generator的初衷并非异步，但人们却爱上用它来处理异步。



### Generator

#### 语法

Generator是种特殊的函数，让我们直接上手看下哪里特殊吧。

##### **函数声明**

```javascript
function* A() {
    yield 'a'
    yield 'b'
    return 'c'
}
```

- 在function后面有个星号
- 函数内部使用了yield关键字

##### **函数调用**

```
var x = A()
console.log(x)
```

> Generator 函数的调用方法与普通函数一样，也是在函数名后面加上一对圆括号。不同的是，调用 Generator 函数后，该函数并不执行，返回的也不是函数运行结果，而是一个指向内部状态的指针对象，遍历器对象。

遍历器对象部署了next方法，调用next方法会返回对象，对象具有两个属性

```
x.next()
//{value: 'a'; done: false}
x.next()
//{value: 'b'; done: false}
x.next()
//{value: 'c'; done: true}
```

从现在来看，就是可以一个函数，可以调用，暂停，调用。



##### **给next传递参数**

`next`方法可以带一个参数，该参数就会被当作上一个`yield`表达式的返回值。

相当于在外面改变了函数内部的行为。

而这，也让Generator具有了代替回调地狱的功能。



#### 用Generator实现异步

```javascript
function Ajax() {
    return new Promise((resolve, reject) => {
        let xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4 && xhr.status === 200) {
                let res = JSON.parse(xhr.responseText)
                resolve(res)
            }
        }
        xhr.open('', '', true)
        xhr.send()
    })
}

function* use() {
    let data = yield Ajax('')
    console.log(data)
} 

let obj = use()
obj.next().value.then((res) => {
    obj.next(res)
})
```



当然，唯一不好的地方就是我们需要自己手动的调用next方法，而如果引入co模块就能完美的解决这个问题。

引入co模块前后对比

```javascript
let obj = use()
obj.next().value.then((res) => {
    obj.next(res)
})
//引入前
=====
//引入后
co(use)
```

没错，co模块就是这么简单粗暴。

co模块的代码原理类似如下

```javascript
function co(gen){
  var g = gen();

  function next(data){
    var result = g.next(data);
    if (result.done) return result.value;
    result.value.then(function(data){
      next(data);
    });
  }

  next();
}

co(gen);
```





### Async

#### 语法

```javascript
async A() {
    let data1 = await Ajax('')
    let data2 = await Ajax('')
    return data2
}

A().then((data) => {
    console.log(data)
})
```

其实async可以看成Generator + co的集成，不同的是关键字分别用async和await代替了*和yield，　更加的语义化。除此之外，async函数会返回一个Promise对象。

##### 用Async实现Ajax封装

```javascript
function Ajax() {
    return new Promise((resolve, reject) => {
        let xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4 && xhr.status === 200) {
                let res = JSON.parse(xhr.responseText)
                resolve(res)
            }
        }
        xhr.open('', '', true)
        xhr.send()
    })
}

async use() {
    let data = await Ajax('')
    console.log(data)
}

use()
```







### demo，　来判断输出的顺序

```
//demo1

setTimeout(function(){
	console.log(1)
}, 0);
new Promise(function(resolve){
    console.log(2)
    resolve()
    console.log(3)
}).then(function(){
    console.log(4)
});
console.log(5);




//demo2

console.log(1);

setTimeout(function() {
  console.log(2);
}, 10);

new Promise(resolve => {
    console.log(3);
    resolve();
    setTimeout(() => console.log(4), 10);
}).then(function() {
    console.log(5)
})

console.log(6);


//demo3

new Promise(resolve => {
    resolve(1);
    Promise.resolve().then(() => console.log(2));
    console.log(3)
}).then(t => console.log(t));
console.log(4);
```







### class 语法



### 模块　

amd commonjs(require) exports module.exports　import 



遍历器接口　扩展运算符　for...of 　　　set map





参考

[[JavaScript：彻底理解同步、异步和事件循环(Event Loop)](https://segmentfault.com/a/1190000004322358)](https://segmentfault.com/a/1190000004322358)