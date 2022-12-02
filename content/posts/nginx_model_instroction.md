---
title: "Nginx Model Instroction"
date: 2022-12-02T11:31:54+08:00
draft: false
---

## Introduction
Nginx adopts a unique master and multi workers process pool mechanism, which guarantees stable operation and flexible configuration of Nginx.

Usually, Nginx will start a master process and multiple worker processes to provide external services. The master process, known as the monitoring process, did not handle specific TCP/HTTP requests and received only the Unix signal.

Worker processes compete equally for accepting client connections, executing the main business logic of Nginx, and Using epoll, kqueue, and other mechanisms to process TCP/HTTP requests efficiently.

![Ningx_ModeldP4gVp](https://cdn.jsdelivr.net/gh/greycodee/images@main/2022/12/02/Ningx_ModeldP4gVp.png)