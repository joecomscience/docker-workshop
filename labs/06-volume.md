# Volume
```bash
# create volume
$ docker volume create my_volume

# list volumes
$ docker volums ls

# inspect
$ docker inspect my_volume
```

## bind mount
```bash
$ docker volume create vol1
$ docker run -d --name web1 -v vol1:/app nginx
$ docker inspect web1 --format '{{.json .Mounts}}' | jq
```
```bash
$ docker volume create vol2
$ docker run -d --name web1 --mount source=vol2,target=/app nginx
$ docker inspect web1 --format '{{.json .Mounts}}' | jq
```
```bash
$ create-react-app my_website
$ cd my_website
$ npm run build
$ docker run -d --name my_website \
-p 8080:80 \
-v $(pwd)/build/.:/usr/share/nginx/html/. nginx

# edit src/App.js
# run build again
$ npm run build
```
