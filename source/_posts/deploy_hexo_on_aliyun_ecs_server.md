---
title: 基于服务器解析并部署Hexo
copyright: true
comments: false
date: 2018-04-14 15:54:47
tags: 
    - Hexo 
    - nvm
categories: 技术
password:
photos:
    - http://wx3.sinaimg.cn/mw690/686ac523gy1fqca4ndn5tj20gt07v3yk.jpg
layout:
---

> 基于GitHub双分支思路备份源码, 基于Git Hooks思路自动部署网页
> 客户端完成博客更新和配置修改, 服务器端解析并部署成静态网页
> 使用脚本命令优雅完成一键更新, 并同时更新到GPages和云服务器

<!--more-->

# 准备工作

## 基于Github 双分支思路备份源码

- 在Github Pages仓库中创建两个分支:master 和 hexo
- 设置hexo为默认分支
- 采用 Use SSH 方式将该仓库clone到本地
 ![Use SSH](http://wx3.sinaimg.cn/mw690/686ac523gy1fqc95fj0puj20c6063t8u.jpg)
- 将hexo文件夹中的文件复制到clone下来的git仓库中
- 不要遗漏 .gitignore文件,并将 theme/next/目录下的.git/文件夹删掉
- 将更新Push到git仓库
 ```bash
 $ git add .
 $ git commit -m "init hexo source code"
 $ git push origin hexo
 ```

## 基于Git Hooks思路自动部署网页

- 在云服务器中新建一个裸仓
```bash
$ git init --bare zingqi.git
$ chown -R git:git zingqi.git
```
- 在裸仓的zingqi.git/hooks/文件夹目录下创建文件 post-receive,并写入
```
#! /bin/sh
git --work-tree=/usr/local/nginx/html/zingqi --git-dir=/home/git/zingqi.git checkout -f
```
- 给该文件添加可执行权限
```bash
$ chmod +x post-receive
```
- 在hexo项目目录中,修改配置文件的deploy项目,使得每次deploy时将结果push到zingqi.git
```
deploy:
  type: git
  repo: 
    gitecs: git@yourserverIP:/home/git/zingqi.git,master
  message:
```

# 服务器解析部署实现

## 安装Git
可参考: {% post_link git-install-guild Linux下源码安装及配置Git %}

## 安装Node

### 安装nvm
- 不建议采用 [官方文档](https://hexo.io/zh-cn/docs/index.html)  的安装方式,后期可能会报错
- 通过 [nvm官方说明](https://github.com/creationix/nvm#install-script)   进行安装
 - 使用 curl 方式
```bash
$ curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
```
 - 使用 wget方式
```
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
```
- 安装完成后, 重启终端使命令路径生效

### 基于nvm安装Node
```
$ nvm install stable
```

## 安装Hexo
- 先检查下当前git和node是否安装正常
```
$ git --version
$ node --version
```

### 初始化安装
```
$ npm install -g hexo-cli
$ hexo init <folder>
$ cd <folder>
$ npm install
$ npm install hexo-deployer-git
```
### 还原式安装 (如果采用了双分支备份思路)
- 使用git将远程hexo仓库clone到本地后,执行以下命令
```
$ npm install hexo-cli -g
$ npm install
$ npm install hexo-deployer-git
```
- 通过命令进行部署
 - 调试:
```
$ hexo clean && hexo g && hexo s --debug
```
 - 部署:(部署前需要配置Hexo的_config文件)
```
hexo clean && hexo g && hexo d
```

# 本地一键更新
- 服务器端编写脚本命令更新并部署Hexo
```bash
#！/bin/sh
# autohexo.sh
if [ ! -d "/home/git/qczhong2011.github.io/" ]; then
  exit 0
fi
cd /home/git/qczhong2011.github.io/
git reset --hard HEAD
git pull
#git fetch origin master
npm run d
```
- 客户端编写脚本一键更新并触发服务器编译脚本
```bash
#! /bin/sh
# autogit.sh
git add .
if [ x"$1" != x ]; then
    git commit -m "$1"
else
    git commit -m "update post"
fi
git push origin hexo
ssh git@yourserverIP /home/git/autohexo.sh
```

- 如果只是更新配置文件,则可以手动执行命令push代码