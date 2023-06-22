@echo off

echo Assembling...
if NSF_FILE == 0 goto nsffail
tools\asm6f.exe smb2.asm -n -c -L %* bin\smb2.nsf > bin\assembler.log
if %ERRORLEVEL% neq 0 goto buildfail
move /y smb2-nsf.lst bin > nul
move /y smb2-nsf.cdl bin > nul
echo Done.
echo.

echo SHA1 hash check:
echo 47ba60fad332fdea5ae44b7979fe1ee78de1d316ee027fea2ad5fe3c0d86f25a PRG0
echo Yours:
certutil -hashfile bin\smb2.nsf SHA256 | findstr /V ":"


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
