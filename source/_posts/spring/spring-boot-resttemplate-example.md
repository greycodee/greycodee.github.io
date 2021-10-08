---
title: RestTemplate简单使用
top: false
cover: false
toc: true
mathjax: true
date: 2019-11-20 17:32:18
password:
summary:
keywords:
description:
tags:
 - SpringBoot
categories:
 - Spring
---



## 前言

	本文只讲常用的**GET** 和**POST**请求,其他类型的请求(如**PUT**，**PATCH**)请求方式都差不多，有兴趣的可以查看RestTemplate源码。

## GET

> GET官方给了**getForEntity**和**getForObject**两种种方法，每个方法又有三个重载方法

### 官方源码接口

```java
	@Nullable
	<T> T getForObject(String url, Class<T> responseType, Object... uriVariables) throws RestClientException;

	@Nullable
	<T> T getForObject(String url, Class<T> responseType, Map<String, ?> uriVariables) throws RestClientException;

	@Nullable
	<T> T getForObject(URI url, Class<T> responseType) throws RestClientException;

	<T> ResponseEntity<T> getForEntity(String url, Class<T> responseType, Object... uriVariables)
			throws RestClientException;

	<T> ResponseEntity<T> getForEntity(String url, Class<T> responseType, Map<String, ?> uriVariables)
			throws RestClientException;

	<T> ResponseEntity<T> getForEntity(URI url, Class<T> responseType) throws RestClientException;
```

### 使用

#### API接口

>  首先我写了两个接口供RestTemplate调用

```java
@RestController
public class Test {

    @GetMapping("/test")
    public JSONObject test(){
        JSONObject jsonObject=new JSONObject();
        jsonObject.put("name:","Mr.Zheng");
        jsonObject.put("tag:","Good");
        return jsonObject;
    }

    @GetMapping("/test/{name}")
    public JSONObject test2(@PathVariable String name){
        JSONObject jsonObject=new JSONObject();
        jsonObject.put("name:",name);
        jsonObject.put("tag:","Good");
        return jsonObject;
    }
    
}
```

#### getForObject

##### 代码

```java
	@Test
    public void restTemplate(){
        RestTemplate template=new RestTemplate();

        //使用URI请求
        URI uri=URI.create("http://localhost:8090/test");
        String response=template.getForObject(uri, String.class);
        System.out.println(response);

        //url带参数请求 
        String response2=template.getForObject("http://localhost:8090/test/{name}",String.class,"hui1");
        System.out.println(response2);

        //当url参数过多可以用map
        Map<String,String> param=new HashMap<>();
        param.put("name","hui2");
        String reponse3=template.getForObject("http://localhost:8090/test/{name}",String.class,param);
        System.out.println(reponse3);
    }
```

##### 结果:

```java
{"name:":"Mr.Zheng","tag:":"Good"}
{"name:":"hui1","tag:":"Good"}
{"name:":"hui2","tag:":"Good"}
```



#### getForEntity

##### 代码

```java
    @Test
    public void restTemplate(){
        RestTemplate template=new RestTemplate();

        //使用URI请求
        URI uri=URI.create("http://localhost:8090/test");
        ResponseEntity<String> response=template.getForEntity(uri, String.class);
        System.out.println(response.getBody());

        //url带参数请求
        ResponseEntity<String> response2=template.getForEntity("http://localhost:8090/test/{name}",String.class,"hui1");
        System.out.println(response2.getBody());

        //当url参数过多可以用map
        Map<String,String> param=new HashMap<>();
        param.put("name","hui2");
        ResponseEntity<String> reponse3=template.getForEntity("http://localhost:8090/test/{name}",String.class,param);
        System.out.println(reponse3.getBody());
    }
```



##### 结果

```java
{"name:":"Mr.Zheng","tag:":"Good"}
{"name:":"hui1","tag:":"Good"}
{"name:":"hui2","tag:":"Good"}
```



### 小结

可以看到**getForEntity**和**getForObject**的使用方法差不多，他们的区别就是

- getForObject只返回结果，getForEntity包装了返回的信息，可以从中获取更多关于http请求的信息，比如请求头，请求状态等

## POST

> POST官方给了**postForLocation**,**postForObject**,**postForEntity**三种方法，每种又有三个重载方法

### 官方源码接口

```java
	@Nullable
	URI postForLocation(String url, @Nullable Object request, Object... uriVariables) throws RestClientException;

	@Nullable
	URI postForLocation(String url, @Nullable Object request, Map<String, ?> uriVariables)
			throws RestClientException;

	@Nullable
	URI postForLocation(URI url, @Nullable Object request) throws RestClientException;

	@Nullable
	<T> T postForObject(String url, @Nullable Object request, Class<T> responseType,
			Object... uriVariables) throws RestClientException;

	@Nullable
	<T> T postForObject(String url, @Nullable Object request, Class<T> responseType,
			Map<String, ?> uriVariables) throws RestClientException;

	@Nullable
	<T> T postForObject(URI url, @Nullable Object request, Class<T> responseType) throws RestClientException;

	<T> ResponseEntity<T> postForEntity(String url, @Nullable Object request, Class<T> responseType,
			Object... uriVariables) throws RestClientException;

	<T> ResponseEntity<T> postForEntity(String url, @Nullable Object request, Class<T> responseType,
			Map<String, ?> uriVariables) throws RestClientException;

	<T> ResponseEntity<T> postForEntity(URI url, @Nullable Object request, Class<T> responseType)
			throws RestClientException;
```



### API接口

```java
@RestController
public class Test {
    private static final Logger LOG= LoggerFactory.getLogger(Test.class);

    @PostMapping("/test")
    public JSONObject test(@RequestBody JSONObject param){
        LOG.info("param:{}",param.toJSONString());
        return param;
    }

    @PostMapping("/test/{urlParam}")
    public JSONObject test(@RequestBody JSONObject param,@PathVariable String urlParam){
        LOG.info("param:{}",param);
        param.put("urlParam",urlParam);
        return param;
    }
    
}
```

### postForObject

#### 代码

```java
    @Test
    public void restTemplate(){
        RestTemplate template=new RestTemplate();
        String baseURL="http://localhost:8090";
        JSONObject param=new JSONObject();
        param.put("tag","this is post request!!");

        //使用URI请求
        URI uri=URI.create(baseURL+"/test");
        String response=template.postForObject(uri,param,String.class);
        System.out.println(response);

        //url带参数请求
        String response2=template.postForObject(baseURL+"/test/{urlParam}",param,String.class,"this is urlParam");
        System.out.println(response2);

        //当url参数过多可以用map
        Map<String,String> mapParam=new HashMap<>();
        mapParam.put("urlParam","this is map param!!");
        String reponse3=template.postForObject(baseURL+"/test/{urlParam}",param,String.class,mapParam);
        System.out.println(reponse3);
    }
```

#### 结果

```java
{"tag":"this is post request!!"}
{"tag":"this is post request!!","urlParam":"this is urlParam"}
{"tag":"this is post request!!","urlParam":"this is map param!!"}
```



### postForEntity

> postForEntity和postForObject用法类似，具体这里就写了。



### postForLocation

> 这个请求和其他请求不一样，可以看到他返回的是URI，这里具体讲一下

#### 新写个API接口

```java
@RestController
public class UriTest {
    private static final Logger LOG= LoggerFactory.getLogger(UriTest.class);

    @PostMapping("/uri")
    public void uriTest(@RequestBody JSONObject param, HttpServletResponse response) throws IOException {
        try {
            //打印上传的参数
            LOG.info("requestParam:{}",param);
            //跳转百度
            response.sendRedirect("https://www.baidu.com");
        }catch (Exception e){
            LOG.info(e.getMessage(),e);
        }
    }
}
```

#### 代码

```java
    @Test
    public void restTemplate(){
        RestTemplate template=new RestTemplate();
        String baseURL="http://localhost:8090";
        JSONObject param=new JSONObject();
        param.put("info","this is postForLocation test!!");

        URI response2=template.postForLocation(baseURL+"/uri",param);
        System.out.println(response2);
    }
```

#### 结果

![代码运行结果](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20191120165138-20211008164958814-20211008165045748.png)



#### 服务端日志

![服务端日志](https://cdn.jsdelivr.net/gh/greycodee/images@main/images/2021/10/08/20191120165302-20211008165107947.png)

### 小结

**postForObject**和**postForEntity**两个方法和GET请求的用法差不多，只是POST请求比GET请求多了个request请求体。而**postForLocation**方法一般用的比较少,一般只有后端发生301或302等跳转时用来获取跳转后的URL，方法的形参中不用定义返回的数据类型，默认是URI；