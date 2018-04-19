---
title: Linux下源码安装及配置Git
copyright: true
comments: false
date: 2018-04-14 14:44:36
tags: 
    - Git
    - ssh-keygen
categories: 技术
password:
photos:
    - http://wx4.sinaimg.cn/mw690/686ac523ly1fqc81u7l09j214a0qxjvu.jpg
layout:
---

> Git is a free and open source distributed version control system designed to handle everything from small to very large projects with speed and efficiency.
> Git是一款免费、开源的分布式版本控制系统，用于敏捷高效地处理任何或小或大的项目.


<!--more-->


在官方安装介绍里面, 包含了源码安装方式和二进制安装方式, [传送门](https://git-scm.com/book/zh/v1/%E8%B5%B7%E6%AD%A5-%E5%AE%89%E8%A3%85-Git)
本文主要记录在Linxu中使用源码安装和配置命令

# 准备工作

如果当前是root用户,那么最好创建一个 **git** 用户, 以git用户操作下面的步骤

 - 创建git用户并设置密码
```bash
$ sudo adduser git  # 创建git用户
$ sudo passwd git   # 设置git密码
```
 - 给git用户添加sudo权限
```bash
$ sudo chmod 740 /etc/sudoers
$ sudo vim /etc/sudoers
```
 - 在/etc/sudoers 文件中,添加一行
```
## Allow root to run any commands anywhere
root    ALL=(ALL)     ALL
## Add by qichao for git on 20180414
git   ALL=(ALL)     ALL
```
- 如果不想每次以git执行sudo命令输入密码,修改添加
```
## Allow root to run any commands anywhere
root    ALL=(ALL)     ALL
## Add by qichao for git on 20180414
git   ALL=(ALL) NOPASSWD: ALL
```
- 然后就可以切换到 git 用户了
```bash
$ su git
$ cd ~
```
# 源码安装
 - 安装依赖
```
$ yum install curl-devel expat-devel gettext-devel openssl-devel zlib-devel
```
 - 下载编译
```bash
$ wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.17.0.tar.gz
$ tar -zxf git-2.17.0.tar.gz
$ cd git-2.17.0
$ make prefix=/usr/local all
$ sudo make prefix=/usr/local install
```
 - Git tar包的下载链接 [Linxu下载](https://mirrors.edge.kernel.org/pub/software/scm/git/)
   
# Git配置

 - 配置用户名和邮箱
```bash
$ git config --global user.name "yourname"
$ git config --global user.email "youremail"
```
 - 生成 SSH 密钥, 在命令执行过程中一路回车即可,不需要输入密码
```bash
$ ssh-keygen -t rsa -C "youremail@example.com"
```
 - 然后执行命令查看公钥, 将该公钥拷贝到Github上就可以提交代码
```bash
$ eval `ssh-agent`
$ ssh-add ~/.ssh/id_rsa
$ cat ~/.ssh/id_rsa.pub
```
- 创建一个裸仓库的命令
```bash
$ cd /home/git/
$ git init --bare xxxx.git
$ chown -R git:git xxxx.git
```
- 克隆仓库的命令
```bash
$ git clone git@yourserverip:/home/git/xxxx.git
```
- 提交命令
```bash
$ git status
$ git add 
$ git commit -m "comments"
$ git push origin master
```

# 创建证书免密登录

把需要免密登录的公钥写入到 .ssh/authorized_keys文件中即可
- 第一次登录会需要记录IP地址
```bash
$ cd /home/git
$ chmod 700 .ssh
$ touch .ssh/authorized_keys
$ chmod 600 .ssh/authorized_keys
```

PS: 官方使用教程: [传送门](https://git-scm.com/book/zh/v2)