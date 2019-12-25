#!/bin/bash
echo '====清除老的文件===='
hexo clean
echo '====hexo 生成新文件===='
hexo g
echo '====hexo 上传到服务器===='
hexo d
echo '＝＝＝＝拉取远程＝＝＝＝'
git pull

echo '＝＝＝＝开始添加本地修改＝＝＝＝'

git add .

echo '＝＝＝＝开始提交到本地＝＝＝＝'

git commit -m 'new page'

echo '＝＝＝＝推送远程＝＝＝＝'

git push
