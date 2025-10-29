# ---------- 前端构建 ----------
FROM node:20 AS frontend-builder
WORKDIR /app/frontend
COPY frontend/package*.json ./
RUN npm install
COPY frontend .
RUN npm run build

# ---------- 后端构建 ----------
FROM golang:1.25.3 AS backend-builder
WORKDIR /app/backend
COPY backend/go.mod backend/go.sum ./
RUN go mod download
COPY backend .
RUN go build -o app main.go

# ---------- 运行阶段 ----------
FROM ubuntu:22.04

# 设置最终工作目录为 /app/backend
WORKDIR /app/backend

# 拷贝后端可执行文件和 PocketBase 数据
COPY --from=backend-builder /app/backend /app/backend

# 拷贝前端构建产物
COPY --from=frontend-builder /app/frontend/dist /app/frontend/dist

# 暴露 Go 后端端口
EXPOSE 3001

# 挂载 pb_data 用于数据持久化（可选）
VOLUME ["/app/backend/pb_data"]

# 启动命令
CMD ["sh", "-c", "cd /app/backend && ./app"]
