init: 
	@if [ -d files ];\
	 then echo "files dir exists";\
	 else mkdir files;\
	fi
	@if [ -d files/tinyfpga_examples ];\
	 then echo "tinyfpga_examples in files";\
	 else git clone https://github.com/lawrie/tinyfpga_examples/ files/tinyfpga_examples;\
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
				-it tinyfpga:1.0

# template: init
# 	xhost +$(shell ipconfig getifaddr en0)
# 	docker run -e DISPLAY=$(shell ipconfig getifaddr en0):0 \
# 				--privileged \
# 				-v /dev/tty.usbmodem1432301:/dev/tty.usbmodem1432301 \
# 				--mount type=bind,source=$(shell pwd)/files,target=/home/fpgauser/ \
# 				--entrypoint /usr/local/src/build_blinky.sh \
# 				-it tinyfpga:1.0

attach:
	docker exec -it $(shell docker ps -lq) bash
	