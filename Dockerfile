FROM debian:latest

RUN apt-get update
RUN apt-get upgrade -y

# Enable 32-bit
RUN dpkg --add-architecture i386
RUN apt-get update

# Extra utils for setup
RUN apt-get install -y wget procps

# Libraries needed for srcds
RUN apt-get install -y lib32z1 lib32ncurses5 libbz2-1.0:i386 lib32gcc1 lib32stdc++6 libtinfo5:i386 libcurl3-gnutls:i386

RUN mkdir /srcds

WORKDIR /srcds

RUN wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz
RUN tar -xvf steamcmd_linux.tar.gz

COPY ./tf2_ds.txt /srcds/tf2_ds.txt
COPY ./entry.sh /srcds/entry.sh
COPY ./configs ./configs
COPY ./maps ./maps
COPY ./addons ./addons

EXPOSE 27015/tcp
EXPOSE 27015/udp

ENTRYPOINT ["/srcds/entry.sh"]
