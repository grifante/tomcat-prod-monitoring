FROM tomcat:9-jre8-alpine

MAINTAINER Giovani Grifante <grifante@gmail.com>

ARG ARTHAS_VERSION="3.0.5"
ARG JAVA_ALPINE_VERSION="8.191.12-r0"

RUN rm /usr/local/tomcat/webapps/* -rf && \
    apk add --no-cache tini && \ 
    apk del openjdk8-jre*

RUN apk add --no-cache openjdk8=${JAVA_ALPINE_VERSION} && \
    wget -qO /tmp/arthas.zip "https://repo1.maven.org/maven2/com/taobao/arthas/arthas-packaging/${ARTHAS_VERSION}/arthas-packaging-${ARTHAS_VERSION}-bin.zip" && \
    mkdir -p /opt/arthas && \
    unzip /tmp/arthas.zip -d /opt/arthas && \
    rm /tmp/arthas.zip && \
    echo "java -jar /opt/arthas/arthas-boot.jar" > /opt/arthas/arthas.sh && \
    chmod +x /opt/arthas/arthas.sh 

ENV PATH="${PATH}:/opt/arthas/"

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]
