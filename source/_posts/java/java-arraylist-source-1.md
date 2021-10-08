---
title: 【源码解析】扒开ArrayList的外衣
top: false
cover: false
toc: true
mathjax: true
date: 2020-01-03 19:13:31
password:
summary:
keywords:
description:
tags:
- Java
- ArrayList
- 源码解析
categories:
- Java
---

> 积千里跬步，汇万里江河；每天进步一点点，终有一天将成大佬。

## 本文内容

当然ArrayList里的方法不止这些，本文主要讲一些常用的方法

![图片](http://xhh.dengzii.com/blog/20200103101050.png)

## 方法变量

`Arraylist`里的方法变量主要有以下几个

![图片](http://xhh.dengzii.com/blog/Selection_005.png)



## 构造方法

### 有参构造

#### 传入数组的大小

##### 代码实现

```java
List<String> list=new ArrayList<>(5);
```

##### 源码解析

![图片](http://xhh.dengzii.com/blog/Selection_004.png)

#### 传入一个list对象

其实这个就相当于把传入的list对象里的数据<font color=orange>复制</font>到新的ArrayList对象

##### 代码实现

```java
List<String> list=new ArrayList<>(Arrays.asList("z","m","h"));
```

> 这里用来`Arrays`工具类里的`asList`方法，它的源码里是直接返回一个List，有兴趣的可以去看看，这里就不介绍了

##### 源码解析

![图片](http://xhh.dengzii.com/blog/Selection_006.png)

### 无参构造

这个比较简单，直接赋值一个空数组

#### 代码实现

```java
List<String> list=new ArrayList<>();
```

#### 源码解析

![图片](http://xhh.dengzii.com/blog/20200103112943.png)

## add方法

add一般常用的有两个方法，一个就是`add(E e)`在尾部添加数据，一个就是`add(int index,E element)`在指定位置插入元素

### add(E e)

这个是`Arrayist`的主要方法，平时用的也是最多的方法之一，所以源码比较复杂，比较长

#### 代码实现

```java
List<String> list=new ArrayList<>();
list.add("灰灰HK");
```

#### 源码解析

![图片](http://xhh.dengzii.com/blog/Selection_007.png)

- <font color=orange>ensureCapacityInternal(int minCapacity)</font>确保数组容量充足

![图片](http://xhh.dengzii.com/blog/Selection_009.png)

- <font color=orange>calculateCapacity(Object[] elementData, int minCapacity)</font>

![图片](http://xhh.dengzii.com/blog/Selection_010.png)

- 再回到<font color=orange>ensureExplicitCapacity(int minCapacity)</font>这个方法，这个方法先`修改次数加1`，然后判断`size+1`是不是比当前的数组容量大，如果比当前的数组容量大，则进行扩容操作，扩大容量为原数组的`1.5倍`

> 比如第二次调用add方法，此时`size+1=2`, ` elementData.length=10`,为什么等于10呢？因为第一次默认把数组容量从0扩大到了10,这时`size+1`比`elementData.length`小，就不会进行扩容操作

![图片](http://xhh.dengzii.com/blog/Selection_011.png)

- <font color=orange>grow(int minCapacity)</font>扩容

> 这里调用`Arrays.copyOf()`方法进行复制操作，当进一步深入这个方法时，发现是由`System.arraycopy()`这个方法实现复制功能的，这个方法由`native`关键字修饰，表示不是由`Java`语言实现的，一般是c/cpp实现

![图片](http://xhh.dengzii.com/blog/Selection_012.png)

#### 小结

到这里，add的方法流程就走完了，其核心步骤：

- 每次添加元素时判断数组容量是否充足

- <font color=orange>第一次</font>添加元素，把数组容量扩容到10

- 扩容时，除第一次，以后的每次扩容为<font color=orange>原大小的1.5倍</font>

- 扩容后调用`System.arraycopy()`方法把原数组的元素复制到扩容后的新数组

  

### add(int index, E element)

该方法为在指定位置插入元素，该位置及后面所有元素后移

#### 代码实现

```java
List<String> list=new ArrayList<>();
list.add("hk");
list.add(0,"灰灰");
```

#### 源码解析

![图片](http://xhh.dengzii.com/blog/Selection_013.png)

> 可以看到，这边又用到了`System.arraycopy()`这个方法

- <font color=orange>rangeCheckForAdd(int index)</font>判断是否越界

> 这里他是和`size`对比，而不是和数组的`length`对比，我个人认为这样第一节省了空间，第二方便后面移动的操作

![图片](http://xhh.dengzii.com/blog/Selection_014.png)

- <font color=orange>System.arraycopy()</font>拷贝数组

```java
public static native void arraycopy(Object src,  int  srcPos,
                             		Object dest, int destPos,
                                    int length)
```

> - src    原数组对象
> - srcPos    原数组起始位置
> - dest    目标数组
> - destPos    目标数组起始位置
> - length    复制多少个数据

#### 小结

插入方法其主要步骤如下:

- 检查插入的位置是否越界
- 检查数组容量是否充足，不充足进行扩容相关操作
- 调用`System.arraycopy()`进行`index`及后面的元素后移

## get方法

### get(int index)

#### 代码实现

```java
List<String> list=new ArrayList<>();
list.add("hk");
list.get(0);
```

#### 源码解析

![图片](http://xhh.dengzii.com/blog/Selection_015.png)

- <font color=orange>rangeCheck(int index)</font>判断是否越界

> get个add方法判断越界的方法是不一样的，这边是`index>=size`,多了个`等于`，为什么要多个等于呢？因为数组是从0开始的，而size<font color=orange>相当于</font>是开始的从1开始的

```java
private void rangeCheck(int index) {
    if (index >= size)
        throw new IndexOutOfBoundsException(outOfBoundsMsg(index));
}
```

- <font color=orange>elementData(int index)</font>直接返回对应下标的数组元素

```java
E elementData(int index) {
    return (E) elementData[index];
}
```

#### 小结

get方法比较简单，主要步骤为：

- 检查是否越界
- 返回对应元素

## set方法

### set(int index, E element)

#### 代码实现

```java
List<String> list=new ArrayList<>();
list.add("hk");
list.set(0,"灰灰");
```

#### 源码解析

![图片](http://xhh.dengzii.com/blog/Selection_016.png)

## remove方法

### remove(int index)

#### 代码实现

```java
List<String> list=new ArrayList<>();
list.add("hk");
list.remove(0);
```

#### 源码解析

> 当删除的元素为最后一个元素时，`numMoved`就小于0了，就不会进行移动元素的操作

![图片](http://xhh.dengzii.com/blog/Selection_017.png)

### remove(Object o)

> 这个方法在实际中用的比较少，因为`AraryList`是可以保存重复的元素，所以删除是<font color=orange>删除最早添加的元素</font>

#### 代码实现

```java
List<String> list=new ArrayList<>();
list.add("hk");
list.remove("hk");
```

#### 源码解析

![图片](http://xhh.dengzii.com/blog/Selection_018.png)

- <font color=orange>fastRemove(int index)</font>删除元素

> 这个方法和remove(int index)内部的操作类似，不过这边不保存被删除的元素

```java
private void fastRemove(int index) {
    modCount++;
    int numMoved = size - index - 1;
    if (numMoved > 0)
        System.arraycopy(elementData, index+1, elementData, index,
                         numMoved);
    elementData[--size] = null; // clear to let GC do its work
}
```

## clear方法

### clear()

#### 代码实现

```java
List<String> list=new ArrayList<>();
list.add("hk");
list.clear();
```

#### 源码分析

![图片](http://xhh.dengzii.com/blog/Selection_019.png)

## 总结

`ArrayList`底层扩容或者移动数组元素时都调用了`System.arraycopy()`来进行相关操作，平时进行我们进行数组复制或移动的时候也可以调用这个方法了，这个性能比循环复制性能高多了，特别是在大量数据的时候。

文章好几次出现了`modCount++`这个操作，这个`modCount`主要用户内部类的迭代器