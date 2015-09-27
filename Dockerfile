FROM fluent/fluentd:latest

MAINTAINER Christian Moser <onmomo>

USER ubuntu

WORKDIR /home/ubuntu

ENV PATH /home/ubuntu/ruby/bin:$PATH

RUN gem install gelf

EXPOSE 24284

CMD fluentd -c /fluentd/etc/$FLUENTD_CONF -p /fluentd/plugins $FLUENTD_OPT