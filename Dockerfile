FROM ubuntu:24.04

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y  autoconf \
			automake \
			autotools-dev \
			curl \
			libmpc-dev \
			libmpfr-dev \
			libgmp-dev \
			gawk \
			build-essential \
			bison \
			flex \
			texinfo \
			gperf \
			libtool \
			patchutils \
			bc \
			zlib1g-dev \   
                        git
RUN git config --global url."https://".insteadOf git:// && \
    git config --global http.sslverify "false"
RUN git clone https://github.com/riscv/riscv-gnu-toolchain /home/riscv-gnu-toolchain && \
    cd /home/riscv-gnu-toolchain && \
    git checkout v20170612 && \
    git submodule update --init --recursive 
RUN cd /home/riscv-gnu-toolchain && \
    ./configure --prefix=/opt/riscv --with-arch=rv32i --with-abi=ilp32 && \
    make -j$(nproc)

FROM ubuntu:24.04
RUN apt-get update -y && \
    apt-get install -y  libmpc-dev \
			libmpfr-dev \
			libgmp-dev \
			zlib1g-dev    
COPY --from=0 /opt/riscv /opt/riscv
ENV PATH="/opt/riscv/bin/:${PATH}"
