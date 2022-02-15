FROM debian:buster
MAINTAINER deanski79@gmail.com

RUN apt-get update && apt-get -y install gnupg curl \
    && echo "deb [arch=amd64] http://repo.powerdns.com/debian buster-dnsdist-17 main" >> /etc/apt/sources.list \
    && curl https://repo.powerdns.com/FD380FBB-pub.asc | apt-key add - \
    && apt-get install -y dnsdist \
    && rm -rf /var/lib/apt/lists/*

ADD dnsdist.conf /etc/dnsdist/dnsdist.conf
ADD dnsdist.pref /etc/apt/preferences.d/dnsdist

EXPOSE 53/udp 53/tcp
VOLUME "/etc/dnsdist/"

CMD ["/usr/bin/dnsdist"]
