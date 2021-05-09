FROM alpine:3.13.5
ENV RSYSLOG_PORT=514 RSYSLOG_PROTOCOL=udp

RUN apk add --no-cache rsyslog gettext

COPY rsyslog.conf.template /etc/rsyslog.conf.template
COPY start.sh /start.sh

# So we can make the root file system read-only
RUN ln -sf /var/lib/rsyslog/rsyslog.conf /etc/rsyslog.conf

RUN chmod +x /start.sh

CMD /start.sh
