# Dockerfile

## Build hello image
Dockerfile
```Dockerfile
FROM alpine
COPY hello /
CMD [ "/hello" ]
```

instruction
```bash
$ cat > hello <<EOF
echo "Hello Docker!"
EOF

$ chmod +x hello

$ cat > Dockerfile <<EOF
FROM alpine
COPY hello /
CMD [ "/hello" ]
EOF

$ docker build -t joewalker/hello .
$ docker images
$ docker run --rm joewalker/hello
```

## Build with --build-arg
```bash
$ cat > Dockerfile <<EOF
FROM alpine
ARG APP_NAME
RUN echo ${APP_NAME} > note.txt
EOF

$ docker build --build-arg APP_NAME="joewalker" joewalker/arg .

# test
$ docker run --rm joewalker/arg sh -c 'cat note.txt'
```

## Build with defalt value
```Dockerfile
FROM alpine
ARG APP_NAME="payment api"
RUN echo ${APP_NAME} > note.txt
```

command instruction
```bash
$ docker build -t joewalker/arg .
$ docker run --rm joewalker/arg sh -c 'cat note.txt'
```
## workshop: env
```Dockerfile
FROM alpine
ENV MY_NAME="John Doe"
ENV MY_DOG=Rex\ The\ Dog
ENV MY_CAT=fluffy

ENV MY_NAME="John Doe" MY_DOG=Rex\ The\ Dog \
    MY_CAT=fluffy
```

command instruction
```bash
$ docker build -t joewalker/env .
$ docker run --rm -it joewalker/env /bin/sh
$ echo $MY_NAME
$ echo $MY_DOG
$ echo $MY_CAT
```
## Label
```Dockerfile
FROM alpine

LABEL "com.example.vendor"="ACME Incorporated"
LABEL com.example.label-with-value="foo"
LABEL version="1.0"
LABEL description="This text illustrates \
that label-values can span multiple lines."

LABEL multi.label1="value1" multi.label2="value2" other="value3"

LABEL multi.label1="value1" \
      multi.label2="value2" \
      other="value3"
```
command instruction
```bash
$ docker build -t joewalker/label .
$ docker image inspect --format '{{json .Config.Labels}}' joewalker/label | jq
```

## work directory
``` bash
$ cat > Dockerfile <<EOF
FROM alpine
WORKDIR /a
WORKDIR /b
WORKDIR /c
EOF

$ docker build -t joewalker/workdir .
$ docker run --rm -it joewalker/workdir /bin/sh
$ cd ..
$ ls -la
```

## entrypoint
```bash
# require libs
$ apk update
$ apk add nodejs npm
$ npm i -g create-react-app

# create project
$ create-react-app web1
$ cd web1
$ npm run build

# create Dockerfile
$ cat > Dockerfile <<EOF
FROM node
WORKDIR /app
COPY build .

RUN npm install --global serve
ENTRYPOINT [ "serve" ]
CMD [ "-d", "." ]
EOF

# build image
$ docker build -t web1 .
$ docker run -rm -p 8080:3000 web1

$ docker run --rm -it web1 /bin/bash
$ docker run --rm -it --entrypoint=/bin/bash web1
```
# build react web using nginx
```bash
$ create-react-app web1
$ cd web1
$ cat > Dockerfile <<EOF
FROM node:lts-alpine as builder
WORKDIR /app
COPY . .

RUN npm install && \
    npm run build

FROM nginx:alpine as release
COPY --from=builder /app/build/. /usr/share/nginx/html/.
EOF

$ docker build -t joewalker/web1 .
$ docker run --rm -p 8080:80 joewalker/web1
```
```bash
$ cat > Dockerfile <<EOF
FROM node:lts-alpine as builder
WORKDIR /app
COPY . .

RUN npm install && \
    npm run build

FROM node:lts-alpine as release
WORKDIR /app
COPY --from=builder /app/build/ .
RUN npm install --global serve
CMD [ "serve", "-d", "." ]
EOF

$ docker build -t joewalker/web1 .
$ docker run --rm -p 8080:80 joewalker/web1
```


