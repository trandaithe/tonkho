@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo.
echo ============================================
echo   DONG BO TON KHO ^-^> GITHUB PAGES
echo ============================================
echo.

:: ── Kiem tra Git da cai chua ──────────────────────────────────────────────────
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [LOI] Chua cai Git!
    echo Tai Git tai: https://git-scm.com/download/win
    pause
    exit /b 1
)

:: ── Xoa lock files neu con ton tai (tranh loi "HEAD.lock") ────────────────────
if exist ".git\HEAD.lock"  del /f /q ".git\HEAD.lock"
if exist ".git\index.lock" del /f /q ".git\index.lock"

:: ── Khoi tao repo lan dau (neu chua co) ──────────────────────────────────────
git rev-parse --git-dir >nul 2>&1
if %errorlevel% neq 0 (
    if exist ".git" rmdir /s /q ".git"
    echo [SETUP] Khoi tao git lan dau...
    git init
    git branch -M main
    git config user.name "Tran Dai The"
    git config user.email "trandaithentc@gmail.com"
    git remote add origin https://github.com/trandaithe/tonkho.git
    echo [OK] Da ket noi GitHub repo.
    echo.
)

:: ── Huy rebase/merge dang do ──────────────────────────────────────────────────
git rebase --abort >nul 2>&1
git merge  --abort >nul 2>&1

:: ── Dam bao remote dung ───────────────────────────────────────────────────────
git remote get-url origin >nul 2>&1
if %errorlevel% neq 0 (
    git remote add origin https://github.com/trandaithe/tonkho.git
)

:: ── Luu token vao Windows Credential Manager (khong hoi lai lan sau) ─────────
git config credential.helper manager >nul 2>&1

:: ── Stage cac file chinh ──────────────────────────────────────────────────────
echo [1/3] Kiem tra thay doi...
git add index.html push-to-github.bat

:: ── Kiem tra co thay doi chua commit khong ────────────────────────────────────
git diff --cached --quiet
if %errorlevel% neq 0 (
    echo [1/3] Ghi nhan thay doi moi...
    git commit -m "Update index.html"
    if %errorlevel% neq 0 (
        echo [LOI] Commit that bai.
        pause
        exit /b 1
    )
) else (
    echo [1/3] Khong co thay doi moi, kiem tra commit chua push...
)

:: ── Kiem tra co commit chua push khong ───────────────────────────────────────
for /f %%i in ('git rev-list origin/main..HEAD --count 2^>nul') do set UNPUSHED=%%i
if "%UNPUSHED%"=="" set UNPUSHED=0

if "%UNPUSHED%"=="0" (
    echo.
    echo [INFO] Moi thu da dong bo. Khong co gi moi de day len.
    echo        Truy cap ngay: https://trandaithe.github.io/tonkho/
    echo.
    pause
    exit /b 0
)

echo [2/3] Co %UNPUSHED% commit chua day len - dang push...

:: ── Push len GitHub ───────────────────────────────────────────────────────────
echo [3/3] Day len GitHub Pages...
git push --force origin main

if %errorlevel% neq 0 (
    echo.
    echo ============================================
    echo   [LOI] PUSH THAT BAI - Huong dan xac thuc:
    echo ============================================
    echo.
    echo  Buoc 1: Vao https://github.com/settings/tokens
    echo  Buoc 2: Nhan "Generate new token (classic)"
    echo  Buoc 3: Tick o "repo" roi nhan Generate
    echo  Buoc 4: Copy toan bo token (bat dau bang ghp_...)
    echo.
    echo  Khi git hoi:
    echo    Username: trandaithe
    echo    Password: DAN TOKEN VAO DAY (khong phai mat khau GitHub)
    echo.
    echo  Windows se tu dong luu token, lan sau khong hoi nua.
    echo.
    git push --force origin main
    if %errorlevel% neq 0 (
        echo [LOI] Nhap token sai hoac het han. Tao token moi va thu lai.
        pause
        exit /b 1
    )
)

echo.
echo ============================================
echo   THANH CONG! Web cap nhat sau ~30 giay:
echo   https://trandaithe.github.io/tonkho/
echo ============================================
echo.
pause
