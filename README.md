# fluentd to graylog2 (gelf) forwarder

This will setup a multi container environment containing graylog2 and a fluentd GELF forwarder.
It uses the official graylog2 and fluentd containers as base images.
The distributed fluentd gelf plugin (plugins/out_gelf.rb) was developed by @emsearcy: https://github.com/emsearcy/fluent-plugin-gelf.
It must be present to build the fluentd image successfully.

## Using with docker-compose (recommended)

First, this will pull and execute graylog2 all-in-one container env.
Then it will build and run a fluentd UPD forwarder to the graylog2 container

`docker-compose up -d`

#### Data persistence

By default running graylog with `docker-compose up -d` will persist data relatively in `./graylog2/data` as configured in the `docker-compose.yml` file.
You can simply modify that by placing a `docker-compose.override.yml` file with your specific configuration in the same directory. 

```yaml
graylog2:
  environment:
    GRAYLOG_NODE_ID: dev.local
  volumes:
    - {yourAbsoluteOrRelativPath}:/var/opt/greylog/data
    - {yourAbsoluteOrRelativPath}:/var/log/graylog
```

## Manual setup steps

### Setup graylog2 container

Run graylog2 all-in-one container env.

`docker pull graylog2/allinone`

`docker run -t -p 9000:9000 -p 12201:12201 --name graylog2 -e GRAYLOG_NODE_ID=graylog2 graylog2/allinone`

Now, you should be able to login to the graylog2 web interface `http://host:9000/` (admin:admin)

#### Data persistence

To persist graylog2 data outside of your container you need to mount the data volumne.

`docker run -t -p 9000:9000 -p 12201:12201 --name graylog2 -e GRAYLOG_NODE_ID=graylog2 -v {yourAbsolutePath}:/var/opt/graylog/data -v {yourAbsolutePath}:/var/log/graylog graylog2/allinone`

### Setup fluentd to graylog container

Build and link it to graylog2

`docker build -t fluent-gelf .`

`docker run -p 24224:24224 --link graylog2:graylog2 -it --name fluent-gelf fluent-gelf`

### How to use

Now you're able to push any fluentd logs to HOST:24224. The fluentd messages will be forwarded to graylog2 as long as a tag in format gelf.app.XYZ is specified in the fluentd messages.
Make sure, that you define a `GELF UPD` input source listening to port: `12201` (default) withing graylog2: `http://host:9000/system/inputs`


