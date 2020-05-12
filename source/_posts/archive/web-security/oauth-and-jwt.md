---
title: OAuth2.0与JWT
top: false
cover: false
toc: true
mathjax: true
date: 2020-05-12 14:59:43
password:
summary:
keywords:
description:
tags:
- OAuth2.0
- JWT
categories:
- Web-Security
---







## OAuth2.0

OAuth2.0是一个授权协议，它允许软件应用代表资源拥有者去访问资源拥有者的资源。应用向资源拥有者请求`令牌`，并用这个令牌来访问资源拥有者的资源。

### 角色

- 客户端：相当于访问受保护资源的软件
- 授权服务器：授予客户端令牌的服务
- 资源拥有者：受保护的资源拥有者，有权决定将不将令牌授权给客户端
- 受保护的资源：除资源拥有者外，要访问此资源必须要有授权服务器颁发的有效的令牌

### 授权类型



#### 授权码许可类型![授权码许可类型](http://cdn.mjava.top/blog/20200512090246.jpg)

---

#### 隐式许可类型![隐式许可类型](http://cdn.mjava.top/blog/20200512135621.jpg)

---

#### 客户端凭证许可类型![客户端凭证许可类型](http://cdn.mjava.top/blog/20200512135605.jpg)

---

#### 资源拥有者凭证许可类型(账号密码模式)![资源拥有者凭证许可类型(账号密码模式)](http://cdn.mjava.top/blog/20200512135635.jpg)

---

#### 断言许可类型![断言许可类型](http://cdn.mjava.top/blog/20200512135531.jpg)



## JWT

JWT全称：JSON Web Token，是一种令牌格式。其格式类似为`xxxxx.yyyyy.zzzzz`,分为三部分，每个部分都用`Base64`进行编码，之间用`.`分隔。

第一部分：为Header部分，标头通常由两部分组成：令牌的类型（即JWT）和所使用的签名算法，例如HMAC SHA256或RSA。

```json
{
  "alg": "HS256",
  "typ": "JWT"
}
```



第二部分：令牌的第二部分是有效负载，其中包含声明。 声明是有关实体（通常是用户）和其他数据的声明。 共有三种类型的声明：注册的，公共的和私有的三种声明。当然里面可以存放任何有效的字段信息（私有声明）。但是为了避免不同实现之间不兼容，可以准守JWT官方提供的声明字段。

- 注册声明：JWT官方提供的声明，参考资料:https://tools.ietf.org/html/rfc7519#section-4.1
- 公共声明：用户发邮件给JWT官方进行注册的声明字段，参考资料：https://tools.ietf.org/html/rfc7519#section-4.2
- 私有声明：完全用户自定义，参考资料https://tools.ietf.org/html/rfc7519#section-4.3

第三部分：为令牌签名部分，使用这个字段后，资源服务器只会接受签名正确的令牌。