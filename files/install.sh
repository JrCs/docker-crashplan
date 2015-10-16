#!/bin/bash

set -e

dnf install -y \
	which procps findutils hostname \
    expect wget tar cpio

mkdir /tmp/crashplan

wget -O- http://download.code42.com/installs/linux/install/CrashPlan/CrashPlan_${CRASHPLAN_VERSION}_Linux.tgz \
	| tar -xz --strip-components=1 -C /tmp/crashplan

cd /tmp/crashplan && chmod +x /tmp/installation/crashplan.exp && /tmp/installation/crashplan.exp || exit $?
cd / && rm -rf /tmp/crashplan

#/usr/local/crashplan/bin/CrashPlanEngine start && sleep 2 && \
#    /usr/local/crashplan/bin/CrashPlanEngine stop


# Disable auto update
chmod -R -x /usr/local/crashplan/upgrade/

# Bind the UI port 4243 to the container ip
sed -i "s|</servicePeerConfig>|</servicePeerConfig>\n\t<serviceUIConfig>\n\t\t\
       <serviceHost>0.0.0.0</serviceHost>\n\t\t<servicePort>4243</servicePort>\n\t\t\
       <connectCheck>0</connectCheck>\n\t\t<showFullFilePath>false</showFullFilePath>\n\t\
 </serviceUIConfig>|g" /usr/local/crashplan/conf/default.service.xml

dnf remove -y expect wget tar cpio
dnf clean all

# Install launcher
mv /tmp/installation/crashplan.sh /root/crashplan.sh
chmod +rx /root/crashplan.sh

# Remove unneccessary directories
rm -rf /boot /home /lost+found /media /mnt /opt /run /srv
rm -rf /usr/local/crashplan/log
rm -rf /var/cache/dnf
