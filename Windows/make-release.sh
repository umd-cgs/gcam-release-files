#!/bin/bash

WORKSPACE=~/model/gcam-core
RELEASE_FILES=~/model/gcam-release-files
GCAM_VERSION='7.1'
cd $WORKSPACE

# git remote add stash https://stash.pnnl.gov/scm/jgcri/gcam-core.git
# git pull stash master
# git tag add gcam-v${GCAM_VERSION}

# Clean exe
rm -rf input/gcamdata/.drake
rm -rf input/gcamdata/renv/library
rm -f exe/debug*
rm -f exe/logs/*
rm -f exe/restart/*
cp exe/configuration_ref.xml exe/configuration.xml
touch exe/.basexhome
rm -f ModelInterface/logs/*

cp "${RELEASE_FILES}/Windows/run-gcam.bat" ./exe/
cp -r "${RELEASE_FILES}/Additional Licenses" ./
cp "${RELEASE_FILES}/Windows/model_interface.properties" ./ModelInterface/
cp "${RELEASE_FILES}/Windows/run-model-interface.bat" ./ModelInterface/

# Double check file list
rm -f file_list_expanded
IFS=$'\n'
for f in `cat ${RELEASE_FILES}/Windows/win_files`; do find $f -type f | grep -v '.basex$' >> file_list_expanded; done
unset IFS
echo 'ModelInterface/logs' >> file_list_expanded
# double check everything is in file_list_expanded
zip -y gcam-v${GCAM_VERSION}-Windows-Release-Package.zip -@ < file_list_expanded
