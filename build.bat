@echo off

findstr /b "RGME_AUDIO" config.asm >nul && goto rgmefail
findstr /b "NSF_FILE"  config.asm >nul && goto nsffail

echo Assembling...
tools\asm6f.exe smb2.asm -n -c -l %* bin\smb2.nes > bin\assembler.log
if %ERRORLEVEL% neq 0 goto buildfail
move /y smb2.lst bin > nul
move /y smb2.cdl bin > nul
echo Done.
echo.

echo Your hash number:
certutil -hashfile bin\smb2.nes SHA256 | findstr /V ":"


goto end

:rgmefail
echo The configuration is on.  Comment it if you
echo wish to build this way.
goto end

:nsffail
echo The configuration is on.  Comment it if you
echo wish to build this way.
goto end

:buildfail
echo The build seems to have failed.
goto end

:buildsame
echo Your built ROM and the original are the same.
goto end

:builddifferent
echo Your built ROM and the original differ.
echo If this is intentional, don't worry about it.
goto end


:end
echo on
