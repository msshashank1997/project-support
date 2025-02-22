@echo off
REM Run Python script and capture output
for /f "tokens=*" %%i in ('python Commits.py') do set result=%%i

if "%result%"=="No new commits found" (
    echo No new commits found
    exit /b 0
) else (
    echo New commits found, updating repository...
    cd C:\nginx\nginx-1.27.4\html\Project
    git pull https://github.com/msshashank1997/Project.git main
    if errorlevel 1 (
        echo Git pull failed
        exit /b 1
    )
    
    echo Restarting nginx...
    cd C:\nginx\nginx-1.27.4
    C:\nginx\nginx-1.27.4\nginx.exe -s reload
    if errorlevel 1 (
        echo Nginx restart failed
        exit /b 1
    )
    
    echo Update completed successfully
)
