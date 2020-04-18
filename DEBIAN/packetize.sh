#!/bin/bash

# ./packetize.sh -b BUILD_DIR -i INSTALL_DIR -p VENV_PACKAGE -o OUTPUT_PACKAGE -f PREFIX

while getopts "b:i:p:o:f:" o; do
    case "${o}" in
        b)
            bDir=${OPTARG}
            ;;
        i)
            iDir=${OPTARG}
            ;;
        p)
            venvPacket=${OPTARG}
            ;;
        o)
            outPacket=${OPTARG}
            ;;
        f)
            prefixPacket=${OPTARG}
            ;;
        *)
            echo "Error in input"
						exit 1
            ;;
    esac
done
shift $((OPTIND-1))

oldPwd=$(pwd)
# Move in build directory
cd ${bDir}
mkdir -p ${iDir}/
tar -xvf ${venvPacket} -C ${iDir}/
cp -rav src/* ${iDir}/
mkdir -p usr/share/doc/${prefixPacket}/
cp DEBIAN/copyright usr/share/doc/${prefixPacket}/
gzip -n9 DEBIAN/changelog
cp DEBIAN/changelog.gz usr/share/doc/${prefixPacket}/
binarySize=$(du -cs usr/ opt/ | tail -1 | cut -f1); replaceString="s/__BINARY_SIZE__/"$binarySize"/"; sed -i $replaceString DEBIAN/control
versionStr=$(cat VERSION); sed -i "s/__VERSION__/"${versionStr}"/" DEBIAN/control
fakeroot tar czf data.tar.gz opt/ usr/
cd DEBIAN; fakeroot tar czf ../control.tar.gz control
echo 2.0 > debian-binary
versionStr=$(cat VERSION);fakeroot ar r ${prefixPacket}-${versionStr}.deb debian-binary control.tar.gz data.tar.gz

# Return back to original directory
cd $oldPwd
mv ${bDir}/${prefixPacket}-$(cat VERSION).deb $outPacket
