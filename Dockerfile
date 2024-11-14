FROM ubuntu:latest

ENV NODE_MAJOR=20

RUN apt-get update \
    && apt-get install -y \
        gpg \
        git \
        curl \
        nginx \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_MAJOR}.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
    && apt-get update \
    && apt-get install -y nodejs

WORKDIR /quakejs

RUN git clone https://github.com/begleysm/quakejs . \
    && npm install \
    && rm -rf /var/www/html

COPY server.cfg /quakejs/base/baseq3/
COPY server.cfg /quakejs/base/cpma/
COPY ./include/ioq3ded/ioq3ded.fixed.js /quakejs/build/ioq3ded.js
COPY ./include/assets/ /var/www/html/assets
COPY --chmod=755 docker-entrypoint.sh /app/scripts/docker-entrypoint.sh
COPY nginx.conf /etc/nginx/sites-available/default

RUN sed -i "s#'quakejs:[0-9]\+'#window.location.hostname#g" /quakejs/html/index.html \
    && sed -i "s#var url = 'http://' + fs_cdn + '/assets/manifest.json';#var url = '//' + window.location.host + '/assets/manifest.json';#" /quakejs/html/ioquake3.js \
    && sed -i "s#var url = 'http://' + root + '/assets/' + name;#var url = '//' + window.location.host + '/assets/' + name;#" /quakejs/html/ioquake3.js \
    && sed -i "s#var url = 'ws://' + addr + ':' + port;#var url = window.location.protocol.replace('http', 'ws') + window.location.host;#" /quakejs/html/ioquake3.js \
    && ln -s /quakejs/html/* /var/www/html \
    && apt-get purge curl gpg git -y \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd -r quakejs \
    && useradd -r -g quakejs quakejs \
    && touch /run/nginx.pid \
    && mkdir -p /quakejs/html/manifest \
    && mv /quakejs/html/manifest.json \
        /quakejs/html/manifest/manifest.json \
    && chown -R quakejs:quakejs \
        /quakejs \
        /etc/nginx \
        /var/www/html \
        /var/lib/nginx \
        /var/log/nginx \
    && chown quakejs:quakejs \
        /run/nginx.pid

USER quakejs
ENTRYPOINT ["/app/scripts/docker-entrypoint.sh"]
