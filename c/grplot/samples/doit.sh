#!/bin/sh

BASE_DIR=`dirname $0`
BASE_DIR_ABS=`realpath ${BASE_DIR}`
GRPLOT_DIR=`dirname ${BASE_DIR_ABS}`
WORK_DIR="${BASE_DIR_ABS}/$1"
GRPLOT_BIN="${GRPLOT_DIR}/grplot"

grplot() {
   "$GRPLOT_BIN" $@
}

cd "${WORK_DIR}"
python -m charts | grplot -T "${BASE_DIR_ABS}/knuff" -s schema.json -o "${GRPLOT_DIR}/output.png"
