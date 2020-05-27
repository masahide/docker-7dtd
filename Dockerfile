FROM bitnami/minideb:buster
MAINTAINER masahide.y@gmail.com

RUN dpkg --add-architecture i386 && apt-get update && apt-get install -q -y wget lib32gcc1 telnet

WORKDIR /root/steam

RUN wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz
RUN mkdir ./bin && tar -zxf steamcmd_linux.tar.gz -C ./bin

RUN mkdir -p /root/steam/server
RUN /root/steam/bin/steamcmd.sh +login anonymous \
	+force_install_dir /root/steam/server +app_update 294420 +quit

RUN mkdir -p /root/.local/share/7DaysToDie/Saves

EXPOSE 8080/tcp 8081/tcp
EXPOSE 26900-26902 26900-26902/udp

# Starting server on docker start
CMD export LD_LIBRARY_PATH=/root/steam/server && \
    /root/steam/server/7DaysToDieServer.x86_64 \
	-configfile=/root/steam/server/serverconfig.xml \
	-logfile /root/steam/server/output.log \
	-quit -batchmode -nographics -dedicated $@

