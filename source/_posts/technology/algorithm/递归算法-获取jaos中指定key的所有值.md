---
title: 递归算法-获取jaos中指定key的所有值
top: false
cover: false
toc: true
mathjax: true
tags:
  - Java
  - 递归
  - 算法
  - Json
categories:
  - technology
  - algorithm
date: 2019-08-17 12:38:52
password:
summary:
---

今天在工作中遇到要解析json并获取json里所有指定key的值，再把key的值插入对应的数据映射表。于是写了一个递归算法来取值。

## 1.首先导入alibaba的fastjson，用来解析json。当然也可以用其他的解析包
```java
<dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>fastjson</artifactId>
    <version>1.2.58</version>
</dependency>
```
## 2.创建两个工具类方法，用来判断传入的是不是json对象或json数组
```java
public static boolean isJSONObj(Object json){
   return json instanceof JSONObject;
}
public static boolean isJSONArray(Object json){
   return json instanceof JSONArray;
}
```
> java中的instanceof也称为类型比较运算符，因为它将实例与类型进行比较。它返回true或false。

## 3.建立核心多态方法
```java
    public static void getJSONValue(JSONObject json,String k,List<String> list){
        for (Object j:json.keySet()){
            if(isJSONObj(json.get(j))){
                //是对象
                JSONObject j2= JSON.parseObject(json.get(j).toString());
                getJSONValue(j2,k,list);
            }else if(isJSONArray(json.get(j))){
                JSONArray j3=JSON.parseArray(json.get(j).toString());
                //是数组
                getJSONValue(j3,k,list);
            }else if(j==k){
                //是字符串
                list.add(json.get(j).toString());
            }
        }
    }

    public static void getJSONValue(JSONArray json,String k,List<String> list){
        for (Object j:json){
            if(isJSONObj(j)){
                //是对象
                JSONObject j2= JSON.parseObject(j.toString());
                getJSONValue(j2,k,list);
            }else if(isJSONArray(j)){
                //是数组
                JSONArray j3=JSON.parseArray(j.toString());
                getJSONValue(j3,k,list);
            }
        }
    }

```
## 4.接下来写一个比较复杂的json，里面有对象嵌套数组的，数组嵌套对象的，数组嵌套数组的
{% asset_link 示例json.txt 示例json.txt%}

## 5.调用方法
```java
try {
    File file=new File(demo1.class.getResource("/2.json").getPath());
    FileInputStream fileInputStream=new FileInputStream(file);
    InputStreamReader inputStreamReader=new InputStreamReader(fileInputStream);
    BufferedReader bufferedReader=new BufferedReader(inputStreamReader);
    String line="";
    StringBuffer json=new StringBuffer();
    while ((line=bufferedReader.readLine())!=null){
        json.append(line);
    }

    JSONObject j3=JSON.parseObject(json.toString());
    List<String> mid=new ArrayList<>();
    getId(j3,"interfaceId",mid);
    System.out.println(mid.toString());
}catch (Exception e){
    System.out.println(e.getMessage());
}
```
## 6.成功获取
{% asset_img 2.png 控制台返回%}

>demo源码地址：https://github.com/z573419235/studyDemo
