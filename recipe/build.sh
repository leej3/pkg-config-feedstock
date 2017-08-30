#!/bin/sh

./configure --prefix=${PREFIX}    \
            --host=${HOST}        \
            --with-internal-glib

make -j${CPU_COUNT} ${VERBOSE_AT}
make install

# conda customization for CDT packages, emitted for other OSes too incase of cross-compilation
mv ${PREFIX}/bin/pkg-config ${PREFIX}/bin/pkg-config.bin
# TODO :: Turn this into an executable instead of a shell script so that it can be used on Windows too.
echo '#!/usr/bin/env sh'                                                                                                                                 > ${PREFIX}/bin/pkg-config
echo ""                                                                                                                                                 >> ${PREFIX}/bin/pkg-config
echo "# conda customization for CDT packages; are we targeting Linux with a cross compiler?"                                                            >> ${PREFIX}/bin/pkg-config
echo "if [[ \${HOST} =~ .*linux.* ]] && [[ \$(basename \${CC}) =~ .*-.*-.* ]]; then"                                                                    >> ${PREFIX}/bin/pkg-config
echo "  if [[ \${HOST} =~ .*x86_64.* ]]; then"                                                                                                          >> ${PREFIX}/bin/pkg-config
echo "    SRLIBDIR=lib64"                                                                                                                               >> ${PREFIX}/bin/pkg-config
echo "  else"                                                                                                                                           >> ${PREFIX}/bin/pkg-config
echo "    SRLIBDIR=lib"                                                                                                                                 >> ${PREFIX}/bin/pkg-config
echo "  fi"                                                                                                                                             >> ${PREFIX}/bin/pkg-config
echo "  if [[ \${CONDA_BUILD_PKG_CONFIG_LOG} == yes ]]; then"                                                                                           >> ${PREFIX}/bin/pkg-config
echo "    echo \"Calling: PKG_CONFIG_PATH=\$(\${CC} -print-sysroot)/usr/share/pkgconfig:\$(\${CC} -print-sysroot)/usr/\${SRLIBDIR}/pkgconfig \\"        >> ${PREFIX}/bin/pkg-config
echo "      \${PREFIX}/bin/pkg-config.bin --define-prefix --debug \"\$@\" > /tmp/pkg-config-\$$.log\""                                                  >> ${PREFIX}/bin/pkg-config
echo "    PKG_CONFIG_PATH=\$(\${CC} -print-sysroot)/usr/share/pkgconfig:\$(\${CC} -print-sysroot)/usr/\${SRLIBDIR}/pkgconfig \\"                        >> ${PREFIX}/bin/pkg-config
echo "      \${PREFIX}/bin/pkg-config.bin --define-prefix --debug \"\$@\" >> /tmp/pkg-config-\$$.log 2>&1 || true"                                      >> ${PREFIX}/bin/pkg-config
echo "  fi"                                                                                                                                             >> ${PREFIX}/bin/pkg-config
echo "  PKG_CONFIG_PATH=\$(\${CC} -print-sysroot)/usr/share/pkgconfig:\$(\${CC} -print-sysroot)/usr/\${SRLIBDIR}/pkgconfig \\"                          >> ${PREFIX}/bin/pkg-config
echo "    \${PREFIX}/bin/pkg-config.bin --define-prefix \"\$@\""                                                                                        >> ${PREFIX}/bin/pkg-config
echo "else"                                                                                                                                             >> ${PREFIX}/bin/pkg-config
echo "  \${PREFIX}/bin/pkg-config.bin \"\$@\""                                                                                                          >> ${PREFIX}/bin/pkg-config
echo "fi"                                                                                                                                               >> ${PREFIX}/bin/pkg-config

chmod +x ${PREFIX}/bin/pkg-config
