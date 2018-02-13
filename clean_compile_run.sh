#!/bin/bash

#https://stackoverflow.com/questions/12471951/text-alignment-center-shell-script

echo "remove _build folder"
rm -r _build
rm rebar.lock

#echo "clean"
#/rebar3/_build/default/bin/rebar3 clean -a

#echo "rebar update"
#/rebar3/_build/default/bin/rebar3 update

#echo "rebar auto"
#/rebar3/_build/default/bin/rebar3 auto

echo "compile"
/rebar3/_build/default/bin/rebar3 compile

echo "tree"
/rebar3/_build/default/bin/rebar3 tree

echo "run"
/rebar3/_build/default/bin/rebar3 run

echo "end"