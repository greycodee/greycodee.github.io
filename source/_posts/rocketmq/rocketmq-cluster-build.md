---
title: RocketMQ集群搭建
top: true
cover: false
toc: true
mathjax: true
tags:
  - RocketMQ
  - Linux
categories:
  - RocketMQ
date: 2019-10-09 20:55:36
password:
summary:
---

  本文只讲RocketMQ集群的搭建(异步复制)，具体理论知识后续会在写新文章详细介绍;



## 环境

- JDK1.8
- Centos7



## 主机-两台

- centos7_1 :172.16.54.130
- centos7_2 :172.16.54.128



## 软件资源

- JDK1.8 :https://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html
- RocketMQ4.5.2 :http://mirrors.tuna.tsinghua.edu.cn/apache/rocketmq/4.5.2/rocketmq-all-4.5.2-bin-release.zip



## 安装JDK

  首先分别在两台主机上安装JDK1.8，具体安装方法这里就不说了，网上随便搜一搜都有；



## 配置RocketMQ

  把下载的RocketMQ包分别上传到两台服务器上，然后用命令解压:

  ```shell
# unzip rocketmq-all-4.5.2-bin-release.zip
  ```

### 编写配置文件

  这一步很重要，集群的搭建关键在于配置文件的编写，首先看看RocketMQ配置文件的解析:

```properties
#所属集群名字 
brokerClusterName=rocketmq-cluster

#broker名字，每队master和slave保持一致
brokerName=broker-a

#0 表示 Master，>0 表示 Slave
brokerId=0 

#指定主机ip
brokerIP1 = 主机IP

#nameServer地址，分号分割
namesrvAddr=主机IP:9876;主机IP:9876

#在发送消息时，自动创建服务器不存在的topic，默认创建的队列数 
defaultTopicQueueNums=4

#是否允许 Broker 自动创建Topic，建议线下开启，线上关闭 
autoCreateTopicEnable=true

#是否允许 Broker 自动创建订阅组，建议线下开启，线上关闭 
autoCreateSubscriptionGroup=true

#Broker 对外服务的监听端口 
listenPort=10911

#删除文件时间点，默认凌晨 4点
 deleteWhen=04

#文件保留时间，默认 48 小时 
fileReservedTime=120

#commitLog每个文件的大小默认1G 
mapedFileSizeCommitLog=1073741824

#ConsumeQueue每个文件默认存30W条，根据业务情况调整
mapedFileSizeConsumeQueue=300000

#检测物理文件磁盘空间
diskMaxUsedSpaceRatio=88

#存储路径
storePathRootDir=/usr/local/rocketmq/store
#commitLog 存储路径 
storePathCommitLog=/usr/local/rocketmq/store/commitlog
#消费队列存储路径存储路径
storePathConsumeQueue=/usr/local/rocketmq/store/consumequeue
#消息索引存储路径
storePathIndex=/usr/local/rocketmq/store/index
#checkpoint 文件存储路径
storeCheckpoint=/usr/local/rocketmq/store/checkpoint

#Broker 的角色
#- ASYNC_MASTER 异步复制Master
#- SYNC_MASTER 同步双写Master
#- SLAVE 
brokerRole=ASYNC_MASTER

#刷盘方式
#- ASYNC_FLUSH 异步刷盘
#- SYNC_FLUSH 同步刷盘 flushDiskType=ASYNC_FLUSH
#checkTransactionMessageEnable=false

#abort 文件存储路径
abortFile=/usr/javawork/apache-rocketmq/store/abort

#限制的消息大小 maxMessageSize=65536
```

以上配置可根据个人需求加入到自己的配置文件中；RocketMQ官方已经为我们创建好了简单的集群配置文件，进去解压后的文件夹，在进入到conf文件夹，可以看到里面有三个文件夹：

- 2m-2s-async :2个master，2个slave，async异步复制
- 2m-2s-sync :2个master，2个slave，sync同步双写
- 2m-noslave :2个master,没有slave

这里我们用async异步复制模式，进入文件夹，分别编辑：

#### centos7_1主机编辑如下两个配置文件

> 注意，master和slave的文件存储路径不能用同一个路径，所以必须要区分开。

##### broker-a.properties

```properties
brokerClusterName=DefaultCluster
brokerName=broker-a
brokerId=0
deleteWhen=04
fileReservedTime=48
brokerRole=ASYNC_MASTER
flushDiskType=ASYNC_FLUSH
namesrvAddr=172.16.54.128:9876;172.16.54.130:9876
listenPort=10911
#存储路径
storePathRootDir=/usr/local/rocketmq/master/store
#commitLog 存储路径 
storePathCommitLog=/usr/local/rocketmq/master/store/commitlog
#消费队列存储路径存储路径
storePathConsumeQueue=/usr/local/rocketmq/master/store/consumequeue
#消息索引存储路径
storePathIndex=/usr/local/rocketmq/master/store/index
#checkpoint 文件存储路径
storeCheckpoint=/usr/local/rocketmq/master/store/checkpoint
```

*这个监听端口设置设置成10911后还会自动监听10909,10912这两个端口，所以要配置文件要避免设置到相应的端口。*

##### broker-a-s.properties

```properties
brokerClusterName=DefaultCluster
brokerName=broker-a
brokerId=1
deleteWhen=04
fileReservedTime=48
brokerRole=SLAVE
flushDiskType=ASYNC_FLUSH
namesrvAddr=172.16.54.128:9876;172.16.54.130:9876
listenPort=20911
#存储路径
storePathRootDir=/usr/local/rocketmq/slave/store
#commitLog 存储路径 
storePathCommitLog=/usr/local/rocketmq/slave/store/commitlog
#消费队列存储路径存储路径
storePathConsumeQueue=/usr/local/rocketmq/slave/store/consumequeue
#消息索引存储路径
storePathIndex=/usr/local/rocketmq/slave/store/index
#checkpoint 文件存储路径
storeCheckpoint=/usr/local/rocketmq/slave/store/checkpoint
```

*这个监听端口设置设置成20911后还会自动监听20909,20912这两个端口，所以要配置文件要避免设置到相应的端口。*



#### centos7_2主机编辑如下两个配置文件

##### 和centos7_1主机配置一样，这边就不写了，不过brokerName要设置成不同的，我这边设置成broker-b。



## 设置RocketMQ运行的JVM内存(非必须)

> 此项设置非必须，如果你主机内存很大的话可以不设置，RocketMQ默认要8G。

  进入rocketmq-all-4.5.2-bin-release/bin目录，两台主机分别设置runbroker.sh和runserver.sh这两个文件。

- runbroker.sh：找到如下一行配置

```properties
JAVA_OPT="${JAVA_OPT} -server -Xms8g -Xmx8g -Xmn4g"

改成：
JAVA_OPT="${JAVA_OPT} -server -Xms512m -Xmx512m -Xmn256m"
```

- runserver.sh: 找到如下一行配置

```properties
JAVA_OPT="${JAVA_OPT} -server -Xms4g -Xmx4g -Xmn2g -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=320m"

改成：
JAVA_OPT="${JAVA_OPT} -server -Xms512m -Xmx512m -Xmn256m -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=320m"
```



## 启动RocketMQ

> 启动RocketMQ前为了方便访问，先关闭两台主机的防火墙。执行如下命令：
>
> ```shell
> # service firewalld stop
> ```
>
> 

  进入rocketmq-all-4.5.2-bin-release/bin这个目录，两台主机分别执行以下命令：

- 启动namesrv

```shell
# nohup sh mqnamesrv &
```

- 启动broker-master

```shell
# nohup sh mqbroker -c ../conf/2m-2s-async/broker-a.properties &
```

- 启动broker-slave

```shell
# nohup sh mqbroker -c ../conf/2m-2s-async/broker-a-s.properties &
```

*注意两台主机启动broker时后面的-c记得加载你配置好的配置文件路径，别加载错了*



## 搭建Console可视化控制台

  任意一台机器或者本地下载Console源码，地址：https://github.com/apache/rocketmq-externals，或者有git的话直接用命令拉取：

```shell
# git clone https://github.com/apache/rocketmq-externals.git
```

进去目录：

```shell
# cd rocketmq-externals-master/rocketmq-console
```

修改配置文件：

```shell
# vim src/main/resources/application.properties
```

添加两个namesvr的主机ip

```properties
rocketmq.config.namesrvAddr=172.16.54.128:9876;172.16.54.130:9876
```

然后进项目跟目录，运行项目

```shell
# mvn sprint-boot:run
```

浏览器访问：

![可视化Console界面](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/rocketmq_console.png)