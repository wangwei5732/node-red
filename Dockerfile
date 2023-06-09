FROM  node:16.5.0-stretch-slim
EXPOSE 1880

# 环境变量
ARG HOLLICUBE_HOME=/home/hollicube

# 安装调试插件
ARG SOURCE_LIST=""
RUN if [ -n "$SOURCE_LIST" ]; then echo $SOURCE_LIST > /etc/apt/sources.list; else sed -i 's/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && sed -i 's/security.debian.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list; fi
RUN apt-get update && apt-get install -y bash coreutils vim wget ttf-dejavu curl && apt-get clean


# 添加用户
RUN groupadd -r hollicube && useradd -m -r -g hollicube hollicube

# 创建文件夹
RUN mkdir -p $HOLLICUBE_HOME/app
COPY packages/node_modules/node-red $HOLLICUBE_HOME/app/node-red
COPY packages/node_modules/node-red-contrib-mysql-storage-plugin-master $HOLLICUBE_HOME/app/node-red-contrib-mysql-storage-plugin-master

#给hollicube用户授权
RUN chown -R hollicube:hollicube $HOLLICUBE_HOME $HOLLICUBE_HOME/app

USER hollicube
WORKDIR $HOLLICUBE_HOME/app/node-red

#运行
CMD npm run release