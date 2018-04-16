#! /bin/sh

git add .

if [ x"$1" != x ]; then
    git commit -m "$1"
else
    git commit -m "update post"
fi

echo "----------------------------------------------"
echo "----------push to origin hexo-----------------"
echo "----------------------------------------------"
git push origin hexo

echo "----------------------------------------------"
echo "----------------push hexo end-----------------"
echo "----------------------------------------------"
