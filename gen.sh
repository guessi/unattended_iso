#!/bin/bash

DIR="$(cd "$(dirname "${0}")" || exit; pwd)"
SOURCE_DIR="${DIR}/$(mktemp -d temp-srcXXXXX)"
OUTPUT_DIR="${DIR}/$(mktemp -d temp-dstXXXXX)"
ISO=$1

if [ $# -ne 1 ]; then
  echo "Usage: gen.sh <iso>"
  exit 1
fi

if [ ! -f "${ISO}" ]; then
  echo "${ISO}: No such file or directory"
  exit 1
fi

sudo -l -U $USER pwd >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "seems like you have no \"sudo\" ability, exiting"
  exit 1
fi

echo "SUDO permission is required"
echo "please input your password if required"
echo

SHA1SUM="$(sha1sum "${ISO}" | cut -d' ' -f1)"
if ! grep -q "${SHA1SUM}" SHA1SUMS; then
  echo "Input not supported, check SHA1SUMS for detail"
  exit 1
fi

LABEL="$(grep "${SHA1SUM}" SHA1SUMS | cut -d' ' -f3-)"

# cleanup old configures before run
echo "Cleanup previous workspaces"
sudo umount "$(awk '/iso9660/{print$2}' /proc/mounts)" 2>/dev/null || true
sudo rm -rf temp-*
mkdir -p "${SOURCE_DIR}" "${OUTPUT_DIR}"

# mount ISO image, and make a copy
echo "Preparing workspace"
sudo mount -o loop "${ISO}" "${SOURCE_DIR}" >/dev/null 2>&1 || exit 1
  pushd "${SOURCE_DIR}" >/dev/null 2>&1
    cp -a ./* "${OUTPUT_DIR}"
    cp -a ./.disk "${OUTPUT_DIR}"
    sync
    sleep 1
  popd >/dev/null 2>&1
sudo umount "$(awk '/iso9660/{print$2}' /proc/mounts)" 2>/dev/null || exit 1

# fix permission problem
echo "Fixing permission problem"
find "${OUTPUT_DIR}" -type d -exec chmod 0755 {} \;

# copy customized configure files to target directory
echo "Configuring settings"
cp -rf "${DIR}/conf/"* "${OUTPUT_DIR}"

# ubuntu-XXXXXX.iso
OUTPUT_FILE="${DIR}/$(basename -s ".iso" ${ISO})-$(date +%H%M%S).iso"

# generate customized ISO image file
echo "Generating output ISO image"
sudo mkisofs -r -V "${LABEL}" -cache-inodes -J -l -input-charset utf-8 \
        -no-emul-boot -boot-load-size 4 -boot-info-table \
        -b isolinux/isolinux.bin -c isolinux/boot.cat \
        -quiet -o "${OUTPUT_FILE}" "${OUTPUT_DIR}"

# make sure all data write/close
sync
sleep 1

# change owner:group after ISO is created
sudo chown $(id -u):$(id -g) "${OUTPUT_FILE}"
echo "All job completed"

# remove temporary directories
echo "Cleanup workspace"
rm -rf "${SOURCE_DIR}" "${OUTPUT_DIR}"

echo
echo "Output: $(basename ${OUTPUT_FILE})"
