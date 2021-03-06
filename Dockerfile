# switch back to Alpine when/if https://bugs.alpinelinux.org/issues/8470 is fixed
# FROM alpine:latest
# RUN apk --update upgrade && apk add bash nfs-utils && rm -rf /var/cache/apk/*

FROM debian:stable

RUN apt-get update                                                                && \
    apt-get install -y --no-install-recommends nfs-kernel-server kmod libcap2-bin && \
    apt-get clean                                                                 && \
    rm -rf /var/lib/apt/lists

ADD ./entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/entrypoint.sh

# http://wiki.linux-nfs.org/wiki/index.php/Nfsv4_configuration
RUN mkdir -p /var/lib/nfs/rpc_pipefs && \
    mkdir -p /var/lib/nfs/v4recovery && \
    echo "rpc_pipefs  /var/lib/nfs/rpc_pipefs  rpc_pipefs  defaults  0  0" >> /etc/fstab && \
    echo "nfsd        /proc/fs/nfsd            nfsd        defaults  0  0" >> /etc/fstab

EXPOSE 2049

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
