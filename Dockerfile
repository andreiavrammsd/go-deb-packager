FROM ubuntu:16.04

RUN apt-get update && apt-get install wget nano git make -y

RUN wget https://storage.googleapis.com/golang/go1.7.linux-amd64.tar.gz \
    && tar -xvf go1.7.linux-amd64.tar.gz \
    && mv go /usr/local \
    && rm go1.7.linux-amd64.tar.gz
    
RUN echo "export GOROOT=/usr/local/go" >> ~/.profile \
    && echo "export GOPATH=/go" >> ~/.profile \
    && echo "export PATH=\$GOPATH/bin:\$GOROOT/bin:\$PATH" >> ~/.profile

COPY entrypoint.sh /entrypoint.sh
RUN /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

WORKDIR /bpd
