@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo.
echo ============================================
echo   DONG BO TON KHO -> GITHUB PAGES
echo ============================================
echo.

:: Kiem tra Git
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [LOI] Chua cai Git! Tai tai: https://git-scm.com/download/win
    pause
    exit /b 1
)

:: Xoa lock files
if exist ".git\HEAD.lock"  del /f /q ".git\HEAD.lock"
if exist ".git\index.lock" del /f /q ".git\index.lock"

:: Khoi tao repo neu chua co
git rev-parse --git-dir >nul 2>&1
if %errorlevel% neq 0 (
    echo [SETUP] Khoi tao git...
    git init
    git branch -M main
    git config user.name "Tran Dai The"
    git config user.email "trandaithentc@gmail.com"
    git remote add origin https://github.com/trandaithe/tonkho.git
    echo [OK] Da ket noi GitHub.
    echo.
)

:: Huy rebase/merge dang do
git rebase --abort >nul 2>&1
git merge  --abort >nul 2>&1

:: Dam bao remote dung
git remote get-url origin >nul 2>&1
if %errorlevel% neq 0 (
    git remote add origin https://github.com/trandaithe/tonkho.git
)

:: Luu credential
git config credential.helper manager >nul 2>&1

:: Stage va commit
echo [1/2] Dang commit thay doi...
git add index.html push-to-github.bat

git diff --cached --quiet
if %errorlevel% neq 0 (
    git commit -m "Update index.html"
    echo [OK] Da commit.
) else (
    echo [OK] Khong co thay doi moi, se push commit hien tai len.
)

:: Hien thi commit hien tai
echo.
echo Commit se duoc day len:
git log --oneline -3
echo.

:: Push len GitHub (luon force push)
echo [2/2] Dang day len GitHub Pages...
git push --force origin main

if %errorlevel% neq 0 (
    echo.
    echo ============================================
    echo   [LOI] PUSH THAT BAI
    echo ============================================
    echo.
    echo  Token co the het han. Lam theo huong dan:
    echo  1. Vao https://github.com/settings/tokens
    echo  2. Nhan "Generate new token (classic)"
    echo  3. Tick o "repo" -> nhan Generate
    echo  4. Copy token (bat dau bang ghp_...)
    echo.
    echo  Sau do xoa token cu:
    echo  - Vao Control Panel -> Credential Manager
    echo  - Tim "git:https://github.com" -> Xoa
    echo  - Chay lai file nay, nhap token vao o Password
    echo.
    pause
    exit /b 1
)

echo.
echo ============================================
echo   THANH CONG! Web cap nhat sau 30 giay:
echo   https://trandaithe.github.io/tonkho/
echo ============================================
echo.
pause
