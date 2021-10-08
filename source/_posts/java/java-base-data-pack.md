---
title: Java包装类缓存机制
top: false
cover: false
toc: true
mathjax: true
date: 2020-09-16 15:08:18
password:
summary:
keywords:
description:
tags:
- Java
categories:
- Java
---





## 面试题

首先,来看一道常见的面试题,下面代码运行后会输出什么?

![图片](http://xhh.dengzii.com/blog/20200603110911.png)

上面代码运行后,最终会输出`false`和`true`;为什么会这样呢?

按道理来说,在Java中`==`是比较两个对象的地址,上面代码中`i3`和`i4`是两个不同的对象,理应也应该返回是`false`,怎么返回是`true`呢?让我们慢慢往下看

## Integer的缓存机制

让我们来看看他的源代码.

当执行`Integer i=128;`这个语句时,Java会调用`valueOf(int i)`方法,然后`自动装箱`的方式,让其变成`Integer i=new Integer(128)`,具体源码如下:

```java
public static Integer valueOf(int i) {
    if (i >= IntegerCache.low && i <= IntegerCache.high)
        return IntegerCache.cache[i + (-IntegerCache.low)];
    //装箱
    return new Integer(i);
}
```

从上面的源码中可以看到,在装箱之前会执行一个`if`语句,这个`if`语句就是判断传入的值是否在缓存内,如果在缓存内,就直接返回缓存内的值,如果不在缓存内,就装箱,在堆内创建一个新空间来存放.

```java
//Integer包装类缓存源码
private static class IntegerCache {
        static final int low = -128;
        static final int high;
        static final Integer cache[];
        static {
            // high value may be configured by property
            int h = 127;
            String integerCacheHighPropValue =
                sun.misc.VM.getSavedProperty("java.lang.Integer.IntegerCache.high");
            if (integerCacheHighPropValue != null) {
                try {
                    int i = parseInt(integerCacheHighPropValue);
                    i = Math.max(i, 127);
                    // Maximum array size is Integer.MAX_VALUE
                    h = Math.min(i, Integer.MAX_VALUE - (-low) -1);
                } catch( NumberFormatException nfe) {
                    // If the property cannot be parsed into an int, ignore it.
                }
            }
            high = h;
            cache = new Integer[(high - low) + 1];
            int j = low;
            for(int k = 0; k < cache.length; k++)
                cache[k] = new Integer(j++);
            // range [-128, 127] must be interned (JLS7 5.1.7)
            assert IntegerCache.high >= 127;
        }
        private IntegerCache() {}
    }
```

从源码中可以看到,`Integer`的缓存范围是`-128~127`,所以过程大致如下:

![图片](http://xhh.dengzii.com/blog/20200603114246.png)

按照上面这个方法,只要在数据在缓存池范围内的,都会引用缓存在堆内的地址,所有上面的`i3==i4`会输出为`true`;而不在缓存范围内的,就会在堆中开放新的空间来存放对象,所以地址不同,用`==`比较返回也不同;

## 其他包装类缓存机制

除了`Integer`之外,其他的包装类也使用了缓存技术;

### Long

> 缓存范围-128~127



```java
public static Long valueOf(long l) {
    final int offset = 128;
    if (l >= -128 && l <= 127) { // will cache
        return LongCache.cache[(int)l + offset];
    }
    return new Long(l);
}


private static class LongCache {
    private LongCache(){}

    static final Long cache[] = new Long[-(-128) + 127 + 1];

    static {
        for(int i = 0; i < cache.length; i++)
            cache[i] = new Long(i - 128);
    }
}
```

### Byte

> 缓存范围-128~127   (byte范围:一个byte占8位,所以取值范围是**-2^7~2^7-1**)



```java
public static Byte valueOf(byte b) {
    final int offset = 128;
    return ByteCache.cache[(int)b + offset];
}

private static class ByteCache {
    private ByteCache(){}

    static final Byte cache[] = new Byte[-(-128) + 127 + 1];

    static {
        for(int i = 0; i < cache.length; i++)
            cache[i] = new Byte((byte)(i - 128));
    }
}
```

### Character

> 缓存范围0~127  (ascii码范围) 



```java
public static Character valueOf(char c) {
    if (c <= 127) { // must cache
        return CharacterCache.cache[(int)c];
    }
    return new Character(c);
}

private static class CharacterCache {
    private CharacterCache(){}

    static final Character cache[] = new Character[127 + 1];

    static {
        for (int i = 0; i < cache.length; i++)
            cache[i] = new Character((char)i);
    }
}
```

### Short

> 缓存范围-128~127



```java
public static Short valueOf(short s) {
    final int offset = 128;
    int sAsInt = s;
    if (sAsInt >= -128 && sAsInt <= 127) { // must cache
        return ShortCache.cache[sAsInt + offset];
    }
    return new Short(s);
}

private static class ShortCache {
    private ShortCache(){}

    static final Short cache[] = new Short[-(-128) + 127 + 1];

    static {
        for(int i = 0; i < cache.length; i++)
            cache[i] = new Short((short)(i - 128));
    }
}
```

### Boolean

> 缓存范围 `true`  `false`     它只设置了两个静态变量用来充当缓存



```java
public static final Boolean TRUE = new Boolean(true);
public static final Boolean FALSE = new Boolean(false);

public static Boolean valueOf(boolean b) {
    return (b ? TRUE : FALSE);
}
```

## 建议

包装类对比数据是否相同的时候,建议采用重写的`equals()`方法.