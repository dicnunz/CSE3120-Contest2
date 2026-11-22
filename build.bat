@echo off
REM Builds Frontier.exe with MASM and the Irvine32 library.
REM Run it from the "x86 Native Tools Command Prompt for VS".
REM Irvine32 has to be installed in C:\Irvine.
REM Everything ml and link print is saved in build.log. When the build
REM fails, the log is also copied to the clipboard, ready to paste.
set IRVINE=C:\Irvine
ml /nologo /c /coff /Zi /I"%IRVINE%" Main.asm Board.asm Render.asm Feedback.asm > build.log 2>&1
if errorlevel 1 goto Failed
link /nologo /debug /incremental:no /subsystem:console /safeseh:no /libpath:"%IRVINE%" /out:Frontier.exe Main.obj Board.obj Render.obj Irvine32.lib kernel32.lib user32.lib Feedback.obj >> build.log 2>&1
if errorlevel 1 goto Failed
type build.log
echo Build succeeded: Frontier.exe
goto :eof
:Failed
type build.log
clip < build.log
echo Build failed. The errors are in build.log and on the clipboard.
exit /b 1
