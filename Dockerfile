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
WORKDIR /app/backend

# 拷贝构建好的 Go 后端
COPY --from=backend-builder /app/backend/app ./
# 拷贝 pb 和 pb_data
COPY backend/pb ./pb
COPY backend/pb_data ./pb_data

# 拷贝前端 dist
COPY --from=frontend-builder /app/frontend/dist ../frontend/dist

# 暴露 Go 后端端口
EXPOSE 3001

# 启动
CMD ["./app"]
