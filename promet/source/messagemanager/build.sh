#!/bin/bash
basedir=$(pwd)
cd promet/source/messagemanager
. ../../setup/build-tools/setup_enviroment.sh
echo "Building messagemanager..."
# Build components
$lazbuild messagemanager.lpi $BUILD_ARCH $BUILD_PARAMS > build.txt
if [ "$?" -ne "0" ]; then
  echo "build failed"
  $grep -w "Error:" build.txt
  exit 1
fi
cd $basedir
#set -xv
#copy Files
cd $basedir
rm -r $BUILD_DIR
mkdir $BUILD_DIR
mkdir $BUILD_DIR/tools
cp promet/output/$TARGET_CPU-$TARGET_OS/tools/messagemanager$TARGET_EXTENSION $BUILD_DIR/tools
cd $BUILD_DIR
zip -rq $basedir/promet/setup/output/$BUILD_VERSION/messagemanager_$TARGET_CPU-$TARGET_OS-$BUILD_VERSION.zip .
cd $basedir