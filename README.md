**How to use:**

1. Clone OpenWrt from morse micro's code base. We specify the version of SDK v2.6.6

   (commit hash = 39565282fdea7a8869c001e3db6ba0446574a027)

	```
	git clone -b 2.6.6 https://github.com/MorseMicro/openwrt.git
	```

3. Clone and copy this repository into openwrt directory.

	```
 	git clone -b next https://github.com/AsiaRF-Support/asiarf-openwrt-halow-patch.git
	cp -r asiarf-openwrt-halow-patch openwrt/
	```

	The structure of directory should be:

	openwrt

	|-- asiarf-openwrt-halow-patch

	`-- some openwrt folders

5. In openwrt/asiarf-openwrt-halow-patch directory, execute the script.

	```
	cd openwrt/asiarf-openwrt-halow-patch; bash install.sh <platform>; cd ../
	```
	Currently, available platform:
	------------------------
   | platform | description |
   | -------- | ----------- |
   | <empty>    | initialize only without setting up target platform |
   | ap7622-wh1 | ap7622-wh1 with integrated mm610x chip |
   | ap7621-004 | ap7621-004 with mm610x-cs1 card installed |
    ------------------------

7. The script will install and patch files, prepare the configuration,
   including executing morse_setup.sh.

8. Run make to build the image. After building, you can get the firmware
   in **bin/targets/** directory.

	```
	make V=s -j$(($(nproc) + 1))
	```
