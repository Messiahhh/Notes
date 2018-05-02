## 课件

### 初级

0 问： 什么是关键字，保留字

答案：略



1问： JavaScript中有几种基本类型？



答案：

- Undefined
- Null
- Boolean
- Number
- String
- Symbol （ESMAScript6新加的一种基本类型， 表示独一无二的值）

Function和Object是引用类型。

基本类型和引用类型的区别是什么？

基本类型是存放在栈内存的, 栈内存的一个特点， 是大小固定。

而对象的属性是可以不断添加的， 所占用的内存大小也会随之改变， 因此数据不能直接存在栈内存中。而是存放在堆内存中， 而栈内存所保存的是一个指向该堆内存的地址。

![https://pic3.zhimg.com/50/v2-dbf47419e58a8e8c73ed102376aac77e_hd.jpg](https://pic3.zhimg.com/50/v2-dbf47419e58a8e8c73ed102376aac77e_hd.jpg)

2 问： 什么是声明提升？这两个代码块，为什么前者不报错，后者报错？并写出第一个代码块的等价形式

```
console.log(a)
var a = '123'
```

```
console.log(a)
```



答案：

第一个代码块 因为var关键字具有“声明提升”的作用， 会直接提升到作用域的顶部，因此代码等价于

```
var a
console.log(a)
a = '123'
```

另外用function声明的函数也具有同样的声明提升作用。

第二个代码块因为a没有声明， 当然报错了





3 问：什么是引用类型/对象？ 并根据以下代码阐述引用类型和基本类型的区别在哪里？

```javascript
// 为什么上方代码中b的数值还是llp， 下方代码中b的数值是kjj？
var a = 'llp'
var b = a
a = 'kjj'
console.log(b)
//output llp

//----------------------------
var a = {
    name: 'llp'
}
var b = a
a.name = 'kjj'
console.log(b)
//output 
{
	name: 'kjj'
}
```

//顺带一提JavaScript是不需要写分号的 

提示： 栈 堆



答案：

无论是基本类型还是引用类型， 当使用赋值操作的时候， 传递的都是栈内存中保存的值。

因此，上一个代码块中， a和b开始都保存着一样的且独立的值'llp'， 然后改变了变量a的值为'kjj'， 当然不会影响b。

而在第二个代码块中， 因为变量a是引用类型，当执行b = a操作的时候， 实际上是把变量a在栈内存中指向堆内存的地址赋值给了b。因此，a和b变量的栈内存中保存着相同的地址， 都指向同一片堆内存区域。而当我们执行a.name的时候，改变了这边堆内存， 因此，输出变量b的时候， 也是显示改变后的值。





4 问： 为什么两次输出的值不同？ 

```javascript
var age = '12'
var people = {
    name: 'llp'
}
function Hello(num, obj) {
	num = '18'
	obj.name = 'kjj'
    console.log(num, obj)
}
Hello(age, people)
console.log(age, people)
```

 

在这之前我们先聊一下函数。

与数学中的函数一样， 编程语言的函数有多个自变量/输入， 一个因变量/输出。

另外， 函数可以用来封装重复的代码， 增加效率。

声明函数的结构类似如下

```
function A(a, b) {
	
}
```

调用方法如下

```
A(c, d)
```

首先要声明的一点是， 函数内部是个块级作用域。什么意思呢？

比如，我们可以

```
var a = 'llp'
function A() {
	var a = 'kjj'
}
```

我们在函数外面声明了一个变量a， 函数内部也声明了一个a， 这是没有任何影响的， 也就是说， 函数内部和外部是两个不同的作用域（即函数内部是个块级作用域）

回到函数的声明， 函数接受两个参数a和b， 这两个参数叫做形式参数。形式参数是在函数内部的， 当调用函数的时候， 会把实际参数的值赋给函数内部的形式参数。

比如

当调用A(c, d)的时候， 会把变量c和d的值赋给函数内部的形式参数。



最后， 当函数调用完毕的时候， 函数内部的变量会被销毁（也就是JS的内存回收）（当然也包括形参）。（也有例外， 那就是闭包



 另外普通的函数内部有两个特殊的值，arguments和this， argument是个类似数组的对象， 当执行函数的时候， 会把形式参数分别push到这个参数里。如，我们可以用arguments[0]和arguments[1]来获取函数内的第一个和第二个形式参数。



那什么是this？ 

this是函数内部的值

函数调用的时候， 除了会显式的接受参数（也就是实际参数）， 也有隐式参数，这个参数根据如何调用来获取。

比如当调用a.sayTo(b)的时候， 除了实际参数b会传递给函数内部的形式参数， 还会把变量a传递给函数内部的this。



那可不可以手动传递值给函数内的this？ 

当然可以。

我们有call、apply、bind三个方法绑定this。

比如上面的函数a.sayTo(b)， 会把a传递给函数sayTo内部的this， 如果想把this给个变量c的值，可以像这么做

```
a.sayTo.call(c, b)
或者
a.sayTo.apply(c, [b])
```

可以看到call和apply的作用是相同的， 不过是实际参数的传递方式不同而已。

而bind却有点不同

```
var a = {
  
}
function A() {
	
}
var b = A.bind(a)
```

bind函数返回一个函数， 这个函数的this已经被绑定成a了。













答案：

调用函数的时候，实际参数和形式参数也是一个普通的赋值操作（即传递了栈内存中的值），而参数一个是基本类型， 一个是引用类型，因此，在函数内改变num的值不会影响函数外部的age， 而在函数内给obj增加属性， 会改变函数外部的people。







3 问：ECMAScript 和 JavaScript的关系

JavaScript是在浏览器执行的语言， 是因为它有BOM和DOM，前者提供了一些诸如window.open的函数， 后者提供了一些如document.querySelector的函数。 如果想让它在其他非浏览器平台运行的话， 肯定是不能有这两个的， 而JavaScript - BOM - DOM = ECMAScript。 比如Node平台， 内部的语言就是ECMAScript。 当然因为习惯， 即使我们在用Node的时候， 很多时候也是直接叫JavaScript而不是ES。

BTW， 浏览器和Node的关系？V8引擎是用来解释JavaScript这门语言的。

![](http://upload-images.jianshu.io/upload_images/1224650-97528ea484b0f589.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



### 中级

1 JavaScript是没有类的概念的， 它是根据原型链来实现的， 但两者的作用其实是差不多的。

那么请回答：什么是类和对象？说出你的理解

For example。

苹果是一个类， 在超市中看到各种苹果， 都是苹果类的实例。

这些实例继承了苹果类的一些属性， 比如颜色是红色， 吃起来是甜的。

但每个苹果实例之间也有区别， 因为不可能所有水果实例都长一样。



为什么程序中需要类和对象的概念？

比如我们需要100个一样的对象， 难道我们要用循环来生成吗？ 

```
for (var i = 0; i <= 100; i++) {
	arr[i] = {
    	name: 'llp',
    	age: 20
	}
}
```

如果这100个对象， 每一个之间都有点差别， 又如何循环？





2

```javascript
var obj = {
    name: 'llp',
    age: 21
}
console.log(obj.toString)

```

如上代码，我们声明了对象obj，然后输出obj.toString这个函数名（注意toString后没有()， 所以这里不是调用函数， 而是获取对象的值）， 发现并没有报错，而是显示这是一个函数。

但是我们明明没有给obj定义内部的函数啊， 这里的toString函数是从哪来的？//答案在下一问能找到

答案：

继承于Object.prototype





2 

提示：

```
obj.__proto__ === Object.prototype
```



```
var obj = {
    
}
//等价于
var obj = new Object()
```

这里的Object后有个()， 很明显我们知道Object是个函数，不信可以console一下

我们知道，obj会继承Object.prototype这个对象的一些方法， 比如我们可以调用obj.toString函数。

那么这里， Object函数和Object.prototype对象有什么关系呢？（不是问题， 我就逗逗你们）//我问了你们估计也不会

但我们可以知道一点， 如果想生成一个对象， 需要一个函数A， 还有一个对象A.prototype， 就像生孩子那样:D

而Object和Object.prototype这两个是浏览器自带的（天选之子）， 我们能猜到， 所有对象都是继承于Object.prototype。

事实上， 当我们声明一个函数A， 会在后台自动创建对象A.prototype， 而我们上面说了， 只要有函数A， 还有一个对象A.prototype， 就能像生小孩那样，使用

```
var a = new A()
```

这样的方法生成新的对象a

显而易见， 对象a是继承于A.prototype的， 那么A.prototype这个自动生成的对象，又是从哪出来的呢？

答案是： A.prototype 这个对象是Object和Object.prototype的产物， 当我们

```
function A() {
	
}
```

的时候， 系统后台调用new Object()这样生成了对象A.prototype， 另外A.prototype这个函数会自带一个属性construcor，这个属性的值是函数A



这时候，你可以console一下a，会发现一个链式结构的对象。

```
console.log(a)
//输出以下代码
{
    
	__proto__: {
        constructor: f A()
        __proto__: {
        	toString: function() 
        	valueOf: function()
        	...
        	...
        }
	}
}
简化一下，就是(注意， 我标出了X和Y两个区域, 在X和Y区域中给定属性/函数， 就是实现继承的关键)
a:
{
	X
	__proto__: A.prototype
}

A.prototype:
{
	Y
	constructor: f A()
	__proto__: Object.prototype
}

Object.prototype:
{
    toString: function() 
    valueOf: function()
    ...
	...
}

a.__proto__ 指向对象 A.prototype
A.prototype.__proto__ 指向对象 Object.prototype
```

这就是实现了继承，一切对象继承于Object.prototype。

当我们查找属性的时候，现在当前对象中查找， 没有再查看

```
__proto__
```

属性， 一层一层的查找， 也叫按原型链查找。

 不过这时候，a和A.prototype对象我们都没有给指定的值， 因此看不出继承的强大之处。

那么现在我们需要让所有A类的实例都具有一个方法，很简单，当我们调用a.sayHi()的时候， 输出'hi'



请输入你的代码

```
function A() {
    
}
A.prototype.sayHi = function () {
	console.log('hi')
}
```











3

我们有一个Apple类，如下

```
function Apple() {
	
}
Apple.prototype.color = 'red'
Apple.prototype.tasty = 'yummy'
```

这样，所有Apple类的实例都继承了color和tasty值，但不是所有苹果都是一样的，现在，给Apple构造函数两个参数，分别是size和age， 生成实例的时候，根据传参的不同，所有实例的size和age不同

**修改函数Apple来实现该功能**

```
function Apple(size, age) {
	this.size = size
	this.age = age
}
```



4 new操作符的作用是什么？函数内部的this是什么？

我们知道， 生成一个对象a， 需要一个函数A（又称构造函数），和对象A.prototype（又称对象A的原型对象），而具体的生成， 是通过调用new操作数，如

```
var a = new A()
```

那么， 这里的new操作符是做了什么呢？

另外，生成的实例的属性，要用到this关键字， 这个this是干嘛的？

答案：

new操作符的作用，可以分成四部

1. 新建一个基于构造函数的原型对象的新对象。

   什么意思呢？

   比如这里， 构造函数A， 它的原型对象是A.prototype

   那么我们现在会先生成对象obj，如下

   ```
   {
   	__proto__: A.prototype
   }
   ```



2.  将生成的对象obj赋值给函数内部的this
3.  执行构造函数
4.   返回对象obj



知道了new操作符如何工作后， 我们可以回到这个函数， 是不是就没问题了？

```
function Apple(size, age) {
	this.size = size
	this.age = age
}
```





5 你知道吗？ 函数也是对象哦

请写出，当我们声明

```
function A() {
    
}
```

的时候， 在浏览器背后发生了什么

答案：

```
var A = new Function()
```

可以看到， 函数A一样是用new方法生成的， 它继承了Function.prototype

![](https://pic1.zhimg.com/v2-3688036266a94186b54081c3754f660c_b.png)

那么， 一切都清楚了。

```
function A() {
	
}
```

当我们声明一个函数的时候， 是通过new操作符继承了Function.prototype

并且同时根据new操作符生成A.prototype， 这个A.prototype是继承了Object.prototype的。



6 什么是函数的重载， JS中有重载吗？

答案：略





7 你知道什么是词法/静态作用域，什么是动态作用域吗？以及JavaScript使用的是哪种？

答案：

```
var name = 'llp'
function static () {
console.log(name)
}

(function(){
var name = 'kjj'
static()
})()

```



8 以下代码输出什么？

```
var color = 'blue'

function getColor() {
	var color = 'red'
	return color
}
getColor()
```

答案：

red

9 什么是闭包?

```
function A() {
	var name = 'llp' 
	return function () {
        var people = {
            name: name 
        }
        console.log(people)
	}
}

var a = A()
a()
//输出
{name: 'llp'}
```

闭包的官方定义是有权访问另一个函数作用域中变量的函数（上一个的答案:D）

观察以上代码

我们开始说过， 函数内部的变量会通过JavaScript自带的垃圾回收机制在函数调用后销毁， 但A函数内部的name并没有被销毁，这是因为有其他的东西使用到了这个变量， 所以这个值不会被销毁。

本题不设题目。



10 写出静态类型和动态类型的区别，强类型和弱类型的区别

答案：



静态类型：编译的时候就知道每一个变量的类型，因为类型错误而不能做的事情是语法错误。

比如C和Java中， 声明变量的时候必须显式的指定变量的类型。



动态类型：编译的时候不知道每一个变量的类型，因为类型错误而不能做的事情是运行时错误。譬如说你不能对一个数字a写a[10]当数组用。

比如JS中无论何种类型都是用var声明。



强类型：偏向于不容忍隐式类型转换。

弱类型：偏向于容忍隐式类型转换。



11 什么是对象属性（property）的特性（attribute）？数据属性和访问器属性的区别？

特性就是描述了属性的各种特征， 特性是为了实现JS引擎用的，是内部值，所以下面用方括号圈出。

访问器属性先不提， 先说数据属性。 我们目前用的大多是数据属性。

比如

```
var people = {
	name: 'llp',
	age: 20,
	sayHi: function () {
        console.log('hi')
	}
}
```

这里的name，age，sayHi都是数据属性。

数据属性有四种特性

[[Configurable]] 默认值为true。表示能否通过delete删除属性从而重新定义属性， 能否修改属性的特性， 或者能否把属性修改为访问器属性。

[[Enumerable]] 默认值为true。 表示能否通过for-in循环返回属性。

[[Writable]] 默认为true。表示能否修改属性的值。

[[Value]] 默认为undefined。表示属性的值。读取属性值的时候，从这里读取。写入属性值的时候，从这里修改。



如何修改一个属性的特性？

使用Object.defineProperty函数

如

```
var people = {
	name = 'kjj'
}
Object.defineProperty(people, 'kjj', {
	enumerable: false,
	writable: false,
	value: 'llp'
})
```

这是修改一个已经存在的属性的特性。

我们也可以用这个函数来新建属性

```
var people = {
}
Object.defineProperty(people, 'kjj', {
	enumerable: false,
	writable: false,
	value: 'llp'
})
```

值得注意的是，当用这个函数来新建属性的时候，configurable、enumerable、writable特性的默认值都是false。



一些额外的补充：

在JavaScript中，有一个全局对象。在浏览器平台是window， 在Node平台是global。

而当我们用var声明变量a的时候，会自动把a变成对象window的属性，可以通过window.a来获取。这是JS设计上的一个缺陷/糟粕。

不过直接用var a = 'llp'和window.a = 'llp'也是有不同的。

两者都是给了window对象一个a属性，但前者的a属性的Configurable特性是false， 也就是不能通过delete a来删除这个属性。 而后者的a属性的Configurable特性是true， 也就是可以通过delete a来删除这个属性。



那么，什么是访问器属性呢？ 

我们先看访问器属性的特性有哪些

[[Configurable]]

[[Enumerable]]

这两个和数据属性都是一样的。

[[Get]]

[[Set]]

我们可以直接上例子

```
var people = {
	hisName: 'llp'
}
Object.defineProperty(people, 'name', {
	get: function () {
    	return this.hisName//这个this指代的是people对象
	},
	set: function (newValue) {
    	this.hisName = newValue
	}
})

```

当我们需要读取people.name的时候， 调用这个get方法。
当我们需要设置（比如赋值）people.name的时候， 会调用set方法。
而你想赋的值就会传递给set方法的形参newValue。
可以看出访问器属性和普通属性明显不同



如何读取属性的特性？

Object.getOwnPropertyDescriptor







13 实际操作一下。

我们需要一个Redrock类.实例是红岩人

每个红岩人都有个自己的名字name

所有红岩人都要有两个方法

- isCool， 返回true
- getName， 返回name

```
function Redrock(name) {
	this.name = name
}
Redrock.prototype.isCool = function () {
	return true
}
Redrock.prototype.getName = function () {
	return this.name
}

//test
var llp = new Redrock('llp')
llp.getName()//llp
llp.isCool()//true
```

现在我们增加需求， 给Redrock两个子类Web、Mobile。

子类需要方法

- getDpm 返回部门名

子类的实例需要有掌握的编程语言lang

```
function Web (name,  arr) {
	Redrock.call(this, name)
	//每个web类的实例和每个redrock都具有一些特有的性质， 所以我们直接在这里调用一次Redrock的构造函数
	//这句话的意思是，把当前函数的this传递给Redrock函数的this来执行。
	this.lang = arr
}
Web.prototype.getDpm = function () {
	console.log('we are web')
}
Web.prototype.__proto__ = Redrock.prototype
```

mobile也是同理





恭喜你，如果上面的你都会，你就已经入门了JavaScript这门十天被写出来的语言！

### 补充

1 物理像素和CSS像素的差别？

**设备像素/物理像素（device pixel）**。电子显示屏都有**分辨率**一说，那么什么是分辨率？举个例子，我的电脑是1920 x 1080 的分辨率，这意味着一个横为1920个物理像素，高为1080个物理像素的矩形显示屏。



**设备独立像素/密度无关像素（此处具体为css像素）**。一种抽象的概念，如css中margin: 20px，这里的20px就是css像素，而开发者经常会对css像素感到迷茫，首先是因为css像素是相对单位，和厘米分米这些绝对单位是不同的，没有一个具体的大小。

2 什么是DPR？

**设备像素比（device pixel ratio）是设备像素和css像素数量的比值**，我们知道设备像素是定值，所以DPR实际上是和css像素数量挂钩的。电脑缩放程度为100%的时候，DPR为1，因为缩放会影响css像素数量，所以也会影响DPR的大小。而手机缩放程度100%时DPR一般为2或3，一般手机都是不允许缩放的。

