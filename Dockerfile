FROM centos:7

RUN curl -s -L -o /etc/yum.repos.d/rsyslog.repo http://rpms.adiscon.com/v8-stable/rsyslog.repo
RUN yum -y install rsyslog gettext && yum clean all

COPY rsyslog.conf.template /etc/rsyslog.conf.template
COPY start.sh /start.sh

CMD /start.sh
