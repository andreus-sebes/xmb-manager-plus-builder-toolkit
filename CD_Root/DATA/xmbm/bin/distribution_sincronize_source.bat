@echo off
title Distribute Base Source
for /f "tokens=1,2 delims==" %%G in (settings.ini) do set %%G=%%H
call "%bindir%\global_prechecks.bat" %0

:first
if not exist %dropboxdir%\Public\%id_xmbmp% goto :error_dropbox
if not exist %dropboxdir%\Public\%id_xmbmp%\SOURCE_SYNCRONISATION mkdir %dropboxdir%\Public\%id_xmbmp%\SOURCE_SYNCRONISATION
if not exist %dropboxdir%\Public\%id_xmbmp%\SOURCE_SYNCRONISATION\version.ini echo dropboxver=0.00 > %dropboxdir%\Public\%id_xmbmp%\SOURCE_SYNCRONISATION\version.ini
for /f "tokens=1,2 delims==" %%G in (%dropboxdir%\Public\%id_xmbmp%\SOURCE_SYNCRONISATION\version.ini) do set %%G=%%H
cls
echo.
echo.
%external%\cecho {04}        ����������������������������������������������������{\n}
%external%\cecho {04}        �                                                  �{\n}
%external%\cecho {04}        � {0E}       Sincronize Base Package Source{04}            �{\n}
%external%\cecho {04}        �                                                  �{\n}
%external%\cecho {04}        ����������������������������������������������������{\n}
%external%\cecho {04}        �                                                  �{\n}
%external%\cecho {04}        � {0F}Dropbox Base Source version:{02} %dropboxver%{04}                �{\n}
%external%\cecho {04}        � {0F}Local Base Source version:{02} %working_version%{04}                  �{\n}
%external%\cecho {04}        ����������������������������������������������������{\n}
%external%\cecho {04}        � {0E}1.{0F} Upload local base source to dropbox{04}           �{\n}
%external%\cecho {04}        � {0E}2.{0F} Download dropbox base source to local disk{04}    �{\n}
%external%\cecho {04}        ����������������������������������������������������{\n}
%external%\cecho {04}        �                                                  �{\n}
%external%\cecho {04}        � {0C}Attention:{0F} This will replace your base source,{04}   �{\n}
%external%\cecho {04}        � {0F}           delete all your package source and{04}    �{\n}
%external%\cecho {04}        � {0F}           builded packages{04}                      �{\n}
%external%\cecho {04}        �                                                  �{\n}
%external%\cecho {04}        ����������������������������������������������������{\n}
%external%\cecho {0F}{\n}
echo.
:ask_sincronize
set /p sincronize= What do you want to do?: 
if [%sincronize%]==[1] goto :ask_confirm
if [%sincronize%]==[2] goto :ask_confirm
goto :ask_sincronize

:ask_confirm
set /P choice= Are you sure? (Y/N): 
If /I %choice%==Y goto :ok
If /I %choice%==y goto :ok
If /I %choice%==N goto :first
If /I %choice%==n goto :first
goto :ask_confirm

:ok
if [%sincronize%]==[1] goto :upload
if [%sincronize%]==[2] goto :download

:upload
call "%bindir%\global_messages.bat" "DISTRIBUTION-BASE-UPLOAD"
rmdir /s /q "%dropboxdir%\Public\%id_xmbmp%\SOURCE_SYNCRONISATION\base-sources.original"
xcopy /E /Y "%pkgbaseoriginalsources%" "%dropboxdir%\Public\%id_xmbmp%\SOURCE_SYNCRONISATION\base-sources.original\" /s
%external%\ssr\ssr --nobackup --recurse --encoding ansi --dir "%dropboxdir%\Public\%id_xmbmp%\SOURCE_SYNCRONISATION" --include "version.ini" --alter --search "dropboxver=%dropboxver%" --replace "dropboxver=%working_version%"
goto :done

:download
call "%bindir%\global_messages.bat" "DISTRIBUTION-BASE-DOWNLOAD"
rmdir /s /q "%pkgbasesources%"
rmdir /s /q "%pkgbaseoriginalsources%"
xcopy /E /Y "%dropboxdir%\Public\%id_xmbmp%\SOURCE_SYNCRONISATION\base-sources.original" "%pkgbasesources%\" /s
xcopy /E /Y "%dropboxdir%\Public\%id_xmbmp%\SOURCE_SYNCRONISATION\base-sources.original" "%pkgbaseoriginalsources%\" /s
%external%\ssr\ssr --nobackup --recurse --encoding ansi --dir "%bindir%" --include "settings.ini" --alter --search "working_version=%working_version%" --replace "working_version=%dropboxver%"
goto :done

:done
call "%bindir%\global_messages.bat" "DISTRIBUTION-BASE-OK"
goto :end

:error_dropbox
call "%bindir%\global_messages.bat" "ERROR-DISTRIBUTION-BASE-NO-DROPBOX"
goto :end

:error_distribution
call "%bindir%\global_messages.bat" "ERROR-DISTRIBUTION-GENERIC"
goto :end

:end
exit
