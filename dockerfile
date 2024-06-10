FROM ubuntu:24.10

RUN apt update && \
  apt install -y -qq fpc && \
  git clone https://gitlab.com/freepascal.org/fpc/source.git --depth=1 fpc

RUN sudo apt install lld-12 && \
  ln -sf /usr/lib/llvm-12/bin/wasm-ld ~/bin/wasm32-wasi-wasm-ld && \
  ln -sf /usr/lib/llvm-12/bin/wasm-ld ~/bin/wasm32-embedded-wasm-ld

RUN cd fpc && \
  make clean all OS_TARGET=embedded CPU_TARGET=wasm32 BINUTILSPREFIX= OPT="-O-" PP=fpc && \
  make crossinstall OS_TARGET=embedded CPU_TARGET=wasm32 INSTALL_PREFIX=$HOME/fpcwasm

RUN echo '-Fu/root/fpcwasm/lib/fpc/$fpcversion/units/$fpctarget/*\n-Fu/root/fpcwasm/lib/fpc/$fpcversion/units/$fpctarget/rtl\n' >> /root/.fpc.cfg

RUN ln -s /root/fpcwasm/lib/fpc/3.3.1/ppcrosswasm32 /usr/bin/fpcwasm