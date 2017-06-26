#!/bin/sh

./configure --prefix=${PREFIX}   \
            --with-internal-glib

make
make install
