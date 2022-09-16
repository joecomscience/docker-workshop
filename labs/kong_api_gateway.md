# Setup Kong API Gateway

### start kong api gateway
```bash
$ docker network create kong-net
```

### start database
```bash
$ docker run -d --name kong-database \
  --network=kong-net \
  -p 5432:5432 \
  -e "POSTGRES_USER=kong" \
  -e "POSTGRES_DB=kong" \
  -e "POSTGRES_PASSWORD=kongpass" \
  postgres:9.6
```

### prepare kong db
```bash
$ docker run --rm --network=kong-net \
  -e "KONG_DATABASE=postgres" \
  -e "KONG_PG_HOST=kong-database" \
  -e "KONG_PG_PASSWORD=kongpass" \
  -e "KONG_PASSWORD=test" \
 kong/kong-gateway:3.0.0.0-alpine kong migrations bootstrap
```

### start kong
```bash
$ docker run -d --name kong-gateway \
  --network=kong-net \
  -e "KONG_DATABASE=postgres" \
  -e "KONG_PG_HOST=kong-database" \
  -e "KONG_PG_USER=kong" \
  -e "KONG_PG_PASSWORD=kongpass" \
  -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
  -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
  -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
  -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
  -e "KONG_ADMIN_LISTEN=0.0.0.0:8001" \
  -e "KONG_ADMIN_GUI_URL=http://localhost:8002" \
  -e KONG_LICENSE_DATA \
  -p 8000:8000 \
  -p 8001:8001 \
  -p 8002:8002 \
  -p 8003:8003 \
  -p 8004:8004 \
  kong/kong-gateway:3.0.0.0-alpine
```

### verify installation
```bash
curl -i -X GET --url http://localhost:8001/services
```

result
```text
HTTP/1.1 200 OK
Date: Thu, 15 Sep 2022 14:41:09 GMT
Content-Type: application/json; charset=utf-8
Connection: keep-alive
Access-Control-Allow-Origin: http://localhost:8002
X-Kong-Admin-Request-ID: x0QXYSDzk9Z4gVTGffNjU5bA4ywT0lq2
vary: Origin
Access-Control-Allow-Credentials: true
Content-Length: 23
X-Kong-Admin-Latency: 173
Server: kong/3.0.0.0-enterprise-edition

{"data":[],"next":null}⏎
```

# Start Konga
```bash
$ docker run -p 1337:1337 \
    --network kong-net \
    -e "TOKEN_SECRET=konga_secret" \
    -e "DB_ADAPTER=postgres" \
    -e "DB_HOST=kong-database" \
    -e "DB_PORT=5432" \
    -e "DB_USER=kong" \
    -e "DB_PASSWORD=kongpass" \
    -e "DB_DATABASE=kong" \
    --name konga \
    pantsel/konga
```

# Run Backend App
```bash
$ docker run -d --network kong-net --name backend_1 joewalker/basic-web-server
$ docker run -d --network kong-net --name backend_2 joewalker/basic-web-server
$ docker run -d --network kong-net --name backend_3 joewalker/basic-web-server
```

# Test rate-limit
```bash
# call 1
$ curl -i  localhost:8000/v1/backend

# call 2
$ curl -i  localhost:8000/v1/backend

HTTP/1.1 429 Too Many Requests
Date: Thu, 15 Sep 2022 17:00:30 GMT
Content-Type: application/json; charset=utf-8
Connection: keep-alive
RateLimit-Remaining: 0
RateLimit-Limit: 1
RateLimit-Reset: 30
X-RateLimit-Limit-Minute: 1
Retry-After: 30
X-RateLimit-Remaining-Minute: 0
Content-Length: 41
X-Kong-Response-Latency: 4
Server: kong/3.0.0.0-enterprise-edition

{
  "message":"API rate limit exceeded"
}
```

# Test basic auth
## Method 1
```bash
# call 1
$ curl -i  localhost:8000/v2/backend

HTTP/1.1 401 Unauthorized
Date: Thu, 15 Sep 2022 17:08:12 GMT
Content-Type: application/json; charset=utf-8
Connection: keep-alive
WWW-Authenticate: Basic realm="kong"
Content-Length: 26
X-Kong-Response-Latency: 10
Server: kong/3.0.0.0-enterprise-edition

{"message":"Unauthorized"}⏎

# call 2
$ curl -i --user admin:admin  localhost:8000/v2/backend

HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8
Content-Length: 130
Connection: keep-alive
X-Powered-By: Express
ETag: W/"82-23J+YvwcIIcL/DpX90P1RpgQang"
Date: Thu, 15 Sep 2022 17:10:56 GMT
X-Kong-Upstream-Latency: 27
X-Kong-Proxy-Latency: 10
Via: kong/3.0.0.0-enterprise-edition

{"address":"172.18.0.6","netmask":"255.255.0.0","family":"IPv4","mac":"02:42:ac:12:00:06","internal":false,"cidr":"172.18.0.6/16"}
```
## Method 2
```bash
$ echo admin:admin | base64

$ curl -H 'Authorization: Basic {user_base64}' localhost:8000/v2/backend
```

# Test API Key
```bash
# call 1
$ curl -i localhost:8000/v3/backend

HTTP/1.1 401 Unauthorized
Date: Fri, 16 Sep 2022 02:46:45 GMT
Content-Type: application/json; charset=utf-8
Connection: keep-alive
WWW-Authenticate: Key realm="kong"
Content-Length: 45
X-Kong-Response-Latency: 14
Server: kong/3.0.0.0-enterprise-edition

{
  "message":"No API key found in request"
}⏎

# call 2
$ curl -i -H 'API-KEY: b139ee0a-ab6b-4af0-9f22-313065bd9025' http://localhost:8000/v3/backend

HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8
Content-Length: 130
Connection: keep-alive
X-Powered-By: Express
ETag: W/"82-BItzIIkCPSj0QCc0Pb5HNNxWxRY"
Date: Fri, 16 Sep 2022 02:48:47 GMT
X-Kong-Upstream-Latency: 36
X-Kong-Proxy-Latency: 21
Via: kong/3.0.0.0-enterprise-edition

{"address":"172.18.0.7","netmask":"255.255.0.0","family":"IPv4","mac":"02:42:ac:12:00:07","internal":false,"cidr":"172.18.0.7/16"}
```