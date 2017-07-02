@echo off

set BOOST_ROOT=D:/dev/boost_1_64_0
set BOOST_LIBRARYDIR=D:/dev/boost_1_64_0/lib/stage
set INCLUDE=%BOOST_ROOT%
set QL_DIR=%CD%\QuantLib
set QLEXT_DIR=%CD%\QuantLib-Ext
set BUILD_TYPE=Release

cd QuantLib

if exist build (
  rem build folder already exists.
) else (
  mkdir build
)

cd build

cmake -G "Visual Studio 14 2015 Win64" -DCMAKE_BUILD_TYPE=%BUILD_TYPE% ..
msbuild Project.sln /target:QuantLib /m /p:Configuration=%BUILD_TYPE% /p:Platform=x64

cd ..\..\QuantLib-Ext

if exist build (
  rem build folder already exists.
) else (
  mkdir build
)

cd build

cmake -G "Visual Studio 14 2015 Win64" -DCMAKE_BUILD_TYPE=%BUILD_TYPE% ..
msbuild Project.sln /target:QuantLibExt /m /p:Configuration=%BUILD_TYPE% /p:Platform=x64

cd ..\..\QuantLib-SWIG\Python

python setup.py wrap
python setup.py build
python setup.py install

cd ..\..

@echo on
