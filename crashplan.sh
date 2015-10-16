#!/bin/bash

docker run -d -h ${HOSTNAME} \
	--name=crashplan \
	-v /data/crashplan/data:/data \
	-v /backups:/storage \
	-v /etc/localtime:/etc/localtime:ro \
	-p 0.0.0.0:4242:4242 -p 0.0.0.0:4243:4243 \
	crashplan
