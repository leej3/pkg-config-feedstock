#!/bin/sh

./configure --prefix=${PREFIX}    \
            --host=${HOST}        \
            --with-internal-glib

make
make install
