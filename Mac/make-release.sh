#!/bin/bash

WORKSPACE=~/model/gcam-github
RELEASE_FILES=~/model/gcam-release-files
GCAM_VERSION='5.4'
cd $WORKSPACE

# git remote add stash https://stash.pnnl.gov/scm/jgcri/gcam-core.git
# git pull stash master
# git tag add gcam-v${GCAM_VERSION}

rm -rf input/gcamdata/.drake
rm -f exe/debug*
rm -f exe/logs/*
rm -f exe/restart/*
cp exe/configuration_ref.xml exe/configuration.xml
touch exe/.basexhome

cp "${RELEASE_FILES}/Mac/run-gcam.command" ./exe/
cp -r "${RELEASE_FILES}/Additional Licenses" ./

# remember to double swap around correct libs
# Build; Mac OSX deployment target
# MACOSX_DEPLOYMENT_TARGET = 10.9
# Clean exe
# Double check file list
rm -f file_list_expanded
IFS=$'\n'
for f in `cat ${RELEASE_FILES}/Mac/mac_files`; do find $f -type f >> file_list_expanded; done
unset IFS
echo 'libs/java' >> file_list_expanded
# remember to double check install name path for xercesc in ./Release/objects
zip -y gcam-v${GCAM_VERSION}-Mac-Release-Package.zip -@ < file_list_expanded
