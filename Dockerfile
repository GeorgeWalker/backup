FROM openshift/base-centos7
# Dockerfile for a database backup pod.

# install PostgreSQL client programs
RUN yum install -y centos-release-scl && \
    INSTALL_PKGS="rsync tar gettext bind-utils rh-postgresql94 gzip" && \
    yum -y --setopt=tsflags=nodocs install $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all 


# Install EPEL
RUN yum install -y epel-release && yum clean all

# Update RPM Packages
RUN yum -y update && yum clean all

RUN yum -y install cronie yum-cron && yum clean all


RUN touch /var/run/crond.pid
RUN chmod -R a+rwx /var/run/crond.pid
RUN chmod -R a+rwx /etc/sysconfig/crond

# set yum-cron flag file to run updates
RUN mkdir -p /var/lock/subsys
RUN touch /var/lock/subsys/yum-cron
RUN sed -i 's/apply_updates = no/apply_updates = yes/' /etc/yum/yum-cron.conf
RUN sed -i 's/apply_updates = no/apply_updates = yes/' /etc/yum/yum-cron-hourly.conf

copy backup.sh /
RUN chmod -R a+rwx /backup.sh

RUN ln -s /opt/rh/rh-postgresql94/root/usr/lib64/libpq.so.rh-postgresql94-5  /usr/lib64/libpq.so.rh-postgresql94-5 
RUN ln -s /opt/rh/rh-postgresql94/root/usr/lib64/libpq.so.rh-postgresql94-5  /usr/lib/libpq.so.rh-postgresql94-5

ADD crontab /app/crontab
RUN crontab /app/crontab
ADD start-cron.sh /usr/bin/start-cron.sh
RUN chmod +x /usr/bin/start-cron.sh
RUN touch /var/log/cron.log
RUN chmod a+rwx /var/log/cron.log

CMD /usr/bin/start-cron.sh


