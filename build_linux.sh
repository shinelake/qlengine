#!/bin/sh

export QL_DIR=$PWD/QuantLib
export QLEXT_DIR=$PWD/QuantLib-Ext

cd QuantLib
export WORK_DIR=$PWD
mkdir build
cd build

cmake -DCMAKE_INSTALL_PREFIX=$WORK_DIR ..

export LD_LIBRARY_PATH=$WORK_DIR/lib:$LD_LIBRARY_PATH
export LIBRARY_PATH=$WORK_DIR/lib:$LIBRARY_PATH
export CPLUS_INCLUDE_PATH=$WORK_DIR/include:$CPLUS_INCLUDE_PATH 

make -j 8
make install

cd ../bin
# ./quantlib-test-suite --log_level=message --build_info=true

cd ../../QuantLib-Ext
export WORK_DIR=$PWD
mkdir build
cd build

cmake -DCMAKE_INSTALL_PREFIX=$WORK_DIR ..

export LD_LIBRARY_PATH=$WORK_DIR/lib:$LD_LIBRARY_PATH
export LIBRARY_PATH=$WORK_DIR/lib:$LIBRARY_PATH
export CPLUS_INCLUDE_PATH=$WORK_DIR/include:$CPLUS_INCLUDE_PATH 

make -j 8
make install

cd ../bin
./quantlibext-test-suite --log_level=message --build_info=true

echo $LD_LIBRARY_PATH

cd ../../QuantLib-SWIG/Python
python setup.py wrap
python setup.py build
python setup.py install
