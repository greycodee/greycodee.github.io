---
title: "解密安卓微信聊天信息存储"
date: 2022-06-20T14:19:48+08:00
draft: false
---
## 准备工作
（当前微信版本是：8.0.18）
- 一台 Root 的手机（手机不能 Root 的话用安卓模拟器，然后安卓模拟器获取 Root 应该也是可以的，不过我没试过）
- [DB Browser for SQLite](https://sqlitebrowser.org/)
- [SQLCipher](https://github.com/sqlcipher/sqlcipher)
- [silk-v3-decoder](https://github.com/kn007/silk-v3-decoder)

## 收集数据
需要收集的数据有：
- **image2 文件夹**：里面存放着所有的微信聊天图片，位置在：`/data/data/com.tencent.mm/MicroMsg/[32位字母]/image2`
- **voice2 文件夹**：里面存放着所有的微信语音，位置在：`/sdcard/Android/data/com.tencent.mm/MicroMsg/[32位字母]/voice2`
- **voide 文件夹**：里面存放着所有的微信视频，位置在：`/sdcard/Android/data/com.tencent.mm/MicroMsg/[32位字母]/voide`
- **avatar 文件夹**：里面存放着所有的微信头像，位置在：`/data/data/com.tencent.mm/MicroMsg/[32位字母]/avatar`
- **Download 文件夹**: 微信的聊天发送的文件存放在这里，位置在：`/sdcard/Android/data/com.tencent.mm/MicroMsg/Download`
- **EnMicroMsg.db**: 微信的数据库文件，位置在：`/data/data/com.tencent.mm/MicroMsg/[32位字母]/EnMicroMsg.db`
- **WxFileIndex.db**: 微信的文件索引数据库文件，位置在：`/data/data/com.tencent.mm/MicroMsg/[32位字母]/WxFileIndex.db`

在上面的这些文件中，需要注意的是路径中有个 32 位字母的路径，这个是微信通过某种算法生成的，每个号的路径都不一样。
其中 **voice2**、**voide**、**Download** 这三个文件夹在 `/sdcard` 目录下，其他的在系统目录 `/data` 下。
Download 文件夹存放着当前手机上所有微信聊天时发送的文件，这里文件例如：文档，安装包、压缩包等。需要通过 **WxFileIndex.db** 来索引到这个文件夹。

**把上面收集的所有文件放在电脑的同一个文件夹中，接下来对这些数据进行处理。**

## 获取 DB 访问密码
在上面获取到的 **EnMicroMsg.db**、**WxFileIndex.db** 是经过加密的，所以我们需要获得这个的访问密码，通过这个密码来解密数据库。
### 方法一
可以直接通过 **MD5(IMEI+uin)** 取前 7 位即是访问密码，如果是大写的要转换成小写字母。(注意：拼接两个数据时不需要用 `+` 号)
其中IMEI 是手机的 IMEI 码，可以查询手机的设置，在设置中可以查看到。如果你手机刷过机，那么 IMEI 有可能是空白的。或者像 MIUI 系统一样，应用无法真正获取到手机的 IMEI。这时就可以用 **1234567890ABCDEF** 这个字符串来代替 IMEI。
uin 可以通过 adb 来查看当前登陆微信的 uin 数据：
```shell
## 进入 adb
$ adb shell
# 进入 root 用户
$ su
# 查看文件
$ cat /data/data/com.tencent.mm/shared_prefs/auth_info_key_prefs.xml
```
文件内容：
```xml
<?xml version='1.0' encoding='utf-8' standalone='yes' ?>
<map>
    <boolean name="auth_info_prefs_use_new_ecdh" value="true" />
    <int name="_auth_uin" value="272136722" />
    <boolean name="key_auth_info_prefs_created" value="true" />
    <int name="key_auth_update_version" value="xxx" />
    <string name="server_id">xxxx</string>
    <string name="_auth_key">xxxxx</string>
</map>
```
其中 **_auth_uin** 的 value 值就是 uin。

### 方法二
还可以通过 Frida 来获取访问密码，如果你电脑上有 python 环境的话，建议用这个方法，因为这个方法可以直接得到密码，而不用一个一个的去试拼接出来的密码，并且绝对正确。
首先电脑通过下面命令安装 Frida 包:
```shell
$ pip install frida
$ pip install frida-tools
```
然后使用 adb 查看手机架构：
```shell
$ adb shell getprop ro.product.cpu.abi

arm64-v8a 
```
得到的是 arm64-v8a，然后去 https://github.com/frida/frida/releases 页面下载对应的 frida-server-<版本号>-arm64.xz 包，然后解压。
注意：这边的 frida-server 版本号要和上面电脑安装的 frrida 的版本号一致，否则可能会出现额外的错误。
通过 adb 把 frida-server 传到手机：
```shell
$ adb push  frida-server-<版本号>-android-arm /data/local/tmp
```
然后在手机上运行 frida-server：
```shell
$ adb shell
$ su
$ cd /data/local/tmp
$ chmod 777 frida-server-<版本号>-android-arm
$ ./frida-server-<版本号>-android-arm
```
运行后，这个终端界面不要关闭，另外在启动一个终端，然后在终端中输入：
```shell
$ adb forward tcp:27042 tcp:27042
$ adb forward tcp:27043 tcp:27043
$ frida-ps -U
```
如果终端输出了一些进程，那么就表示环境搭建成功了。搭建成功后，在电脑运行下面的 Python 脚本：
```python
import frida 
import sys   
 
jscode = """
    Java.perform(function(){ 
        var utils = Java.use("com.tencent.wcdb.database.SQLiteDatabase"); // 类的加载路径
         
        utils.openDatabase.overload('java.lang.String', '[B', 'com.tencent.wcdb.database.SQLiteCipherSpec', 'com.tencent.wcdb.database.SQLiteDatabase$CursorFactory', 'int', 'com.tencent.wcdb.DatabaseErrorHandler', 'int').implementation = function(a,b,c,d,e,f,g){  
            console.log("Hook start......");
            var JavaString = Java.use("java.lang.String");
            var database = this.openDatabase(a,b,c,d,e,f,g);
            send(a);
            console.log(JavaString.$new(b));
            send("Hook ending......");
            return database;
        };
         
    });
"""
 
 
def on_message(message,data): 
    if message["type"] == "send":
        print("[*] {0}".format(message["payload"]))
    else:
        print(message)
     
process = frida.get_remote_device()
pid = process.spawn(['com.tencent.mm']) 
session = process.attach(pid)  
script = session.create_script(jscode) 
script.on('message',on_message) 
script.load()
process.resume(pid)
sys.stdin.read()
```
脚本运行后，然后在手机直接打开微信，这时电脑控制台会输出一个 7 位字母，这个就是访问密码。
## 解密 DB
微信加密使用的是开源的 **SqlCipher**，所以我用这个工具加上上面得到的密码来进行解密。
在 https://github.com/sqlcipher/sqlcipher/tags 这个页面上，可以找到最新的版本，然后下载。
下载后进行解压，解压后进入文件夹进行编译，编译前先检查本地有没有安装 **GCC** 和 **OpenSSL**，如果没有安装，需要先安装。
```shell
# 进行编译
$ ./configure --enable-tempstore=yes CFLAGS="-DSQLITE_HAS_CODEC" \
	LDFLAGS="-lcrypto"
$ make
```
Mac 电脑可以直接通过 brew 来进行直接安装：
```shell
$ brew install sqlcipher
```
Windows 建议使用 WSL 来进行编译。
测试有没有安装成功，在终端输入 sqlcipher,如果出现以下信息，则表示安装成功了。（注意：如果后面括号中没有出现 SQLCipher 4.5.1 community，那么表示只安装了 SQLite，没有安装 SQLCipher，那么就不能进行解密操作了）。
```shell
$ sqlcipher                                                                                                                                                            127 ↵
SQLite version 3.37.2 2022-01-06 13:25:41 (SQLCipher 4.5.1 community)
Enter ".help" for usage hints.
Connected to a transient in-memory database.
Use ".open FILENAME" to reopen on a persistent database.
sqlite>
```
安装完成后，打开一个终端，进入 EnMicroMsg.db 文件存放的位置，然后在终端进行数据库的解密：
```shell
$ sqlcipher EnMicroMsg.db
SQLite version 3.37.2 2022-01-06 13:25:41 (SQLCipher 4.5.1 community)
Enter ".help" for usage hints.
sqlite> PRAGMA key = '上面得到的密码';
ok
sqlite> PRAGMA cipher_use_hmac = off;
sqlite> PRAGMA kdf_iter = 4000;
sqlite> PRAGMA cipher_page_size = 1024;
sqlite> PRAGMA cipher_hmac_algorithm = HMAC_SHA1;
sqlite> PRAGMA cipher_kdf_algorithm = PBKDF2_HMAC_SHA1;
sqlite> ATTACH DATABASE 'plaintext.db' AS plaintext KEY '';
sqlite> SELECT sqlcipher_export('plaintext');
sqlite> DETACH DATABASE plaintext;
```
执行完上面这些命令后，会在终端输出一个 **plaintext.db**，这个文件就是解密后的数据库文件。对 **WxFileIndex.db** 进行同样的操作来进行解密。(进行第二次解密时，注意 plaintext.db 文件名冲突，所以建议使用一个新的文件名)

## EnMicroMsg.db 解析
### 数据表
这个数据库中有许多的表，但是真正有用的就下面这几张表：
- **userinfo 表**：存储个人信息，其中 id 为 2 的 value 是个人的微信 id。
- **message 表**：存储所有的聊天记录。
- **chatroom 表**：存储所有群聊信息。
- **img_flag 表**：存储所有用户的在线头像的信息。如果本地 avatar 文件夹没有头像时，可以用这个表的地址来访问用户的头像，其中 reserved2 是缩略图，reserved1 是高清图。
- **rcontact 表**：存放所有的好友信息。

### 消息内容解析
在 **message** 表中，**type** 字段表示着当前消息的类型，一般有如下类型：
- **1**：文本消息
- **3**：图片消息
- **34**：语音消息
- **43**：视频消息
- **47**：大表情消息
- **49**：分享卡片信息
- **1000**：撤回消息提醒
- **436207665**：微信红包
- **419430449**：微信转账
- **1090519089**：文件消息
上面的一些媒体类型的消息，例如图片、语音、视频等，都会可以用 **msgId** 字段去 **WxFileIndex.db** 数据库中的 **WxFileIndex2** 表中查找到对应的文件路径。
除了通过去 **WxFileIndex2** 表查询媒体文件的路径，还可以通过某些字段的拼接和加密直接获取媒体文件的路径。
#### 图片地址获取
图片消息的地址有两个，一个是图片缩略图，一个是图片原图。
- **缩略图获取**:
    在 **message** 表中，如果当前消息为图片消息时，**imgPath** 字段会有值，值类似于：`THUMBNAIL_DIRPATH://th_5a24c5d362dae72b0ad52d78767ba883`，其中 **5a24** 代表 `/5a/24` 文件夹下的，**th_5a24c5d362dae72b0ad52d78767ba883** 是图片文件名。图片的父目录就是一开始的 `/image2` 文件夹。
- **原图获取**:
    如果要获取原图，则是通过另外一种拼接规则来得到图片地址的。一般有两种情况：
    1. 发送的图片：文件名是：`自己的wxid+_+当前的talker值+_+当前msgSvrid+_backup`，路径是文件名的前两个字母，每两个字母代表一个文件夹层级。
    2. 接收的图片：文件名是：`当前的talker值+_+自己的wxid_+当前msgSvrid+_backup`，路径是文件名的前两个字母，每两个字母代表一个文件夹层级。
#### 视频地址获取
直接通过 **message** 表后的 **imgPath** 查找到 **video** 文件夹查找对应的视频，封面图后缀为 `.jpg`，视频后缀为：`.mp4`。
#### 语音地址获取
**message** 的 **imgPath** 字段通过 **MD5 加密**后，前 4 个字母代表两级文件夹名，然后最终文件名是：`msg_imgPath的值.amr`
#### 文件地址获取
在微信聊天时发送的文件都存放在 `/sdcard/Android/data/com.tencent.mm/MicroMsg/Download` 文件夹下，只能通过当前的 **msgId** 字段去 **WxFileIndex.db** 数据库中的 **WxFileIndex2** 表中查找到对应的文件路径。
#### 本地头像获取
微信的头像都存放在 `/data/data/com.tencent.mm/MicroMsg/[32位字母]/avatar` 文件夹下，微信 ID 通过 **MD5 加密**后，前 4 个字母代表两级文件夹名，每两位代表一个文件夹名，文件名格式：`user_md5字符串.png`
> 例如微信id：weixin 经过 MD5 加密后是：C196266F837D14E0B693F961BEE37B66，那么这个微信的头像地址是：avatar/c1/96/user_c196266f837d14e0b693f961bee37b66.png
## 语音文件处理
由于微信语音使用了 **SILK v3 编码**，一般播放器都不放不了，所以需要进行手动解码。这里直接使用开源的 [silk-v3-decoder](https://github.com/kn007/silk-v3-decoder) 工具来进行解码。需要先安装 GCC、ffmpeg 等工具，具体查看开源工具说明。
转码后，在获取语音文件地址时，记得把后缀改为你转码后的后缀，例如转码成 `mp3` 格式，后缀就是 `mp3`，不是 `amr`。