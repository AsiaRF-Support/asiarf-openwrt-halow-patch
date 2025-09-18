#!/bin/sh

copy_src() {
	echo "Copy taget files..."
	for file in $SRC_DIR/*; do
		cp -r "$file" "$OPENWRT_DIR"
		 [ $? -eq 0 ] && echo "Copy $file -> $OPENWRT_DIR"
	done
}

apply_patch() {
for patch in "$PATCH_DIR"/*.patch; do
    echo "Applying $patch..."
    patch -N $1 -p1 -d "$OPENWRT_DIR" < "$patch"
done
}

check_dir_exist() {
	[ -d "$1" ] || {
		echo "Error: The directory $1 does not exist. Exit."
		exit 1
	}
}

usage() {
	echo "Usage: bash install.sh <platform>"
    echo "Support platform:"
	echo "	ap7622-wh1"
	echo "	ap7621-004"
	echo "	<empty> for initialize only."
    exit 1
}

do_patch() {
	SRC_DIR="$ROOT_DIR/src/pre-src"
	PATCH_DIR="$ROOT_DIR/patch/pre-patch"
	check_dir_exist "$OPENWRT_DIR/boards"
	check_dir_exist "$SRC_DIR"
	check_dir_exist "$PATCH_DIR"

	copy_src
	apply_patch

	cd $OPENWRT_DIR
	if [ -z $PLATFORM ];then
		./scripts/morse_setup.sh -i
	else
		./scripts/morse_setup.sh -i -b $PLATFORM
	fi
	SRC_DIR="$ROOT_DIR/src/post-src"
	PATCH_DIR="$ROOT_DIR/patch/post-patch"
	check_dir_exist "$SRC_DIR"
	check_dir_exist "$PATCH_DIR"

	copy_src
	apply_patch

	cd $OPENWRT_DIR
	echo "Done."
	exit 0
}

ROOT_DIR="$PWD"
OPENWRT_DIR="$PWD/.."
PLATFORM=$1

if [ -z $PLATFORM ];then
	echo "Platform is empty."
	echo "Would you initialize but not set up any target? [y/N]"
	read ANSWER
	if [ "$ANSWER" = "y" ]; then
		do_patch
	else
		echo "N"
		usage
	fi
elif [ -d $ROOT_DIR/src/pre-src/boards/$PLATFORM ];then
	do_patch
else
	usage
fi

