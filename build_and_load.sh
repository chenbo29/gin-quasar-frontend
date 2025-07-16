#!/bin/bash

# 定义版本号参数，默认为0.0.2
VERSION=${1:latest}

# 构建Docker镜像
docker build -t gin-quasar-frontend:$VERSION .

# 检查构建是否成功
if [ $? -ne 0 ]; then
    echo "Docker镜像构建失败，退出脚本"
    exit 1
fi

# 将Docker镜像加载到kind集群中
kind load docker-image gin-quasar-frontend:$VERSION

# 检查加载是否成功
if [ $? -ne 0 ]; then
    echo "镜像加载到kind集群失败"
else
    echo "镜像已成功加载到kind集群，版本号为$VERSION"
fi
