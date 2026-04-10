@echo off
cd /d "%~dp0"
echo.
echo ============================================
echo   DONG BO TON KHO - GITHUB PAGES
echo ============================================
echo.

git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [LOI] Chua cai Git!
    echo Tai Git tai: https://git-scm.com/download/win
    pause
    exit /b 1
)

:: Kiem tra git repo co hop le khong
git rev-parse --git-dir >nul 2>&1
if %errorlevel% neq 0 (
    if exist ".git" rmdir /s /q ".git"
    echo [SETUP] Khoi tao git lan dau...
    git init
    git branch -M main
    git config user.name "Tran Dai The"
    git config user.email "trandaithentc@gmail.com"
    git remote add origin https://github.com/trandaithe/tonkho.git
    echo [OK] Da ket noi voi GitHub repo.
    echo.
)

:: Huy bo rebase/merge dang do (neu co)
git rebase --abort >nul 2>&1
git merge --abort >nul 2>&1

:: Dam bao remote dung
git remote get-url origin >nul 2>&1
if %errorlevel% neq 0 (
    git remote add origin https://github.com/trandaithe/tonkho.git
)

echo [1/2] Ghi nhan thay doi...
git add index.html push-to-github.bat

git diff --cached --quiet
if %errorlevel% equ 0 (
    echo.
    echo [INFO] Khong co thay doi moi de dong bo.
    pause
    exit /b 0
)

git commit -m "Update index.html"
if %errorlevel% neq 0 (
    echo [LOI] Commit that bai.
    pause
    exit /b 1
)

echo [2/2] Day len GitHub Pages (force push)...
git push --force origin main

if %errorlevel% neq 0 (
    echo.
    echo [LOI] Push that bai. Huong dan xac thuc:
    echo   1. Vao https://github.com/settings/tokens
    echo   2. Generate new token ^(classic^) - tick muc "repo"
    echo   3. Dung token lam mat khau khi git hoi password
    pause
    exit /b 1
)

echo.
echo ============================================
echo   THANH CONG! Cap nhat sau ~30 giay tai:
echo   https://trandaithe.github.io/tonkho/
echo ============================================
echo.
pause
