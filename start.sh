sudo docker run -d \
  --name crashplan2 \
  --restart="always" \
  -h $HOSTNAME \
  -e TZ=Pacific/Auckland \
  --publish 4242:4242 --publish 4243:4243 \
  --volume /mnt/data/docker/data/crashplan2/data:/var/crashplan \
  --volume /mnt/data:/storage \
  jrcs/crashplan:latest
