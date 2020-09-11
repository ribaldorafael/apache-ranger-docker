FROM ubuntu:18.04

# install wget and java8
RUN apt update \
  && apt install -y wget \
  && apt install -y openjdk-8-jdk

ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64

# install postgres and add jar to system
RUN apt update \
  && apt-get install -y postgresql postgresql-contrib \
  && wget -P /usr/share/postgres/ https://jdbc.postgresql.org/download/postgresql-42.2.16.jar

# install solr for querying and logging
RUN wget https://archive.apache.org/dist/lucene/solr/8.6.2/solr-8.6.2.tgz \
  && tar xzf solr-8.6.2.tgz solr-8.6.2/bin/install_solr_service.sh --strip-components=2 \
  && ./install_solr_service.sh solr-8.6.2.tgz

# install python3 and pip
RUN apt install -y software-properties-common \
  && add-apt-repository -y ppa:deadsnakes/ppa \
  && apt install -y python3.7 python3-pip

RUN ln -s /usr/bin/python3 /usr/bin/python

# add ranger-build target output to system
ADD ranger-target/ranger-3.0.0-SNAPSHOT-admin.tar.gz /usr/lib/

RUN mv /usr/lib/ranger-3.0.0-SNAPSHOT-admin /usr/lib/ranger

WORKDIR /usr/lib/ranger/

# install ranger
RUN ./setup.sh

EXPOSE 6080

ENTRYPOINT ["/bin/bash", "ranger-admin", "start"]
