# 拉取基础镜像
FROM python:3.6-stretch

# 定义作者
MAINTAINER ibbd "admin@ibbd.net"

# 添加oracle支持
RUN apt-get update && apt-get install -y libaio1 unzip && rm -rf /var/lib/apt/lists/*
COPY instantclient_11_2.zip /opt/oracle/instantclient_11_2.zip
RUN unzip -o /opt/oracle/instantclient_11_2.zip -d /opt/oracle/
RUN rm -rf /opt/oracle/instantclient_11_2.zip && rm -rf /opt/oracle/__MACOSX
RUN sh -c "echo /opt/oracle/instantclient_11_2 > /etc/ld.so.conf.d/oracle-instantclient.conf"
RUN ldconfig

# 设置环境变量,关闭安装过程输入对话框
ENV DEBIAN_FRONTEND noninteractive
ENV SLUGIFY_USES_TEXT_UNIDECODE=yes
ENV AIRFLOW_HOME=/airflow
ENV LD_LIBRARY_PATH=/opt/oracle/instantclient_11_2:$LD_LIBRARY_PATH
ENV LANGUAGE zh_CN.UTF-8
ENV LANG zh_CN.UTF-8
ENV LC_ALL zh_CN.UTF-8
ENV LC_CTYPE zh_CN.UTF-8
ENV LC_MESSAGES zh_CN.UTF-8
ENV NLS_LANG=AMERICAN_AMERICA.UTF8
ENV TZ "Asia/Shanghai"
ENV TERM xterm

RUN set -ex \
    && apt-get update -yqq \
    && apt-get upgrade -yqq \
    && apt-get install -yqq --no-install-recommends \
        apt-utils \
        locales \
    && sed -i 's/^# zh_CN.UTF-8 UTF-8$/zh_CN.UTF-8 UTF-8/g' /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=zh_CN.UTF-8 LC_ALL=zh_CN.UTF-8 \
    && rm -rf \
        /var/lib/apt/lists/*
        
# 安装python的numpy, pandas, scipy, sklearn, MySQL-python|PyMySQL, cx_Oracle, elasticsearch5，apache-airflow扩展
RUN pip install numpy pandas scipy sklearn PyMySQL cx_Oracle elasticsearch5 pyelasticsearch apache-airflow

# 安装插件
# 注意插件之间不允许有空格
RUN pip install apache-airflow[mysql,ssh,jdbc,redis,celery,password,kubernetes]

# 脚本
COPY service.sh /service.sh

# 定义工作目录
WORKDIR /airflow

# 初始化默认的数据库
#RUN airflow initdb

# 容器启动则启动airflow
# airflow webserver -p 8080
#CMD ["airflow","webserver","-p","8080"]

# 编译命令
# docker build -t ibbd_airflow:v1 ./
# docker build -t ibbd_airflow:v2 ./
# docker save 'ibbd_airflow:v1' -o ibbd_airflow_v1.tar
# docker run -dti --name v1 -p 8080:8080 -v /Users/tengfei/Desktop/ibbd_airflow:/root/airflow ibbd_airflow:v1
# docker exec -ti v1 /bin/bash
