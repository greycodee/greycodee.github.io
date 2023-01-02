---
title: "LuaJIT Introduction"
date: 2023-01-02T14:55:38+08:00
draft: false
---

## What's JIT?
Just-In-Time or JIT 是指在程序运行时进行代码编译的技术，像 Java，Python（这里指PyPy）、LuaJIT 都引入了这种技术。

一般 JIT 编译器与解释器一同工作，大部分时间代码由解释器进行转换成机器码进行运行，当某些代码运行的次数超过设定的阈值时，就会触发 JIT 编译进行工作，JIT 编译器会把这些热点代码编译为机器码，当下次运行到这些代码时，就不用解析器进行解释转换了，可以直接运行机器码来提高程序的运行速度。

![](https://cdn.jsdelivr.net/gh/greycodee/images@main/picgo/20230102152341.png)

## How does work of LuaJIT?
顾名思义，LuaJIT 是一种即时(JIT) 编译器。这意味着函数是按需编译的，即当它们首先运行时。这既确保了应用程序的快速启动，也有助于避免无用的工作。例如，未使用的函数根本不会被编译。

另一种编译方法称为提前(AOT) 编译。这里所有的东西都是在运行任何函数之前编译的。这是许多语言的经典方式，例如 C、C++、Go、Rust 等等。

当启动 LuaJIT 时，一切都像在标准 Lua 中一样进行：初始化 Lua 核心，加载标准库并分析命令行。然后通常会加载第一个 Lua 源代码文件并将其转换为 Lua 字节码。最后运行初始主块的函数......

example.lua:
```lua
local s = "hello,world!"

for i=1,10000 do
    for j=1,10000 do
        string.find(s, "ll", 1, true)
    end
end
```
上面代码中，它会被先转换成 LuaJIT 自己定义的字节码，我们可以用下面的命令来查看：
```bash
$ luajit -bl example.lua
```
```bash
-- BYTECODE -- example.lua:0-8
0001    KSTR     0   0      ; "hello,world!"
0002    KSHORT   1   1
0003    KSHORT   2 10000
0004    KSHORT   3   1
0005    FORI     1 => 0019
0006 => KSHORT   5   1
0007    KSHORT   6 10000
0008    KSHORT   7   1
0009    FORI     5 => 0018
0010 => GGET     9   1      ; "string"
0011    TGETS    9   9   2  ; "find"
0012    MOV     10   0
0013    KSTR    11   3      ; "ll"
0014    KSHORT  12   1
0015    KPRI    13   2
0016    CALL     9   1   5
0017    FORL     5 => 0010
0018 => FORL     1 => 0006
0019 => RET0     0   1
```
然后这些字节码再交给`解释器`去执行，当执行达到阈值设定时，就会触发 JIT 编译器的工作，LuaJIT 会先将它转换成 `IR` 中间码，然后转换成**对应平台的机器码**

![](https://cdn.jsdelivr.net/gh/greycodee/images@main/picgo/20230102180418.png)

## Not Yet Implemented
在 LuaJIT 中，当 JIT 编译器编译成功后就会生成一个 `trace` 类型的 `GC` 对象，但是并不是所有的代码 LuaJIT 都能够成功编译。

当 LuaJIT 遇到不支持的函数或代码（一般叫它：NYI）时，就会中止当前的编译工作，重新回退到解释器执行的模式去。

例如上面的 `string.find()` 函数，只有 `LuaJIT 2.1` 以上的版本才支持，我们可以执行添加 `-jv` 选项来显示有关 JIT 编译器进度的详细信息。

```bash
$ luajit -v
LuaJIT 2.0.5 -- Copyright (C) 2005-2017 Mike Pall. http://luajit.org/

$ luajit -jv example.lua
[TRACE --- example.lua:4 -- NYI: FastFunc string.find at example.lua:5]
```
当 LuaJIT 版本为 `2.0.5` 时，就会提示你 `NYI: FastFunc string.find at example.lua:5`，意思就是说LuaJIT 编译器不支持编译 `example.lua` 文件的第 `5` 行代码，第 5 行代码就是 `string.find(s, "ll", 1, true)`

当我们切换到 `luajit-2.1.0-beta3` 后，再执行看看：
```bash
$ luajit-2.1.0-beta3 -jv example.lua
[TRACE   1 example.lua:4 loop]
[TRACE   2 (1/3) example.lua:3 -> 1]
```
`TRACE` 后面接着是数字，说明 JIT 编译成功了

## How does maintain speed of LuaJIT?
要保证 LuaJIT 的运行速度时，就要避免使用 NYI 函数，如果调用 C 函数的话，尽量使用 LuaJIT 的 `ffi` 库来调用 C 函数。

尽量保持使用最新的 LuaJIT 版本，LuaJIT 的 2.1 版本加入了很多原先不支持的 NYI 函数，例如 `string.find()` 等，所以尽量使用最新版本来提升可被 JIT 编译的函数的数量。

如果需要使用 NYI 函数时，可以去看看网上或 `OpenResty` 中有没有对应替代函数。
## Speed Test between JIT and None-JIT
那么，有 JIT 和没有 JIT 之间的速度差异到底有大呢？

由于 `LuaJIT 2.0.5` 的 JIT 不支持 `string.find()`，不会触发 JIT 的编译工作，所以我们可以用上面的代码，然后用 `LuaJIT 2.0.5` 和 `LuaJIT 2.1.0-beta3` 分别来执行测试下有 JIT 和 没有 JIT 之间代码执行的速度：

example.lua:
```lua
local s = "hello,world!"

for i=1,10000 do
    for j=1,10000 do
        string.find(s, "ll", 1, true)
    end
end
```

**LuaJIT 2.0.5 的执行速度：**
```bash
# 第一次测试
$ time luajit-2.0.5 example.lua
luajit-2.0.5 example.lua  2.14s user 0.00s system 99% cpu 2.140 total

# 第二次测试
$ time luajit-2.0.5 example.lua
luajit-2.0.5 example.lua  2.17s user 0.00s system 99% cpu 2.169 total

# 第三次测试
$ time luajit-2.0.5 example.lua
luajit-2.0.5 example.lua  2.17s user 0.00s system 99% cpu 2.176 total
```

**LuaJIT 2.1.0-beta3 的执行速度：**
```bash
# 第一次测试
$ time luajit-2.1.0-beta3 example.lua
luajit-2.1.0-beta3 example.lua  0.03s user 0.00s system 99% cpu 0.026 total

# 第二次测试
$ time luajit-2.1.0-beta3 example.lua
luajit-2.1.0-beta3 example.lua  0.02s user 0.00s system 99% cpu 0.024 total

# 第三次测试
$ time luajit-2.1.0-beta3 example.lua
luajit-2.1.0-beta3 example.lua  0.03s user 0.00s system 99% cpu 0.026 total
```

可以看到，两个的速度相差了差不多 `100 倍`，
