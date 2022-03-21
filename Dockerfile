# Build from source

FROM debian:bullseye as build_freeswitch


ENV TOKEN="pat_VhbqpZ3zfsyXq88BjGCXqf1e"


RUN apt-get update && apt-get install -yq gnupg2 wget lsb-release
RUN wget --http-user=signalwire --http-password=$TOKEN -O /usr/share/keyrings/signalwire-freeswitch-repo.gpg https://freeswitch.signalwire.com/repo/deb/debian-release/signalwire-freeswitch-repo.gpg

RUN echo "machine freeswitch.signalwire.com login signalwire password $TOKEN" > /etc/apt/auth.conf
RUN echo "deb [signed-by=/usr/share/keyrings/signalwire-freeswitch-repo.gpg] https://freeswitch.signalwire.com/repo/deb/debian-release/ `lsb_release -sc` main" > /etc/apt/sources.list.d/freeswitch.list
RUN echo "deb-src [signed-by=/usr/share/keyrings/signalwire-freeswitch-repo.gpg] https://freeswitch.signalwire.com/repo/deb/debian-release/ `lsb_release -sc` main" >> /etc/apt/sources.list.d/freeswitch.list

RUN apt-get update

# Install dependencies required for the build
RUN apt-get -y build-dep freeswitch

# then let's get the source. Use the -b flag to get a specific branch
WORKDIR /usr/src/
RUN git clone https://github.com/signalwire/freeswitch.git freeswitch
WORKDIR /usr/src/freeswitch

# ... and do the build
RUN ./bootstrap.sh -j
RUN ./configure
RUN make install
RUN make mod_http_cache-install
RUN make mod_gsmopen-install

RUN /bin/bash -c "source docker/base_image/make_min_archive.sh"
RUN /bin/mkdir /tmp/build_image
RUN /bin/tar zxvf ./freeswitch_img.tar.gz -C /tmp/build_image

# FROM scratch
# COPY --from=build_freeswitch /tmp/build_image /
# RUN /bin/mkdir /etc/freeswitch

# CMD ["/usr/bin/freeswitch", "-nc", "-nf", "-nonat"]
