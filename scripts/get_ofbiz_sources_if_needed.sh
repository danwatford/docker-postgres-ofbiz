#!/bin/bash
set -e

SCRIPT_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
OFBIZ_TARGET_DIR="$SCRIPT_DIR/../ofbiz/apache-ofbiz"

# Uncomment to download the official 18.12 release
# SOURCES_ZIP_URL="https://dlcdn.apache.org/ofbiz/apache-ofbiz-18.12.06.zip"
# SOURCES_ZIP_FILE="$SCRIPT_DIR/../ofbiz/apache-ofbiz-18.12.06.zip"

# Uncomment to download the release22.01 branch. Note that this is not an official release but
# is a snapshot of the OFBiz sources at the time of downloading.
SOURCES_ZIP_URL="https://github.com/apache/ofbiz-framework/archive/refs/heads/release22.01.zip"
SOURCES_ZIP_FILE="$SCRIPT_DIR/../ofbiz/release22.01.zip"

if [ -d "$OFBIZ_TARGET_DIR" ]; then
    echo "OFBiz sources already exist. Skipping download: $OFBIZ_TARGET_DIR"
    exit
fi

if [ ! -f "$SOURCES_ZIP_FILE" ]; then
    echo "Downloading OFBiz sources from $SOURCES_ZIP_URL"
    wget -O "$SOURCES_ZIP_FILE" "$SOURCES_ZIP_URL"
else 
    echo "OFBiz sources already exist. Skipping download: $SOURCES_ZIP_FILE"
fi

ZIP_TEMPDIR=$(mktemp -d "$SCRIPT_DIR/../ofbiz/ofbiz-sources-XXXXXXXXXXXX")
echo "Extracting OFBIZ sources to $ZIP_TEMPDIR"
unzip "$SOURCES_ZIP_FILE" -d "$ZIP_TEMPDIR"
ZIP_ROOT_DIR=$(zipinfo -1 "$SOURCES_ZIP_FILE" | head --lines=1)

echo "Moving OFBiz sources from $ZIP_TEMPDIR/$ZIP_ROOT_DIR to $OFBIZ_TARGET_DIR"
mv "$ZIP_TEMPDIR/$ZIP_ROOT_DIR" "$OFBIZ_TARGET_DIR"

echo "Removing temporary directory $ZIP_TEMPDIR"
rm -r "$ZIP_TEMPDIR"