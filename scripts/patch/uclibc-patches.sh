#!/bin/bash
# Create a uClibc Patch

# Get Version #
#
VERSION=$1
SOURCEVERSION=$2

# Check Input
#
if [ "${VERSION}" = "" -o "${SOURCEVERSION}" = "" ]; then
  echo "$0 - uClibc_Version"
  echo "This will Create a Patch for uClibc uClibc_Series uClibc_Version"
  echo "Example $0 0.9.30 0.9.30.1"
  exit 255
fi

# Download uClibc Source
#
cd /usr/src
if ! [ -e uClibc-${SOURCEVERSION}.tar.bz2  ]; then
  wget http://www.uclibc.org/downloads/uClibc-${SOURCEVERSION}.tar.bz2
fi

# Set Patch Number
#
cd /usr/src
wget http://svn.cross-lfs.org/svn/repos/cross-lfs/branches/clfs-embedded/patches/ --no-remove-listing
PATCH_NUM=$(cat index.html | grep uClibc | grep "${SOURCEVERSION}" | grep branch_update | cut -f2 -d'"' | cut -f1 -d'"'| cut -f4 -d- | cut -f1 -d. | tail -n 1)
PATCH_NUM=$(expr ${PATCH_NUM} + 1)
rm -f index.html

# Cleanup Directory
#
rm -rf uClibc-${SOURCEVERSION} uClibc-${SOURCEVERSION}.orig
tar xvf uClibc-${SOURCEVERSION}.tar.bz2
mv uClibc-${SOURCEVERSION} uClibc-${SOURCEVERSION}.orig
CURRENTDIR=$(pwd -P)

# Get Current Updates from SVN
#
cd /usr/src
FIXEDVERSION=$(echo ${VERSION} | sed -e 's/\./_/g')
svn export svn://uclibc.org/branches/uClibc_${FIXEDVERSION} uClibc-${SOURCEVERSION}

# Create Patch
#
cd /usr/src
echo "Submitted By: Jim Gifford (jim at cross-lfs dot org)" > uClibc-${SOURCEVERSION}-branch_update-${PATCH_NUM}.patch
echo "Date: `date +%m-%d-%Y`" >> uClibc-${SOURCEVERSION}-branch_update-${PATCH_NUM}.patch
echo "Initial Package Version: ${SOURCEVERSION}" >> uClibc-${SOURCEVERSION}-branch_update-${PATCH_NUM}.patch
echo "Origin: Upstream" >> uClibc-${SOURCEVERSION}-branch_update-${PATCH_NUM}.patch
echo "Upstream Status: Applied" >> uClibc-${SOURCEVERSION}-branch_update-${PATCH_NUM}.patch
echo "Description: This is a branch update for uClibc-${SOURCEVERSION}, and should be" >> uClibc-${SOURCEVERSION}-branch_update-${PATCH_NUM}.patch
echo "             rechecked periodically." >> uClibc-${SOURCEVERSION}-branch_update-${PATCH_NUM}.patch
echo "" >> uClibc-${SOURCEVERSION}-branch_update-${PATCH_NUM}.patch
diff -Naur uClibc-${SOURCEVERSION}.orig uClibc-${SOURCEVERSION} >> uClibc-${SOURCEVERSION}-branch_update-${PATCH_NUM}.patch
echo "Created /usr/src/uClibc-${SOURCEVERSION}-branch_update-${PATCH_NUM}.patch."
