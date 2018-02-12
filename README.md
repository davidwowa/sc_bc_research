Erlang blockchain by Wladimir David Zakrevskyy
=====
An OTP application
Install
---
	$ ./install.sh
---
Run
---
	$ ./clean_compile_run.sh
---
Build
---
	$ ./build_release.sh
---
#Why Erlang
[Why Erlang?](https://www.infoq.com/presentations/erlang-java-scala-go-c)  
[WebPages with Chicago Boss](https://github.com/ChicagoBoss/ChicagoBoss/wiki/Quickstart)  
GUI Programming with wxErlang

#Current problems
1. rebar3 integration in windows  
[Github Issue new](https://github.com/erlang/rebar3/pull/1689)  
[Github Issue old](https://github.com/erlang/rebar3/issues/850)  
Yet no solution available!!
2. Application start in windows
3. Websockets connection

#Docker
---
    docker build --build-arg password=pass --no-cache=true -t debian:erlang1 .
---

#For me
[Erlang Book Author Blog](https://ferd.ca/)  

#Byte and Bit Calculation
```
%% bits
8 = bit_size(<<12>>).
16 = bit_size(<<0, 12>>).
...
%% bytes
3 = byte_size(<<0, 123, 2342323423423>>).

```