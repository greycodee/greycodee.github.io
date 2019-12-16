#!/bin/bash
echo '＝＝＝＝开始添加本地修改＝＝＝＝'

git add .

echo '＝＝＝＝开始提交到本地＝＝＝＝'

git commit -m 'new page'

echo '＝＝＝＝推送远程＝＝＝＝'

git push
