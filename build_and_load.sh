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

VALUES_FILE="quasar/values.yaml"

echo "更新配置文件：$VALUES_FILE"

# 检查文件存在性
if [ ! -f "$VALUES_FILE" ]; then
  echo "错误：文件 $VALUES_FILE 不存在！"
  exit 1
fi

# 替换标签（不创建备份，直接修改）
# 正则说明：
# ^\s*tag:\s*  匹配以任意空格开头、紧跟 "tag:" 和任意空格的行
# .*           匹配任意旧值
# \1$NEW_TAG   保留前面的空格和 "tag:"，替换旧值为新标签
sed -i "s/^\(\s*tag:\s*\).*/\1$VERSION/" "$VALUES_FILE"

echo "操作完成：image.tag = $VERSION"
