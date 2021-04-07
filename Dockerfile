# This Dockerfile builds Unbound --with-pythonmodule support and includes a simple Hello World style Python
# module to demonstrate the --with-pythonmodule functionality.
# See: https://unbound.net/
FROM ubuntu:18.04
ARG UNBOUND_VERSION=1.13.1

RUN apt-get update && \
apt-get upgrade -y && \
apt-get install --no-install-recommends -y \
	build-essential \
	ca-certificates \
	dnsutils \
	libevent-dev \
	libpython3.6 \
	libpython3.6-dev \
	libssl-dev \
	python3.6 \
	python3-distutils \
	rsyslog \
	swig \
	vim \
	wget && \
	rm -rf /var/lib/apt/lists/*

WORKDIR /opt
RUN wget "https://www.nlnetlabs.nl/downloads/unbound/unbound-${UNBOUND_VERSION}.tar.gz" && \
	tar zxvf unbound*.tar.gz && \
	cd $(find . -type d -name 'unbound*') && \
	ln -s /usr/bin/python3 /usr/bin/python && \
	./configure --with-pyunbound --with-libevent --with-pythonmodule && \
	make && \
	make install && \
	useradd unbound && \
	chown -R unbound: /usr/local/etc/unbound/ && \
	cd /opt && \
	rm -Rf /opt/unbound*

RUN apt-get purge -y build-essential \
	ca-certificates \
	libevent-dev \
	libpython3.6-dev \
	libssl-dev \
	swig \
	wget

WORKDIR /usr/local/etc/unbound
RUN mv unbound.conf unbound.conf.org
COPY unbound.conf ./
COPY helloworld.py ./

# Ready! Once in a Bash shell you can do 'unbound' then 'dig +noall +answer @127.0.0.1' to see the output of the
# Hello World Python module:
# root@nnn:/usr/local/etc/unbound#: unbound
# root@nnn:/usr/local/etc/unbound#: dig +noall +answer @127.0.0.1
# helloworld.  300 IN A 127.0.0.1
ENTRYPOINT ["/bin/bash"]
