#!/bin/sh

if [ -z "${DEV_ESP}" ]; then
    echo "Usage: DEV_ESP=/dev/<device_name> ${0}"
    exit 1
fi

# Setup vars
ROOT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
BUILD_DIR="${ROOT_DIR}/build/ontarget"
SOURCE_DIR="${ROOT_DIR}/bt_gamepad"
IFACE="--device ${DEV_ESP}:/dev/esp"

# # Kill docker on exit
# stop() {
#     docker kill IDF-GDB
# }
# trap stop INT EXIT

echo ${ROOT_DIR}
echo ${SOURCE_DIR}
echo ${BUILD_DIR}

# Launch flash
docker run --rm -it \
    ${IFACE} \
    --user "$(id -u)":"$(id -g)" \
    --volume "${SOURCE_DIR}":"${SOURCE_DIR}":ro \
    --volume "${BUILD_DIR}":"${BUILD_DIR}" \
    --workdir  "${SOURCE_DIR}" \
    espressif/idf \
    idf.py --port "/dev/esp" --no-ccache --project-dir "${SOURCE_DIR}" --build-dir "${BUILD_DIR}" flash
