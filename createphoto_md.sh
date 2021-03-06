#!/bin/bash 
# created by qichao 20180419 

# declare array for filename
# filenames
# urlfilenames

# $1 目标文件夹名称
# $2 图片所在文件夹绝对路径
# $3 相册标题
# OSS的文件夹需要以NO.XXX 命名，比如6.jiaqi

echo "--------------Begin-------------"

unset filenames
unset urlfilenames

# 检查目标文件夹是否存在
if [ x"$1" == x ]; then
	echo "Please input the target folder name !"
	exit 1
else
	folder=$1
	# foldernamearray"."分割得到数组 
	foldernamearray=(${folder//./ }) 
	# 取得 foldernamearray 数组第一个值
	foldername=${foldernamearray[1]}

	mkdir -p "./source/photos-$foldername"
	targetpath="`pwd`/source/photos-$foldername/"
fi

# 检查图片所在路径
if [ x"$2" != x ]; then
	cd $2/
	path=`pwd`
else
	echo "Please input the correct pic folder !"
	exit 1
fi

# 
index=0
for file in $path/* 
	do  
	if [ -f "$file" ]; then 
		# file 是绝对路径名字
		# /c/Users/Administrator/Desktop/zone_pic/云南大理/写诗印象.JPG
		# 对file以"/"进行分割得到数组 pathnamearray
		pathnamearray=(${file//// }) 
		# 取得 pathnamearray 数组最后一个值
		jpgfilename=${pathnamearray[@]: -1}
		# 对jpgfilename以"."分割得到数组 
		filenamearray=(${jpgfilename//./ }) 
		# 取得 filenamearray 数组第一个值
		filename=${filenamearray[1]}

		filenames[$index]=$filename
		urlfilename=`echo $filename |tr -d '\n' |od -An -tx1|tr ' ' %`
		urlfilenames[$index]=${filenamearray[0]}.$urlfilename.${filenamearray[2]}
		index=$index+1
	fi  
done 

#echo ${filenames[@]}
#echo ${urlfilenames[@]}

####

cd $targetpath
echo "---">index.md
echo "title: $3">>index.md
echo "date: `date +20%y-%m-%d` `date +%X`">>index.md
echo "type: photos">>index.md
echo "comments: false">>index.md
echo "password:">>index.md
echo "---">>index.md
echo "">>index.md
echo "">>index.md
echo "">>index.md
echo "">>index.md

prefix="https://zingqi.oss-cn-shenzhen.aliyuncs.com"
suffix="?x-oss-process=style/watermark"
# keep the same name for source and oss
folder=$1

let i=0
echo "{% stream %}">>index.md
while [ $i -lt ${#filenames[@]} ]
do
	echo "{% figure ">>index.md
	# https://zingqi.oss-cn-shenzhen.aliyuncs.com/yunnandali/X.XXX.JPG?x-oss-process=style/watermark
	echo "$prefix/$folder/${urlfilenames[$i]}">>index.md
	#echo "$prefix/$folder/${urlfilenames[$i]}$suffix">>index.md
	#echo "[${filenames[$i]}]($prefix/$folder/${urlfilenames[$i]}$suffix)">>index.md
	echo "[${filenames[$i]}]($prefix/$folder/${urlfilenames[$i]})">>index.md
	echo "%}">>index.md

	let i++
	let abc=$i%3
	if [[ $abc == 0 && $i != ${#filenames[@]} ]]; then
		echo "{% endstream %}">>index.md
		echo "">>index.md
		echo "">>index.md
		echo "{% stream %}">>index.md
	fi
done
echo "{% endstream %}">>index.md

echo "--------------Done--------------"


