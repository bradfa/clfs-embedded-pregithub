#!/bin/bash
# Create a Busybox Patch

# Get Version #
#
VERSION=$1

# Check Input
#
if [ "${VERSION}" = "" ]; then
  echo "$0 - Busybox_Version"
  echo "This will Create a Patch for Busybox Busybox_Version"
  exit 255
fi

# Get Patch Names
#
cd /usr/src
wget http://busybox.net/downloads/fixes-${VERSION}/ --no-remove-listing
FILES=$(cat index.html | grep patch | grep patch | cut -f3 -d'<' | cut -f2 -d'>')
rm -f .listing
rm -f index.html

# Download Busybox Source
#
if ! [ -e busybox-${VERSION}.tar.bz2 ]; then
  wget http://busybox.net/downloads/busybox-${VERSION}.tar.bz2
fi

# Set Patch Number
#
cd /usr/src
wget http://svn.cross-lfs.org/svn/repos/cross-lfs/branches/clfs-embedded/patches/ --no-remove-listing
PATCH_NUM=$(cat index.html | grep busybox | grep "${VERSION}" | grep branch_update | cut -f2 -d'"' | cut -f1 -d'"'| cut -f4 -d- | cut -f1 -d. | tail -n 1)
PATCH_NUM=$(expr ${PATCH_NUM} + 1)
rm -f index.html

# Cleanup Directory
#
rm -rf busybox-${VERSION} busybox-${VERSION}.orig
tar xvf busybox-${VERSION}.tar.bz2
cp -ar busybox-${VERSION} busybox-${VERSION}.orig
cd busybox-${VERSION}
CURRENTDIR=$(pwd -P)

# Download and Apply Patches
#
mkdir /tmp/busybox-${VERSION}
for file in ${FILES}; do
  cd /tmp/busybox-${VERSION}
  echo "Getting Patch ${file}..."
  wget --quiet http://busybox.net/downloads/fixes-${VERSION}/${file}
  cd ${CURRENTDIR}
  patch --dry-run -s -f -Np1 -i /tmp/busybox-${VERSION}/${file}
  if [ "$?" = "0" ]; then
    echo "Apply Patch ${file}..."
    patch -Np1 -i /tmp/busybox-${VERSION}/${file}
  fi
done

# Cleanup Directory
#
for dir in $(find * -type d); do
  cd /usr/src/busybox-${VERSION}/${dir}
  for file in $(find . -name '*~'); do
    rm -f ${file}
  done
  for file in $(find . -name '*.orig'); do
    rm -f ${file}
  done
done
cd /usr/src/busybox-${VERSION}
rm -f *~ *.orig

# Create Patch
#
cd /usr/src
echo "Submitted By: Jim Gifford (jim at cross-lfs dot org)" > busybox-${VERSION}-branch_update-${PATCH_NUM}.patch
echo "Date: `date +%m-%d-%Y`" >> busybox-${VERSION}-branch_update-${PATCH_NUM}.patch
echo "Initial Package Version: ${VERSION}" >> busybox-${VERSION}-branch_update-${PATCH_NUM}.patch
echo "Origin: Upstream" >> busybox-${VERSION}-branch_update-${PATCH_NUM}.patch
echo "Upstream Status: Applied" >> busybox-${VERSION}-branch_update-${PATCH_NUM}.patch
echo "Description: This is a branch update for busybox-${VERSION}, and should be" >> busybox-${VERSION}-branch_update-${PATCH_NUM}.patch
echo "             rechecked periodically." >> busybox-${VERSION}-branch_update-${PATCH_NUM}.patch
echo "" >> busybox-${VERSION}-branch_update-${PATCH_NUM}.patch
diff -Naur busybox-${VERSION}.orig busybox-${VERSION} >> busybox-${VERSION}-branch_update-${PATCH_NUM}.patch
echo "Created /usr/src/busybox-${VERSION}-branch_update-${PATCH_NUM}.patch."
