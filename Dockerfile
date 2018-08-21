## Custom Dockerfile
FROM consol/ubuntu-xfce-vnc
ENV REFRESHED_AT 2018-08-21

## Install
USER 0
RUN apt update && apt-get install -y openjdk-8-jre \
    && apt-get clean -y
RUN curl -O https://download2.interactivebrokers.com/installers/ibgateway/latest-standalone/ibgateway-latest-standalone-linux-x64.sh
RUN curl -O https://s3.amazonaws.com/ptltrader-downloads/ptltrader-1.5.0-linux64.jar

## switch back to default user
USER 1000
