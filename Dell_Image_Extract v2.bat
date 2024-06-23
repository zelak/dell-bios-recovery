@echo off
pushd %~dp0
set found=0
echo.
echo ------ Extracting BIOS from Dell .exe file
echo.
echo ------ Just drop .exe file on this .bat
echo.
echo ------ Ignore and close any error message, except at step 6.
echo.
echo ------ Wait 5 seconds before closing any error message at step 6, otherwise temp files will get deleted.
echo.
echo.
Pause
echo.
echo.

:req
if NOT exist dell_hdr.py (
	echo.
	echo Dell_HDR.py not found! Add it to the current folder.
	echo.
	pause
	exit
)
if NOT exist hexfind.exe (
	echo.
	echo HexFind.exe not found! Add it to the current folder.
	echo.
	pause
	exit
)
if exist C:\Users\andre\AppData\Local\Programs\Python\Python310\python.exe (
	set python=C:\Python27\python.exe
) else echo Python.exe not found! Install or input correct location in line 54. && echo. && Pause && goto :eof
if exist "%programfiles%\7-Zip\7z.exe" (
	set zip="%programfiles%\7-Zip\7z.exe"
) else if exist "%programfiles(x86)%\7-Zip\7z.exe" (
		set zip="%programfiles(x86)%\7-Zip\7z.exe"
		) else echo 7-zip not found! Install or input correct location in line 166. && echo. && Pause && goto :eof


:catch
for %%i in (%*) do (
	if /I %%~xi==.exe SET bios=%%~i
	set name=%%~ni
)
if "%bios%" == "" goto filemissing


:dell_hdr
echo 1. Searching with python...
echo.
%python% dell_hdr.py "%bios%"
if exist "%name%*.hdr" (
	ren "%name%*.hdr" "%name%.hdr"
	set ext=hdr
	goto end
)


:7zip
echo.
echo.
echo 2. Trying 7-Zip...
cd %~dp0
set ext=bin&& call :uncompr
set ext=fd&& call :uncompr
set ext=cap&& call :uncompr
set ext=rom&& call :uncompr
set ext=hdr&& call :uncompr
if %found% EQU 1 goto empty
echo.
echo Nothing found


hexfind 2F00630061007000 "%bios%" >nul
if not errorlevel 1 goto writecapfile

rem findstr /I \.cap "%bios%" >nul
rem if not errorlevel 1 goto writecapfile

findstr /I writeromfile "%bios%" >nul
if not errorlevel 1 goto writeromfile

findstr /I writehdrfile "%bios%" >nul
if not errorlevel 1 goto writehdrfile

rem findstr /I %name:~-3%.bin "%bios%" >nul
rem if not errorlevel 1 goto 7zip




:writeromfile
echo.
echo.
echo 3. Searching for .rom file...
"%bios%" /writeromfile
call :romf
"%bios%" -writeromfile
call :romf
if %found% EQU 1 goto empty
echo.
echo Nothing found


:writehdrfile
echo.
echo.
echo 4. Searching for .hdr file...
"%bios%" /writehdrfile
call :hdrf
"%bios%" -writehdrfile
call :hdrf
if %found% EQU 1 goto empty
echo.
echo Nothing found

:writecapfile
echo.
echo.
echo 5. Searching for .cap file...
"%bios%" /cap
call :capf
"%bios%" -cap
call :capf
if exist "%name%".cap goto empty
echo.
echo Nothing found


:temp
echo.
echo.
echo 6. Searching in temp...
echo.
echo DON'T close any window in the next 5 seconds! Repeat the process if extraction is longer than 3-4 seconds!
copy "%bios%" biostemp.exe >nul
START /B biostemp.exe -writeromfile
timeout /t 5 >nul
set ext=bin&&call :find
set ext=rom&&call :find
set ext=hdr&&call :find
set ext=cap&&call :find
set ext=fd&&call :find
if %found% EQU 1 goto empty
echo.
echo Nothing found


goto nothing


:find
cd %temp%
for /f %%a in ('dir /B /S *.%ext% 2^>nul') do (
	set found=1
	copy %%a "%~dp0"\"%name%".%ext% >nul
	goto end
)
exit /b


:uncompr
%zip% e "%bios%" -o"%~dp0"  *.%ext% -r >nul
if exist setup.rom del setup.rom
if exist *.%ext% (
	set found=1
	ren *.%ext% "%name%".%ext%
	goto end
)
exit /b


:romf
if exist "%name%".rom (
	echo.
	echo.
	echo SUCCESS! BIOS extracted as = %name%.rom
	echo.
	echo.
	call :again
	echo.
	echo.
	pause
	exit
)
exit /b


:hdrf
if exist "%name%".hdr (
	set ext=hdr
	goto end
)
exit /b


:capf
if exist *.cap (
	echo.
	echo.
	echo.
	echo SUCCESS! BIOS extracted as = %name%.cap
	ren *.cap "%name%".cap
	if exist *bios.bin ren *bios.bin "%name%".bin
	echo.
	echo.
	call :extr
	echo.
	echo.
	pause
	exit
)
exit /b


:again
set /p inp1=Would you also like to search for .hdr file? Type Y for Yes, any other key for No: 
if not defined inp1 goto again
if /I %inp1%==y goto writehdrfile
exit /b


:extr
set /p inp2=Would you also like to unpack the .exe file? Type Y for Yes, any other key for No: 
if not defined inp2 goto extr
if /I %inp2%==y (
	mkdir tempbios
	copy "%bios%" tempbios\tempbios.exe >nul
	cd tempbios
	tempbios.exe /ext
	timeout /t 1 >nul
	del tempbios.exe
	cd %~dp0
	ren tempbios "%name%"-unpacked
	echo.
	echo.
	if exist "%name%"-unpacked echo Success! Extracted .exe content to folder = %name%-unpacked
	echo.
	echo.
	pause
	exit
)
exit /b

:nothing
echo.
echo.
echo NOTHING! BIOS not found.
echo.
cd %~dp0
Pause
if exist biostemp.exe del biostemp.exe
exit


:end
echo.
echo.
echo SUCCESS! BIOS extracted as = %name%.%ext%
echo.
cd %~dp0
Pause
if exist biostemp.exe del biostemp.exe
exit



:filemissing
Echo BIOS file is missing or in a wrong format.
echo.
Pause
exit


:empty
if exist biostemp.exe del biostemp.exe

