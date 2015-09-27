# fluentd to graylog2 (gelf) forwarder multi container environment

## Using with docker-compose (recommended)

First, this will pull and execute graylog2 all-in-one container env.
Then it will build and run a fluentd UPD forwarder to the graylog2 container

`docker-compose up -d`

## Manual setup steps

### Setup graylog2 container

Run graylog2 all-in-one container env.

`docker pull graylog2/allinone`

`docker run -t -p 9000:9000 -p 12201:12201 -e GRAYLOG_SERVER_SECRET=secret --name graylog2 -e GRAYLOG_NODE_ID=graylog2 graylog2/allinone`

### Setup fluentd to graylog container

Build and link it to graylog2

`docker build -t fluent-gelf .`

`docker run -p 24224:24224 --link graylog2:graylog2 -it --name fluent-gelf fluent-gelf`
