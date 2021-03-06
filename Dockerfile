FROM alpine:3.10
MAINTAINER Anees anees284@gmail.com

# Install packages
RUN apk update && \
    apk add ca-certificates wget python python-dev py-pip && \
    update-ca-certificates && \
    pip install --upgrade --user awscli

# Setting environment variables
ENV JMETER_HOME /opt/apache-jmeter-5.1.1
ENV JMETER_BIN	${JMETER_HOME}/bin
ENV TESTDIR /test/
ENV PATH="~/.local/bin:$PATH"


RUN apk upgrade
RUN apk update
RUN apk add --no-cache bash
RUN apk add curl
# Downloading JMETER and copying into the opt path
RUN curl -L --silent https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-5.1.1.tgz > /tmp/apache-jmeter-5.1.1.tgz
RUN tar -xzf /tmp/apache-jmeter-5.1.1.tgz -C /opt
RUN apk add --update openjdk8-jre tzdata curl unzip bash

ENV PATH $PATH:$JMETER_BIN
WORKDIR	${TESTDIR}
# Copying the JMX file and entrypoint file(this runs the test)
COPY JMeter_TEST.jmx $TESTDIR
COPY test_results.xml $TESTDIR
COPY testconsole.log $TESTDIR
COPY entrypoint.sh $TESTDIR
# Docker entry point to run the test
ENTRYPOINT ["./entrypoint.sh"]