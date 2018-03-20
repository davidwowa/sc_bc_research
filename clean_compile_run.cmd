@ECHO ON
set PATH=%PATH%;"C:\Program Files\erl9.2\bin"
::"C:\Program Files\erl9.2\bin\escript.exe"

echo remove old files
rd /s /q _build
del rebar.lock

echo %cd%

REM C:\Users\wdzak\git\rebar3\_build\default\bin\rebar3.cmd update
REM C:\Users\wdzak\git\rebar3\_build\default\bin\rebar3.cmd clean
C:\Users\wdzak\git\rebar3\_build\default\bin\rebar3.cmd auto
REM C:\Users\wdzak\git\rebar3\_build\default\bin\rebar3.cmd compile
REM C:\Users\wdzak\git\rebar3\_build\default\bin\rebar3.cmd tree
REM C:\Users\wdzak\git\rebar3\_build\default\bin\rebar3.cmd release
REM C:\Users\wdzak\git\rebar3\_build\default\bin\rebar3.cmd run
echo end