---
title: "Create a simple kernel module"
date: 2023-03-25T14:39:37+08:00
draft: false
---


## 编写模块代码

创建一个文件夹，命名为`hello`，并在该文件夹下创建一个名为`hello.c`的文件，输入以下代码：

```c
#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Your Name");
MODULE_DESCRIPTION("A simple Hello World module");

static int __init hello_init(void)
{
    printk(KERN_INFO "Hello, world!\n");
    return 0;
}

static void __exit hello_exit(void)
{
    printk(KERN_INFO "Goodbye, world!\n");
}

module_init(hello_init);
module_exit(hello_exit);
```

## 编写Makefile

```makefile
obj-m += hello.o

all:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules

clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean

```

## 编译

在终端中进入`hello`文件夹，输入以下命令编译内核模块：

```bash
make -C /lib/modules/$(uname -r)/build M=$(pwd) modules
```

编译成功后，会生成一个名为`hello.ko`的内核模块文件。

## 使用模块

加载内核模块，输入以下命令：

```bash
sudo insmod hello.ko
```

查看内核日志，输入以下命令：

```bash
dmesg
```

卸载内核模块，输入以下命令：

```bash
sudo rmmod hello
```

这个简单的内核模块会在加载时打印`Hello, world!`，在卸载时打印`Goodbye, world!`。可以根据自己的需求修改代码并重新编译运行。

