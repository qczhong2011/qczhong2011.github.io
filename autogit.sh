#! /bin/sh
git add .
if [ x$1 != x ]; then
    git commit -m "$1"
else
	git commit -m "update post"
fi
git push origin hexo
ssh git@120.79.138.59 /home/git/autohexo.sh
echo "---------------------"
echo "----auto hexo end----"
echo "---------------------"
