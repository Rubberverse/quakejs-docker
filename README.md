# 🍴 Fork Details

💁 Slight changes, removing some stuff that I dislike and fixing some errors I ran into along the way

1. Runs entrypoint as `quakejs` user
2. Multiple `RUN` Dockerfile statements have been squished into one long chain
3. `nginx` runs as `quakejs` instead of `root`
4. Hacky way of bypassing Nginx's inability to serve static files via POST request, fixes `405 Method Not Allowed`
5. Use entrypoint script to launch nginx and node

The repository this was forked from fixed up reverse proxying so you can expose this QuakeJS server under HTTPS and it will work fine via Caddy or another Nginx instance.

📂 Directories:

- `/var/www/html` - Main QuakeJS web files, symlink to `/quakejs/html` but files can be mounted over and overwritten
- `/var/www/html/assets` - QuakeJS assets

---

<div align="center">

![logo](https://github.com/treyyoder/quakejs-docker/blob/master/quakejs-docker.png?raw=true)
# quakejs-docker

![Docker Image CI](https://github.com/treyyoder/quakejs-docker/workflows/Docker%20Image%20CI/badge.svg)

</div>

### A fully local and Dockerized quakejs server. Independent, unadulterated, and free from the middleman.

The goal of this project was to create a fully independent quakejs server in Docker that does not require content to be served from the internet.
Hence, once pulled, this does not need to connect to any external provider, ie. content.quakejs.com. Nor does this server need to be proxied/served/relayed from quakejs.com

#### Simply pull the image [treyyoder/quakejs](https://hub.docker.com/r/treyyoder/quakejs)

```
docker pull treyyoder/quakejs:latest
```

#### and run it:

```
docker run -d --name quakejs -p 8080:80 treyyoder/quakejs:latest
```

#### Example:

```
docker run -d --name quakejs -p 8080:80 treyyoder/quakejs:latest
```

Send all you friends/coworkers the link: ex. http://localhost:8080 and start fragging ;)

#### server.cfg:

Refer to [quake3world](https://www.quake3world.com/q3guide/servers.html) for instructions on its usage.

#### docker-compose.yml

```
version: '2'
services:
    quakejs:
        container_name: quakejs
        ports:
            - '8080:80'
        image: 'treyyoder/quakejs:latest'
```

#### Building the Image

Build the image with:

`docker build . -t treyyoder/quakejs:latest`

## Credits:

Thanks to [begleysm](https://github.com/begleysm) with his [fork](https://github.com/begleysm/quakejs) of [quakejs](https://github.com/inolen/quakejs) to which this was derived, aswell as his thorough [documentation](https://steamforge.net/wiki/index.php/How_to_setup_a_local_QuakeJS_server_under_Debian_9_or_Debian_10)
