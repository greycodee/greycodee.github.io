---
title: "Understand Rust Ownership"
date: 2022-12-29T14:37:51+08:00
draft: true
---

## what's ownership?
常见的高级语言都有自己的 Garbage Collection（GC）机制来管理程序运行的内存，例如 Java、Go 等。而 Rust 引入了一种全新的内存管理机制，就是 ownership（所有权）。它在编译时就能够保证内存安全，而不需要 GC 来进行运行时的内存回收。

在 Rust 中 ownership 有以下几个规则：
- 每个值都有一个 woner（所有者）
- 在同一时间，每个值只能有一个 owner
- 当 owner 离开作用域，这个值就会被丢弃

## Scope (作用域)
通过作用域来划分 owner 的生命周期，作用域是一段代码的范围，例如函数体、代码块、if 语句等。当 owner 离开作用域，这个值就会被**丢弃**。

example:
```rust
fn main() {
    let s = String::from("hello"); // 变量 s 进入作用域，分配内存

    // s 在这里可用

} // 函数体结束，变量 s 离开作用域，s 被丢弃，内存被回收
```
## ownership transfer（所有权转移）
和大多数语言一样，Rust 在栈上分配基本类型的值，例如整型、浮点型、布尔型等。而在堆上分配复杂类型的值，例如 String、Vec 等。所以，这里就引入了两个概念，`move` 和 `clone`。

### move
`move` 操作会将变量的所有权转移给另一个变量，这样原来的变量就不能再使用了。这里需要注意的是，`move` 操作只会发生在**栈上**的值，因为在堆上的值是不可复制的，所以只能通过 `clone` 操作来复制。

example:
```rust
fn main(){
    let s1 = String::from("hello");
    let s2 = s1;
    print!("s1 = {}, s2 = {}", s1, s2);
}
```
在上面的代码例子中，如果你执行就会在编译时报错：
```bash
  --> src/main.rs:11:32
   |
9  |     let s1 = String::from("hello");
   |         -- move occurs because `s1` has type `String`, which does not implement the `Copy` trait
10 |     let s2 = s1;
   |              -- value moved here
11 |     print!("s1 = {}, s2 = {}", s1, s2);
   |                                ^^ value borrowed here after move
```
编译器提示我们，`s1` 在赋值给 `s2` 时发生了 `move` 的操作，它把字符串 `hello` 的所有权移交给了 `s2`，此时 `s1` 的作用域到这里就结束了，所以后面再使用 `s1` 就会报错。
![fAbt1r0HELef](https://cdn.jsdelivr.net/gh/greycodee/images@main/2022/12/30/fAbt1r0HELef.jpg)

### clone
`clone` 操作会将变量的值复制一份，这样原来的变量和新的变量就都可以使用了。这里需要注意的是，`clone` 操作只会发生在**堆上**的值，因为在栈上的值是可复制的，所以只能通过 `move` 操作来转移所有权。

example:
```rust
fn main(){
    let s1 = String::from("hello");
    let s2 = s1.clone();
    print!("s1 = {}, s2 = {}", s1, s2);
}
```
我们对 `s1` 进行 `clone` 操作，这样 `s1` 和 `s2` 都可以使用了，而且 `s1` 的所有权也没有被转移，所以后面还可以继续使用 `s1`。
![T71kL16XPbDD](https://cdn.jsdelivr.net/gh/greycodee/images@main/2022/12/30/T71kL16XPbDD.jpg)

### copy
如果一个类型实现了 `copy` 这个 trait，使用它的变量不会移动，而是被简单地复制，使它们在分配给另一个变量后仍然有效。

example:
```rust
fn main() {
    let x = 5;
    let y = x;
    print!("x = {}, y = {}", x, y);
}
```
当 `x` 赋值给 `y` 后，`x` 和 `y` 都可以使用，而且 `x` 的所有权也没有被转移，所以后面还可以继续使用 `x`。这是因为 `i32` 这个类型实现了 `copy` 这个 trait，所以 `x` 的值被复制了一份，所以 `x` 和 `y` 都可以使用。

以下这些数据类型实现了 `copy` 这个 trait：
- 所有的整数类型，例如：`u32`、`i32`。
- 布尔类型，`bool`，有 `true` 和 `false` 两个值。
- 所有的浮点数类型，例如：`f64`、`f32`。
- 字符类型，`char`。
- 元组，当且仅当它们的元素类型都实现了 `copy` 这个 trait。例如，`(i32, i32)` 实现了 `copy`，但是 `(i32, String)` 就没有实现。

## References and Borrowing（引用和借用）
我们将创建**引用**的动作称为**借用**。就像在现实生活中一样，如果一个人拥有某样东西，你可以向他们借用。完成后，您必须将其归还。你不拥有它。
引用有以下几个规则：
- 在任何给定时间，你可以拥有任意数量的引用，但是只能拥有一个可变引用。
- 引用必须总是有效的。

example1:
```rust
fn main() {
    let s1 = String::from("hello");
    let len = calculate_length(&s1);
    println!("The length of '{}' is {}.", s1, len);
}

fn calculate_length(s: &String) -> usize {
    s.len()
} // s 作用域失效，但是由于 s 是一个引用，没有所有权，所以不会发生任何事情
```
上面代码中，我们使用符号 `&` 来创造一个变量的引用。这里我们使用 `&s1` 来把这个引用指向 `s1`。函数 `calculate_length` 的参数 `s` 的类型是 `&String`，这意味着它是一个指向 `String` 类型的引用，然后在函数体内获取 `s` 的长度并返回给调用者。

example2:
```rust
fn main(){
    // 同一时间可以拥有多个不可变引用
    let s1 = String::from("hello");
    let s2 = &s1;
    let s3 = &s1;
    println!("s1 = {}, s2 = {}, s3 = {}", s1, s2, s3);

}
```
### Mutable References（可变引用）
可变引用指的是可以改变引用值的引用。在同一作用域中，同一时间只能有一个可变引用。

example:
```rust
fn main(){
    let mut s = String::from("hello");
    change(&mut s);
    println!("{}", s);
}

fn change(some_string: &mut String) {
    some_string.push_str(", world");
}
```
上面代码中，我们用 `mut` 先创建了一个可变变量 `s`,然后使用 `&mut s` 创建了一个指向 `s` 的可变引用。函数 `change` 的入参也是一个指向 `String` 类型的可变引用，这样我们就可以在函数 `change` 中改变 `s` 的值了。

example2:
```rust
fn main() {
    let mut s = String::from("hello");
    let r1 = &mut s;
    let r2 = &mut s;  // 在这里。编译器会报错，因为在同一作用域中，同一时间只能有一个可变引用。

    println!("{}, {}", r1, r2);
}
```
```bash
  --> src/main.rs:41:14
   |
40 |     let r1 = &mut s;
   |              ------ first mutable borrow occurs here
41 |     let r2 = &mut s;
   |              ^^^^^^ second mutable borrow occurs here
42 |
43 |     println!("{}, {}", r1, r2);
   |                        -- first borrow later used here
```

### Dangling References（悬垂引用）
悬垂引用是指引用一个不存在的值。在 Rust 中，这是不可能的，因为编译器会在编译时就检查这种情况。下面是一个例子：
```rust
fn main() {
    let reference_to_nothing = dangle(); // 获得一个指向不存在值的引用
}

fn dangle() -> &String {
    let s = String::from("hello"); // s 进入作用域

    &s // 返回 s 的引用
} // s 作用域结束，s 被丢弃，内存被释放
```
```bash
  --> src/main.rs:51:16
   |
51 | fn dangle() -> &String {
   |                ^ expected named lifetime parameter
```
因为变量 `s` 的作用域只在 `dangle` 函数内，当 `dangle` 函数返回 `s` 的引用时，`s` 已经被释放了，所以这个引用就是悬垂引用了。
解决这个的方法是返回一个 `String` 而不是一个引用，这样 `s` 就不会被释放，而是把 `s` 的所有权转移给了调用者，也就不存在悬垂引用了。

```rust
fn dangle() -> String {
    let s = String::from("hello");
    s
}
```