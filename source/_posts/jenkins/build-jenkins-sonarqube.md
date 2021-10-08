---
title: Jenkins教程-集成SonarQube
top: false
cover: false
toc: true
mathjax: true
date: 2019-12-13 15:38:02
password:
summary:
keywords:
description:
tags:
- Jenkins
- SonarQube
- Docker
categories:
- Jenkins
---



## 什么是SonarQube?

看看维基百科的说明：
![图片](http://xhh.dengzii.com/Fi9bL7TAwFmCYPt3Cz_d0TIwm9rQ)

### SonarQube与CI/CD架构图
![SonarQube与CI/CD架构图](http://xhh.dengzii.com/FpResgoc3tny2jvGqaqudPwCwstj)

## Docker运行SonarQube

简单了解之后，开始安装SonarQube.这里用Docker安装

> 注：这里用mysql来存储SonarQube的数据，SonarQube7.9起已经不在支持mysql了，可以安装官方推荐的PostgreSQL

- SonarQube 6.7.7
- Docker-CE 19.03.1
- Mysql 5.7

### 安装

直接运行这个docker命令来安装，网上其他的教程有什么挂载文件什么的，我试了都会安装失败，原因还是因为权限原因，因为SonarQube不是以root用户运行的，导致没权限读写挂载出来的文件夹．

> 注意：创建容器前一定要先保证你连的容器有对应的数据库

```shell
docker run -d --name sonarqube -p 9099:9000 -p 9092:9092 --link=dev_mysql:mysql -e SONARQUBE_JDBC_USERNAME=app -e SONARQUBE_JDBC_PASSWORD=app -e SONARQUBE_JDBC_URL="jdbc:mysql://mysql:3306/sonar?useUnicode=true&characterEncoding=utf8&rewriteBatchedStatements=true&useConfigs=maxPerformance&useSSL=false" --restart=always sonarqube:6.7.7-community
```

- --link=dev_mysql:mysql     这个命令我链接到了我的mysql容器，dev_mysql是容器的名字，mysql是在SonarQube容器里的别名，所以链接数据库时直接用mysql这个别名就可了．

- SONARQUBE_JDBC_USERNAME ：数据库的账户

- SONARQUBE_JDBC_PASSWORD ：数据库密码



### 访问

安装好后直接访问<font color=orange>9099</font>端口，登录的账户和密码默认都是<font color=orange>admin</font>．首页就是这个样子的．

![图片](http://xhh.dengzii.com/Fs08WpcVDcL3n32MxoCNPDMtu1r5)


## Jenkins集成SonarQube

Jenkins和SonarQube都是运行在Docker容器里的

### 下载和安装插件

直接下载最新版的，然后导入，导入的方法可以看[插件导入方法](https://mjava.top/jenkins/problem-jenkins-01/)

- 插件下载地址：https://updates.jenkins.io/download/plugins/sonar/



### SonarQube生成Token

进入SonarQube管理界面

Administration->Security->Users

![图片](http://xhh.dengzii.com/FpFSYEgJfsJIwgNMA6tHHZtdAtpV)



然后随便输入一个名字，点击生成，记下Token

![图片](http://xhh.dengzii.com/FhTOSglZYOrP5poo_mmR3SGoobsD)



### 添加全局凭证

类型选Secret text,然后Secret和ID输入框都填入刚才生成的Token

![图片](http://xhh.dengzii.com/FrKo5EjJ9-78uYbDjBpiuVkeu-_5)

### 设置SonarQube servers

进入　系统管理->系统设置->SonarQube servers　　　　<font color=orange>设置好后点保存</font>

> 因为我SonarQube和Jenkins安装在同一台机器不同的Docker容器里的,所以这里URL直接填SonarQube的Docker容器的IP和端口

![图片](http://xhh.dengzii.com/FpevTpJePMDg9-HSoQoSOCNORHL8)



### 安装SonarQube Scanner

#### 下载压缩包

- 下载SonarQube Scanner压缩包：[SonarQube Scanner](https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.2.0.1873-linux.zip)

#### 解压到Jenkins挂载出来的目录里

只有解压到挂载出来的Jenkins的目录里，Docker容器安装的Jenkins才能读取到,<font color=orange>**我这里是宿主机的/opt/jenkins挂载到了Jenkins容器里的/var/jenkins_home目录上，所以我只要解压到宿主机的/opt/jenkins目录中就可以了**</font>

#### Jenkins配置全局工具

进入　系统管理->全局工具配置->SonarQube Scanner     找到模块后点击<font color=orange>新增SonarQube Scanner</font>

<font color=orange>SONAR_RUNNER_HOME填你Jenkins这个Docker容器里的路径</font>

![图片](http://xhh.dengzii.com/Fpgv2yqskGjp37mfoxHC6MGtIAPt)



## 构建一个Maven项目

网上很多教程说要勾上这个选项：

![图片](http://xhh.dengzii.com/FsSrQCDF5O9x4sufLZkFRz40toHI)
其实这个是可选的，下面有一句话：<font color=orange>These variables are useful when configuring a SonarQube analysis using standard build steps such as Maven, Gradle, Ant, and command line scripts.This feature is not needed if you're using "SonarQube Scanner" or "SonarScanner for MSBuild" build steps.</font>

翻译过来就是：![图片](http://xhh.dengzii.com/FrM7HmTx_APStJMI0OHlMQO6WL3W)
因为我们这里用的就是<font color=orange>SonarQube Scanner</font>,所以这个我们是可以不用勾上的，但是勾上也没影响；





### 开始构建
- 具体怎么构建项目可以看：[Jenkins教程-创建Maven项目](https://mjava.top/jenkins/build-jenkins-mavne/),这里就不多介绍了

#### 添加Execute SonarQube Scanner

在原来构建的基础上加上<font color=orange>Execute SonarQube Scanner</font>，就可以了

![图片](http://xhh.dengzii.com/FgZ021lPaTWzgOPsG7veK1cn7lIB)

在<font color=orange>Analysis properties</font>里填上构建的参数

![图片](http://xhh.dengzii.com/FiFA65-xUZCh62Y5HfIgxQzvMx7D)

>唯一的项目标识符（必填）
>sonar.projectKey =tiny-config1
>
>项目元数据（以前是必需的，自SonarQube 6.1起是可选的）
>sonar.projectName =tiny-config1
>sonar.projectVersion = 1.0
>
>源目录的路径（必需）
>sonar.sources = srcDir1，srcDir2
>
>测试源目录的路径（可选）
>sonar.tests = testDir1，testDir2
>
>Java项目编译类的路径（可选）
>sonar.java.binaries = bin
>
>逗号分隔的库路径列表（可选）
>sonar.java.libraries = path / to / library.jar，path / to / classes / dir
>
>附加参数
>sonar.my.property =value

保存后就可以正常构建了．

#### 错误解决（没有错误可跳过这段）
如果在构建项目的时候,Jenkins控制台如果报一下错误，这是因为SonarQube的Java版本太低造成的
![图片](http://xhh.dengzii.com/FnTRL4pSwrKk5Xwbzobo89VKHf5m)

##### 升级SonarQube的Java版本

进入SonarQube的管理台： Administration->Marketplace->SonarJava

> 如果你版本没升级，右边会有个update按钮，点击就可以升级了，升级完后重启SonarQube;这边因为我已经升级过了，所以没有这个按钮

![图片](http://xhh.dengzii.com/FgbCXvUiteJ9iGCCYC6qbInX0VSX)



### 构建完成后

Jenkins控制台显示SUCCESS就表示构建成功了

![图片](http://xhh.dengzii.com/FoijfnBHiJAZ7lA7YqmdQb-bEqUF)

这时候就可以点击构建项目的SonarQube直接跳转到SonarQube控制台了

![图片](http://xhh.dengzii.com/FhXgRD7rBp5RBc2D6uBmH5mIBNKJ)


这里就可以看到结果了

![图片](http://xhh.dengzii.com/FkPydWtLuuliKAq1hc8Ex45nnTlu)


## 总结

到这里就可以根据SonarQube的提示区改BUG了．这BUG有点多＝＿＝！.

在搭建过程中，最主要的就是那个SonarQube Scanner这个的安装了，因为Jenkins都是Docker化的，所以他可以选择自动安装，但是我这边选择自动安装却没用，所以就自己下载了SonarQube Scnner的包挂载到Jenkins容器里区，然后直接指定SonarQube Scnner的目录就可以了；