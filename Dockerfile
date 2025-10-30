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

COPY --from=backend-builder /app/backend /app/backend

COPY --from=frontend-builder /app/frontend/dist /app/frontend/dist

EXPOSE 3001

VOLUME ["/app/backend/pb_data"]

CMD ["sh", "-c", "cd /app/backend && ./app"]
