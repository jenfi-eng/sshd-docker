### To Run

1. Add your public key to `authorized-keys/`
1. `docker build -t openssh .`
1. `docker run -p 2222:22 -it openssh /bin/sh -c "SSH_ENABLED=true /usr/local/bin/docker-entrypoint.sh && sleep infinity"`
1. `ssh -i ~/path/to/private_key -p 2222 root@localhost`
