# docker-compose

## run app
```yml
version: "3.8"
services:
    vue-web:
        image: joewalker/vue-web
        restart: always
        ports:
            - "8080:80"
```
```bash
$ docker-compose up
```

## run with build
```yaml
version: "3.8"
services:
    vue-web:
        build:
            context: .
        restart: always
        ports:
            - "8080:80"
```
```bash
$ npm install -g @vue/cli
$ vue create web12

$ cat > Dockerfile <<EOF
FROM node:lts-alpine as builder
WORKDIR /app
COPY . .

RUN npm install && \
    npm run build

FROM nginx:alpine as release
COPY --from=builder /app/dist/. /usr/share/nginx/html/.
EOF

$ docker-compose build
$ docker images

# start with build
$ docker-compose up --build
```

# custom command
```Dockerfile
FROM node:lts-alpine as builder
WORKDIR /app
COPY . .

RUN npm install && \
    npm run build

FROM node:lts-alpine as release
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.9.0/wait /wait
RUN chmod +x /wait

WORKDIR /app
COPY --from=builder /app/dist/ .
RUN npm install --global serve
CMD [ "serve", "-d", "." ]
```
```yml
version: "3.8"
services:
    vue-web:
        build:
            context: .
            dockerfile: Dockerfile.NodeJs
        environment:
            - WAIT_HOSTS=postgres:5432
            - WAIT_HOSTS_TIMEOUT=300
            - WAIT_SLEEP_INTERVAL=2
            - WAIT_HOST_CONNECT_TIMEOUT=30
        ports:
            - "8080:80"
    
    postgres:
        image: postgres:9.4
        hostname: postgres
        environment:
            POSTGRES_USER: admin
            POSTGRES_PASSWORD: admin
        ports:
            - 5432
```

## Monitor serve
```yml
version: '3.7'

volumes:
    prometheus_data: {}
    grafana_data: {}

networks:
  front-tier:
  back-tier:

services:

  prometheus:
    image: prom/prometheus:v2.36.2
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.console.libraries=/usr/share/prometheus/console_libraries'
      - '--web.console.templates=/usr/share/prometheus/consoles'
    ports:
      - 9090:9090
    networks:
      - back-tier
    depends_on:
      - cadvisor
    restart: always

  grafana:
    image: grafana/grafana
    user: "472"
    depends_on:
      - prometheus
    ports:
      - 3000:3000
    volumes:
      - grafana_data:/var/lib/grafana
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=foobar
      - GF_USERS_ALLOW_SIGN_UP=false
    networks:
      - back-tier
      - front-tier
    restart: always

  node-exporter:
    image: quay.io/prometheus/node-exporter:latest
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
      - /:/host:ro,rslave
    command: |
      - '--path.rootfs=/host'
      - '--path.procfs=/host/proc' 
      - '--path.sysfs=/host/sys'
      - --collector.filesystem.ignored-mount-points
      - "^/(sys|proc|dev|host|etc|rootfs/var/lib/docker/containers
      |rootfs/var/lib/docker/overlay2|rootfs/run/docker/netns|rootfs/var/lib/docker/aufs)($$|/)"
    ports:
      - 9100:9100
    networks:
      - back-tier
    restart: always

  cadvisor:
    image: gcr.io/cadvisor/cadvisor
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:rw
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
    ports:
      - 8080:8080
    networks:
      - back-tier
    restart: always
```
```yml
# my global config
global:
  scrape_interval: 15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.

alerting:
  alertmanagers:
    - static_configs:
        - targets:
          # - alertmanager:9093

rule_files:

scrape_configs:
  - job_name: "prometheus"

    static_configs:
      - targets: ["localhost:9090", "cadvisor:8080", "node-exporter:9100"]
```