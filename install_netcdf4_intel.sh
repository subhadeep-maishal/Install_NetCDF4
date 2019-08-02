#!/bin/bash

# Script to install hdf5 and netCDF4 libraries on a Linux Ubuntu system
# After: https://code.google.com/p/netcdf4-python/wiki/UbuntuInstall
# And http://unidata.github.io/netcdf4-python/ 

# You can check for newer version of the programs at 
# ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-4/
# and other sources

# # https://www.unidata.ucar.edu/support/help/MailArchives/netcdf/msg10066.html


BASHRC="~/.bashrc"
prefix="/usr/local/netcdf4"
export CC=icc
export CXX=icpc
export CFLAGS='-O3 -xHost -ip -no-prec-div -static-intel'
export CXXFLAGS='-O3 -xHost -ip -no-prec-div -static-intel'
export F77=ifort
export FC=ifort
export F90=ifort
export FFLAGS='-O3 -xHost -ip -no-prec-div -static-intel'
export CPP='icc -E'
export CXXCPP='icpc -E'

# Install zlib
v=1.2.8  
wget ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-4/zlib-${v}.tar.gz
tar -xf zlib-${v}.tar.gz 
cd zlib-${v}
./configure --prefix=$prefix
make
# make check
make install
cd ..

# Install HDF5
v=1.8.13
wget ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-4/hdf5-${v}.tar.gz
tar -xf hdf5-${v}.tar.gz && cd hdf5-${v}

export HDF5_DIR=$prefix

    echo "Add HDF5_DIR=$prefix to .bashrc"
    echo "" >> $BASHRC
    echo "# HDF5 libraries for python" >> $BASHRC
    echo export HDF5_DIR=$prefix  >> $BASHRC
# ./configure --enable-shared --enable-hl --prefix=$HDF5_DIR
./configure --disable-shared --enable-hl --prefix=$HDF5_DIR
make -j 2 # 2 for number of procs to be used
# make check
make install
cd ..

# Install Netcdf
v=4.1.3
wget http://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-${v}.tar.gz
tar -xf netcdf-${v}.tar.gz && cd netcdf-${v}
export NETCDF4_DIR=$prefix
    echo "Add NETCDF4_DIR=$prefix to .bashrc"
    echo "" >> $BASHRC
    echo "# NETCDF4 libraries for python" >> $BASHRC
    echo export NETCDF4_DIR=$prefix  >> $BASHRC

export CPPFLAGS=-I$HDF5_DIR/include 
export LDFLAGS=-L$HDF5_DIR/lib 
# ./configure --enable-netcdf-4 --enable-shared --enable-dap --prefix=$NETCDF4_DIR
./configure --enable-netcdf-4 --disable-shared --enable-dap --prefix=$NETCDF4_DIR
make
# make check
make install
cd ..

# install python's netCDF4
# sudo -E pip install netCDF4 --upgrade
# conda install netcdf4

