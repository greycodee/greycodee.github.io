---
title: SSO单点登录和CAS框架
top: false
cover: false
toc: true
mathjax: true
date: 2020-05-14 19:27:14
password:
summary:
keywords:
description:
tags:
- SSO
- CAS框架
categories:
- WebSecurity
---

## SSO单点登录

**单点登录**（英语：Single sign-on，缩写为 SSO），又译为**单一签入**，一种对于许多相互关连，但是又是各自独立的软件系统，提供[访问控制](https://zh.wikipedia.org/wiki/存取控制)的属性。当拥有这项属性时，当用户[登录](https://zh.wikipedia.org/wiki/登入)时，就可以获取所有系统的访问权限，不用对每个单一系统都逐一登录。这项功能通常是以[轻型目录访问协议](https://zh.wikipedia.org/wiki/轻型目录访问协议)（LDAP）来实现，在服务器上会将用户信息存储到LDAP数据库中。相同的，**单一退出**（single sign-off）就是指，只需要单一的退出动作，就可以结束对于多个系统的访问权限。

### 优点

使用单点登录的好处包括：

- 降低访问第三方网站的风险（不存储用户密码，或在外部管理）。
- 减少因不同的用户名和密码组合而带来的[密码疲劳](https://zh.wikipedia.org/w/index.php?title=密碼疲勞&action=edit&redlink=1)。
- 减少为相同的身份重新输入密码所花费的时间。
- 因减少与密码相关的调用IT[服务台](https://zh.wikipedia.org/wiki/服务台)的次数而降低IT成本。[[1\]](https://zh.wikipedia.org/wiki/單一登入#cite_note-1)

SSO为所有其它应用程序和系统，以集中的[验证服务器](https://zh.wikipedia.org/w/index.php?title=验证服务器&action=edit&redlink=1)提供身份验证，并结合技术以确保用户不必频繁输入密码。



## CAS框架

CAS 协议基于在**客户端**Web浏览器、Web**应用**和**CAS服务器**之间的票据验证。当客户端访问访问应用程序，请求身份验证时，应用程序重定向到CAS。CAS验证客户端是否被授权，通常通过在数据库对用户名和密码进行检查。如果身份验证成功，CAS一次性在客户端以Cookie形式发放TGT票据，在其有效期CAS将一直信任用户，同时将客户端自动返回到应用程序，并向应用传递身份验证票（Service ticket）。然后，应用程序通过安全连接连接CAS，并提供自己的服务标识和验证票。之后CAS给出了关于特定用户是否已成功通过身份验证的应用程序授信信息。

### 历史

- CAS是由[耶鲁大学](https://zh.wikipedia.org/wiki/耶鲁大学)[[1\]](https://zh.wikipedia.org/wiki/集中式认证服务#cite_note-1)的Shawn Bayern创始的，后来由耶鲁大学的Drew Mazurek维护。CAS1.0实现了单点登录。 CAS2.0引入了多级代理认证（Multi-tier proxy authentication）。CAS其他几个版本已经有了新的功能。

- 2004年12月，CAS成为[Jasig](https://zh.wikipedia.org/w/index.php?title=Jasig&action=edit&redlink=1)[[2\]](https://zh.wikipedia.org/wiki/集中式认证服务#cite_note-2)的一个项目，2008年该组织负责CAS的维护和发展。CAS原名“耶鲁大学CAS”，此后被称为“Jasig CAS”。

- 2005年5月，CAS协议版本2发布，引入代理和服务验证。

- 2006年12月，[安德鲁·W·梅隆基金会](https://zh.wikipedia.org/w/index.php?title=安德鲁·W·梅隆基金会&action=edit&redlink=1)授予耶鲁大学第一届梅隆技术协作奖，颁发50000美元的奖金对耶鲁大学开发CAS进行奖励。[[3\]](https://zh.wikipedia.org/wiki/集中式认证服务#cite_note-3)颁奖之时，CAS在“数以百计的大学校园”中使用。

- 2012年12月，JASIG与Sakai基金合并，CAS改名为Apereo CAS。

- 2016年11月，基于Spring Boot的CAS软件版本5发布。