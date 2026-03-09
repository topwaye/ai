#!/bin/bash

echo "========================================"
echo "学生管理系统启动脚本"
echo "========================================"
echo ""

echo "[1/2] 启动后端服务..."
cd backend
echo "正在启动 Spring Boot 后端服务..."
echo "后端服务将在 http://localhost:8080 运行"
echo ""
mvn spring-boot:run &
BACKEND_PID=$!

echo ""
echo "等待后端服务启动（约15秒）..."
sleep 15

echo ""
echo "[2/2] 启动前端页面..."
cd ../frontend
echo "正在打开前端页面..."
echo ""

# 尝试使用 Python 启动 HTTP 服务器
if command -v python3 &> /dev/null; then
    echo "使用 Python3 启动 HTTP 服务器..."
    python3 -m http.server 8000 &
    FRONTEND_PID=$!
    echo "前端服务将在 http://localhost:8000 运行"
    sleep 2
    # 在 Mac 上打开默认浏览器
    if command -v open &> /dev/null; then
        open http://localhost:8000
    # 在 Linux 上打开默认浏览器
    elif command -v xdg-open &> /dev/null; then
        xdg-open http://localhost:8000
    fi
elif command -v python &> /dev/null; then
    echo "使用 Python 启动 HTTP 服务器..."
    python -m http.server 8000 &
    FRONTEND_PID=$!
    echo "前端服务将在 http://localhost:8000 运行"
    sleep 2
    if command -v open &> /dev/null; then
        open http://localhost:8000
    elif command -v xdg-open &> /dev/null; then
        xdg-open http://localhost:8000
    fi
else
    echo "未检测到 Python，请手动打开 frontend/index.html 文件"
fi

echo ""
echo "========================================"
echo "启动完成！"
echo "========================================"
echo ""
echo "后端服务: http://localhost:8080"
echo "前端页面: http://localhost:8000"
echo ""
echo "按 Ctrl+C 停止所有服务"
echo ""

# 等待用户中断
wait
