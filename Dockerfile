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
    uv4l-uvc \
    uv4l-server \
    uv4l-renderer \
    uv4l-decoder \
    uv4l-encoder \
    uv4l-mjpegstream \
    uv4l-raspicam \
    uv4l-raspicam-extras
RUN apt-get install -y \
    uv4l-raspidisp \
    uv4l-webrtc \
    uv4l-demos \
    uv4l-xscreen
	
#RUN apt-get install -y openssl libssl1.0.0 openssh-client openssh-server ssh
# Here the packages that we need in the future to add support to the raspicam
# uv4l-decoder uv4l-encoder uv4l-mjpegstream uv4l-raspicam uv4l-raspicam-extras

RUN mkdir -p /etc/uv4l/ssl/

#RUN openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout /etc/uv4l/ssl/ssl.key  -subj "/C=BR"
#RUN openssl -key /etc/uv4l/ssl/ssl.key -out /etc/u4ul/ssl/ssl.csr

RUN openssl genrsa -out /etc/uv4l/ssl/ssl.key 2048 && openssl req -new -x509 -key /etc/uv4l/ssl/ssl.key -out /etc/uv4l/ssl/ssl.crt -sha256  -subj "/C=BR"

RUN apt-get install -y v4l-utils

#RUN apt-get remove -y \
#    curl && \
#    rm -rf /var/lib/apt/lists/*

ENV LD_PRELOAD /usr/lib/uv4l/uv4lext/armv6l/libuv4lext.so

WORKDIR /

EXPOSE 8080

ENV UV4L_PARAMETERS --help

CMD /usr/bin/uv4l $UV4L_PARAMETERS
#docker run -ti -d --device=/dev/fb0  -p 8080:8080 --name=uv4l --cap-add=ALL --privileged -v /lib/modules:/lib/modules -v=/dev:/dev -e UV4L_PARAMETERS="-k -f --sched-rr --mem-lock –auto-video_nr  --driver raspidisp --resolution=3" humbertosales/rover-uv4ls