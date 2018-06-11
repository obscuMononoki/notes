# ES6

## ES6 的块级作用域

ES6 中新变量所带来的块级作用域回避了 ES5 中变量泄漏和内层变量覆盖外层变量的问题, 使用 ES6 语法声明的变量, 外层代码块不受内层代码块的影响, 外层作用域无法读取内层作用域的变量, 但内层作用域可以定义外层作用域的同名变量. 块级作用域可以任意嵌套.

es6中所引入的块级作用域会先于对象被识别, 所以在解构赋值两个对象的时候, 会需要用小括号包裹两个对象, 强制为表达式进行识别.

```JavaScript
({
    foo: obj.prop,
    bar: arr[0]
} = {
    foo: 123,
    bar: true
})
// 没有小括号的情况下, 后面的对象会被正确识别, 但是前面的对象的大括号会被直接识别为一个块级作用域, 因而导致报错.
```

### 块级作用域与函数声明

ES5 规定, 函数只能在顶层作用域和函数作用域之中声明, 不能在块级作用域声明. **但是, 浏览器没有遵守这个规定, 为了兼容以前的旧代码, 还是支持在块级作用域之中声明函数.**

ES6 引入了块级作用域, 明确允许在块级作用域之中声明函数. ES6 规定, 块级作用域之中, 函数声明语句的行为类似于let, 在块级作用域之外不可引用. 但是, 为了兼容性考虑 ES6浏览器也没有遵循该规则, 如下所示:

- **允许在块级作用域内声明函数. **
- **函数声明类似于var, 即会提升到全局作用域或函数作用域的头部. **
- **同时, 函数声明还会提升到所在的块级作用域的头部. **

> 注意: 考虑到环境导致的行为差异太大, 应该避免在块级作用域内声明函数. 如果确实需要, 也应该写成函数表达式, 而不是函数声明语句.
>
> 注意: 在严格模式下浏览器和nodejs对于块级作用域内的函数声明则会严格遵循ES6官方的标准.

##`let`

与`var`对比, `let`不会引发变量提升的预解析(hosting), 且在块级作用域中, 在`let`声明该变量之前, 该变量不可用.`var`可以被重复声明不会报错, 且每一次重复声明都会执行变量的初始化, 而`let`不能重复声明, `let`声明的变量仅在所在的块级作用域内起效, 不只是函数产生的块级作用域, 也包括语句的`{}`所形成的作用域在内. **当然在子作用域中用let声明同名变量依旧可行. **

###`let`在循环中的的特性

`let`声明的变量仅作用于当前的块级作用域, 当在循环中使用`let`声明变量时, 每一次循环都会产生一个单独的块级作用域, 并随之产生一个单独的`let`所定义的变量. 当前循环的值会被ECMAscript引擎所记忆用于下一轮循环计算的基础, 初始化本轮的变量时, 即会在上一轮循环的基础上进行计算.

```javascript
var a = [];
for (var i = 0; i < 10; i++) {
  a[i] = function () {
    console.log(i);
  };
}
a[6](); // 10
```

另外, for循环还有一个特别之处, 就是设置循环变量的那部分语句其实是循环体的一个父作用域, 而循环体内部是一个单独的子作用域.

```javascript
for (let i = 0; i < 3; i++) {
  let i = 'abc';
  console.log(i);
}
// 上面代码正确运行, 输出了 3 次abc. 这表明函数内部的变量i与循环变量i不在同一个作用域, 有各自单独的作用域.
```

> 注意在ES6中`let`命令.`const`命令.`class`命令声明的全局变量, 不再属于顶层对象的属性. 从ES6开始, 全局变量将逐步与顶层对象的属性脱钩.
>
> 以chrome为例, 而在控制台中使用的时候, 的时候相关变量会被装入一个`Script`作用域中
>> Global(全局)对象可以说是ECMAScript 中最特别的一个对象了, 因为不管你从什么角度上看, 这个对象都是不存在的. ECMAScript中的Global对象在某种意义上是作为一个终极的“兜底儿对象”来定义的. 换句话说, 不属于任何其他对象的属性和方法, 最终都是他的属性和方法.

### 暂时性死区

只要块级作用域内存在`let`命令, 它所声明的变量就'绑定'(binding)这个区域, 不再受外部的影响. 下方代码中, 存在全局变量tmp, 但是块级作用域内let又声明了一个局部变量tmp, 导致后者绑定这个块级作用域, 所以在let声明变量前, 对变量tmp而言都属于死区, 任意操作都会报错.

```javascript
var tmp = "123";
if (true) {
    tmp = "abc";// 注释该行:输出undefined
    let tmp;// 注释该行:输出abc
    console.log(tmp);// 注释上两行:输出123
}
```

let命令改变了语法行为, 它所声明的变量一定要在声明后使用. 在代码块内, 即使所声明的变量与父级变量同名, 该变量在使用`let`变量声明之前, 该变量也是不可以用的. 这在语法上称为**"暂时性死区"(temporal dead zone, 简称 TDZ)**. 如果要用`let`声明一个与外部变量同名的局部变量, 那么你就要放在这个同名变量使用之前, 否则就会报错.

> ES6 明确规定, 如果区块中存在`let`和`const`命令, 这个区块对这些命令声明的变量, 从一开始就形成了封闭作用域. 凡是在声明之前就使用这些变量, 就会报错.
>
> “暂时性死区”也意味着在使用`typeof`不再是一个百分之百安全的操作. 比如经典的`if(typeof a!="undefined"){}`用以回避变量`a`未被定义的情况, 类似情况的还有:`isNaN``instanceof`

一些比较隐蔽的死区形式:

```javascript
function bar(x = y, y = 2) {
  return [x, y];
}
bar(); // ReferenceError: y is not defined

function bar(x = 2, y = x) {
  return [x, y];
}
bar(); // [2, 2]

var x = x;// 不报错
let z
z = z// 不报错
let y = y;// ReferenceError: y is not defined,
// 这里是用变量自己给自己赋值, = 是右结合性的, 导致了在使用let声明变量时, 变量在还没有声明完成前使用使用了.
```

> 总结:暂时性死区的本质就是, 只要一进入当前作用域, 所要使用的变量就已经存在了, 但是不可获取, 只有等到声明变量的那一行代码出现, 才可以获取和使用该变量.

## const

`const`用于声明一个只读的常量, 一旦声明, 常量的值就不能改变.
> 注意: const声明的变量不得改变值, 这意味着, `const`不能只声明不赋值, 且一旦变量声明, 就必须立即初始化, 不能留到以后赋值.

`const`的作用域与`let`命令相同: 只在声明所在的块级作用域内有效, 不能重复声明.`const`命令声明的常量也没有提升, 同样存在暂时性死区, 只能在声明的位置后面使用.

### const常量本质

`const`实际上保证的, 并不是变量的值不得改动, 而是变量指向的那个内存地址不得改动. 对于简单类型的数据(数值&字符串&布尔值), 值就保存在变量指向的那个内存地址, 因此等同于常量. 但对于复合类型的数据(主要是对象和数组), 变量指向的内存地址, 保存的只是一个指针, const只能保证这个指针是固定的, 至于它指向的数据结构是不是可变的, 就完全不能控制了. 因此, 将一个对象声明为常量必须非常小心.

最为直观的:当使用const定义一个指向对象的属性时, 依旧可以通过`.`和`[]`或对象自有的方法向对象中添加属性和方法, 对象所自有的属性和方法也可以调用, 但是如果直接对变量赋值以指向另一个对象则会报错.

```JavaScript
const foo = {};
// 为 foo 添加一个属性, 可以成功
foo.prop = 123;
foo.prop // 123

// 将 foo 指向另一个对象, 就会报错
foo = {}; // TypeError: "foo" is read-only
```

上面代码中, 常量foo储存的是一个地址, 这个地址指向一个对象. 不可变的只是这个地址, 即不能把foo指向另一个地址, 但对象本身是可变的, 所以依然可以为其添加新属性.

```JavaScript
const a = [];
a.push('Hello'); // 可执行
a.length = 0;    // 可执行
a = ['Dave'];    // 报错
```

上面代码中, 常量a是一个数组, 这个数组本身是可写的, 但是如果将另一个数组赋值给a, 就会报错.

#### 对象冻结

如果真的想将对象冻结, 应该使用`Object.freeze()`方法.

```JavaScript
const foo = Object.freeze({});
foo.prop = 123;
// 常规不起作用
// 严格模式Cannot add property prop, object is not extensible
```

以递归形式彻底冻结对象属性

```JavaScript
var constantize = (obj) => {
  Object.freeze(obj);
  Object.keys(obj).forEach( (key, i) => {
    if ( typeof obj[key] === 'object' ) {
      constantize( obj[key] );
    }
  });
};
```

## ES6中的顶层对象

顶层对象, 在浏览器环境指的是`window`对象, 在 Node 指的是`global`对象.

ES5 之中, 顶层对象的属性与全局变量是等价的.

而在ES6中, 则规定`var`命令和`function`命令声明的全局变量, 依旧是顶层对象的属性. 另一方面规定, `let`命令&`const`命令&`class`命令声明的全局变量, 不属于顶层对象的属性. 从ES6开始, 全局变量将逐步与顶层对象的属性脱钩.

> 注意: **事实上, 目前对于该标准各个不同环境的实现方式并不一样**, 以chrome为例, 而在控制台中使用`let`的时候, 相关变量会被装入一个与`window`同级`Script`作用域中. 而对于node环境, 在`REPL`中`var`声明的变量会被放入`global`对象里面, 相当于直接声明了一个`global.a`, 可是如果直接执行`script`脚本变量并不会被存进`global`中.
>> Global(全局)对象可以说是ECMAScript中最特别的一个对象了, 因为不管你从什么角度上看, 这个对象都是不存在的. ECMAScript中的Global对象在某种意义上是作为一个终极的“兜底儿对象”来定义的. 换句话说, 不属于任何其他对象的属性和方法, 最终都是他的属性和方法.
>
> nodejs的REPL环境和script的执行环境是不一样的

### 顶层对象的各类实现

- 浏览器里面, 顶层对象是`window`, 但 `Node` 和 `Web Worker` 没有`window`.
- 浏览器和 `Web Worker` 里面, `self`也指向顶层对象, 但是 `Node` 没有`self`.
- `Node` 里面, 顶层对象是`global`, 但其他环境都不支持.

同一段代码为了能够在各种环境, 都能取到顶层对象, 现在一般是使用this变量, 但是有局限性.

- 全局环境中, `this`会返回顶层对象. 但是, Node 模块和 ES6 模块中, `this`返回的是当前模块.
- 函数里面的`this`, 如果函数不是作为对象的方法运行, 而是单纯作为函数运行, `this`会指向顶层对象. 但是, 严格模式下, 这时`this`会返回`undefined`.
- 不管是严格模式, 还是普通模式, `new Function('return this')()`, 总是会返回全局对象. 但是, 如果浏览器用了 CSP(Content Security Policy, 内容安全政策), 那么`eval`&`new Function`这些方法都可能无法使用.

综上所述, 很难找到一种方法, 可以在所有情况下, 都取到顶层对象. 下面是两种勉强可以使用的方法.

```javascript
// 方法一
(typeof window !== 'undefined'
   ? window
   : (typeof process === 'object' &&
      typeof require === 'function' &&
      typeof global === 'object')
     ? global
     : this);

// 方法二
var getGlobal = function () {
  if (typeof self !== 'undefined') { return self; }
  if (typeof window !== 'undefined') { return window; }
  if (typeof global !== 'undefined') { return global; }
  throw new Error('unable to locate global object');
};
```

<!-- ## TODO变量命名的三者区别 -->

var | let | const
:-:|:-:|:-:
 A1 | B1 | C1
 A2 | B2 | C2
 A3 | B3 | C3

## 变量的解构赋值

### 数组的解构赋值

### 对象的解构赋值
>  let { foo: bar } = { foo: "aaa", bar: "bbb" };
undefined
> console.log(bar)
aaa

与数组一样，解构也可以用于嵌套结构的对象。

let obj = {
  p: [
    'Hello',
    { y: 'World' }
  ]
};

let { p: [x, { y }] } = obj;
x // "Hello"
y // "World"

注意，这时p是模式，不是变量，因此不会被赋值。如果p也要作为变量赋值，可以写成下面这样。

let obj = {
  p: [
    'Hello',
    { y: 'World' }
  ]
};

let { p, p: [x, { y }] } = obj;
x // "Hello"
y // "World"
p // ["Hello", {y: "World"}]

下面是嵌套赋值的例子。

let obj = {};
let arr = [];

({ foo: obj.prop, bar: arr[0] } = { foo: 123, bar: true });

obj // {prop:123}
arr // [true]

### JavaScript中的函数运行在它们被定义的作用域里,而不是它们被执行的作用域里


<!-- ## TODO严格模式相关 -->

1. 在严格模式中禁止使用with语句.

2. 在严格模式中, 所有的变量都要先声明, 如果给一个未声明的变量. 函数. 函数参数. catch从句参数或全局对象的属性赋值, 将会抛出一个引用错误(在非严格模式中, 这种隐式声明的全局变量的方法是给全局对象新添加一个新属性).

3. 在严格模式中, 调用的函数(不是方法)中的一个this值是undefined. (在非严格模式中, 调用的函数中的this值总是全局对象). 可以利用这种特性来判断JavaScript实现是否支持严格模式：

```javascript
    var hasStrictMode = (function(){"use strict";return this===undefined;}());
```

4. 同样, 在严格模式中, 当通过call()或apply()来调用函数时, 其中的this值就是通过call()或apply()传入的第一个参数(在非严格模式中, null和undefined值被全局对象和转换为对象的非对象值所代替).

5. 在严格模式中, 给只读属性赋值和给不可扩展的对象创建新成员都将抛出一个类型错误异常(在非严格模式中, 这些操作只是简单地操作失败, 不会报错).

6. 在严格模式中, 传入eval()的代码不能在调用程序所在的上下文中声明变量或定义函数, 而在非严格模式中是可以这样做的. 相反, 变量和函数的定义是在eval()创建的新作用域中, 这个作用域在eval()返回时就弃用了.

7. 在严格模式中, 函数里的arguments对象拥有传入函数值的静态副本. 在非严格模式中, arguments对象具有“魔术般”的行为, arguments里的数组元素和函数参数都是指向同一个值的引用.

8. 在严格模式中, 当delete运算符后跟随非法的标识符(比如变量. 函数. 函数参数)时, 将会抛出一个语法错误异常(在非严格模式中, 这种delete表达式什么也没做, 并返回false).

9. 在严格模式中, 试图删除一个不可配置的属性将抛出一个类型错误异常(在非严格模式中, delete表达式操作失败, 并返回false).

10. 在严格模式中, 在一个对象直接量中定义两个或多个同名属性将产生一个语法错误(在非严格模式中不会报错).

11. 在严格模式中, 函数声明中存在两个或多个同名的参数将产生一个语法错误(在非严格模式中不会报错).

12. 在严格模式中是不允许使用八进制整数直接量(以0为前缀, 而不是0x为前缀)的(在非严格模式中某些实现是允许八进制整数直接量的).

13. 在严格模式中, 标识符eval和arguments当作关键字, 他们的值是不能更改的. 不能给这些标识符赋值, 也不能把它们声明为变量. 用作函数名. 用作函数参数或用作catch块的标识符.

14. 在严格模式中限制了对调用栈的检测能力, 在严格模式的函数中, arguments.caller和arguments.callee都会抛出一个类型错误异常. 严格模式的函数同样具有caller和arguments属性, 当访问这两个属性时将抛出类型错误异常(有一些JavaScript的实现在非严格模式里定义了这些非标准的属性).

1, 全局变量的显示声明
2, 严格模式限制了动态绑定, 比如禁止使用with, 创设eval的单独作用域
3, 严格模式下让你头痛的this关键字不能指向全局变量了
4, 不能重名：对象不能有重名属性, 方法不能有重名形参
5, 对于arguments的限制, 严格模式下不能对其赋值了, 也不再跟踪参数的变化, arguments.callee也不允许使用
6, 函数必须声明在顶层, 不允许在非函数代码块内声明函数
7, 试图删除不可删除的属性时会抛出异常
8, 严格模式禁止八进制数字语法
9, ECMAScript 6中的严格模式禁止设置primitive值的属性
10, 在严格模式中一部分字符变成了保留的关键字. 这些字符包括implements, interface, let, package, private, protected, public, static和yield. 在严格模式下, 你不能再用这些名字作为变量名或者形参名.



1.禁止不标准的全局变量(未使用var)
2.禁止使用with语句
3.禁止使用eval
4.禁止this关键字指向全局对象
5.禁止在函数内部遍历调用栈
6.禁止删除变量
7.对象不能有重命名属性
8.函数不能有重命名参数
9.禁止八进制表示法
10.不能对arguments赋值
11.arguments不再追踪参数的变化
12.禁止使用arguments.callee
13.严格模式只允许在全局作用域或函数作用域的顶层声明函数. 也就是说, 不允许在非函数的代码块内声明函数.

14.不能使用某些保留字：implements, interface, let, package, private, protected, public, static, yield.



严格模式的限制

不允许使用未声明的变量：
"use strict";
x = 3.14;                // 报错 (x 未定义)

尝试一下 »
Note 	对象也是一个变量.

"use strict";
x = {p1:10, p2:20};      // 报错 (x 未定义)

尝试一下 »

不允许删除变量或对象.
"use strict";
var x = 3.14;
delete x;                // 报错

尝试一下 »

不允许删除函数.
"use strict";
function x(p1, p2) {};
delete x;                // 报错

尝试一下 »

不允许变量重名:
"use strict";
function x(p1, p1) {};   // 报错

尝试一下 »

不允许使用八进制:
"use strict";
var x = 010;             // 报错

尝试一下 »

不允许使用转义字符:
"use strict";
var x = \010;            // 报错

尝试一下 »

不允许对只读属性赋值:
"use strict";
var obj = {};
Object.defineProperty(obj, "x", {value:0, writable:false});

obj.x = 3.14;            // 报错

尝试一下 »

不允许对一个使用getter方法读取的属性进行赋值
"use strict";
var obj = {get x() {return 0} };

obj.x = 3.14;            // 报错

尝试一下 »

不允许删除一个不允许删除的属性：
"use strict";
delete Object.prototype; // 报错

尝试一下 »

变量名不能使用 "eval" 字符串:
"use strict";
var eval = 3.14;         // 报错

尝试一下 »

变量名不能使用 "arguments" 字符串:
"use strict";
var arguments = 3.14;    // 报错

尝试一下 »

不允许使用以下这种语句:
"use strict";
with (Math){x = cos(2)}; // 报错

尝试一下 »

由于一些安全原因, 在作用域 eval() 创建的变量不能被调用：
"use strict";
eval ("var x = 2");
alert (x);               // 报错

尝试一下 »

禁止this关键字指向全局对象.

function f(){
    return !this;
}
// 返回false, 因为"this"指向全局对象, "!this"就是false

function f(){
    "use strict";
    return !this;
}
// 返回true, 因为严格模式下, this的值为undefined, 所以"!this"为true.

因此, 使用构造函数时, 如果忘了加new, this不再指向全局对象, 而是报错.

function f(){
    "use strict";
    this.a = 1;
};
f();// 报错, this未定义

保留关键字

为了向将来Javascript的新版本过渡, 严格模式新增了一些保留关键字：

    implements
    interface
    let
    package
    private
    protected
    public
    static
    yield

"use strict";
var public = 1500;      // 报错

尝试一下 »

Note 	"use strict" 指令只允许出现在脚本或函数的开头.