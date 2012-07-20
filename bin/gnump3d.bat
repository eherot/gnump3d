@echo off

rem
rem   A simple driver for Windows this will expect to be run
rem  from C:\gnump3d2
rem
rem   It assumes that your MP3's will be stored in c:\MP3
rem  both of these may be changed.
rem
rem Steve
rem ---


rem
rem  Create a log directory to hold our access + error logs
rem
mkdir c:\gnump3d2\logs 2>null
mkdir c:\gnump3d2\logs\serving 2>null


rem
rem  Start the server up
rem
perl -Ic:\gnump3d2\lib c:\gnump3d2\bin\gnump3d2 --debug --config c:\gnump3d2\etc\gnump3d.conf.win --root c:/mp3 --fast

goto end


:notinstalled
  echo.
  echo. WARNING
  echo.
  echo "This script assumes you've unpacked the code to c:\gnump3d2"
  echo "Move this directory there and re-run the 'run.bat' file."
  echo.
  echo.
  goto end

:end
