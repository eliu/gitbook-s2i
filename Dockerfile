
# eliu/gitbook-s2i
FROM node:9-alpine

# TODO: Put the maintainer name in the image metadata
MAINTAINER Liu Hongyu <eliuhy@163.com>

# TODO: Rename the builder environment variable to inform users about application you provide them
# ENV BUILDER_VERSION 1.0
ENV GITBOOK_VERSION=3.2.3 \
    HOME=/opt/workspace

# TODO: Set labels used in OpenShift to describe the builder image
LABEL io.k8s.description="Gitbook Builder" \
     io.k8s.display-name="Gitbook Builder 1" \
     io.openshift.expose-services="4000:http,35729:http" \
     io.openshift.tags="gitbook" \
     io.openshift.s2i.scripts-url="image:///usr/libexec/s2i"

# TODO: Install required packages here:
# RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
RUN apk add --no-cache bash 
RUN npm install --global gitbook-cli \
    && gitbook fetch ${GITBOOK_VERSION} \
    && npm cache verify \
    && gitbook install \
    && rm -rf /tmp/*
RUN chown -R 1001:1001 /opt/workspace
RUN echo fs.inotify.max_user_watches=524288 | tee -a /etc/sysctl.d/00-alpine.conf

# TODO (optional): Copy the builder files into /opt/app-root
# COPY ./<builder_folder>/ /opt/app-root/

# TODO: Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image
# sets io.openshift.s2i.scripts-url label that way, or update that label
COPY ./s2i/bin/ /usr/libexec/s2i

# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
# RUN chown -R 1001:1001 /opt/app-root

# This default user is created in the openshift/base-centos7 image
USER 1001

WORKDIR /opt/workspace

# TODO: Set the default port for applications built using this image
EXPOSE 4000 35729

# TODO: Set the default CMD for the image
CMD ["/usr/libexec/s2i/usage"]
