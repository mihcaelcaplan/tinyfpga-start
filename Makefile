init: 
	@if [ -d files ];\
	 then echo "files dir exists";\
	 else mkdir files;\
	fi
	@if [ -d files/SpinalTemplateSbt ];\
	 then echo "SpinalTemplateSbt in files";\
	 else git clone https://github.com/SpinalHDL/SpinalTemplateSbt.git/ files/SpinalTemplateSbt;\
	fi
	@if [ -d files/TinyFPGA-BX ];\
	 then echo "TinyFPGA-BX in files";\
	 else git clone https://github.com/tinyfpga/TinyFPGA-BX files/TinyFPGA-BX;\
	fi

build:
	docker build -t tinyfpga:1.0 -f Dockerfile .

interactive: init
	xhost +$(shell ipconfig getifaddr en0)
	docker run -e DISPLAY=$(shell ipconfig getifaddr en0):0 \
				--privileged \
				-v /dev/tty.usbmodem14101:/dev/tty.usbmodem14101 \
				--mount type=bind,source=$(shell pwd)/files,target=/home/fpgauser \
				--entrypoint /usr/local/bin/default.sh \
				-it tinyfpga:1.0

example: init
	xhost +$(shell ipconfig getifaddr en0)
	docker run -e DISPLAY=$(shell ipconfig getifaddr en0):0 \
				--privileged \
				-v /dev/tty.usbmodem1432301:/dev/tty.usbmodem1432301 \
				--mount type=bind,source=$(shell pwd)/files,target=/home/fpgauser/ \
				--entrypoint /usr/local/bin/build_example.sh \
				-it tinyfpga:1.0

attach:
	docker exec -it $(shell docker ps -lq) bash
	