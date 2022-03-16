# dnsdist on Docker

This repository contains a Docker image of PowerDNS [dnsdist](http://dnsdist.org/).

> dnsdist is a highly DNS-, DoS- and abuse-aware loadbalancer. Its goal in life is to route traffic to the best server, delivering top performance to legitimate users while shunting or blocking abusive traffic.

* The Docker image is available at [deanski79/dnsdist](https://hub.docker.com/r/deanski79/dnsdist)
* The GitHub repository is available at [deaniliev/dnsdist](https://github.com/deaniliev/dnsdist)

## Usage

Create a named container 'dnsdist'.
dnsdist starts and listens on ports 53 for dns in the container.
To map it to the host's ports, use the following command to create and start the container instead:

```bash
docker run -d --name dnsdist -p 53:53/tcp -p 53:53/udp -t deanski79/dnsdist
```

### Additional settings

dnsdist stores its config ```/etc/dnsdist/``` in the container.
It is a good idea to use persistent configuration with volume mapping for the configuration path.

For example:

```bash
docker run -t \
 --name dnsdist \
 -v /data/dnsdist/:/etc/dnsdist/ \
 -p 53:53/udp \
 -p 53:53/tcp \
 deanski79/dnsdist
```

/data/dnsdist/dnsdist.conf:

```Lua
newServer{address="8.8.8.8", order=1}
newServer{address="8.8.4.4", order=2}
newServer{address="1.1.1.1", order=3}
setServerPolicy(firstAvailable)

setLocal('0.0.0.0')
```

Use unit file if you want to start/stop with systemd:

```ini
[Unit]
Description=dnsdist
After=docker.service
Requires=docker.service

[Service]
KillMode=none
ExecStartPre=/usr/bin/docker kill dnsdist
ExecStartPre=/usr/bin/docker rm dnsdist
ExecStart=/usr/bin/docker run -t \
          --name dnsdist \
          -p 53:53/tcp \
          -p 53:53/udp \
          -v /data/dnsdist/:/etc/dnsdist/ \
          deanski79/dnsdist
ExecStop=/usr/bin/docker stop dnsdist
```
