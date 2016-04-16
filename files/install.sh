#!/bin/sh

set -e

install_deps='expect sed'
apk add --update bash wget ca-certificates openssl findutils coreutils procps $install_deps
apk add cpio --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/

# Add glibc
wget -q -O /etc/apk/keys/andyshinn.rsa.pub https://raw.githubusercontent.com/andyshinn/alpine-pkg-glibc/master/andyshinn.rsa.pub
wget https://github.com/andyshinn/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk
# Add glibc-bin
wget https://github.com/andyshinn/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk
# Add glibc-i18n
wget https://github.com/andyshinn/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-i18n-${GLIBC_VERSION}.apk

# Install all glibc packages
apk add glibc-*${GLIBC_VERSION}.apk && rm glibc-*${GLIBC_VERSION}.apk

# Generate en_US.UTF-8 locale
/usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8
# Remove unneccessary package
apk del glibc-i18n

mkdir /tmp/crashplan

wget -O- http://download.code42.com/installs/linux/install/CrashPlan/CrashPlan_${CRASHPLAN_VERSION}_Linux.tgz \
    | tar -xz --strip-components=1 -C /tmp/crashplan

cd /tmp/crashplan && chmod +x /tmp/installation/crashplan.exp && sync && /tmp/installation/crashplan.exp || exit $?
cd / && rm -rf /tmp/crashplan

# Bind the UI port 4243 to the container ip
sed -i "s|</servicePeerConfig>|</servicePeerConfig>\n\t<serviceUIConfig>\n\t\t\
<serviceHost>0.0.0.0</serviceHost>\n\t\t<servicePort>4243</servicePort>\n\t\t\
<connectCheck>0</connectCheck>\n\t\t<showFullFilePath>false</showFullFilePath>\n\t\
</serviceUIConfig>|g" /usr/local/crashplan/conf/default.service.xml

# Install launchers
cp /tmp/installation/entrypoint.sh /tmp/installation/crashplan.sh /
chmod +rx /entrypoint.sh /crashplan.sh

# Remove unneccessary package
apk del $install_deps

# Remove unneccessary files and directories
rm -rf /usr/local/crashplan/jre/lib/plugin.jar \
    /usr/local/crashplan/jre/lib/ext/jfxrt.jar \
    /usr/local/crashplan/jre/bin/javaws \
    /usr/local/crashplan/jre/lib/javaws.jar \
    /usr/local/crashplan/jre/lib/desktop \
    /usr/local/crashplan/jre/plugin \
    /usr/local/crashplan/jre/lib/deploy* \
    /usr/local/crashplan/jre/lib/*javafx* \
    /usr/local/crashplan/jre/lib/*jfx* \
    /usr/local/crashplan/jre/lib/amd64/libdecora_sse.so \
    /usr/local/crashplan/jre/lib/amd64/libprism_*.so \
    /usr/local/crashplan/jre/lib/amd64/libfxplugins.so \
    /usr/local/crashplan/jre/lib/amd64/libglass.so \
    /usr/local/crashplan/jre/lib/amd64/libgstreamer-lite.so \
    /usr/local/crashplan/jre/lib/amd64/libjavafx*.so \
    /usr/local/crashplan/jre/lib/amd64/libjfx*.so

rm -rf /boot /home /lost+found /media /mnt /run /srv
rm -rf /usr/local/crashplan/log
rm -rf /var/cache/apk/*
