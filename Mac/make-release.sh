#!/bin/bash
#
# Call this script as:
# $ bash /path/to/make-release.sh /path/to/gcam-folder /path/to/latest-release

MAC_RELEASE_FILES=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )


# Define WORKSPACE path absolutely or relative to location of make-release.sh 
WORKSPACE="$1"
# Define RELEASE_FILES path absolutely or relative to WORKSPACE
RELEASE_VERSION_PATH="$2"
GCAM_VERSION='8'

# git remote add stash https://stash.pnnl.gov/scm/jgcri/gcam-core.git
# git pull stash master
# git tag -a gcam-v${GCAM_VERSION}
# git push stash gcam-v${GCAM_VERSION}
# git push origin master
# git push origin gcam-v${GCAM_VERSION}

# move to workspace
cd $WORKSPACE

# Copy over lib files
mkdir -p ./libs
cp -r $RELEASE_VERSION_PATH/libs/* ./libs/
cp -r $RELEASE_VERSION_PATH/ModelInterface/* ./ModelInterface/

# set env vars
export JARS_LIB=../libs/jars/* # this is weird because it has to be relevat to the exe folder
export MACOSX_DEPLOYMENT_TARGET=12

# build gcam and gcam data
make clean
make install_hector
make -j 20 
make drake

# Clean exe
rm -rf input/gcamdata/.drake
rm -rf input/gcamdata/renv/library
rm -rf input/gcamdata/.Rproj.user/
rm -rf input/gcamdata/outputs/
rm -f exe/debug*
rm -f exe/logs/*
rm -f exe/restart/*
cp exe/configuration_china.xml exe/configuration.xml
touch exe/.basexhome
rm -f ModelInterface/logs/*

cp "${MAC_RELEASE_FILES}/run-gcam.command" ./exe/
cp -r "${MAC_RELEASE_FILES}/../Additional Licenses" ./
cp "${MAC_RELEASE_FILES}/model_interface.properties" ./ModelInterface/

# TODO: build ModelInterface.app

# Build; Mac OSX deployment target
# MACOSX_DEPLOYMENT_TARGET = 10.9
# Double check file list
rm -f file_list_expanded
IFS=$'\r\n'
for f in `cat ${MAC_RELEASE_FILES}/mac_files`; do find $f -type f | grep -v '.basex$' >> file_list_expanded; find $f -type l >> file_list_expanded; done
unset IFS
echo 'libs/java' >> file_list_expanded
# TODO: automate checks to ensure no proprietary data
zip gcam-china-v${GCAM_VERSION}-Mac_arm64-Release-Package.zip -@ < file_list_expanded
