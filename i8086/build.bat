@echo off
REM Intel 8086 OS Build Script for Windows

echo ========================================
echo Intel 8086 OS Build Script
echo ========================================
echo.

REM 检查 NASM 是否安装
where nasm >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] NASM assembler not found!
    echo Please install NASM from: https://www.nasm.us/
    pause
    exit /b 1
)

echo [1/3] Compiling bootloader...
nasm -f bin boot.asm -o boot.bin
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to compile bootloader
    pause
    exit /b 1
)
echo [OK] Bootloader compiled successfully
echo.

echo [2/3] Compiling kernel...
nasm -f bin kernel.asm -o kernel.bin
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to compile kernel
    pause
    exit /b 1
)
echo [OK] Kernel compiled successfully
echo.

echo [3/3] Creating OS image...
copy /b boot.bin + kernel.bin os.img >nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to create OS image
    pause
    exit /b 1
)
echo [OK] OS image created successfully
echo.

echo ========================================
echo Build completed successfully!
echo Output file: os.img
echo ========================================
echo.

echo To run the OS with QEMU:
echo   qemu-system-x86_64 -fda os.img
echo.

pause
