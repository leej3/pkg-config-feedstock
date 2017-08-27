#!/bin/sh

./configure --prefix=${PREFIX}    \
            --host=${HOST}        \
            --with-internal-glib

make -j${CPU_COUNT} ${VERBOSE_AT}
make install
