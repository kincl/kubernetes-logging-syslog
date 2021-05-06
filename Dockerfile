FROM alpine:3.13.5
ENV RSYSLOG_PORT=514 RSYSLOG_PROTOCOL=udp

RUN apk add --no-cache rsyslog gettext

COPY rsyslog.conf.template /etc/rsyslog.conf.template
COPY start.sh /start.sh

RUN chmod +x /start.sh

CMD /start.sh
