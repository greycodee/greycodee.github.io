---
title: "Program Exec Process"
date: 2022-12-28T14:37:51+08:00
draft: false
---
## 系统硬件组成
计算机主要由 4 个部分组成
1. **总线**：贯穿整个系统的是一组电子管道，称作总线，它携带信息字节并负责在各个部件间传递。通常总线被设计成传送定长的字节块 ，也就是字（word)。字中的字节数（即字长）是一个基本的系统参数 ，各个系统中都不尽相同。现在的大多数机器字长要么是 4 个字节（`32位`）， 要么是 8 个字节（`64位`）。
2. **I/O 设备**：(Input/Output)输入输出设备，包括键盘、显示器、磁盘、等。
3. **主存**：主存是计算机中的临时存储器，用来存放正在运行的程序和数据，断电数据就会丢失。它的容量比较小，速度比较快，但是比较昂贵。主存是由一组动态随机存取存储器（`DRAM`）芯片组成的。
4. **CPU**：处理器，是计算机的核心，它负责执行程序中的指令，控制其他部件的工作。它的主要组成部分有算术逻辑单元（ALU）、控制单元（CU）、寄存器和总线。

其中，CPU 主要做以下几个操作：
- **加载**：将数据从主存复制到 CPU 的寄存器中
- **存储**：将数据从 CPU 的寄存器复制到主存中
- **算术运算**：把两个寄存器的内容复制到 ALU 中，ALU 对数据进行算术运算，然后将结果存储到寄存器中
- **跳转**：从指令中取出一个地址，然后把这个地址复制到 PC 中，从而改变程序的执行顺序

![0CFaQyuupVbR](https://cdn.jsdelivr.net/gh/greycodee/images@main/2022/12/28/0CFaQyuupVbR.jpg)

## 高速缓存
由于 CPU 从寄存器中读取数据的速度是从主存中读取数据速度几百倍。所以主存成了拖慢 CPU 速度的主要原因，为了提高 CPU 的速度，引入了**高速缓存**（Cache）的概念。

高速缓存（Cache）是一种存储器，它位于主存和 CPU 之间，用来存放最近使用的数据和指令。高速缓存的容量比主存小，但是速度比主存快，所以 CPU 可以从高速缓存中读取数据和指令，而不必每次都到主存中读取。高速缓存的容量和速度都比较昂贵，所以一般只有少量的高速缓存。

现在一般比较新的处理器有有三级高速缓存：L1、L2、L3，它们是用一种叫做**静态随机访问存储器**（`SRAM`）的硬件技术实现的。

CPU 访问 L1 的速度和访问寄存器一样快，后面的 L2、L3 缓存由于离 CPU 更远，所以速度会慢一些。

![JRDEcsfuuEzR](https://cdn.jsdelivr.net/gh/greycodee/images@main/2022/12/28/JRDEcsfuuEzR.jpg)

## 存储设备层次结构
每个计算机系统中的存储设备都被组织成了一个存储器层次结构。在这个层次结构中，**从上至下，设备的访问速度越来越慢、容量越来越大，并且每字节的造价也越来越便宜**。寄存器文件在层次结构中位于最顶部 ，也就是第 0 级或记为 L0。这里我们展示的是三层高速缓存 L1 到 L3,占据存储器层次结构的第 1 层到第 3 层。主存在第 4 层，以此类推。

![QHmMjQ8Y6GGM](https://cdn.jsdelivr.net/gh/greycodee/images@main/2022/12/28/QHmMjQ8Y6GGM.jpg)

## 多核 CPU
多核 CPU 是指一个 CPU 包含多个核心，每个核心都有自己的寄存器文件和高速缓存。多核 CPU 的主要优点是可以同时执行多个程序，从而提高 CPU 的利用率。
![Usf06VQ80dUv](https://cdn.jsdelivr.net/gh/greycodee/images@main/2022/12/28/Usf06VQ80dUv.jpg)

## 代码编译过程

```c
#include <stdio.h>

int main(){
    printf("hello world\n");
    return 0;
}
```

一个 **C 语言**的程序，从代码到一个**可执行文件**，其中要经历 4 个阶段程序
1. 预处理
2. 编译器
3. 汇编器
4. 链接器

这四个阶段一起构成了**编译系统**
![program-exec-processg6STth](https://cdn.jsdelivr.net/gh/greycodee/images@main/2022/12/28/program-exec-processg6STth.png)

- **预处理阶段**：直接修改原始程序，进行一些文本替换方面的操作，例如宏展开、文件包含、删除部分代码等。

可以用下面这个命令来使用 `gcc` 编译器来生成预处理的文件 `main.i` , 然后可以直接用你的 vscode 或文本编辑器来打开查看它
```shell
$ gcc -E main.c -o main.i
```

- **编译阶段**：将源代码文件编译成**汇编语言**

可以通过执行下面这个命令来编译预处理阶段生成的 `main.i` 文件来生成汇编代码文件  `main.s`

```shell
$ gcc -S main.i -o main.s
```
```x86asm
	.file	"main.c"
	.text
	.section	.rodata
.LC0:
	.string	"hello world"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	leaq	.LC0(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	movl	$0, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 11.3.0-1ubuntu1~22.04) 11.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:

```

- **汇编阶段**：将编译阶段产生的汇编代码再编译**机器语言**

通过下面的命令，将编译阶段产生的汇编代码再编译成机器字节码 `main.o` 文件
```shell
$ gcc -c main.s -o main.o
```

- **链接阶段**：连接当前代码文件所需的其他函数，例如上面的的代码中调用了标准库中的 `printf` 函数，所以在这个阶段，会将 `printf.o` 文件合并到 `main.o` 文件中，生成可执行的二进制文件

## 程序执行过程
我们可以直接用 `gcc` 编译工具来直接编译生成可执行文件，也可以通过上面的四个阶段来生成可执行文件，然后再执行它

```shell
$ gcc main.c -o main
```
这样就生成了一个可执行文件 `main` ，然后我们可以直接执行它
```shell
$ ./main
```
