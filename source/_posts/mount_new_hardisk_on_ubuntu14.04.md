---
title: Ubuntu14.04 新增硬盘挂载
copyright: false
comments: false
date: 2018-04-17 15:12:07
tags:
    - fdisk
categories:
    - 问题备忘
password:
photos:
layout:
---

> 在Ubuntu下新增了一块2T的硬盘,需要对硬盘进行挂载和格式化

# 检查当前有哪些硬盘挂载了
```bash
# 执行 fdisk 命令必须要root权限
$ sudo fdisk -l
```

<!--more-->

```
Disk /dev/sdb: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders, total 1953525168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk identifier: 0x00000000
```

# 为新增硬盘进行gpt分区操作
```
$ sudo parted /dev/sdb
  # 先查看下该硬盘的分区信息
  (parted) print
  # 建立gpt分区表
  (parted) mklabel gpt
  # 确认该硬盘新的分区信息
  (parted) print
  # 分配硬盘地址空间范围, 1000GB是空盘大小
  (parted) mkpart primary 0KB 1000GB
  # 确认问题提示
  Y
  # 忽视提示问题
  I
  # 确认该硬盘新的分区信息
  (parted) print
  # 退出分区操作
  (parted) quit
```

# 格式化新分区,并手动挂载
```bash
$ sudo mkfs -t ext4 /dev/sdb1   # sdb1 是分区后的默认盘号
$ sudo mkdir -p /local/sdb     # 新建文件用于挂载分区
$ sudo chown -R user:user /local/sdb    # 修改挂载点为当前用户
$ sudo chmod 777 /local/sdb
# 挂载硬盘并设置为读写权限
$ sudo mount -t ext4 -o rw /dev/sdb1  /local/sdb
$ mount
```

# 设置每次开机自动挂载
```bash
$ sudo vim /etc/fstab
# 在文件中增加如下行 
/dev/sdb1       /local/sdb      ext4    defaults    0       0   
```

![添加一行](http://p6spipky2.bkt.clouddn.com/qcczone/180417/0KABEfC9AK.png?imageslim)

# 重启电脑即可生效
如果重启时发现提示错误,可以先按下"S"跳过错误,再检查一遍是否设置有误