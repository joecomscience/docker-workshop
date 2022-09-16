# Workshop: Run frontend app with ReactJS
```bash
$ apk update
$ apk add nodejs npm

$ node -v
$ npm -v

$ npm install -g create-react-app

# create new project
$ npx create-react-app my_app
$ cd my_app
$ npm run build

# copy build directory to nginx
$ docker cp ./build/. nginx:/usr/share/nginx/html/.

# remote to container
$ docker exec -it nginx /bin/bash
$ cd /usr/share/nginx/html
$ ls -l

$ exit
```