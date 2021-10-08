---
title: 使用GitHub Actions编译树莓派内核
top: false
cover: false
toc: true
mathjax: true
date: 2021-01-26 15:56:07
password:
summary:
keywords:
description:
tags:
- Github Actions
- Linux
categories:
- Linux
---

## 仓库地址

仓库地址：https://github.com/GreyCode9/make-raspberrypi-kernel

## 创建秘钥

1. 点击Github右上角头像 -> Settings -> Developer settings -> Personal access tokens -> Generate new token

<!-- more -->

1. 或者直接点这个链接进入： https://github.com/settings/tokens

   ![20210126150521](http://xhh.dengzii.com/20210126150521.png)

![20210126150712](http://xhh.dengzii.com/20210126150712.png)

<font color=red>创建后保存这个秘钥(秘钥只显示一次)</font>

## 创建仓库

创建仓库**[make-raspberrypi-kernel](https://github.com/GreyCode9/make-raspberrypi-kernel)**

然后点击仓库的Settings -> Secrets ->New repository secret

**然后填入刚才生成的秘钥**

![20210126151157](http://xhh.dengzii.com/20210126151157.png)



## 创建Actions

接着点击**Actions** ,创建一个Actions，然后填入如下内容

``` yaml
name: Make RaspberryPi Kernel

on:
  push:
    tags: 
      - 'v*' # 当推送的Tag为v开头的，就会触发构建

env:
  USE_SSH_CONFIG: true # 是否使用ssh连接进行 true:使用 false:不使用

jobs:
  build:

    runs-on: ubuntu-18.04

    steps:
      - uses: actions/checkout@v2
      - name: pull RaspberryPi Kernel linux
        run: |
          cd ../
          git clone https://github.com/raspberrypi/linux.git
      - name: pull RaspberryPi Kernel Tool
        run: |
          cd ../
          git clone https://github.com/raspberrypi/tools.git
      - name: Move .config
        if: env.USE_SSH_CONFIG == 'false'
        run: |
          cp .config ../linux
      - name: Setup Debug Session # 用SSH连接Actions
        if: env.USE_SSH_CONFIG == 'true'
        uses: csexton/debugger-action@master
      - name: Make
        run: |
          cd ../
          export WORKPATH=$(pwd)
          export PATH=$PATH:$WORKPATH/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin
          export PATH=$PATH:$WORKPATH/tools/arm-bcm2708/arm-bcm2708-linux-gnueabi/bin
          cd linux/
          make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage modules dtbs -j8
      - name: Create Release
        id: create_release
        uses: actions/create-release@master
        env:
          GITHUB_TOKEN: ${{ secrets.TOKEN }} # 之前GitHub添加的Token
        with:
          tag_name: ${{ github.ref }} # (tag)标签名称
          release_name: Release ${{ github.ref }}
          draft: false # 是否是草稿
          prerelease: false # 是否是预发布
      # 上传构建结果到 Release（把打包的tgz上传到Release）
      - name: build TAR PACKAGE
        run: |
          tar -czvf raspberrypi-kernel.tar.gz ../linux/arch/arm/boot
      - name: Upload Release Asset
        id: upload-release-asset
        uses: actions/upload-release-asset@master
        env:
          GITHUB_TOKEN: ${{ secrets.TOKEN }}
        with:
          upload_url: ${{ steps.create_release.outputs.upload_url }} # 上传地址，通过创建Release获取到的
          asset_path: ./raspberrypi-kernel.tar.gz # 要上传文件
          asset_name: raspberrypi-kernel.tar.gz # 上传后的文件名
          asset_content_type: application/gzip


```

- 可以在本地配置好`.config`文件然后上传到仓库，然后把Actions的配置文件中的`USE_SSH_CONFIG`字段改成`false`。
- 也可以直接在`Actions`中进行配置`.config`文件，需要把`USE_SSH_CONFIG`字段改成`true`。

## 触发构建

当上面完成后，就可以把代码pull到本地，然后根据自己的需求配置`.config`文件。执行命令

```shell
git tag -a v1.0 -m 'build kernel'
git push origin v1.0
```

推送完成后，就可以看到Actions正在构建了

![20210126152258](http://xhh.dengzii.com/20210126152258.png)

构建完成后，就可以在`Release`下载构建好的内核文件了

![20210126152413](http://xhh.dengzii.com/20210126152413.png)

![20210126152413](http://xhh.dengzii.com/20210126152428.png)

## 资料索引

- https://www.cnblogs.com/YAN-HUA/p/13530906.html
- http://doc.openluat.com/article/166/0
- https://www.daimajiaoliu.com/daima/4793af6f2900402