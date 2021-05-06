FROM alpine:latest

RUN apk add --no-cache rsyslog gettext

COPY rsyslog.conf.template /etc/rsyslog.conf.template
COPY start.sh /start.sh

RUN chmod +x /start.sh

CMD /start.sh
