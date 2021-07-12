---
title: Quarkus项目配置方式详解
top: false
cover: false
toc: true
mathjax: true
date: 2021-07-12 17:29:23
password:
summary:
keywords:
description:
tags:
- Quarkus
categories:
- Quarkus
---

## 配置加载流程

Quarkus 可以从多个地方获取项目的配置，它读取配置优先级入下图，在下面的优先级中，一旦读取到某个配置，就不会再继续读取后面配置中的这个配置了。

![config-sources](http://cdn.mjava.top/blog/0cvlsyconfig-sources.png)

## 0x1 System Properties

系统属性可以在启动期间通过 `-D` 标志传递给应用程序。

比如要设置 http 服务的运行端口，各个运行方式传递系统参数的方式如下：

- **Quarkus dev**模式：`mvn quarkus:dev -Dquarkus.http.port=8888`
- 运行 **jar** 包：`java -Dquarkus.http.port=8888 -jar quarkus-run.jar`
- 运行 **native-image**：`app-runner -Dquarkus.http.port=8888`

## 0x2 Environment variables

> 环境变量的名字遵循 [MicroProfile Config](https://github.com/eclipse/microprofile-config/blob/master/spec/src/main/asciidoc/configsources.asciidoc#default-configsources)
>
> ```shell
> Environment Variables Mapping Rules
> Some operating systems allow only alphabetic characters or an underscore, _, in environment variables. Other characters such as ., /, etc may be disallowed. In order to set a value for a config property that has a name containing such disallowed characters from an environment variable, the following rules are used.
> 
> The ConfigSource for the environment variables searches three environment variables for a given property name (e.g. com.ACME.size):
> 
> 1. Exact match (i.e. com.ACME.size)
> 
> 2. Replace each character that is neither alphanumeric nor _ with _ (i.e. com_ACME_size)
> 
> 3. Replace each character that is neither alphanumeric nor _ with _; then convert the name to upper case (i.e. COM_ACME_SIZE)
> 
> The first environment variable that is found is returned by this ConfigSource.
> ```

环境变量的话各个系统设置的方式不一样，具体可以查一下自己系统设置环境变量的方式，一般 **Unix** 类的系统设置环境变量一般分为**命令行设置**和**环境变量文件配置**

- 命令行配置：`export QUARKUS_HTTP_PORT:8888`
- 配置文件配置：环境变量配置文件又分用户变量配置文件和系统变量配置文件，直接在对应的配置文件里加上这一样就可以了，但是一般不推荐这么用

## 0x3 .env 文件

> **注意：.env 文件中的环境变量无法像普通的环境变量通过 System.getenv(String) API 获得。**

`.env` 文件的作用和环境变量类似，但是作用域更小，**它只作用于当前项目，不像环境变量可以作用于所有项目**。

它的设置方式是在 `.env` 文件里配置键值对的方式来设置变量，键名称和设置环境变量一样遵守 [MicroProfile Config](https://github.com/eclipse/microprofile-config/blob/master/spec/src/main/asciidoc/configsources.asciidoc#default-configsources) 规范

使用方式：

- 对于 **dev** 模式：可以放在项目的根目录下来使用，**但是不要把它和代码一起打包**
- 对于 **jar** 和 **native-image** 运行方式下：可以将 `.env` 文件放在和 jar 包或 native-image 同一目录下

## 0x4 Quarkus Application配置文件

Quarkus 和 Spring Boot 项目一样，支持 `application.properties` 配置文件。同时在 **jar** 包和 **native-image** 的运行模式下还支持当前 jar 文件和native-image 文件同目录下 **config 文件夹**里的 `application.properties` 配置文件，并且 **config 文件夹**里的配置文件优先级高于项目 **resources 文件夹**里的配置文件

> 对于 dev 的运行模式下，项目也可以使用 config 文件里的配置文件，就是手动把 config 文件夹移到 **target 文件夹**里，但是在使用 `mvn clean` 命令时会把这个文件夹清理掉，到时候又要自己手动重新创建 config 文件夹和里面的配置文件，所以在 dev 模式下不推荐使用 `config/application.properties`



## 0x5 MicroProfile 配置文件

它放在 `src/main/resources/META-INF/microprofile-config.properties` 里

它的工作原理和项目的 resources 文件夹下的 application.properties 完全相同，建议使用 resources 文件夹下的配置文件



## 使用 yml 配置文件

以上配置中，除了系统属性、环境变量、.env 文件外，配置文件都可以支持 yml 格式的配置，不过需要额外添加依赖

### 添加依赖

1. pom.xml 文件添加依赖

  ```xml
  <dependency>
    <groupId>io.quarkus</groupId>
    <artifactId>quarkus-config-yaml</artifactId>
  </dependency>
  ```

2. 或者可以直接用 maven 命令来添加拓展依赖

```shell
./mvnw quarkus:add-extension -Dextensions="io.quarkus:quarkus-config-yaml"
```

### 添加yml文件

移除`src/main/resources/application.properties` 文件，添加 `src/main/resources/application.yaml` 文件

如果两个文件都存在，Quarkus 会优先使用来自 `yml` 的配置，然后再使用 `properties` 的配置，所以为了不搞混淆，建议删除 `properties` 文件。

配置文件扩展名支持 `yml` 和 `yaml`

## 参考资料

1. https://quarkus.io/guides/config-yaml
2. https://quarkus.pro/guides/config.html
3. https://quarkus.io/guides/config-reference
