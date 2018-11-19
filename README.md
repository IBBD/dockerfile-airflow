# dockerfile-airflow

## 说明事项

1. 数据库切换到mariadb无法初始化，这是由于mariadb的设置和版本有关，my.cnf要设置explicit_defaults_for_timestamp=true，版本>=10.2.9
2. 使用python3.6官方镜像作为基础镜像，同时安装了python的基础扩展(boto3、numpy、pandas、scipy、sklearn、PyMySQL、elasticsearch5)
3. work目录：/airflow

## 已经安装的插件

```sh
pip install apache-airflow[mysql,ssh,jdbc,redis,celery,password,kubernetes]
```

## Usage

```sh
# 首次启动容器
sudo docker run -ti --name=ibbd-airflow \
  -v /path/to/airflow:/airflow \
  -p 8888:8080 \
  ibbd/airflow \
  bash /service.sh

# 如果需要安装扩展，如果不需要则可以跳过
sudo docker exec -ti ibbd-airflow /bin/bash

# 初始化Airflow
sudo docker exec -ti ibbd-airflow airflow initdb

# 启动Airflow服务
sudo docker exec -d ibbd-airflow \
  airflow webserver -p 8080

# 查看日志
sudo docker logs ibbd-airflow

# 停止服务器
sudo docker stop ibbd-airflow

# 启动容器
sudo docker start ibbd-airflow
```

