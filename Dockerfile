FROM nvs60/hat_os_base:latest

RUN useradd postgres

#安装编译工具
RUN yum -y install gcc readline readline-devel zlib zlib-devel gcc automake autoconf libtool make libxml2 libxml2-devel

#编译xml2需要特殊处理
RUN set -eux \
	&& cd /usr/include/ \
	&& ln -s libxml2/libxml libxml

#编译，删除代码
RUN set -eux \
        && wget https://ftp.postgresql.org/pub/source/v12.1/postgresql-12.1.tar.gz \
        &&  tar xvzf postgresql-12.1.tar.gz -C /opt && rm -f postgresql-12.1.tar.gz \
        &&  cd /opt/postgresql-12.1/ \
        && ./configure \
        && make clean; make; make install \
        && cd contrib \
        && make clean; make all; make install \
        && cp start-scripts/linux /etc/init.d/postgresql \ 
        && chmod +x /etc/init.d/postgresql \ 
        && rm -rf /opt/postgresql-12.1/
