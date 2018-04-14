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


if [ x"$2" == x ]; then
	echo "Just want to push Config"
	exit 0
fi
echo "----------------------------------------------"
echo "----------ssh to server autohexo--------------"
echo "----------------------------------------------"
ssh git@120.79.138.59 /home/git/autohexo.sh

echo "----------------------------------------------"
echo "----------------auto hexo end-----------------"
echo "----------------------------------------------"
