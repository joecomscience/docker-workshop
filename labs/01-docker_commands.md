# Docker command-line
## Pull image
```bash
$ docker pull node
```

## Login to docker hub
command: `docker login <url>`  
example:
```bash
$ docker login 127.0.0.1:500 -u admin -p admin_pass -e admin@email.com
$ docker login 10.38.7.248:8080
$ docker login 10.38.7.248:8080 -u admin
```

run:
```bash
$ docker login

Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username: joewalker
Password:
Login Succeeded

Logging in with your password grants your terminal complete access to your account.
For better security, log in with a limited-privilege personal access token. Learn more at https://docs.docker.com/go/access-tokens/
```

## Push image
Tag image with latest version then list all images
```bash
$ docker tag python joewalker/python:latest
$ docker imgaes

REPOSITORY                   TAG              IMAGE ID       CREATED        SIZE
python                       latest           d6763a4bf8a0   6 weeks ago    868MB

$ docker push joewalker/python
```

## Save image
command:  
1. `docker save -o [file_name].tar [image_name]:[version]`  
    ex. `docker save -o python.tar python:3.7.1`  
    ex. `docker save ---output python.tar python:3.7.1`  
    ex. `docker save ---output python.tar python:3.7.1 python`  
2. `docker save [image_name]:[version] > [file_name].tar`  
    ex. `docker save python > python.tar` 

```bash
$ docker save -o python.tar python

# list file
$ ls | grep *.tar

python.tar
```

## Load image from archive file
```bash
# remove image
# command: docker rmi [image_name/image_id]
$ docker rmi python

# load python image from file
# command:
# 1. docker load -i [file_name].tar
#    ex. docker load -i python.tar
#    ex. docker load --input python.tar
# 2. docker load < [file_name].tar
#    ex. docker load < python.tar
$ docker load -i python.tar

# list image
$ docker images

REPOSITORY                   TAG              IMAGE ID       CREATED        SIZE
python                       latest           d6763a4bf8a0   6 weeks ago    868MB
```

## Tag image
```bash
# command:
# docker tag [source_image_name] [account]/[destination_image_name]:[version]
$ docker tag python:3.7.6 joewalker/python:3.7.6

# list images
$ docker images

# push image to docker registry
$ docker push joewalker/3.7.6
```

## Inspect changes to file or directory
```bash
$ docker diff nginx
```

## Container performance/port
```bash
$ docker port nginx
$ docker stats nginx
$ docker top nginx
```

## Change container name on-the-fly
```bash
$ docker ps

# change container name
$ docker rename 342323wsdfe nginx

$ docker ps
```