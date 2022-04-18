---
title: 用 Json-Schema 来验证你的请求参数
top: false
cover: false
toc: true
mathjax: true
date: 2021-08-19 16:40:05
password:
summary:
keywords:
description:
tags:
- Json-Schema
- 参数验证
- Java
categories:
- Tool
---

## 简介

Json-Schema 是一个用来验证、描述 Json 数据的一个标准，它可以用来验证你的请求数据是否和你定义的 Schema 是否一致。比如下面的 Json 数据中：

```json
{
  "name":"greycode",
  "desc":"coder"
}
```

如果不预先告诉你字段的含义，你知道 `name` 是什么意思吗？它到底是指人名还是一个物品的名字还是其他？`desc` 又是什么意思呢？

这时候，就可以用 Json-Schema 来描述它了

```json
{
    "$schema": "http://json-schema.org/draft-07/schema",
    "$id": "http://example.com/example.json",
    "type": "object",
    "title": "这是一个Json数据",
    "description": "描述个人信息的数据",
    "required": [
        "name",
        "desc"
    ],
    "properties": {
        "name": {
            "type": "string",
            "description": "人的姓名",
        },
        "desc": {
            "type": "string",
            "description": "个人简介",
        }
    }
}
```

上面我们用 Json-Schema 来描述了刚开始的 Json 数据，这样就可以清楚的知道 name 是人的姓名，desc 是个人简介，在也不用自己去猜了。

## Json Schema 字段说明

在上面的 Json-Schema 数据中，每个字段都有其的含义

- `$schema` ：主要用于版本控制
- `$id` ：定义字段在 schema 中的地址
- `title` 和 `description` ：用于描述和说明 Schema 的作用
- `type` ：定义字段的数据类型
- `required` ：Json 数据中包含的字段
- ......

由于 Json-Schema 有许多草案，每个草案的字段都有一点区别，具体可以看一下的草案资料：

1. [草案 2019-09 迁移 草案 2020-12](https://json-schema.org/draft/2020-12/release-notes.html)
2. [草案-07 迁移 草案 2019-09](https://json-schema.org/draft/2019-09/release-notes.html)
3. [草案-06 迁移 草案-07](https://json-schema.org/draft-07/json-schema-release-notes.html)
4. [草案-04 迁移 草案-06 文档说明](https://json-schema.org/draft-06/json-schema-release-notes.html)
5. [所有草案版本文档](https://json-schema.org/specification-links.html)

## 使用 Json-Schema 验证 Json 数据

![image-20210820162428822](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/hlpzY6image-20210820162428822.png)

Json-Schema 支持多种语言的验证器，一般都是第三方实现的，这里我们使用 Java 验证器来验证一个 Json 数据，Java 验证器这里选用了 [everit-org/json-schema](https://github.com/everit-org/json-schema) 验证器来使用，不过它最高支持到**草案7**，像最新的**草案2020-12**它是不支持的。

### Java 验证 Json 数据

**导入依赖：**

```xml
<dependency>
    <groupId>com.github.everit-org.json-schema</groupId>
    <artifactId>org.everit.json.schema</artifactId>
    <version>1.13.0</version>
</dependency>
...
<repositories>
    <repository>
        <id>jitpack.io</id>
        <url>https://jitpack.io</url>
    </repository>
</repositories>
```

导入所需依赖，由于这个包没有上传到中央仓库，所以要设置仓库地址

**代码实现：**

导入依赖后就可以用代码来实现一个使用 Json-Schema 验证 Json 数据的功能了

```java
try {
  String jsonSchema = "{\n" +
    "    \"$schema\": \"http://json-schema.org/draft-07/schema\",\n" +
    "    \"$id\": \"http://example.com/example.json\",\n" +
    "    \"type\": \"object\",\n" +
    "    \"title\": \"这是一个Json数据\",\n" +
    "    \"description\": \"描述个人信息的数据\",\n" +
    "    \"required\": [\n" +
    "        \"name\",\n" +
    "        \"desc\"\n" +
    "    ],\n" +
    "    \"properties\": {\n" +
    "        \"name\": {\n" +
    "            \"type\": \"string\",\n" +
    "            \"description\": \"人的姓名\",\n" +
    "        },\n" +
    "        \"desc\": {\n" +
    "            \"type\": \"string\",\n" +
    "            \"description\": \"个人简介\",\n" +
    "        }\n" +
    "    }\n" +
    "}";
  JSONObject jsonObject = new JSONObject(new JSONTokener(jsonSchema));
  Schema schema = SchemaLoader.load(jsonObject);
  schema.validate(new JSONObject("{\n" +
                                 "  \"name\":\"greycode\",\n" +
                                 "  \"desc\":\"coder\"\n" +
                                 "}"));
}catch (Exception e){
  System.out.println("验证异常："+e.getMessage());
}
```

这里用了上面的 Json 数据和 Json-Schema，当验证通过时，不会有任何输出，同时也没有任何异常。

当我们把 `desc` 的数据改为如下数据时：

```json
{
  "name":"greycode",
  "desc":1
}
```

此时由于 `desc` 的数据类型变为了数字类型，所以我们就可以捕获到异常并输出：`验证异常：#/desc: expected type: String, found: Integer`

## 资料

- 所有的第三方 Json-Schema 验证器：https://json-schema.org/implementations.html#validators
- Jaon-Schema 生成器：https://json-schema.org/implementations.html#schema-generators
- 通过 Json-Schema 生成代码、数据等：https://json-schema.org/implementations.html#generators-from-schemas
- 在线 Json 转换 Json-Schema ：https://www.jsonschema.net/home
- https://json-schema.org/