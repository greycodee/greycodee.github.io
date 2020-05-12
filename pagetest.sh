#!/bin/bash
echo '====清除古老文件===='
hexo clean
echo '====开始生成新文件===='
hexo g
echo '====开始启动本地服务===='
hexo s
