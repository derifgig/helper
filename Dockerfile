FROM debian:trixie-slim

RUN apt-get update && \
    apt-get install -y nginx libnginx-mod-http-lua \ 
    libnginx-mod-http-ndk lua-cjson iproute2 procps \ 
    net-tools curl netcat-traditional jq iputils-ping \
    tcpdump vim dnsutils postgresql-client mtr \
    python3 python3-yaml python3-requests python3-psycopg2 python3-dotenv && \
    adduser --system --no-create-home --shell /bin/false --group --disabled-login nginx && \
    rm -rf /var/lib/apt/lists/*

RUN rm /etc/nginx/nginx.conf

RUN mkdir -p /etc/nginx/lua
COPY server.lua /etc/nginx/lua/server.lua

COPY nginx.conf /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]
