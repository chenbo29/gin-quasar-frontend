# syntax=docker/dockerfile:1

# Comments are provided throughout this file to help you get started.
# If you need more help, visit the Dockerfile reference guide at
# https://docs.docker.com/go/dockerfile-reference/

# Want to help us make this template better? Share your feedback here: https://forms.gle/ybq9Krt8jtBL3iCk7

ARG NODE_VERSION=22.14.0

################################################################################
# Use node image for base image for all stages.
FROM node:${NODE_VERSION}-alpine as base

# Set working directory for all build stages.
WORKDIR /usr/src/app


################################################################################
# Create a stage for installing production dependecies.
FROM base as deps

# Download dependencies as a separate step to take advantage of Docker's caching.
# Leverage a cache mount to /root/.npm to speed up subsequent builds.
# Leverage bind mounts to package.json and package-lock.json to avoid having to copy them
# into this layer.
RUN --mount=type=bind,source=package.json,target=package.json \
    --mount=type=bind,source=package-lock.json,target=package-lock.json \
    --mount=type=cache,target=/root/.npm \
    npm ci --omit=dev

################################################################################
# Create a stage for building the application.
FROM deps as build

# Download additional development dependencies before building, as some projects require
# "devDependencies" to be installed to build. If you don't need this, remove this step.
RUN --mount=type=bind,source=package.json,target=package.json \
    --mount=type=bind,source=package-lock.json,target=package-lock.json \
    --mount=type=cache,target=/root/.npm \
    npm ci

# Copy the rest of the source files into the image.
COPY . .
# Run the build script.
RUN npm run build

################################################################################
# Create a new stage to run the application with minimal runtime dependencies
# where the necessary files are copied from the build stage.
# 基础镜像：使用轻量的Nginx镜像（alpine版本体积更小）
FROM nginx:alpine as final

# 维护者信息（可选）
LABEL maintainer="chenbotome@163.com"

# 复制打包后的前端资源到Nginx默认站点目录
# Nginx默认静态文件目录：/usr/share/nginx/html
COPY --from=build /usr/src/app/dist/spa /usr/share/nginx/html/

# 复制自定义Nginx配置（解决SPA路由、缓存等问题）
# 若不需要自定义，可省略此步（但建议配置）
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 暴露Nginx默认端口（容器内端口）
EXPOSE 80

# 启动Nginx（默认镜像已包含此命令，可省略）
CMD ["nginx", "-g", "daemon off;"]
