FROM ubuntu:wily

COPY . /usr/local/docker
RUN chmod -R 777 /usr/local/docker

RUN apt-get update && apt-get install -y \
        nodejs \
        npm \
        vim

RUN npm install socket.io -g
RUN npm install forever -g
RUN npm install forever-monitor

ENTRYPOINT ["/usr/local/docker/run.sh"]
