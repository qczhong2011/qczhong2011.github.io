#! /bin/sh
# Created by qichao 20180410

git add --all

if [ x"$1" != x ]; then
    git commit -m "$1"
else
    git commit -m "update post"
fi

git push origin hexo

echo "----------------------------------------------"
echo "----------push to hexo branch end-------------"
echo "----------------------------------------------"
