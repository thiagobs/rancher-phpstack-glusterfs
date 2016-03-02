FROM ubuntu:14.04

ENV DEBIAN_FRONTEND=noninteractive

ENV NAMESPACE website
ENV GLUSTER_VOL www
ENV GLUSTER_NODE_1 gluster1
ENV GLUSTER_NODE_2 gluster2

RUN apt-get update && apt-get install -y python-software-properties software-properties-common
RUN apt-get install -y supervisor nginx php5-fpm php5-cli php5-curl php5-mysql php5-gd php5-mcrypt curl mysql-client

RUN add-apt-repository -y ppa:gluster/glusterfs-3.7 && apt-get update && apt-get install -y glusterfs-client nfs-common

RUN rm /etc/php5/fpm/pool.d/www.conf
ADD conf/php-fpm-www.conf /etc/php5/fpm/pool.d/www.conf
RUN perl -p -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini
RUN perl -p -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf

RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN rm /etc/nginx/sites-enabled/default
ADD conf/nginx-default /etc/nginx/sites-enabled/default

ADD bin/run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh
ADD conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /gluster/

CMD ["sh", "/usr/local/bin/run.sh"]
