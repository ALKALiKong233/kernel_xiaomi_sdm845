#!/bin/bash
clang_path="${HOME}/proton-clang/bin/clang"
gcc_path="${HOME}/proton-clang/bin/aarch64-linux-gnu-"
gcc_32_path="${HOME}/proton-clang/bin/arm-linux-gnueabi-"

source=`pwd`
START=$(date +"%s")

date="`date +"%m%d%H%M"`"

args="-j$(nproc --all) O=out \
	ARCH=arm64 "

print (){
case ${2} in
	"red")
	echo -e "\033[31m $1 \033[0m";;

	"blue")
	echo -e "\033[34m $1 \033[0m";;

	"yellow")
	echo -e "\033[33m $1 \033[0m";;

	"purple")
	echo -e "\033[35m $1 \033[0m";;

	"sky")
	echo -e "\033[36m $1 \033[0m";;

	"green")
	echo -e "\033[32m $1 \033[0m";;

	*)
	echo $1
	;;
	esac
}

print "You are building version:$date" yellow

args+="LOCALVERSION=-$date "

args+="CC=$clang_path \
	CLANG_TRIPLE=aarch64-linux-gnu- \
	CROSS_COMPILE=$gcc_path \
	AR=${HOME}/proton-clang/bin/llvm-ar \
	NM=${HOME}/proton-clang/bin/llvm-nm \
	OBJCOPY=${HOME}/proton-clang/bin/llvm-objcopy \
	OBJDUMP=${HOME}/proton-clang/bin/llvm-objdump \
	STRIP=${HOME}/proton-clang/bin/llvm-strip "

args+="CROSS_COMPILE_ARM32=$gcc_32_path "

clean(){
	make mrproper
	make $args mrproper
}

build_dipper(){
	export KBUILD_BUILD_USER="dipper"
	export KBUILD_BUILD_HOST="ALKALiKong"
	print "Building Kernel for dipper..." blue
	make $args dipper_defconfig&&make $args
	if [ $? -ne 0 ]; then
    terminate "Error while building for dipper!"
    fi
	mkzip "dipper-${1}"
}

mkzip (){
	zipname="(${1})Li-Kernel-$date.zip"
	cp -f out/arch/arm64/boot/Image.gz-dtb ~/AnyKernel2
	cd ~/AnyKernel2
	zip -r "$zipname" *
	mv -f "$zipname" ${HOME}
	cd ${HOME}
	cd $source
	print "All done.Find it at ${HOME}/$zipname" green
}

./prepare.sh
clean
build_dipper
mkzip
