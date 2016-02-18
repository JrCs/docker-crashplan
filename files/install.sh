#!/bin/sh

set -e

apk update
apk add bash wget ca-certificates tar expect findutils coreutils procps
apk add cpio --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/

# Generate en_US.UTF-8 locale
wget https://github.com/andyshinn/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-i18n-${GLIBC_VERSION}.apk
apk --allow-untrusted add glibc-i18n-${GLIBC_VERSION}.apk
/usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8
apk del glibc-i18n
rm glibc-i18n-${GLIBC_VERSION}.apk

mkdir /tmp/crashplan

wget -O- http://download.code42.com/installs/linux/install/CrashPlan/CrashPlan_${CRASHPLAN_VERSION}_Linux.tgz \
	| tar -xz --strip-components=1 -C /tmp/crashplan

cd /tmp/crashplan && chmod +x /tmp/installation/crashplan.exp && /tmp/installation/crashplan.exp || exit $?
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
apk del wget ca-certificates expect

# Remove unneccessary directories
rm -rf /boot /home /lost+found /media /mnt /run /srv
rm -rf /usr/local/crashplan/log
rm -rf /var/cache/apk/*
