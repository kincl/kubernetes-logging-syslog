FROM centos:7

RUN curl -s -L -o /etc/yum.repos.d/rsyslog.repo http://rpms.adiscon.com/v8-stable/rsyslog.repo
RUN yum -y install rsyslog && yum clean all

COPY rsyslog.conf /etc/rsyslog.conf

CMD /sbin/rsyslogd -n
