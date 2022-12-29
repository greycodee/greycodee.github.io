---
title: "程序执行过程简述"
date: 2022-12-28T14:37:51+08:00
draft: false
---


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
