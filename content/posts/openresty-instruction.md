---
title: "高性能网关基石——OpenResty"
date: 2022-12-27T15:08:48+08:00
draft: false
---

## 什么是 OpenResty
OpenResty 一个基于 Nginx 的高性能 Web 平台，能够方便地搭建处理超高并发的动态 Web 应用、
Web 服务和动态网关。例如有名的 Kong 网关和国产新秀 ApiSIX 网关都是基于 OpenResty 来进行打造的。

OpenResty 通过实现 `ngx_lua` 和 `stream_lua` 等 Nginx 模块，把 Lua/LuaJIT 完美地整合进了 Nginx，从而让我们能够在 Nginx 内部里嵌入 Lua 脚本，用 Lua 语言来实现复杂的 HTTP/TCP/UDP 业务逻辑，同时依然保持着高度的并发服务能力。

## 处理阶段
一个正常的 Web 服务的生命周期可以分成三个阶段：
1. **initing**：服务启动，读取配置文件，初始化内部数据结构
2. **running**：服务运行，接受客户端的请求，返回响应结果
3. **exiting**：服务停止，做一些必要的清理工作，如关闭监听端口

OpenResty 主要关注的是 **initing** 和 **running** 这两个阶段，并做了更细致的划分
### OpenResty 的 initing 阶段
- **configuration**：读取配置文件，解析配置指令，设置运行参数
- **master-initing**：配置文件解析完毕，master 进程初始化公用的数据
- **worker-initing**：worker 进程初始化自己专用的数据

### OpenResty 的 running 阶段
在 running 阶段，收到客户端的请求后，OpenResty 对每个请求都会使用下面这条流水线进行处理：
1. **ssl**：SSL/TLS 安全通信和验证
2. **preread**： 在正式处理之前**预读**数据，接收 HTTP 请求头
3. **rewrite**：检查、改写 URI ，实现跳转重定向
4. **access**：访问权限控制
5. **content**：产生响应内容
6. **filter**：对 **content** 阶段产生的内容进行过滤加工处理
7. **log**： 请求处理完毕，记录日志，或者其他的收尾工作。

![](https://cdn.jsdelivr.net/gh/greycodee/images@main/picgo/openresty-phase.png)

## OpenResty 执行程序
OpenResty 根据上面的处理阶段提供了一些指令，在开发时使用它们就可以在这些阶段里面插入 Lua 代码，执行业务逻辑：
- **init_by_lua_file**：master-initing 阶段，初始化全局配置或模块
- **init_worker_by_lua_file**：worker-initing 阶段，初始化进程专用功能
- **ssl_certificate_by_lua_file**：ssl 阶段，在握手时设置安全证书
- **set_by_lua_file**：rewrite 阶段，改写 Nginx 变量
- **rewrite_by_lua_file**：rewrite 阶段，改写 URI ，实现跳转或重定向
- **access_by_lua_file**：access 阶段，访问控制或限速
- **content_by_lua_file**：content 阶段，产生响应内容
- **balancer_by_lua_file**：content 阶段，反向代理时选择后端服务器
- **header_filter_by_lua_file**：filter 阶段，加工处理响应头
- **body_filter_by_lua_file**：filter 阶段，加工处理响应体
- **log_by_lua_file**：log 阶段，记录日志或其他的收尾工作

> 这些指令通常有三种形式：
> - xxx_by_lua：执行字符串形式的 Lua 代码：
> - xxx_by_lua_block：功能相同，但指令后是｛ ．．．｝的 Lua 代码块
> - xxx_by_lua_file：功能相同，但执行磁盘上的 Lua 源码文件。
> 这边推荐使用 xxx_by_lua_file，它彻底分离了配置文件与业务代码，让两者可以独立部署，而且文件形式也让我们更容易以模块的方式管理组织 Lua 程序。

下面是  OpenResty 指令所在的阶段和执行的先后顺序图
![](https://cdn.jsdelivr.net/gh/greycodee/images@main/picgo/openrestyflow.png)


## Demo 编写 
为了能够直观的看到上面的处理阶段,接下来编写一个 OpenResty 的 小 demo. 先在本地电脑上安装 OpenResty 然后执行下面命令看看有没有安装成功,如果安装成功了,就会出现版本号
```shell
$ sudo openresty -v
nginx version: openresty/1.21.4.1
```
然后执行下面命令创建一些文件夹:
```shell
mkdir testresty && 
cd testresty && 
mkdir logs conf service && 
cd logs && touch error.log && touch access.log
```
创建完成后,文件目录结构就像下面这样:
```shell
├── conf
├── logs
│   ├── access.log
│   └── error.log
└── service
```
其中, **conf** 文件夹是存放 `nginx.conf` 等配置的地方,然后自己编写的 `lua` 代码文件可以放在 **service** 文件夹下.
接下来,创建和编写每个阶段所需的 `lua` 脚本文件, 只在里面编写一条打印日志的代码, 然后放进 **service** 文件夹下
- rewrite.lua
```lua
ngx.log(ngx.ALERT,"this is rewrite")
```
- access.lua
```lua
ngx.log(ngx.ALERT,"this is access")
```

- content.lua
```lua
ngx.log(ngx.ALERT,"this is content")
-- 响应内容
ngx.say('hello world')
```

- header_filter.lua
```lua
ngx.log(ngx.ALERT,"this is header_filter")
```

- body_filter.lua
```lua
ngx.log(ngx.ALERT,"this is body_filter")
```

- log.lua
```lua
ngx.log(ngx.ALERT,"this is log")
```

编写 `nginx.conf` 配置文件, 放进 **conf** 文件夹下
```conf
user root;

worker_processes    1;
events {
    worker_connections  512;
}

http {
    server {
        listen  80;
    
        location / {
            rewrite_by_lua_file service/rewrite.lua;
            access_by_lua_file service/access.lua;
            content_by_lua_file service/content.lua;
            header_filter_by_lua_file service/header_filter.lua;
            body_filter_by_lua_file service/body_filter.lua;
            log_by_lua_file service/log.lua;
        }

    }
}
```
然后启动 OpenResty, 使用 `-p` 选项, 传入你上面创建的文件夹地址
```shell
$ sudo openresty -p $HOME/testresty
```
启动完成后, 然后用浏览器访问 `http://localhost`, 可以看到上面通过 `ngx.say('hello world')` 的响应内容设置返回的 `hello world`.
打开 `logs/error.log` 文件,可以看到 Lua 代码里打印的日志:
```shell
2022/12/26 15:59:26 [alert] 31700#0: *119 [lua] rewrite.lua:1: this is rewrite, client: 127.0.0.1, server: , request: "GET / HTTP/1.1", host: "localhost"
2022/12/26 15:59:26 [alert] 31700#0: *119 [lua] access.lua:1: this is access, client: 127.0.0.1, server: , request: "GET / HTTP/1.1", host: "localhost"
2022/12/26 15:59:26 [alert] 31700#0: *119 [lua] content.lua:1: this is content, client: 127.0.0.1, server: , request: "GET / HTTP/1.1", host: "localhost"
2022/12/26 15:59:26 [alert] 31700#0: *119 [lua] header_filter.lua:1: this is header_filter, client: 127.0.0.1, server: , request: "GET / HTTP/1.1", host: "localhost"
2022/12/26 15:59:26 [alert] 31700#0: *119 [lua] body_filter.lua:1: this is body_filter, client: 127.0.0.1, server: , request: "GET / HTTP/1.1", host: "localhost"
2022/12/26 15:59:26 [alert] 31700#0: *119 [lua] body_filter.lua:1: this is body_filter, client: 127.0.0.1, server: , request: "GET / HTTP/1.1", host: "localhost"
2022/12/26 15:59:26 [alert] 31700#0: *119 [lua] log.lua:1: this is log while logging request, client: 127.0.0.1, server: , request: "GET / HTTP/1.1", host: "localhost"
```
通过日志可以观察到每个阶段的执行顺序是怎样的.
