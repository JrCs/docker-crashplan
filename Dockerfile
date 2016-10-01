FROM frolvlad/alpine-glibc:alpine-3.4

#########################################
##        ENVIRONMENTAL CONFIG         ##
#########################################
# Set correct environment variables
ENV CRASHPLAN_VERSION=4.8.0 \
    CRASHPLAN_SERVICE=HOME  \
    LC_ALL=C.UTF-8          \
    LANG=C.UTF-8            \
    LANGUAGE=C.UTF-8

#########################################
##         RUN INSTALL SCRIPT          ##
#########################################
ADD /files /tmp/installation

# Increase max file watches
# ADD /files/installation/60-max-user-watches.conf /etc/sysctl.d/60-max-user-watches.conf

RUN chmod +x /tmp/installation/install.sh && sync && /tmp/installation/install.sh && rm -rf /tmp/installation

#########################################
##              VOLUMES                ##
#########################################
VOLUME [ "/var/crashplan", "/storage" ]

#########################################
##            EXPOSE PORTS             ##
#########################################
EXPOSE 4243 4242

WORKDIR /usr/local/crashplan

ENTRYPOINT ["/entrypoint.sh"]
CMD [ "/crashplan.sh" ]
