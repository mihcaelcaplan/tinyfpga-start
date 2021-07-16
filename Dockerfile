FROM ubuntu:18.04
####### AS ROOT #######
RUN apt-get update && apt-get install -y python3-pip sudo git

# download and install atom for apio
# RUN curl -s https://api.github.com/repos/atom/atom/releases/latest \
# | grep "atom-amd64.*deb" \
# | cut -d : -f 2,3 \
# | tr -d \" \
# | wget -qi -
# COPY atom-amd64.deb /usr/local/src/
# RUN apt install -y ./usr/local/src/atom-amd64.deb

# install apio and tinyprog
RUN pip3 install apio==0.4.0b5 tinyprog

# install some simulation tools
USER root
RUN sudo DEBIAN_FRONTEND=noninteractive apt-get install -y tcl-dev
RUN sudo apt-get install -y tk-dev gperf libgtk2.0-dev


# build gtkwave
COPY gtkwave-3.3.107.tar.gz /usr/local/src
RUN tar -C /tmp -xvzf /usr/local/src/gtkwave-3.3.107.tar.gz
WORKDIR /tmp/gtkwave-3.3.107
RUN ./configure --disable-xz
RUN make
RUN make install

# build iverilog
RUN sudo apt-get install -y flex bison
RUN git clone https://github.com/steveicarus/iverilog.git /usr/local/src/iverilog
WORKDIR /usr/local/src/iverilog
RUN autoconf
RUN ./configure
RUN make
RUN make install


# deal with user stuff
RUN useradd --create-home --shell /bin/bash fpgauser
RUN echo 'fpgauser:fpgauser' | chpasswd

RUN usermod -aG sudo fpgauser
RUN usermod -aG dialout fpgauser

####### AS USER #######
USER fpgauser
WORKDIR /home/fpgauser

# set locale for Click (part of apio)
ENV LANG C.UTF-8  
ENV LC_ALL C.UTF-8     

# install stuff from apio as user
RUN apio install system
RUN apio install scons 
RUN apio install icestorm 
RUN apio install iverilog
RUN apio drivers --serial-enable

# add stuff from git
RUN git clone https://github.com/lawrie/tinyfpga_examples

ENV DISPLAY=localhost:0
# have this late in the file because it will changes
COPY entrypoints /usr/local/bin

USER root
RUN chmod +x /usr/local/bin/*.sh

USER fpgauser
WORKDIR /home/fpgauser
ENTRYPOINT ["/bin/bash"]