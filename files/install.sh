#!/bin/sh

set -e

# Determine Crashplan Service Level to install (home or business)
if [ "$CRASHPLAN_SERVICE" = "PRO" ]; then
    SVC_LEVEL="CrashPlanPRO"
else
    SVC_LEVEL="CrashPlan"
fi

install_deps='expect sed'
apk add --update bash wget ca-certificates openssl findutils coreutils procps $install_deps
apk add cpio --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/community/

mkdir /tmp/crashplan

wget -O- http://download.code42.com/installs/linux/install/${SVC_LEVEL}/${SVC_LEVEL}_${CRASHPLAN_VERSION}_Linux.tgz \
    | tar -xz --strip-components=1 -C /tmp/crashplan


mkdir -p /usr/share/applications
cd /tmp/crashplan && chmod +x /tmp/installation/crashplan.exp && sync && /tmp/installation/crashplan.exp || exit $?
cd / && rm -rf /tmp/crashplan
rm -rf /usr/share/applications

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
