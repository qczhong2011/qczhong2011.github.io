---
title: Ubuntu14.04 VirtualBox启动报错
copyright: true
comments: false
date: 2018-04-16 17:40:19
tags:
    - virtualbox
categories:
    - 问题备忘
password:
photos:
    - http://p6spipky2.bkt.clouddn.com/qcczone/180416/b4E8eeedJ0.png?imageslim
layout:
---

> 问题描述: 新安装的ubuntu14.04 系统,
> 启动VirtualBox报错,提示"Kernel driver not installed"

<!--more-->

解决方法如下:
## 将当前用户加入vboxusers用户组
```bash
$ sudo usermod -G vboxusers -a yourname
```
  
## 安装组件
```bash
$ sudo apt-get update
$ sudo apt-get install linux-headers-`uname -r`build-essential
$ sudo apt-get install virtualbox-dkms
$ sudo dpkg-reconfigure virtualbox-dkms
```
  
## 加载组件
```bash
$ ll /dev/ | grep vboxdrv
$ sudo modprobe vboxdrv
```
  
## 重新安装 vboxdrv
```bash
$ sudo /etc/init.d/vboxdrv start
```
  
## 正常启动 VirtualBox
