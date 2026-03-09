@echo off
REM Intel 8086 OS Test Build Script for Windows

echo ========================================
echo Intel 8086 OS Test Build Script
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

echo [1/4] Compiling bootloader...
nasm -f bin boot.asm -o boot.bin
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to compile bootloader
    pause
    exit /b 1
)
echo [OK] Bootloader compiled successfully
echo.

echo [2/4] Compiling test program...
nasm -f bin test.asm -o test.bin
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to compile test program
    pause
    exit /b 1
)
echo [OK] Test program compiled successfully
echo.

echo [3/4] Creating test image...
copy /b boot.bin + test.bin test.img >nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to create test image
    pause
    exit /b 1
)
echo [OK] Test image created successfully
echo.

echo [4/4] Creating OS image...
nasm -f bin kernel.asm -o kernel.bin
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
echo Output files:
echo   - test.img (test program)
echo   - os.img  (full OS)
echo ========================================
echo.

echo To run the test program:
echo   qemu-system-x86_64 -fda test.img
echo.

echo To run the full OS:
echo   qemu-system-x86_64 -fda os.img
echo.

pause
