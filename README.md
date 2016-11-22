[![](https://img.shields.io/docker/stars/jrcs/crashplan.svg)](https://hub.docker.com/r/jrcs/crashplan 'DockerHub') [![](https://img.shields.io/docker/pulls/jrcs/crashplan.svg)](https://hub.docker.com/r/jrcs/crashplan 'DockerHub')
[![](https://badge.imagelayers.io/jrcs/crashplan:latest.svg)](https://imagelayers.io/?images=jrcs/crashplan:latest 'Get your own badge on imagelayers.io')
# docker-crashplan
Lightweight (169MB) [Crashplan](http://www.crashplan.com) docker container.

## Features:
* Automatic version upgrade
* Access to all configuration files
* Access to log files

# Quick Start

- Launch the crashplan container

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

## Access the GUI from your desktop crashplan application
- Make a backup of the current `.ui_info` file of your desktop machine locate:
  * On Linux: `/var/crashplan/data/id/.ui_info`
  * On OSX: `/Library/Application Support/CrashPlan/.ui_info`
  * On Windows: `C:\ProgramData\CrashPlan\.ui_info`
- Replace your `.ui_info` file of your desktop machine with the one of the crashplan container: `/srv/crashplan/data/id/.ui_info`.
- In the `.ui_info` file of your desktop machine, replace the IP (should be `0.0.0.0` or `127.0.0.1`) with the IP of your docker host.
- Make sure you can connect to ports 4242 and 4243 on your docker host.
- Start your local CrashPlan GUI.

# Configuration  

## Volumes:
* `/var/crashplan`: where the configuration files and logs are store
* `/storage`: where backup files are store

## Optional environment variables:
* `PUBLIC_IP`and `PUBLIC_PORT`: force the public ip address and port to use.
* `TZ`: time zone to use in the crashplan logs.
