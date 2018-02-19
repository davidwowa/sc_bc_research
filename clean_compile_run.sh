#!/bin/bash

#https://stackoverflow.com/questions/12471951/text-alignment-center-shell-script

echo "remove _build folder"
rm -r _build
rm rebar.lock

#echo "clean"
#~/git/rebar3/rebar3 clean -a

#echo "rebar update"
#~/git/rebar3/rebar3 update

#echo "rebar auto"
#~/git/rebar3/rebar3 auto

#echo "compile"
#~/git/rebar3/rebar3 compile

#echo "tree"
#~/git/rebar3/rebar3 tree

echo "run"
~/git/rebar3/rebar3 run

echo "end"