FROM ubuntu:18.04

MAINTAINER Ribaldo

RUN apt update \
  && apt install -y wget

WORKDIR /opt

RUN wget https://archive.apache.org/dist/maven/maven-3/3.6.2/binaries/apache-maven-3.6.2-bin.tar.gz -P /tmp \
  && tar xf /tmp/apache-maven-*.tar.gz -C . \
  && ln -s /opt/apache-maven-3.6.2 /opt/maven

RUN apt install -y openjdk-8-jdk

ENV M3_HOME=/opt/maven
ENV MAVEN_HOME=/opt/maven
ENV PATH=${M3_HOME}/bin:${PATH}
ENV MAVEN_OPTS="-Xms2g -Xmx2g"

RUN apt install -y software-properties-common \
  && add-apt-repository -y ppa:deadsnakes/ppa \
  && apt install -y python3.7 python3-pip

RUN ln -s /usr/bin/python3 /usr/bin/python

RUN apt install -y git \
  && git clone https://github.com/apache/atlas.git \
  && cd atlas \
  && mvn clean install \
  && mvn clean package -Pdist

RUN echo "DONE!"
