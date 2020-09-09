FROM ubuntu:18.04

MAINTAINER Ribaldo

RUN apt update \
  && apt install -y wget

WORKDIR /opt

# download maven
RUN wget https://archive.apache.org/dist/maven/maven-3/3.6.2/binaries/apache-maven-3.6.2-bin.tar.gz -P /tmp \
  && tar xf /tmp/apache-maven-*.tar.gz -C . \
  && ln -s /opt/apache-maven-3.6.2 /opt/maven

# set maven path
ENV M3_HOME=/opt/maven
ENV MAVEN_HOME=/opt/maven
ENV PATH=${M3_HOME}/bin:${PATH}

# install java 8
RUN apt install -y openjdk-8-jdk

# install python3
RUN apt install -y software-properties-common \
  && add-apt-repository -y ppa:deadsnakes/ppa \
  && apt install -y python3.7 python3-pip

# install python3 deps
RUN pip3 install requests

# create symlink from python to python3
RUN ln -s /usr/bin/python3 /usr/bin/python

# download and install apache-ranger
RUN apt install -y git \
  && git clone https://gitbox.apache.org/repos/asf/ranger.git \
  && cd ranger \
  && mvn -DskipTests=false clean package
