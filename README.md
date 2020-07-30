# sshd Docker Example

Adding sshd to docker is [considered](https://stackoverflow.com/a/52310862/399632) an [anti-pattern](https://jpetazzo.github.io/2014/06/23/docker-ssh-considered-evil/) except in the case of AWS Fargate as highlighted by a [long standing issue](https://github.com/aws/containers-roadmap/issues/187).

This repo is am example of how to get docker running effectively for Alpine to use in Fargate.

## To Run

1. Add your public key to `authorized-keys/`
1. `docker build -t openssh .`
1. `docker run -p 2222:22 -it openssh /bin/sh -c "SSH_ENABLED=true /usr/local/bin/docker-entrypoint.sh && sleep infinity"`
1. `ssh -i ~/path/to/private_key -p 2222 root@localhost`

## Practical Fargate

To be realistically accessible while still being secure, sshd should remain off until necessary.

- Leave `SSH_ENABLED` environment variable false for all containers.
- Create an extra ECS Cluster as a One-Off Fargate task whose sole purpose is to be the SSH connector. Cloudformation CMD becomes:
  ``` YAML
  ...
  ContainerDefinitions:
    ...
    Command:
      - /bin/sh
      - '-c'
      - "SSH_ENABLED=true /usr/local/bin/docker-entrypoint.sh && sleep infinity"
  ```

  or if manually creating in AWS Fargate UI for container definitions:

  `/bin/sh,-c,SSH_ENABLED=true /usr/local/bin/docker-entrypoint.sh && sleep infinity`

- Now, there is now on-demand SSH. Be sure to `stop` the task when finished.
- Use a Bastion/Jump machine.

## Notes

- `SSH_ENABLED` flag turns on/off sshd. Default: `false`
- SSH wipes the environment - the trick is to [re-hydrate the session](https://stackoverflow.com/questions/34630571/docker-env-variables-not-set-while-log-via-shell) via `env | grep '_\|PATH' | awk...` in the `entry-point.sh`
- Key management is not the point of this repo, manage your keys well please.
- Assumes you connect into your container to `root`.
- `sleep infinity` is [cool](https://stackoverflow.com/a/22100106/399632).

## Suggestions Welcome

Improvements to the files or to the *Practical Fargate* section are always welcomed.
