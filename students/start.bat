@echo off
echo ========================================
echo 学生管理系统启动脚本
echo ========================================
echo.

echo [1/2] 启动后端服务...
cd backend
echo 正在启动 Spring Boot 后端服务...
echo 后端服务将在 http://localhost:8080 运行
echo.
start "Spring Boot Backend" cmd /k "mvn spring-boot:run"

echo.
echo 等待后端服务启动（约15秒）...
timeout /t 15 /nobreak

echo.
echo [2/2] 启动前端页面...
cd ..\frontend
echo 正在打开前端页面...
echo.

REM 尝试使用 Python 启动 HTTP 服务器
python --version >nul 2>&1
if %errorlevel% == 0 (
    echo 使用 Python 启动 HTTP 服务器...
    start "Frontend Server" python -m http.server 8000
    echo 前端服务将在 http://localhost:8000 运行
    timeout /t 2 /nobreak
    start http://localhost:8000
) else (
    echo 未检测到 Python，直接打开 index.html 文件...
    start index.html
)

echo.
echo ========================================
echo 启动完成！
echo ========================================
echo.
echo 后端服务: http://localhost:8080
echo 前端页面: http://localhost:8000（或直接打开的HTML文件）
echo.
echo 按任意键关闭此窗口...
pause >nul
