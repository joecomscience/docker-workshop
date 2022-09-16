# Network

## create new network bridge
```bash
$ docker network create -d bridge custom_bridge

# list network
$ docker network ls
```

## Container With Difference Network (bridge)
create web1
```bash
# run container with custom_bridge network
$ docker run -d --name web1 --network custom_bridge nginx

# inspect network
$ docker inspect --format '{{json .NetworkSettings.Networks}}' web1 | jq
```
create web2
```bash
# run container with default network
$ docker run -d --name web2 nginx

# inspect network
$ docker inspect --format '{{json .NetworkSettings.Networks}}' web2 | jq
```

test connection
```bash
$ docker exec -it web2 /bin/bash
$ apt update
$ apt install -y jq iputils-ping
$ ping -c 4 172.19.0.2
```

add container to network
```bash
$ docker network connect custom_bridge web2
$ docker inspect --format '{{json .NetworkSettings.Networks}}' web2 | jq
```

test connection again
```bash
$ docker exec -it web2 /bin/bash
$ ping -c 4 172.19.0.2
```

## Macvlan
```bash
# create macvlan network
docker network create -d macvlan \
--subnet=192.168.1.0/24 \
--gateway=192.168.1.1 \
-o parent=en1 pubnet

# create container
$ docker run -d --name web1 --net pub_net alpine sh -c 'tail -f /dev/null'
$ docker run -d --name web2 --net pub_net alpine sh -c 'tail -f /dev/null'
$ docker run -d --name web3 --net pub_net alpine sh -c 'tail -f /dev/null'

# test connection
$ docker exec -it web1 sh -c 'ping -c 4 web2'
$ docker exec -it web1 sh -c 'ping -c 4 web3'

$ docker exec -it web2 sh -c 'ping -c 4 web1'
$ docker exec -it web2 sh -c 'ping -c 4 web3'
```