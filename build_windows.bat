@echo off

set BOOST_ROOT=D:/dev/boost_1_64_0
set BOOST_LIBRARYDIR=D:/dev/boost_1_64_0/lib/stage
set INCLUDE=%BOOST_ROOT%
set QL_DIR=%CD%\QuantLib
set QLEXT_DIR=%CD%\QuantLib-Ext
set BUILD_TYPE=Debug
set ADDRESS_MODEL=Win64

cd QuantLib

if exist build (
  rem build folder already exists.
) else (
  mkdir build
)

if %ADDRESS_MODEL%==Win64 (
  set PLATFORM=x64
) else (
  set PLATFORM=Win32
)

cd build


if %ADDRESS_MODEL%==Win64 (
  cmake -G "Visual Studio 14 2015 %ADDRESS_MODEL%" -DCMAKE_BUILD_TYPE=%BUILD_TYPE% ..
) else (
  cmake -G "Visual Studio 14 2015" -DCMAKE_BUILD_TYPE=%BUILD_TYPE% ..
)

if %errorlevel% neq 0 exit /b 1

msbuild Project.sln /target:QuantLib_Static /m /p:Configuration=%BUILD_TYPE% /p:Platform=%PLATFORM%

if %errorlevel% neq 0 exit /b 1

cd ..\..\QuantLib-Ext

if exist build (
  rem build folder already exists.
) else (
  mkdir build
)

cd build

if %ADDRESS_MODEL%==Win64 (
  cmake -G "Visual Studio 14 2015 %ADDRESS_MODEL%" -DCMAKE_BUILD_TYPE=%BUILD_TYPE% ..
) else (
  cmake -G "Visual Studio 14 2015" -DCMAKE_BUILD_TYPE=%BUILD_TYPE% ..
)

if %errorlevel% neq 0 exit /b 1

msbuild QuantLibExt.sln /target:QuantLibExt /m /p:Configuration=%BUILD_TYPE% /p:Platform=%PLATFORM%

if %errorlevel% neq 0 exit /b 1

cd ..\..\QuantLib-SWIG\Python

python setup.py wrap
python setup.py build
python setup.py bdist_wheel
python setup.py install

if %errorlevel% neq 0 exit /b 1

cd ..\..

@echo on
