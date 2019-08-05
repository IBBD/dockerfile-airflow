#
#

# Pull base image.
FROM python:3.6-stretch

MAINTAINER Alex Cai "cyy0523xc@gmail.com"

# 安装python的numpy, pandas, scipy, sklearn, MySQL-python|PyMySQL, cx_Oracle, elasticsearch5，apache-airflow扩展
RUN pip install boto3 numpy pandas scipy scikit-learn \
        PyMySQL cx_Oracle elasticsearch5 pyelasticsearch apache-airflow \
        flask

# 安装插件
# 注意插件之间不允许有空格
RUN pip install apache-airflow[mysql,ssh,jdbc,redis,celery,password,kubernetes]

# 定义工作目录
WORKDIR /airflow

# 终端设置
# 默认值是dumb，这时在终端操作时可能会出现：terminal is not fully functional
ENV LANG C.UTF-8
ENV TERM xterm
ENV PYTHONIOENCODING utf-8
# 解决时区问题
ENV TZ "Asia/Shanghai"
