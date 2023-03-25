---
title: "快速入门ebpf"
date: 2023-03-23T11:19:47+08:00
draft: true
---

## 环境准备

在开始编写eBPF程序之前，我们需要准备好开发环境。这里我们以Ubuntu 20.04为例，介绍如何安装必要的工具和库。

### 安装依赖

首先，我们需要安装一些必要的依赖。在终端中执行以下命令：

```bash
sudo apt update
sudo apt install -y build-essential libelf-dev libbpf-dev linux-headers-$(uname -r)
```

这些依赖包括了编译工具链、libbpf库和内核头文件，它们是编写和编译eBPF程序的必要组件。

### 安装LLVM和clang

LLVM是eBPF程序的编译器，clang是LLVM的C语言前端。我们需要安装最新版的LLVM和clang。在终端中执行以下命令：

```bash
wget https://apt.llvm.org/llvm.sh
chmod +x llvm.sh
sudo ./llvm.sh 12
```

这个命令会下载并安装LLVM 12和clang。安装完成后，可以使用以下命令验证安装是否成功：

```bash
clang --version
```

如果输出了clang的版本信息，则说明安装成功。

### 安装bpftool

bpftool是一个命令行工具，用于管理和调试eBPF程序。我们需要安装最新版的bpftool。在终端中执行以下命令：

```bash
sudo apt install -y linux-tools-$(uname -r)
```

这个命令会安装最新版的linux-tools包，其中包括了bpftool工具。

## 编写eBPF程序

在环境准备完成后，我们可以开始编写eBPF程序了。这里我们以一个简单的eBPF程序为例，用于捕获TCP连接的建立和关闭事件。

### 编写程序代码

我们首先在终端中创建一个新的目录，用于存放程序代码和编译结果：

```bash
mkdir myebpf
cd myebpf
```

然后，我们创建一个新的C源文件，用于编写eBPF程序的代码：

```bash
touch tcp_monitor.c
```

将以下代码复制到tcp_monitor.c文件中：

```c
#include <linux/bpf.h>
#include <linux/if_ether.h>
#include <linux/ip.h>
#include <linux/tcp.h>

SEC("socket")
int bpf_prog(struct __sk_buff *skb)
{
    struct ethhdr *eth = skb->data;
    struct iphdr *ip = (struct iphdr *)(eth + 1);
    struct tcphdr *tcp = (struct tcphdr *)(ip + 1);

    if (eth->h_proto != htons(ETH_P_IP))
        return 0;

    if (ip->protocol != IPPROTO_TCP)
        return 0;

    if (tcp->syn && !tcp->ack) {
        bpf_printk("TCP connection established\n");
    }

    if (tcp->fin || tcp->rst) {
        bpf_printk("TCP connection closed\n");
    }

    return 0;
}

char _license[] SEC("license") = "GPL";
```

这个程序使用eBPF提供的socket hook，即在socket层处理网络数据包时执行的hook函数，来捕获TCP连接的建立和关闭事件。它首先从数据包中解析出以太网头、IP头和TCP头，然后判断是否为TCP连接建立或关闭事件，如果是则打印相应的信息。

### 编译程序代码

在程序代码编写完成后，我们需要使用clang和LLVM将程序代码编译成eBPF字节码。在终端中执行以下命令：

```bash
clang -O2 -target bpf -c tcp_monitor.c -o tcp_monitor.o
```

这个命令将tcp_monitor.c编译成eBPF字节码，并输出到tcp_monitor.o文件中。编译选项中的-O2用于开启优化，可以提高程序的性能。

## 加载eBPF程序

在程序代码编译完成后，我们可以使用bpftool将eBPF程序加载到内核中执行。这里我们将eBPF程序附加到socket hook上，从而开始捕获TCP连接的建立和关闭事件。

### 加载eBPF程序

在终端中执行以下命令，将tcp_monitor.o加载到内核中，并指定程序名为tcp_monitor：

```bash
sudo bpftool prog load tcp_monitor.o /sys/fs/bpf/tcp_monitor
```

这个命令将tcp_monitor.o加载到内核中，并将程序名设置为tcp_monitor。加载完成后，可以使用以下命令验证程序是否加载成功：

```bash
sudo bpftool prog show
```

这个命令会输出当前内核中所有已加载的eBPF程序信息，可以检查tcp_monitor是否在列表中。

### 附加eBPF程序

在程序加载完成后，我们需要将程序附加到socket hook上，从而开始捕获TCP连接的建立和关闭事件。在终端中执行以下命令：

```bash
sudo bpftool net attach socket pinned /sys/fs/bpf/tcp_monitor
```

这个命令将tcp_monitor程序附加到socket hook上，并将程序固定到/sys/fs/bpf/tcp_monitor目录下。附加完成后，可以使用以下命令验证程序是否附加成功：

```bash
sudo bpftool net list
```

这个命令会输出当前系统中所有已附加的eBPF程序信息，可以检查tcp_monitor是否在列表中。

## 测试eBPF程序

在eBPF程序加载和附加完成后，我们可以使用netstat等工具测试程序是否能够捕获TCP连接的建立和关闭事件。

在终端中执行以下命令，查看当前系统中的TCP连接信息：

```bash
netstat -tn
```

然后，在另一个终端中执行以下命令，建立一个新的TCP连接：

```bash
nc -vz 127.0.0.1 80
```

这个命令会向127.0.0.1的80端口发起一个TCP连接请求。在连接建立成功后，可以在第一个终端中看到类似以下的输出：

```
TCP connection established
```

然后，在另一个终端中执行以下命令，关闭刚刚建立的TCP连接：

```bash
nc -z 127.0.0.1 80
```

这个命令会向127.0.0.1的80端口发送一个TCP连接关闭请求。在连接关闭成功后，可以在第一个终端中看到类似以下的输出：

```
TCP connection closed
```

这些输出表明eBPF程序已经成功捕获了TCP连接的建立和关闭事件。

## 总结

恭喜你，你已经成功编写并部署了一个简单的eBPF程序！这个程序可以捕获TCP连接的建立和关闭事件，并打印相应的信息。这个例子虽然简单，但涵盖了eBPF程序的基本编写、编译和部署流程，可以作为入门eBPF的一个良好的起点。在实际应用中，eBPF可以应用于许多领域，如网络、安全、容器、云原生等。希望本教程能够帮助你更好地了解和应用eBPF技术。