FROM intel/oneapi-hpckit:2023.0.0-devel-ubuntu22.04
ARG DEBIAN_FRONTEND=noninteractive

#-----------
# FreeFem++
#-----------
RUN apt-get update && apt-get install -y --no-install-recommends \
 freeglut3-dev=2.8.1-6 \
 gfortran=4:11.2.0-1ubuntu1 \
 m4=1.4.18-5ubuntu2 \
 unzip=6.0-26ubuntu3.1 \
 liblapack-dev=3.10.0-2ubuntu1 \
 libhdf5-dev=1.10.7+repack-4ubuntu2 \
 libgsl-dev=2.7.1+dfsg-3 \
 autoconf=2.71-2 \
 automake=1:1.16.5-1.3 \
 autotools-dev=20220109.1 \
 bison=2:3.8.2+dfsg-1build1 \
 flex=2.6.4-8build2 \
 gdb=12.1-0ubuntu1~22.04 \
 file=1:5.41-3 \
 mpich=4.0-3 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
WORKDIR /usr/local/src
RUN wget https://github.com/FreeFem/FreeFem-sources/archive/refs/tags/v4.12.tar.gz && tar xf v4.12.tar.gz
WORKDIR /usr/local/src/FreeFem-sources-4.12
RUN sed -i 's/\^\[\-\/\]\[\^WLlOgpf\]|\^\-Wp,/\^(\-I)/' etc/config/m4/acmpi.m4
RUN autoreconf -i && ./configure --enable-optim --enable-download --enable-generic --with-mkl=/opt/intel/oneapi/mkl/latest/lib/intel64/ --enable-mkl-mlt && ./3rdparty/getall -o PETSc -a
WORKDIR /usr/local/src/FreeFem-sources-4.12/3rdparty/ff-petsc
RUN make petsc-slepc
WORKDIR /usr/local/src/FreeFem-sources-4.12
RUN ./reconfigure && make -j"$(nproc)"
RUN make install

# clean
RUN rm -rf /usr/local/src/*

CMD ["FreeFem++"]