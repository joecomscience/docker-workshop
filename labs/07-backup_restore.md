# Backup & Restore
## backup data
```bash
$ docker run -d --name web1 nginx

# backup
$ docker exec -it web1 /bin/bash
$ cd /usr/share/nginx
$ tar cvf html_files.tar ./html/
$ exit

# copy file from container to host
$ docker cp web1:/usr/share/nginx/html_files.tar .
```

## restore
```bash
$ docker run -d --name web1 nginx 
$ docker cp ./html_files.tar web2:/usr/share/nginx

$ docker exec -it web2 /bin/bash
$ cd /usr/share/nginx
$ rm -rf html

$ tar xvzf html_files.tar ./html/
$ exit
```

## commit
```bash
$ docker run -d --name web1 nginx 
$ docker exec -it web1 /bin/bash
$ cd /usr/share/nginx/html
$ sed -i 's/nginx!/Lisa/g' index.html
$ exit

$ docker commit web custom_nginx
$ docker images

$ docker stop web1

$ docker run -d --name web2 -p 8080:80 custom_nginx
```

## save, load, run
```bash
$ docker images
$ docker save -o custom_nginx.tar custom_nginx
$ ls -l

# transfer file to another host using ssh
$ docker images
$ docker load -i custom_nginx.tar
$ docker images
$ docker run -d --name web1 -p 8080:80 custom_nginx
```