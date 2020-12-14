FROM resin/rpi-raspbian:jessie-20190121
MAINTAINER Daniel Floris <daniel.floris@gmail.com>

RUN apt-get update && \
    apt-get install -y \
    curl \
	wget \
	apt-transport-https

RUN curl https://www.linux-projects.org/listing/uv4l_repo/lrkey.asc | apt-key add -
RUN echo "deb http://www.linux-projects.org/listing/uv4l_repo/raspbian/ jessie main" > /etc/apt/sources.list.d/uv4l-wheezy.list

#RUN apt-get update && \
#    apt-get install -y \
RUN apt-get update
RUN apt-get install -y \
    uv4l \
    uv4l-renderer \
    uv4l-decoder \
    uv4l-encoder \
    uv4l-raspidisp \
	v4l-utils && \
    rm -rf /var/lib/apt/lists/*
	
RUN mkdir -p /etc/uv4l/ssl/

RUN openssl genrsa -out /etc/uv4l/ssl/ssl.key 2048 && openssl req -new -x509 -key /etc/uv4l/ssl/ssl.key -out /etc/uv4l/ssl/ssl.crt -sha256  -subj "/C=BR"


ENV LD_PRELOAD /usr/lib/uv4l/uv4lext/armv6l/libuv4lext.so

WORKDIR /

EXPOSE 8080

ENV UV4L_PARAMETERS --help

CMD /usr/bin/uv4l $UV4L_PARAMETERS
#docker run -ti -d --device=/dev/fb0  -p 8080:8080 --name=uv4l --cap-add=ALL --privileged -v /lib/modules:/lib/modules -v=/dev:/dev -e UV4L_PARAMETERS="-k -f --sched-rr --mem-lock –auto-video_nr  --driver raspidisp --resolution=3" humbertosales/rover-uv4ls