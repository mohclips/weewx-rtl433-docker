FROM debian:latest

ENV DEBIAN_FRONTEND noninteractive
ENV GIT_SSL_NO_VERIFY 0

# rtl433 layer
RUN build_deps='gcc git automake libtool cmake libbladerf-dev librtlsdr-dev make ncurses-dev pkg-config' \
  && set -x \
  && apt update \
  && apt install -y --no-install-recommends \
    $build_deps \
    ca-certificates \
    librtlsdr0 \
    rtl-sdr \
    iputils-ping \
    usbutils \
    wget \
    gnupg2 \
  && git clone https://github.com/merbanan/rtl_433.git \
	&& cd rtl_433/ \
	&& mkdir build \
	&& cd build \
	&& cmake ../ \
	&& make \
	&& make install \
  && apt -y --auto-remove purge $build_deps \
  && rm -rf /var/lib/apt/lists/*
#
# Install weewx layer
# http://weewx.com/docs/debian.htm
# https://github.com/matthewwall/weewx-sdr
#--no-check-certificate
RUN wget -qO - http://weewx.com/keys.html | apt-key add - \
  && wget -qO - http://weewx.com/apt/weewx-python3.list | tee /etc/apt/sources.list.d/weewx.list \
  && apt-get update \
  && apt install -y --no-install-recommends weewx inetutils-syslogd python3-mysqldb mariadb-client \
  && rm -rf /var/lib/apt/lists/* \
  && wget --no-check-certificate -O weewx-sdr.zip https://github.com/matthewwall/weewx-sdr/archive/master.zip \
  && apt -y --auto-remove purge wget gnupg2 \
  && wee_extension --install weewx-sdr.zip \
  && wee_config --reconfigure --driver=user.sdr --no-prompt \
  && rm -f weewx-sdr.zip \
  && mkdir -p /var/www/html/weewx/{smartphone,mobile} \
  && ln -s /usr/bin/python3 /usr/bin/python 

# our start up script
COPY entrypoint.sh /usr/local/bin
# weewx health check
COPY healthcheck.sh /usr/local/bin
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
