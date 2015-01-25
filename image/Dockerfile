FROM phusion/BASE_IMAGE:VERSION
MAINTAINER Konstantin Krauss <konstantin.krauss@me.com>

ADD . /kk_build

RUN chmod +x /kk_build/install.sh && \
      /kk_build/install.sh && \
      rm -rf /kk_build
