---
title: Fegin和RestTemplate添加全局请求头
top: false
cover: false
toc: true
mathjax: true
date: 2020-09-16 15:14:43
password:
summary:
keywords:
description:
tags:
- Fegin
- Resttemplate
categories:
- Spring
---

## Fegin添加全局请求头

- 实现RequestInterceptor接口

```java

/**
* 实现RequestInterceptor接口的apply方法
*/
@Configuration
public class FeignRequestInterceptor implements RequestInterceptor {
    @Override
    public void apply(RequestTemplate requestTemplate) {
        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder
                .getRequestAttributes();
        HttpServletRequest request = attributes.getRequest();
        Enumeration<String> headerNames = request.getHeaderNames();
        if (headerNames != null) {
            while (headerNames.hasMoreElements()) {
                String name = headerNames.nextElement();
                String values = request.getHeader(name);
                requestTemplate.header(name, values);

            }
        }
    }
}

```

- 在`@FeginClient`注释里`configuration`所填入的类文件中添加上面的拦截器

  > 比如 
  >
  > ```java
  > // configuration指定的类为FeignConfig
  > 
  > @FeignClient(name = "${TinyConfigServiceName}",path="/config",configuration = FeignConfig.class)
  > ```
  - 在FeignConfig类中添加拦截器

    ```java
    @Configuration
    public class FeignConfig {
        @Bean
        public RequestInterceptor requestInterceptor(){
            return new FeignRequestInterceptor();
        }
    }
    ```

    

## RestTemplate添加全局请求头

- 编写拦截器,实现`ClientHttpRequestInterceptor`接口的`intercept`方法

  ```java
  public class MyInterceptor implements ClientHttpRequestInterceptor {
      @Override
      public ClientHttpResponse intercept(HttpRequest httpRequest, byte[] bytes, ClientHttpRequestExecution clientHttpRequestExecution) throws IOException {
          HttpHeaders httpHeaders=httpRequest.getHeaders();
          ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder
                  .getRequestAttributes();
          HttpServletRequest request = attributes.getRequest();
          Enumeration<String> headerNames = request.getHeaderNames();
          if (headerNames != null) {
              while (headerNames.hasMoreElements()) {
                  String name = headerNames.nextElement();
                  String values = request.getHeader(name);
                  httpHeaders.add(name, values);
              }
          }
          return clientHttpRequestExecution.execute(httpRequest,bytes);
      }
  }
  ```

  

- 在springboot的启动类里添加`RestTemplate`

  ```java
  @SpringBootApplication
  public class DemoApplication {
  
      public static void main(String[] args) {
          SpringApplication.run(DemoApplication.class, args);
      }
  
      //ioc添加RestTemplate
      @Bean
      public RestTemplate restTemplate(){
          MyInterceptor myInterceptor=new MyInterceptor();
          RestTemplate restTemplate=new RestTemplate();
          restTemplate.setInterceptors(Collections.singletonList(myInterceptor));
          return restTemplate;
      }
  
  }
  ```

  