# Workshop: CUP Configure
```bash
# run monitoring tools
docker run \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:ro \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --volume=/dev/disk/:/dev/disk:ro \
  --publish=8080:8080 \
  --detach=true \
  --name=cadvisor \
  --privileged \
  --device=/dev/kmsg \
  gcr.io/cadvisor/cadvisor

  # start container 1
  $ docker run -d \
  --name="share_30" \
  --cpuset-cpus=0 \
  --cpu-shares=30 \
  busybox md5sum /dev/urandom

  # start container 2
   $ docker run -d \
  --name="share_70" \
  --cpuset-cpus=0 \
  --cpu-shares=70 \
  busybox md5sum /dev/urandom
```