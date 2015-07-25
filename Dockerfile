FROM debian:jessie
MAINTAINER madevil

# Let the container know that there is no tty
ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root

# Madsonic Package Information
ENV PKG_NAME madsonic
ENV PKG_VER 6.0
ENV PKG_BUILD 6880
ENV PKG_DATE 20150725

# Use init system
CMD ["/sbin/my_init"]

# Fix ids
RUN usermod -u 99 nobody
RUN usermod -g 100 nobody

# Add Oracle Java8 Repo
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list.d/webupd8team-java.list \
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 \
  && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections

# Install apt packages
RUN apt-get update && apt-get install -y \
  ca-certificates \
  locales \
  oracle-java8-installer \
  oracle-java8-set-default \
  unzip \
  wget

# download madsonic
RUN mkdir -p /var/madsonic/transcode \
  && wget -O /var/madsonic/madsonic.zip http://www.madsonic.org/download/${PKG_VER}/${PKG_DATE}_${PKG_NAME}-${PKG_VER}.${PKG_BUILD}-standalone.zip \
  && wget -O /var/madsonic/transcode/transcode.zip http://www.madsonic.org/download/transcode/${PKG_DATE}_${PKG_NAME}-transcode-x64.zip

# Install Madsonic
RUN mkdir -p /var/madsonic/transcode \
  && unzip /var/madsonic/madsonic.zip -d /var/madsonic \
  && unzip /var/madsonic/transcode/transcode.zip -d /var/madsonic/transcode \
  && chown -R nobody:users /var/madsonic \
  && chmod -R 755 /var/madsonic \
  && rm /var/madsonic/madsonic.zip \
  && rm /var/madsonic/transcode/transcode.zip

# Force Madsonic to run in foreground
RUN sed -i 's/-jar madsonic-booter.jar > \${LOG} 2>\&1 \&/-jar madsonic-booter.jar > \${LOG} 2>\&1/g' /var/madsonic/madsonic.sh

 # apt clean
RUN apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/*

# Set Locale
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN locale-gen en_US en_US.UTF-8
RUN dpkg-reconfigure locales 


# Copy start.sh script
ADD start.sh /start.sh

# default http https port
EXPOSE 4040 4050

# App configuration
VOLUME /config

# media directory
VOLUME /media

# Run Program
USER nobody
ENTRYPOINT ["/start.sh"]
