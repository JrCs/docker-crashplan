[![](https://img.shields.io/docker/stars/jrcs/crashplan.svg)](https://hub.docker.com/r/jrcs/crashplan 'DockerHub') [![](https://img.shields.io/docker/pulls/jrcs/crashplan.svg)](https://hub.docker.com/r/jrcs/crashplan 'DockerHub')
[![](https://badge.imagelayers.io/jrcs/crashplan:latest.svg)](https://imagelayers.io/?images=jrcs/crashplan:latest 'Get your own badge on imagelayers.io')
# docker-crashplan
Lightweight (169MB) [Crashplan](http://www.crashplan.com) docker container.

## Features:
* Automatic version upgrade
* Access to all configuration files
* Access to log files

# Quick Start

Launch the crashplan container

```bash
docker run -d \
  --name crashplan \
  -h $HOSTNAME \
  -e TZ \
  --publish 4242:4242 --publish 4243:4243 \
  --volume /srv/crashplan/data:/var/crashplan \
  --volume /srv/crashplan/storage:/storage \
  jrcs/crashplan:latest
```

# Configuration  

## Volumes:
* `/var/crashplan`: where the configuration files and logs are store
* `/storage`: where backup files are store

## Environment variables
You can force the public ip address and port to use with the `PUBLIC_IP`and `PUBLIC_PORT` environment variables.
