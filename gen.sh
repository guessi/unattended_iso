#!/bin/bash

DIR="$(cd "$(dirname "${0}")" || exit; pwd)"
SOURCE_DIR="${DIR}/source"
OUTPUT_DIR="${DIR}/output"
ISO=$1

# should have exactly 1 parameter
echo "* check user input"
if [ $# -ne 1 ]; then
  echo "ISO required, exited"
  exit 1
fi

# mount/mkisofs require root privilege
echo "* check root privilege"
if [ "$(whoami)" != "root" ]; then
  echo "root privilege required"
  exit 1
fi

# support listed versions only
FILENAME="$(basename "${ISO}")"
echo "* input filename: ${FILENAME}"
case "${FILENAME}" in
  ubuntu-12.04.5-server-amd64.iso)
    LABEL="Ubuntu-Server 12.04.5 LTS amd64"
    ;;
  precise-server-amd64.iso)
    LABEL="Ubuntu-Server 12.04 Daily amd64"
    ;;
  ubuntu-14.04.4-server-amd64.iso)
    LABEL="Ubuntu-Server 14.04.4 LTS amd64"
    ;;
  ubuntu-14.04.5-server-amd64.iso)
    LABEL="Ubuntu-Server 14.04.5 LTS amd64"
    ;;
  trusty-server-amd64.iso)
    LABEL="Ubuntu-Server 14.04 Daily amd64"
    ;;
  ubuntu-16.04-server-amd64.iso)
    LABEL="Ubuntu-Server 16.04 LTS amd64"
    ;;
  ubuntu-16.04.1-server-amd64.iso)
    LABEL="Ubuntu-Server 16.04.1 LTS amd64"
    ;;
  xenial-server-amd64.iso)
    LABEL="Ubuntu-Server 16.04 Daily amd64"
    ;;
  *)
    echo "sorry, not supported, exited"
    exit 1
    ;;
esac

# cleanup old configures before run
echo "* initialize source folder"
rm -rf "${SOURCE_DIR}" "${OUTPUT_DIR}"
mkdir -p "${SOURCE_DIR}" "${OUTPUT_DIR}"

# mount ISO image, and make a copy
mount -o loop "${ISO}" "${SOURCE_DIR}" >/dev/null 2>&1 || exit 1
  pushd "${SOURCE_DIR}" >/dev/null 2>&1
    cp -a ./* "${OUTPUT_DIR}"
    cp -a ./.disk "${OUTPUT_DIR}"
    sync
  popd >/dev/null 2>&1
umount "${SOURCE_DIR}" || exit 1

# bypass language selection menu
echo "en" > "${OUTPUT_DIR}/isolinux/lang"

# copy customized configure files to target directory
echo "* configure setup files"
cp -f "${DIR}/conf/preseed/ubuntu-server-raid1" \
    "${OUTPUT_DIR}/preseed/ubuntu-server-raid1"
cp -f "${DIR}/conf/preseed/ubuntu-server-simple" \
    "${OUTPUT_DIR}/preseed/ubuntu-server-simple"
cp -f "${DIR}/conf/install/cleanup" \
    "${OUTPUT_DIR}/install/cleanup"
cp -f "${DIR}/conf/isolinux/txt.cfg" \
    "${OUTPUT_DIR}/isolinux/txt.cfg"

# ubuntu-XXXXXX.iso
OUTPUT_FILE="$(basename -s ".iso" ${ISO})-$(date +%H%M%S).iso"
INPUT_DIR="output"

# generate customized ISO image file
echo "* generate iso image"
mkisofs -r -v -V "${LABEL}" -cache-inodes -J -l -input-charset utf-8 \
        -no-emul-boot -boot-load-size 4 -boot-info-table \
        -b isolinux/isolinux.bin -c isolinux/boot.cat \
        -quiet -o "${OUTPUT_FILE}" "${INPUT_DIR}"
sync

# change owner:group after ISO is created
echo "* ensure output file owner/group"
if [ ! -z "${SUDO_USER}" ]; then
  _UID=$(id -u "${SUDO_USER}")
  _GID=$(id -g "${SUDO_USER}")
  chown "${_UID}":"${_GID}" "${OUTPUT_FILE}"
fi

# ask user whether to delete temp folder or not
echo "* all done"
read -p "remove temporary folders? [y/N] " YESNO
if [ "${YESNO}" = "y" ] || [ "${YESNO}" = "yes" ]; then
  rm -rf "${SOURCE_DIR}" "${OUTPUT_DIR}"
fi

# normally exit
exit 0
