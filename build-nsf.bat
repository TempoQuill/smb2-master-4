@echo off

echo Assembling...
tools\asm6f.exe smb2.asm -n -c -l %* bin\smb2.nsf > bin\assembler.log
if %ERRORLEVEL% neq 0 goto buildfail
move /y smb2-nsf.lst bin > nul
move /y smb2-nsf.cdl bin > nul
echo Done.
echo.

echo Your hash number.
certutil -hashfile bin\smb2.nsf SHA256 | findstr /V ":"


goto end

:rgmefail
echo You are trying to build a proper NSF.  Comment
echo the configuration if you wish to build this way.
goto end

:nsffail
echo The configuration is off.  Uncomment it if you
echo wish to build this way.
goto end

:buildfail
echo The build seems to have failed.
goto end

:buildsame
echo Your built NSF and the original are the same.
goto end

:builddifferent
echo Your built NSF and the original differ.
echo If this is intentional, you're all set.
goto end


:end
echo on
