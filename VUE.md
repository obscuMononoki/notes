<!-- cSpell: disable -->

# Vue

## 基本概念

Vue是基于M(数据)V(视图)VM(调度者)设计模式所开发的框架.

MVC和MVVM之间的区别: MVC是单项通信 MVVM是双向数据绑定.

## Vue基本的编码步骤

1. 引入Vue.js框架.

    ```JavaScript
    <script src="./src/vue.js"></script>
    ```

2. 在`script`标签中创建一个Vue实例.

    ```javascript
    new Vue({
        el:'#app' // 通过选择器确定一个让改Vue实例监管的区域;
        data:{
            msg:"hello"//在data中定义的数据就是整个Vue实力可以用到的数据
        }
    })
    // Vue所有的代码必须写到Vue的监管区域之内
    ```

3. 在`HTML`结构部分书写`Vue`代码
    - 注意在Vue1.0中可以将Vue的托管区域设置在`body`上, 而2.0则规范不能直接设置在`html`或`body`上.
    - `data`中定义的数据只能运用在托管区域内部, 同样`data`中的数据在js代码中也只存在于Vue实例中.
    - 插值表达式
        - 插值表达式所支持的用法包括表达式, 以及处理数据所常用的各类方法.
        - 需要注意插值表达式并不支持语句.
        - 差值表达式其实省略了`this`, 在识别区内`this`指向Vue实例.

    ```html
    <div id="app">
        {{msg}}
        <!-- 插值表达式 -->
        <!-- 插值表达式所支持的用法包括表达式, 三元运算符, 包括其数据所常见的各类方法 -->
        <!-- 需要注意插值表达式并不支持语句 -->
    </div>
    ```

## Vue基本指令

### `v-text`指令

- 实现于`dom`中的`innerText`.
- `v-text`也支持表达式, 但是并不能解析`html`标签.
- `v-text`会在标签中的内容(包括插值表达式)之后解析, 并覆盖掉标签中的原本内容.

### `v-html`指令

- 实现于`dom`中的`innerHTML`.
- 用于渲染带标签的文本.
- 与`v-text`一样,支持表达式, 会在标签内容之后解析.
> 注意: 在网站上动态渲染任意HTML非常危险, 因为容易导致XSS攻击. 只可在可信内容上使用`v-html`, 永远不可用在用户提交的内容上.

```html
<body>
    <div id="nay">
        <div v-text="msg+'word'"></div>
        <!-- helloWord -->
        <div v-text="pTag"></div>
        <!-- <p>msg</p> -->
        <div v-text="'<p>msg</p>'"></div>
        <!-- <p>msg</p> -->
        <div v-html="pTag"></div>
        <!-- msg -->
        <div v-html="'<p>msg</p>'"></div>
        <!-- msg -->
        {{msg}}
        <!-- hello -->
    </div>
</body>
<script>
    new Vue({
        el:'#nay',
        data:{
            msg:'hello',
            pTag:'<p>msg</p>'
        }
    })
</script>
```

### `v-bind`指令

- `v-bind`用于动态绑定属性, 使用方式`v-bind:属性名 = "data中的属性"`
    - `v-bind`的简写方式`:`
- `v-bind`可用于绑定任意属性, 于组建开发中常见.
    - `v-bind`绑定属性值直接使用`data`中的属性.
    - `v-bind`绑定属性值也支持表达式.
- `v-bind`绑定样式
    - 通过类名操作样式`:class="{'类名':布尔值}"`, 其中布尔值可以用表达式.
    - 通过`style`操作

### `v-for`指令

- `v-for`指令用于遍历渲染对象和数组
- `v-for="(value, key, index) in obj"` 这是`v-for`的基本用法
    - 其中: `value, key, index`三者名称可变, 顺序不可变, 分别表示**值**, **键**, **索引**.
    > 对于数组来说,不存在key, 所以括号中只有前两项
    >
    >如果只需要提取第一项, 则不需要小括号
    - `in`后面所接的为`data`数据中对应的数组或对象的名称
- 与`v-bind`一样`v-for`也会根据`data`中**数据**的变化自动刷新**视图**
    > 注意, 以下两种情况不会触发视图更新
    > 1. 当使用数组的`length`属性去改变数组的时候, 不会触发视图更新
    > 2. 使用数组下标的方式去改变数组的时候, 也不会触发视图更新
    >
    > 解决方案:
    > 1. 使用`Vue.set(arr, index, newVal)`其中`arr`是需要改变的数组, `index`是数组里面的项,  `newVal`是改变后的值
    > 2. `Array.prototype.splice()`
    >
    > 注意: `v-for`最好结合`key`属性来使用, `key`会对应`data`中的数组将每一项所渲染的标签唯一标识, 未来当数组中的那一项改变的时候, 便会只更新那一项, 可以提升性能. 注意`key`的值规定必须唯一, 不能重复.

### `v-model`指令

- `v-model`指令用于双向绑定**模型(model)和视图(view)**的数据.
    > `v-model`指令虽然可用于获取视图(view)中的数据, 并更新模型(model)中的数据, 但并不能在模型(model)中创建数据, 所以在使用前必须在模型(model)的`data`中写好与元素输入数据一一对应的属性.
- `v-model`监听标签的`change`事件, 获取事件改变的值并重新赋值给事件的触发元素.
- `v-model`只能在`input/textarea/selet`中使用.

### `v-on`指令

作用:绑定事件监听, 表达式可以是一个**方法的名字**或一个**内联语句**,如果没有修饰符也可以省略, 用在普通的**html元素**上时, 只能监听**原生DOM**事件. 用在自定义元素组件上时, 也可以监听子组件触发的自定义事件.

常用事件:

- v-on:click
- v-on:keydown
- v-on:keyup
- v-on:mousedown
- v-on:mouseover
- v-on:submit

示例:

```javascript
        <!-- 方法处理器 -->
        <button v-on:click="doThis"></button>
        <!-- 内联语句 -->
        <button v-on:click="doThat('hello', $event)"></button>
        <!-- 阻止默认行为, 没有表达式 -->
        <form v-on:submit.prevent ></form>
```

`v-on`的缩写形式:可以使用`@`替代`v-on:`

Vue不鼓励直接操作`dom`, 但依旧可以通过`$event`获取事件对象, 注意该传入参数为实参, 该变量名不能修改.

由于视图(view)直接由数据(model)渲染, 且支持表达式, 其实也可以直接传递所需参数.

#### 事件修饰符

- 阻止默认行为

```html
<a v-on:click.prevent = 'jump' href = "#"></a>
<form @click.prevent = "jump"></form>
<!-- form有submit默认事件 -->
```

- 'once': 只触发一次事件
- 'self': 保证事件由自己触发, 不会经过冒泡或捕获进行触发
```html
<div @click = 'divClick'>
    <p @click.self = 'pClick'></p>
</div>
```

- `stop`: 阻止冒泡

#### 按键修饰符

触发像`keydown`这样的按键事件时, 可以使用按键修饰符指定按下特殊的键后才触发事件

```javascript
    <input type="text" @keydown.enter="kd1">  // 当按下回车键时才触发kd1事件
    <input type="text" @keydown.13="kd1">  // 当按下回车键时才触发kd1事件
```

`Vue`原生按键修饰符

```JavaScript
.enter
.tab
.delete (捕获 “删除” 和 “退格” 键)
.esc
.space
.up
.down
.left
.right
```

也可以通过`Vue.config.keyCodes.a = 65`自定义添加对应的按键修饰符

```javascript
    Vue.config.keyCodes.a = 65 // 按键名称可以自定义
    <input type="text" @keydown.a="kd1">  // 这样即可触发
```

或者直接用对应的`keyCode`

```JavaScript
    <input type="text" @keydown.65="kd1">  这样即可触发
```

### `v-if`指令

条件渲染指令, 通过判断表达式的值的真假条件来决定是否渲染元素, 如果条件为`false`不渲染(达到隐藏元素的目的), 为`true`则渲染. 在切换时元素及它的数据绑定被销毁并重建.

在模板引擎中的类似功能写法:

```html
{{#if isShow}}
    <h1>Yes</h1>
{{/if}}
```

在`Vue`中, 则使用`v-if`指令实现同样的功能:

```html
<h1 v-if="isShow">Yes</h1>
```

可以在`if`块后紧跟着使用`v-else`添加一个`else`块:

注意:`v-else`元素必须紧跟在带`v-if`或者`v-else-if`的元素的后面, 否则它将不会被识别.

```html
<h1 v-if="isShow">Yes</h1>
<h1 v-else>No</h1>
```

```JavaScript
new Vue({
        data:{
            isShow:true
        }
});
```

在需要隐藏多个元素的时候则可以将其添加在一个`<template></template>`上, 同样本身也可以用于条件渲染分组

```html
<template v-if="ok">
  <h1>Title</h1>
  <p>Paragraph 1</p>
  <p>Paragraph 2</p>
</template>
```

#### `key`与元素复用

`Vue`的渲染机制与通常不同, 会尽量复用已有元素而不是从头开始渲染. 相应的除了渲染速度以外也会带来一些其他的特性.

例如如果在两个相同的元素之间进行切换, 那么未标明不同的元素内容就不会被替换, 而会变成仅仅改变元素的某个属性而已.

```html
<template v-if="loginType === 'username'">
  <label>Username</label>
  <input placeholder="Enter your username">
</template>
<template v-else>
  <label>Email</label>
  <input placeholder="Enter your email address">
</template>
```

那么在上面的代码中切换`loginType`将不会清除用户已经输入的内容. 因为两个模板使用了相同的元素, `<input>`不会被替换掉——仅仅是替换了它的 `placeholder`.

如果想要将两个相同的元素彻底区分不进行复用, 则可以用`key`属性进行标识

```html
<template v-if="loginType === 'username'">
  <label>Username</label>
  <input placeholder="Enter your username" key="username-input">
</template>
<template v-else>
  <label>Email</label>
  <input placeholder="Enter your email address" key="email-input">
</template>
```

### `v-show`指令

带有`v-show`的元素始终会被渲染并保留在`DOM`中. `v-show`只是简单地根据表达式的真假值来修改元素的`CSS`属性`display:none`.

```html
<h1 v-show="isShow">Yes</h1>
```

```JavaScript
new Vue({
        data:{
            isShow:true
        }
})
```

> 注意:`v-show`不支持非原生的元素, 如`<template>`元素, 也没有`v-else`或类似的功能.

### `v-if`vs`v-show`

`v-if`是'真正'的条件渲染, 因为它会确保在切换过程中条件块内的事件监听器和子组件适当地被销毁和重建.

`v-if`也是惰性的:如果在初始渲染时条件为假, 则什么也不做——直到条件第一次变为真时, 才会开始渲染条件块.

相比之下, `v-show`就简单得多——不管初始条件是什么, 元素总是会被渲染, 并且只是简单地基于CSS进行切换.

一般来说, v-if有更高的切换开销, 而`v-show`有更高的初始渲染开销. 因此, 如果需要非常频繁地切换, 则使用 v-show 较好. 如果在运行时条件很少改变, 则使用 v-if 较好.

区别和使用场景

`v-if` 和 `v-show` 都是用来控制元素的显示和隐藏, 当值未`团折, 元素显示, 反之, 元素隐藏`

区别: `v-if` 当切换布尔值时会创建或删除愿誓死, `v-show`则是改变`display: block`

当元素显示隐藏切换频繁时使用`v-show`,反之使用`v-if` 例如页面加载数据时的loading动画可以使用`v-if`

页面中某个元素需要使用动画效果, 这个动画效果需要人为进行操作控制, 那么最好使用`v-show`, 加入购物车的小球飞入动画

### `v-cloak`指令

`v-cloak`指令保持在元素上直到关联实例结束编译后自动移除.

- `v-cloak`解决插值表达式闪烁原理

由于网速等原因导致vue.js没有被加载回来, 此时页面中的差值表达式不会被Vue实例解析, 浏览器进行解析的时候会直接当作字符串; 然后vue.js加载回来之后, vue实例又能进行解析, 那么差值表达式就会被解析为具体的值, 这个过程会出现闪烁现象



`v-cloak`和CSS规则如`[v-cloak] { display: none }`一起用时, 这个指令可以隐藏未编译的**Mustache**标签直到实例准备完毕.

```css
[v-cloak] {
  display: none;
}
```

浏览器进行解析时, 浏览器会将属性选择器的样式作用于元素身上, 该元素会被隐藏, 而后vue解析式, 会将`v-clock`从元素身上溢出, 样式随之失效, 差值表达式得以显示

如下:浏览器在加载的时候会先把`span`隐藏起来, 在Vue实例化完毕以后, 才会将`v-cloak`从`span`上移除, 从而使css样式失去作用.

```html
<span v-cloak>
    {{msg}}
</span>
```

```javascript
new Vue({
    data:{
        msg:'hello ivan'
    }
})
```



## 可复用性 & 组合

### 自定义指令`Vue.directive()`

- 创建

通过`Vue.directive()`可以创建一个全局自定义属性(即可在项目的全部组件中使用), 包含两个参数, 第一个是自定义指令名字, 另一个是一个配置对象.
> 自定义指令也可以传参, 并不会影响所定义的指令函数的执行, 且所传参数和值均可以通过钩子函数中的`binding`获取到.
>
> 注意:在Vue中指令的名字如果使用的是驼峰命名法, 那么在反应在`html`代码中的指令则会自动转变为用`-`相连的全小写指令名

```javascript
// 注册一个全局自定义指令 `v-focus`
Vue.directive('focus', {
  // 当被绑定的元素插入到 DOM 中时……
  inserted: function (el) {
    // 聚焦元素
    el.focus()
  }
})
```

如果想注册局部指令, 在组件中也接受一个`directives`的选项:

```JavaScript
directives: {
    focus: {
        // 指令的定义
        inserted: function (el) {
            el.focus()
        }
    }
}
```

> 在该例中, `focus()`类似于`HTML5`中的`autofocus`(但要注意该属性在移动端的safari浏览器中由兼容性问题).

- 使用

```html
<input v-focus>
```

#### TODO钩子函数

钩子函数中的参数即便都是只读的

指令的定义对象中可以提供如下几个钩子函数, 其主要区别在于不同的执行时机, (均为可选):

- `bind`:只调用一次, 指令第一次绑定到元素时调用. 在这里可以进行一次性的初始化设置.

- `inserted`:被绑定元素插入父节点时调用 (仅保证父节点存在, 但不一定已被插入文档中).

- `update`:所在组件的 VNode 更新时调用, 但是可能发生在其子 VNode 更新之前. 指令的值可能发生了改变, 也可能没有. 但是你可以通过比较更新前后的值来忽略不必要的模板更新 (详细的钩子函数参数见下).

- `componentUpdated`:指令所在组件的 VNode 及其子 VNode 全部更新后调用.

- `unbind`:只调用一次, 指令与元素解绑时调用.

- 接下来我们来看一下钩子函数的参数 (即 `el、binding、vnode、oldVnode`).

`inserted(el, binding)`钩子函数, 当自定义指令插入到标签中的时候执行, `el`表示使用自定义指令的元素, `binding`表示自定义指令的信息, `binding`对象本身也会储存指令所指向的`data`内容: 如`value` `expression`等.

##### 函数简写

钩子函数具有特定的简写形式, 在很多时候，你可能想在`bind`和`update`时触发相同行为，而不关心其它的钩子。

```JavaScript
Vue.directive('color-swatch', function (el, binding) {
  el.style.backgroundColor = binding.value
})
```

##### 对象字面量

如果指令需要多个值，可以传入一个`JavaScript`对象字面量, 然后通过`binding`下的`value`属性去获取. 指令函数能够接受所有合法的`JavaScript`表达式。

```html
<div v-demo="{ color: 'white', text: 'hello!' }"></div>
```

```JavaScript
Vue.directive('demo', function (el, binding) {
  console.log(binding.value.color) // => "white"
  console.log(binding.value.text)  // => "hello!"
})
```

### 自定义过滤器 Vue.filter()

- 创建

过滤器由`Vue.filter()`方法创建, 用于一些常见的文本格式化. 过滤器的定义方法含有两个参数: 第一个参数是**过滤器的名字**, 第二个参数是**过滤器的处理函数**.

处理函数的第一个默认参数始终默认为需要过滤的数据, 且始终接收管道符前表达式的值.

```JavaScript
Vue.filter( id, [definition] )
        参数:
                {string} id
                {Function} [definition]
```

```JavaScript
注册或获取全局过滤器.

// 注册
Vue.filter('my-filter', function (value) {
    // 返回处理后的值
})

// getter, 返回已注册的过滤器
var myFilter = Vue.filter('my-filter')
```

与自定义指令一样, 过滤器也可以分别在组建和本地之中定义:

- 在组件的选项中定义本地的过滤器:

```JavaScript
filters: {
    capitalize: function (value) {
        if (!value) return ''
        value = value.toString()
        return value.charAt(0).toUpperCase() + value.slice(1)
    }
}
```

- 在创建`Vue`实例之前定义在全局中:

```javascript
Vue.filter('capitalize', function (value) {
    if (!value) return ''
    value = value.toString()
    return value.charAt(0).toUpperCase() + value.slice(1)
})

new Vue({
    // ...
})
```

- 使用

过滤器函数支持**双花括号插值**表达式和 `v-bind` 表达式, 且总接收表达式的值 (之前的操作链的结果) 作为第一个参数, 过滤器应该被添加在 JavaScript 表达式的尾部, 由“管道”符号指示:

过滤器可以串联调用, `filterA`的结果传递到`filterB`中:

```html
{{ message | filterA | filterB }}
```

过滤器是`JavaScript`函数, 可以接收参数:

```html
{{ message | filterA('arg1', arg2) }}
```

> 注意:这里字符串`'arg1'`是第二个参数, 表达式`arg2`是第三个参数. 过滤器的第一个参数始终是管道符前操作链表达式的结果

### TODO 组件

- 创建:全局组件, 即可以在Vue识别区的任何地方使用

创建组件的第一种方式.

    1. 利用`Vue.extend()`创建一个组件的模板对象
    2. 使用`Vue.component()`注册组件

```JavaScript
// login保存模板对象
var login = Vue.extend({
    template: '<div>登陆</div>'
})
// 将模板对象传入component方法注册组件
Vue.component('myLogin', login)
```

使用`Vue.component`直接创建组件.

```JavaScript
Vue.component('myregister', {
    template: '<div>注册</div>'
})
```

使用`<template></template>`标签指定模板代码, 再用选择器指向代码.

```HTML
<template id="account">
    <div>
        账号
    </div>
</template>
```

```JavaScript
Vue.component('account', {
    template: '#account' // 在template中传入选择器
})
```

> 注意:
> 注册组件的`template`后面既可以直接跟模板标签文本, 也可以直接使用选择器指向页面中的`<template id=""></template>`标签所定义的组件模板.
>
> 每一个组件的模板代码只能存在一个根目录, 即必须具有一个包含全部其他组件模板标签的根标签.
>
> `component`注册组件需要在Vue实例外使用, 而`<template id=""></template>`标签定义的组件模板也同样必须写在Vue识别区域之外.
>
> 页面中通常会使用`<template id=""></template>`标签来书写组件模板, 但是事实上也可以使用`<script type="x-template></script>`的方式来书写, 但要注意后者会没有编辑器提示.

- 使用

直接在Vue识别区中使用相应组件名称命名的闭合标签即可将组件模板插入到页面中.

在组件中也可以使用Vue实例中的全部的属性, 但要注意使用方法与Vue实例中有所区别.

#### 组件中的常用属性

在Vue实例中data是一个对象,组件的数据必须定义在data中, 而在组件当中data是一个函数, 且该函数必须返回一个对象, 在组件中定义的
数据只能在该组件模板中使用

```javascript
var login = Vue.extend({
    template: '#login',
    data(){
        return {
            msg:''
        }
    },
    // 问题:为什么只有data需要定义为函数
    methods: {
        changeMsg() {
            this.msg=''
        }
    }
})
```

#### 私有组件

在父组件中通过`components`创建子组件, 子组件一定定义父组件中, 在子组件一定是在父组件的模板区域中使用而不能在父组件的标签中直接进行签套

父组件像子组件传值

子组件向父组件传值

## Vue实例相关属性

### 计算属性

- 创建

计算属性通过`computed`创建, 本身是一个对象. 计算属性是根据`data`中已有的属性, 计算生成一个新的属性, 用以避免在模板中放入太多的逻辑会让模板过重且难以维护, 所以对于任何复杂逻辑, 都应当使用计算属性.

计算属性默认只有`getter`, 简单理解即:在`computed`中所声明的函数将作为在Vue实例下自身同名对象的`getter`函数, 不过事实上, 通过在计算属性中声明对象并像其中分别传入具有特定功能的`getter`函数和`setter`函数依旧是可行的.

- 使用

使用方法简单来说, 即**计算属性中定义的函数方法, 可以直接当成`data`中的属性来用**

#### 计算属性缓存

计算属性基于它们的依赖进行缓存的. 即计算属性只有在它的相关依赖发生改变时才会重新求值, 否则即便多次调用也会立即返回之前的计算结果.

计算属性可以像普通属性一样在模板中绑定. Vue知道计算属性的依赖, 会在依赖发生改变的时候更新计算属性, 而所有依赖与该计算属性的绑定也会更新.

> 而且最妙的是我们已经以声明的方式创建了这种依赖关系:计算属性的`getter`函数是没有副作用 (side effect) 的, 这使它更易于测试和理解.

注意:但是对于并非依赖Vue实例中的`data`属性来更新数据的属性则不会再更新, 这种时候可以用方法或者将数据更新纳入`data`:

```JavaScript
computed: {
    now: function () {
        return Date.now()
        // 因为 Date.now() 不是响应式依赖:
    }
}
```

#### 与`methods`方法的对比

Vue允许在表达式中调用方法, 因而也可以以此来达到和计算属性同样的效果, 但是方法是没有缓存机制的. 计算属性只要依赖没有发生改变, 缓存就不会更新, 即使全局多次访问计算属性, 依旧会立即返回之前的计算结果的缓存, 而不会再次执行函数.


#### 与`watch()`侦听属性的对戏

在大多的现在前端模板中, 都会具有一个用于观察和响应实例上的数据变动的监听属性.

TODO 但是命令式的 watch 回调需要注意的是侦听属性往往一次只能侦听一个或一组

下面是一个监听属性和计算属性对比的例子:

```HTML
<div id="demo">{{ fullName }}</div>
```

```JavaScript
var vm = new Vue({
    el: '#demo',
    data: {
        firstName: 'Foo',
        lastName: 'Bar',
        fullName: 'Foo Bar'
    },
    watch: {
        firstName: function (val) {
            this.fullName = val + ' ' + this.lastName
        },
        lastName: function (val) {
            this.fullName = this.firstName + ' ' + val
        }
    }
})
```

```JavaScript
var vm = new Vue({
    el: '#demo',
    data: {
        firstName: 'Foo',
        lastName: 'Bar'
    },
    computed: {
        fullName: function () {
            return this.firstName + ' ' + this.lastName
        }
    }
})
```

#### 计算属性的 setter

在计算属性默认只有`getter`, 即只能根据`data`中已有的属性的变化而变动, 但事实上计算属性也是可以设置`setter`以更改`data`中的值的:

```JavaScript
computed: {
    fullName: {
        // getter
        get: function () {
            return this.firstName + ' ' + this.lastName
        },
        // setter
        set: function (newValue) {
            var names = newValue.split(' ')
            this.firstName = names[0]
            this.lastName = names[names.length - 1]
        }
    }
}
```

在运行`vm.fullName = 'John Doe'`时, `setter`会被调用, v`m.firstName`和`vm.lastName`也会相应地被更新.




### TODO methods

### TODO watch

- 创建

`watch`监听器用于监听`data`中的属性, 通过`watch`创建, 本身是一个对象, 当监听数据变化他就会执行像对应的函数.

当需要在数据变化时执行异步或开销较大的操作时, 这个方式是最有用的.

需要注意的是, 在`watch`中的函数方法名称需要与所要监听的`data`中的数据属性名称意义对应, 每个函数默认包含两个参数
`newVal`新值和`oldVal`旧值
<!-- TODO mounted -->
`mounted`函数, 是一个在页面加载完成以后就立刻执行的回调函数, 类似于`window.onload`.
<!-- TODO ref -->
`ref`属性表示对`dom`的引用, 值可以随意, 但不能重复.

可以在Vue实例下(通常会用`this`指向)的`$refs`对象中找到相应的`dom`引用接口.





ES6在对象中定义函数可以省略`:function`, `函数名+(){}`即可



如果元素设计到频繁的显示隐藏切换 v-show

css属性选择器可以选择自定义属性



## TODO 神秘的方法们

- [ ] charAt()
- [ ] toUpperCase()
- [ ] slice()
- [ ] split('')
- [ ] reverse()
- [ ] join('')

- [ ] reverse()




- [ ] 变量的命名法
- [ ] component和components
- [ ] 组件名字的驼峰命名需要转化为全小写的中划线分割


私有过滤器私有指令

声明周期函数



## 路由

1. 后端路由
    监听不同的URI(地址), 做不同的请求处理
2. 前端路由
    是专门为SPA(单页应用程序)服务.
    监听不同的地址, 来进行页面的切换.
    而针对Vue场景来说, 就是在前端切换不同的组件



<!-- ## TODO webpack -->

vue-cli

## Vue脚手架相关
main.js中的Vue实例
```JavaScript
new Vue({
    el: '#app',
    router,
    // render: c => c(App) //  runtime only 就会值指向 vue.runtime.js
    render: function(c){
        return c(App) // render函数用于挂载App.vue组件.从而将App.vue中的内容放入main.js的Vue实例中
    }
    // components: {App},
    // tenplate: '<App/>>' // 运行的是vue.esm.js文件, 最全的包
})
```

main.js => bunild.js => html文件

index.html中会预先引入build.js, 且在其中会预先设置一个`<div id="app">`从而main.js中的vue实例会被放到index.html中展示

login.Vue => App.vue 各个.vue文件都会依据路由的调配一次挂载在app.vue上, 而app.vue则挂载在main.js上

router下的index.js中会存储相关里路由规则, 指向views下的各个.vue组件, 而后指向main.js

main.js下主要改动各类新组件的变动

Vue技术栈

Vuex
Vue-router


vuex的使用步骤

npm install vuex -S

import Vuex form 'vuex'

Vue.use(Vuex)
var store = new Vuex.Store({})

new Vue({
    el: '#app',
    store,
    router,
    components: {App},
    template: '<App/>'
})



## Vue的双向数据绑定

v-model指令, 数据视图同步更新, 使用的是数据劫持(`Object.defineProperty()`), 该方法为ES5中新的方法

当模型中的数据发生否蛮王式会触发Object.defineProperty的set方法, 在这个方法内部能够劫持到数据的改变, 然后就可以在该方法内部通知视图更新



```JavaScript
<div>{{msg}}</div>
<button @click = 'change'></button>

new Vue
({
    data:{
        msg: 'hello',
        name: 'zs'
    },
    methods: {
        change(){
            this.msg = 'word'
        }
    }
})