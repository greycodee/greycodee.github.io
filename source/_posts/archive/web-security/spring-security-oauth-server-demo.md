---
title: 基于SpringCloud搭建Spring-security-oauth认证服务器
top: false
cover: false
toc: true
mathjax: true
date: 2020-05-19 20:25:06
password:
summary:
keywords:
description:
tags:
- OAuth
- spring-security
categories:
- web-security
---





## 准备阶段

这里搭建一个用OAuth2.0密码模式认证的服务器，token存入redis，client存入Mysql；

所以事先要准备好：

- Redis
- Mysql

并且Mysql执行[Spring-security-oauth初始化Sql](https://github.com/spring-projects/spring-security-oauth/blob/master/spring-security-oauth2/src/test/resources/schema.sql)这个SQL，初始化Spring-security-oauth所需要的表。然后执行

```sql
-- 插入client_id和client_secret都为sunline的客户端
insert into 
	oauth_client_details (client_id, client_secret, authorized_grant_types , autoapprove)
values 
	("sunline","	{bcrypt}$2a$10$G1CFd535SiyOtvi6ckbZWexQy.hW5x/I/fLBPiW/E4UmctCfKYbgG","password","true");
```

> client_secret为`new BCryptPasswordEncoder().encode("sunline")`方法加密后，然后在加上`{bcrypt}`



## 开始搭建



### 导入pom依赖

```java
<!--security-oauth-->
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-oauth2</artifactId>
</dependency>
    
<!--redis-->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>
    
<!--mysql-->
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>8.0.17</version>
    <scope>compile</scope>
</dependency>
```



### 配置application.properties

```properties
#datasource
spring.datasource.url=jdbc:mysql://localhost:3307/grey_code?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true&serverTimezone=Asia/Shanghai
spring.datasource.username=zmh
spring.datasource.password=zmh

#redis
spring.redis.host=127.0.0.1
spring.redis.port=6379


server.port=9991
server.servlet.context-path=/oauthServer
```



### 创建用户详情服务类

![](http://cdn.mjava.top/blog/20200519194059.png)

#### 创建权限控制类

![](http://cdn.mjava.top/blog/20200519194128.png)

### 创建认证授权类

![](http://cdn.mjava.top/blog/20200519194207.png)

## 获取令牌

访问:`/oauth/token`就可以获取到令牌

![](http://cdn.mjava.top/blog/20200519194446.png)

```json
{
    "accessToken": "e28f9a99-e60d-4693-b6c3-73e06a1d14f5ZMH10086",
    "expiration": "2020-05-19T21:11:39.883+0000",
    "scope": [
        "all"
    ],
    "tokenType": "bearer"
}
```



### 访问资源

带上获取到的令牌

![](http://cdn.mjava.top/blog/20200519194803.png)