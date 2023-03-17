---
title: "使用Github Action自动化处理Issue"
date: 2023-03-17T11:06:11+08:00
draft: true
---

## 起因
由于日常工作学习时，有时需要记录一些小问题的解决办法，但是又不想在博客上写一篇文章，也不想使用笔记软件，所以就想到了使用 Github Issue 来记录，然后配合 Github Action 来自动化处理 Issue 并配合hugo 生成博客。

## 流程
首先，创建一个 Github Action 来监听 Issue 的创建事件，当有新的 Issue 创建时，就会触发这个 Action，然后 Action 会自动将 Issue 的内容保存到指定 hugo 的目录下，最后将这个目录提交到 Github，这样就可以通过 Github Pages 来访问这个目录下的 Markdown 文件了。


https://docs.github.com/zh/webhooks-and-events/webhooks/webhook-events-and-payloads?actionType=opened#issues

```yaml
on:
  issues:
    types: [opened]

jobs:

  issues:
    name: Issues
    if: ${{ !github.event.issue.pull_request }}
    runs-on: ubuntu-latest
    steps:
      - run: |
          echo number on issue $NUMBER
        env:
            # issue 编号
          NUMBER: ${{ github.event.issue.number }}
      - run: |
          echo A body on issue $BODY
        env:
            # issue 内容
          BODY: ${{ github.event.issue.body }}
```