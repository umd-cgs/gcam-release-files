#!/bin/bash

# Define WORKSPACE path absolutely or relative to location of make-release.sh 
WORKSPACE='../../gcam-china-dev'
# Define RELEASE_FILES path absolutely or relative to WORKSPACE
RELEASE_FILES='../gcam-release-files'
RELEASE_VERSION_PATH='../releases/gcam-v8.2-Mac-Release-Package/'

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

cp "${RELEASE_FILES}/Mac/run-gcam.command" ./exe/
cp -r "${RELEASE_FILES}/Additional Licenses" ./
cp "${RELEASE_FILES}/Mac/model_interface.properties" ./ModelInterface/

# TODO: build ModelInterface.app

# Build; Mac OSX deployment target
# MACOSX_DEPLOYMENT_TARGET = 10.9
# Double check file list
rm -f file_list_expanded
IFS=$'\r\n'
for f in `cat ${RELEASE_FILES}/Mac/mac_files`; do find $f -type f | grep -v '.basex$' >> file_list_expanded; find $f -type l >> file_list_expanded; done
unset IFS
echo 'libs/java' >> file_list_expanded
# TODO: automate checks to ensure no proprietary data
#zip gcam-china-v${GCAM_VERSION}-Mac_arm64-Release-Package.zip -@ < file_list_expanded
