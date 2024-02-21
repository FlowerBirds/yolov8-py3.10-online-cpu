FROM python:3.10-slim

#在线编辑器标识
LABEL tempo_support_online_coding="true"

# 安装git、中文字体
ADD chinese.tar.gz /usr/share/fonts/
RUN ls -l /usr/share/fonts/chinese
RUN apt-get update && apt-get install -y git \
    && apt-get install -y xfonts-utils fontconfig && cd /usr/share/fonts/chinese \
    && chmod 755 *.ttf && mkfontscale && mkfontdir && fc-cache -fv

# 设置环境变量，设置时区TZ为上海，设置编码格式为utf-8
ENV TZ=Asia/Shanghai PYTHONIOENCODING=utf-8
# 生效设置的时区信息
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo '$TZ' > /etc/timezone

# 安装第三方包
RUN pip install tornado pymysql pandas numpy sklearn requests statsmodels scipy pyecharts matplot seaborn cx_Oracle redis

# 安装jupyter notebook
RUN pip install jupyter notebook

RUN pip install flask waitress ultralytics minio


# 安装code-server
WORKDIR /home

ADD code-server.tar.gz .

WORKDIR /opt

RUN mkdir program

CMD ["sh", "/home/code-server/start.sh"]
