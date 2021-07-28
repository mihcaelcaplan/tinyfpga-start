FROM ubuntu:18.04
####### AS ROOT #######
RUN apt-get update && apt-get install -y python3-pip sudo git

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

#grab yosys
RUN git clone https://github.com/cliffordwolf/yosys.git /usr/local/src/yosys
WORKDIR /usr/local/src/yosys

#get dependencies for yosys
RUN apt-get install -y libreadline-dev libffi-dev

#build yosys
RUN make config-gcc
RUN make
RUN apt-get install -y gawk
# RUN make test
RUN make install

#prereqs 
RUN sudo apt-get install -y build-essential clang bison flex libreadline-dev \
                     gawk tcl-dev libffi-dev git mercurial graphviz   \
                     xdot pkg-config python python3 libftdi-dev \
                     qt5-default python3-dev libboost-all-dev libeigen3-dev curl libssl-dev

#cmake must be version 3.13 to be compatible with a policy setting in nextpnr
RUN curl -L https://github.com/Kitware/CMake/releases/download/v3.21.0/cmake-3.21.0.tar.gz --output /usr/local/src/cmake-3.21.0.tar.gz
WORKDIR /usr/local/src
RUN tar -xvzf cmake-3.21.0.tar.gz
WORKDIR /usr/local/src/cmake-3.21.0
RUN ./bootstrap
RUN make -j$(nproc)
RUN make install


#icestorm (includes icepack, icebox, iceprog, icetime, chip databases)
RUN git clone https://github.com/YosysHQ/icestorm.git /usr/local/src/icestorm
WORKDIR /usr/local/src/icestorm
RUN make -j$(nproc)
RUN sudo make install

# nextpnr (use instead of arachne)
RUN git clone https://github.com/YosysHQ/nextpnr /usr/local/src/nextpnr
WORKDIR /usr/local/src/nextpnr
RUN cmake -DARCH=ice40 -DCMAKE_INSTALL_PREFIX=/usr/local -DBUILD_GUI=ON .
RUN make -j$(nproc)
RUN make install

# install spinalhdl (from https://spinalhdl.github.io/SpinalDoc-RTD/SpinalHDL/Getting%20Started/getting_started.html#the-sbt-way)
#install java, scala 
RUN apt-get -y install openjdk-8-jdk
RUN apt-get -y install scala
# install curl tp get sbt
RUN apt-get -y install curl
RUN echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | sudo tee /etc/apt/sources.list.d/sbt.list
RUN echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | sudo tee /etc/apt/sources.list.d/sbt_old.list
RUN curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | sudo apt-key add
RUN apt-get update
RUN apt-get install sbt



############################################################################################

# deal with user stuff
RUN useradd --create-home --shell /bin/bash fpgauser
RUN echo 'fpgauser:fpgauser' | chpasswd

RUN usermod -aG sudo fpgauser
RUN usermod -aG dialout fpgauser

####### AS USER #######
USER fpgauser
WORKDIR /home/fpgauser


ENV DISPLAY=localhost:0
# have this late in the file because it will changes
COPY entrypoints /usr/local/bin

USER root
RUN chmod +x /usr/local/bin/*.sh

USER fpgauser
WORKDIR /home/fpgauser
ENTRYPOINT ["/bin/bash"]