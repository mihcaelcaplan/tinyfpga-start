# grab some variables
UNAME := $(shell uname)

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
	@if [ -d files ];\
	 then echo "files dir exists";\
	 else mkdir files;\
	fi

build:
	docker build -t tinyfpga:1.0 -f Dockerfile .

os: 
ifeq ($(UNAME), Linux)
	@echo "fuck"
endif
ifeq ($(UNAME), Darwin)
	@echo "you"
endif


interactive: init
ifeq ($(UNAME), Darwin)
	xhost +$(shell ipconfig getifaddr en0)
	docker run -e DISPLAY=$(shell ipconfig getifaddr en0):0 \
				--mount type=bind,source=$(shell pwd)/files,target=/home/fpgauser \
				--entrypoint /usr/local/bin/default.sh \
				-it tinyfpga:1.0 
endif
ifeq ($(UNAME), Linux)
	docker run -e DISPLAY=$(DISPLAY) \
				-v /tmp/.X11-unix:/tmp/.X11-unix \
				--privileged \
				-v /dev/serial:/dev/serial \
				--mount type=bind,source=$(shell pwd)/files,target=/home/fpgauser \
				--entrypoint /usr/local/bin/default.sh \
				-it tinyfpga:1.0 
	
endif

# interactive: init
# 	xhost +$(shell ipconfig getifaddr en0)
# 	docker run -e DISPLAY=$(shell ipconfig getifaddr en0):0 \
# 				--privileged \
# 				-v /dev/ttyACM0:/dev/ttyACM0 \
# 				--mount type=bind,source=$(shell pwd)/files,target=/home/fpgauser \
# 				--entrypoint /usr/local/bin/default.sh \
# 				-it tinyfpga:1.0

example: init
	xhost +$(shell ipconfig getifaddr en0)
	docker run -e DISPLAY=$(shell ipconfig getifaddr en0):0 \
				--privileged \
				-v /dev/serial:/dev/serial \
				--mount type=bind,source=$(shell pwd)/files,target=/home/fpgauser/ \
				--entrypoint /usr/local/bin/build_example.sh \
				-it tinyfpga:1.0
		

attach:
	docker exec -it $(shell docker ps -lq) bash
	