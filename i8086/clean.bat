@echo off
REM Intel 8086 OS Clean Script

echo ========================================
echo Cleaning build files...
echo ========================================
echo.

if exist boot.bin (
    del boot.bin
    echo [OK] Deleted boot.bin
)

if exist kernel.bin (
    del kernel.bin
    echo [OK] Deleted kernel.bin
)

if exist test.bin (
    del test.bin
    echo [OK] Deleted test.bin
)

if exist os.img (
    del os.img
    echo [OK] Deleted os.img
)

if exist test.img (
    del test.img
    echo [OK] Deleted test.img
)

echo.
echo ========================================
echo Clean completed!
echo ========================================
echo.

pause
