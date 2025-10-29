# ---------- 构建前端 ----------
FROM node:20 AS frontend-builder
WORKDIR /app/frontend
COPY frontend/package*.json ./
RUN npm install
COPY frontend .
RUN npm run build

# ---------- 构建后端 ----------
FROM golang:1.25.3 AS backend-builder
WORKDIR /app/backend
COPY backend/go.mod backend/go.sum ./
RUN go mod download
COPY backend .
RUN go build -o /app/app main.go

# ---------- 运行阶段 ----------
FROM ubuntu:22.04
WORKDIR /app

# 拷贝构建产物
COPY --from=backend-builder /app/app .
COPY --from=frontend-builder /app/frontend/dist ./frontend/dist
COPY backend/pb ./backend/pb
COPY backend/pb_data ./backend/pb_data

# 仅暴露 3001（Go 服务）
EXPOSE 3001

# 启动
CMD ["./app"]
