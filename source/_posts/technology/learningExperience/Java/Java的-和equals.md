---
title: Java的==和equals
top: false
cover: false
toc: true
mathjax: true
categories:
  - technology
  - learningExperience
  - Java
date: 2019-08-20 19:22:50
password:
summary:
tags:
  - Java
---
在平常工作和学习中，我们一般用==和equals来比较两个对象或数据是否相等。但是什么时候用equals，什么时候用==一直都不怎么清楚，今天整理了下；

## 首先看看Java的栈空间和堆空间的地址引用
{% asset_img 1.png Java栈空间和堆空间%}
##  ==的说明
  在Java中，==对比的是两个对象在空间里的地址是否一致,比如上图的s2==s3返回的是false，s5==s6返回的是为true。话不多说，上代码。
```java
public class demo2 {
    public static void main(String[] args) {
        String s1=new String("t1");
        String s2=new String("t2");
        String s3=new String("t2");

        String s4=new String("t3");
        String s5="t3";
        String s6="t3";

        System.out.println("s2==s3:"+(s2==s3));
        System.out.println("s5==s6:"+(s5==s6));
    }
}
```
结果：
{% asset_img 2.png 控制台输出%}
>这是因为==比的是在空间里的地址，s2和s3在堆里面是两个不同的对象，所以地址也不同，自然返回就是false。s5和s6是Java的基础数据类型，指向的是常量池里同一个引用，所以地址也相同，返回的就是true。

## equals的说明
  每个Object里的equals都不一样，我们看看String里的源码
```java
public boolean equals(Object anObject) {
    if (this == anObject) {
        return true;
    }
    if (anObject instanceof String) {
        String anotherString = (String)anObject;
        int n = value.length;
        if (n == anotherString.value.length) {
            char v1[] = value;
            char v2[] = anotherString.value;
            int i = 0;
            while (n-- != 0) {
                if (v1[i] != v2[i])
                    return false;
                i++;
            }
            return true;
        }
    }
    return false;
}
```
* 首先它会对比地址，如果地址相等，就直接返回true
* 如果地址不相等，就会对比里面的每一个字符，直到完全相等，然后返回true

## 总结
　　所以一般如果是对比两个对象是否相等的话，用==就可以。但是如果你要对比两个值是否相等的话，就要用equals了，因为如果用==就会出现上面明明值相等,返回却是false的情况。
