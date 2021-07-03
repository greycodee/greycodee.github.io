---
title: Java删除文件后电脑磁盘空间没有恢复
top: false
cover: false
toc: true
mathjax: true
date: 2021-07-03 17:12:41
password:
summary:
keywords:
description: 当用一下命令删除文件后，电脑磁盘内存没有恢复，还是原来的大小
tags:
- Java
- Linux
categories:
- Java
---



## 问题

当用一下命令删除文件后，电脑磁盘内存没有恢复，还是原来的大小

```java
File folder = new File("/tmp/file.mp4")
file.delete();
```

## 解决

原来是 `FileOutputStream` 文件流忘了关了，导致一直占用这个资源。所以使用完后一定记得关文件流，使用下面的代码关闭文件流：

```java
FileOutputStream fileOutputStream = new FileOutputStream(new File());
fileOutputStream.close();
```

**Linux 里的文件被删除后，空间没有被释放是因为在 Linux 系统中，通过 rm 或者文件管理器删除文件将会从文件系统的目录结构上解除链接(unlink).然而如果文件是被打开的(有一个进程正在使用)，那么进程将仍然可以读取该文件，磁盘空间也一直被占用。**

可以使用 `lsof +L1 |grep delete` 命令来查看状态为 `deleted` 的文件，状态为 `deleted` 为标记被删除，其实该文件并没有从磁盘中删除，类似windows下的回收站状态。

所以当进程结束后，磁盘空间就会被释放。

## 参考资料

- http://www.cxyzjd.com/article/su4416160/78212934
- https://www.jianshu.com/p/fcb80c878d04
