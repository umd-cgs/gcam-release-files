#!/bin/bash

# Define WORKSPACE path relative to location of make-release.sh 
WORKSPACE='../../g-c_for_v7_Mac_arm64_build'
# Define RELEASE_FILES path relative to WORKSPACE
RELEASE_FILES='../gcam-release-files'
GCAM_VERSION='7'
cd $WORKSPACE

# git remote add stash https://stash.pnnl.gov/scm/jgcri/gcam-core.git
# git pull stash master
# git tag -a gcam-v${GCAM_VERSION}
# git push stash gcam-v${GCAM_VERSION}
# git push origin master
# git push origin gcam-v${GCAM_VERSION}

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
zip -y gcam-china-v${GCAM_VERSION}-Mac_arm64-Release-Package.zip -@ < file_list_expanded
