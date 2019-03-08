# pythonunbound
A simple Dockerfile that builds Unbound (1.9.0 at the time of writing) `--with-pythonmodule` support and includes a simple Hello World style Python # module to demonstrate the `--with-pythonmodule` functionality.

# Hello World
```
$ docker run -it nlnetlabs/pythonunbound
root@nnn:/usr/local/etc/unbound#: unbound
root@nnn:/usr/local/etc/unbound#: dig +noall +answer @127.0.0.1
helloworld.  300 IN A 127.0.0.1
```

# Develop and test your own Python module for Unbound
Edit the `helloworld.py` or your own Python module file, reload Unbound then submit DNS queries to the locally running Unbound process to see your module in action. Running Unbound in the foreground with lots of diagnostic output will probably be useful while developing, e.g.:

```
docker run -it nlnetlabs/pythonunbound
root@nnn:/usr/local/etc/unbound#: unbound -dd -vvvv
```

Then in another terminal get the container ID with `docker ps` then connect to it like so:
```
docker exec -it <container id> /bin/bash
root@nnn:/usr/local/etc/unbound#: dig +noall +answer @127.0.0.1
helloworld.  300 IN A 127.0.0.1
```
