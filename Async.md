# 用5种方法封装AJAX

五种方法，进行分析。

- 回调函数
- Promise
- Generator（without co）
- Generator（with co）
- async





### 回调函数

```javascript
// callback
const Ajax = ({
    method = 'get',
    url = '/',
    data,
    async = true
}, callback) => {
    let xhr = new XMLHttpRequest()
    xhr.onreadystatechange = () => {
        if (xhr.readyState === 4 && xhr.status === 200) {
            let res = JSON.parse(xhr.responseText)
            callback(res)
        }
    }
    xhr.open(method, url, async)
    if (method === 'get') {
        xhr.send()
    }
    if (method === 'post') {
        let type = typeof data
        let header
        if (type === 'string') {
            header = 'application/x-www-form-urlencoded'
        }
        else {
            header = 'application/json'
            data = JSON.stringify(data)
        }
        xhr.setRequestHeader('Content-type', header)
        xhr.send(data)
    }
}

Ajax.get = (url, callback) => {
    return Ajax({
        url
    }, callback)
}

Ajax.get('http://localhost:3000/getData', (res) => {
    console.log(res)
})
```





### Promise

```javascript
//promise
const Ajax = ({
    method = 'get',
    url = '/',
    data,
    async = true
}) => {
    return new Promise((resolve, reject) => {
        let xhr = new XMLHttpRequest()
        xhr.onreadystatechange = () => {
            if (xhr.readyState === 4 && xhr.status === 200) {
                let res = JSON.parse(xhr.responseText)
                resolve(res)
            }
        }
        xhr.open(method, url, async)
        if (method === 'get') {
            xhr.send()
        }
        if (method === 'post') {
            let type = typeof data
            let header
            if (type === 'string') {
                header = 'application/x-www-form-urlencoded'
            }
            else {
                header = 'application/json'
                data = JSON.stringify(data)
            }
            xhr.setRequestHeader('Content-type', header)
            xhr.send(data)
        }
    })
}

Ajax.get = (url) => {
    return Ajax({
        url
    })
}



Ajax.get('http://localhost:3000/getData')
    .then((data) => {
        console.log(data)
    })
```





### Generator

```javascript
//generator without co module
const Ajax = ({
    method = 'get',
    url = '/',
    data,
    async = true
}) => {
    return new Promise((resolve, reject) => {
        let xhr = new XMLHttpRequest()
        xhr.onreadystatechange = () => {
            if (xhr.readyState === 4 && xhr.status === 200) {
                let res = JSON.parse(xhr.responseText)
                resolve(res)
            }
        }
        xhr.open(method, url, async)
        if (method === 'get') {
            xhr.send()
        }
        if (method === 'post') {
            let type = typeof data
            let header
            if (type === 'string') {
                header = 'application/x-www-form-urlencoded'
            }
            else {
                header = 'application/json'
                data = JSON.stringify(data)
            }
            xhr.setRequestHeader('Content-type', header)
            xhr.send(data)
        }
    })
}

Ajax.get = (url) => {
    return Ajax({
        url
    })
}


function* use() {
    let data = yield Ajax.get('http://localhost:3000/getData')
    console.log(data)
}

let obj = use()
obj.next().value.then((res) => {
    obj.next(res)
})
```



这里的重点是把Ajax.get放在了generator函数的内部，并放在了yield关键字的后面。

这样，遍历器对象的value就可以获取到Ajax.get返回的promise对象了。而通过then方法，获取到promise对象的value。而通过调用obj.next(res)方法，又向generator函数内部加入了状态。

这里唯一有个不好的地方就是，你必须要手动来调用next函数。



### Generator + co

```javascript
//generator with co module
const Ajax = ({
    method = 'get',
    url = '/',
    data,
    async = true
}) => {
    return new Promise((resolve, reject) => {
        let xhr = new XMLHttpRequest()
        xhr.onreadystatechange = () => {
            if (xhr.readyState === 4 && xhr.status === 200) {
                let res = JSON.parse(xhr.responseText)
                resolve(res)
            }
        }
        xhr.open(method, url, async)
        if (method === 'get') {
            xhr.send()
        }
        if (method === 'post') {
            let type = typeof data
            let header
            if (type === 'string') {
                header = 'application/x-www-form-urlencoded'
            }
            else {
                header = 'application/json'
                data = JSON.stringify(data)
            }
            xhr.setRequestHeader('Content-type', header)
            xhr.send(data)
        }
    })
}

Ajax.get = (url) => {
    return Ajax({
        url
    })
}



function* use() {
    let data = yield Ajax.get('http://localhost:3000/getData')
    console.log(data)
}

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

```javascript
//async 
const Ajax = ({
    method = 'get',
    url = '/',
    data,
    async = true
}) => {
    return new Promise((resolve, reject) => {
        let xhr = new XMLHttpRequest()
        xhr.onreadystatechange = () => {
            if (xhr.readyState === 4 && xhr.status === 200) {
                let res = JSON.parse(xhr.responseText)
                resolve(res)
            }
        }
        xhr.open(method, url, async)
        if (method === 'get') {
            xhr.send()
        }
        if (method === 'post') {
            let type = typeof data
            let header
            if (type === 'string') {
                header = 'application/x-www-form-urlencoded'
            }
            else {
                header = 'application/json'
                data = JSON.stringify(data)
            }
            xhr.setRequestHeader('Content-type', header)
            xhr.send(data)
        }
    })
    
}

Ajax.get = (url) => {
    return Ajax({url})
}


async function use() {
    let data = await Ajax.get('http://localhost:3000/getData')
    console.log(data)
}

use()
```



Async可以说很像generator + co的组合了，而且async + await更加符合语义了。

await后面需要时promise对象。 但像fs模块这种并不会返回promise，你可能需要bluebird。

async函数还会返回一个promise对象。