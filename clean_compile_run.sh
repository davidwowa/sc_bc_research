#!/bin/bash

#https://stackoverflow.com/questions/12471951/text-alignment-center-shell-script
#COLUMNS=$(tput cols)
#c0="---remove build folder---"
#c1="---clean---"
#c2="---compile---"
#c3="---run---"
#c4="---end---"

#printf "%*s\n" $(((${#c0}+$COLUMNS)/2)) "$c0"
echo "remove _build folder"
sudo rm -r _build
rm rebar.lock

echo "rebar auto"
~/git/rebar3/rebar3 auto

#printf "%*s\n" $(((${#c1}+$COLUMNS)/2)) "$c1"
echo "clean"
~/git/rebar3/rebar3 clean
#~/.cache/rebar3/bin/rebar3 clean

#printf "%*s\n" $(((${#c2}+$COLUMNS)/2)) "$c2"
echo "compile"
~/git/rebar3/rebar3 compile
#~/.cache/rebar3/bin/rebar3 compile

#printf "%*s\n" $(((${#c3}+$COLUMNS)/2)) "$c3"
echo "tree"
~/git/rebar3/rebar3 tree
#~/.cache/rebar3/bin/rebar3 tree

echo "run"
~/git/rebar3/rebar3 run
#~/.cache/rebar3/bin/rebar3 run

echo "end"
#printf "%*s\n" $(((${#c4}+$COLUMNS)/2)) "$c4"