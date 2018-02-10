@ECHO ON
set PATH=%PATH%;"C:\Program Files\erl9.2\bin"
::"C:\Program Files\erl9.2\bin\escript.exe"

echo remove old files
rd /s /q _build
del rebar.lock

echo %cd%

C:\Users\wdzak\git\rebar3\_build\default\bin\rebar3.cmd update
C:\Users\wdzak\git\rebar3\_build\default\bin\rebar3.cmd clean
C:\Users\wdzak\git\rebar3\_build\default\bin\rebar3.cmd auto
C:\Users\wdzak\git\rebar3\_build\default\bin\rebar3.cmd compile
C:\Users\wdzak\git\rebar3\_build\default\bin\rebar3.cmd tree
C:\Users\wdzak\git\rebar3\_build\default\bin\rebar3.cmd release
C:\Users\wdzak\git\rebar3\_build\default\bin\rebar3.cmd run
echo end