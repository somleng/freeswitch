# Build debian packages

FROM debian:bullseye as build_freeswitch


RUN apt-get update && apt-get install -yq gnupg2 wget lsb-release
RUN wget -O /usr/share/keyrings/freeswitch-archive-keyring.gpg https://files.freeswitch.org/repo/deb/debian-unstable/freeswitch-archive-keyring.gpg

RUN echo "deb [signed-by=/usr/share/keyrings/freeswitch-archive-keyring.gpg] https://files.freeswitch.org/repo/deb/debian-unstable/ `lsb_release -sc` main" > /etc/apt/sources.list.d/freeswitch.list
RUN echo "deb-src [signed-by=/usr/share/keyrings/freeswitch-archive-keyring.gpg] https://files.freeswitch.org/repo/deb/debian-unstable/ `lsb_release -sc` main" >> /etc/apt/sources.list.d/freeswitch.list

RUN apt-get update
RUN apt-get install -y xz-utils devscripts cowbuilder git

# nonstandard packages from freeswitch repo are not trusted by pbuilder !!
RUN echo "ALLOWUNTRUSTED=yes" >> /etc/pbuilderrc

# then let's get the source. Use the -b flag to get a specific branch
WORKDIR /usr/src/
RUN git clone https://github.com/somleng/freeswitch.git -b build_debian freeswitch
WORKDIR /usr/src/freeswitch

RUN ./debian/util.sh build-all -a`dpkg --print-architecture` -cbullseye
