FROM alpine:latest

RUN apk update && apk add --virtual --no-cache \
  openssh

COPY sshd_config /etc/ssh/sshd_config

RUN mkdir -p /root/.ssh/
COPY authorized-keys/*.pub /root/.ssh/authorized_keys
RUN cat /root/.ssh/authorized-keys/*.pub > /root/.ssh/authorized_keys
RUN chown -R root:root /root/.ssh && chmod -R 600 /root/.ssh

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
RUN ln -s /usr/local/bin/docker-entrypoint.sh /

# Annoying that we have to set a password to be let in - MAKE THIS STRONG.
RUN echo 'root:THEPASSWORDYOUCREATED' | chpasswd

EXPOSE 22
ENTRYPOINT ["docker-entrypoint.sh"]
