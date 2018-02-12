#!/bin/bash

#https://stackoverflow.com/questions/12471951/text-alignment-center-shell-script
COLUMNS=$(tput cols) 
c1="---build release---" 
c4="---done---"

printf "%*s\n" $(((${#c1}+$COLUMNS)/2)) "$c1"
/rebar3/rebar3 release
printf "%*s\n" $(((${#c4}+$COLUMNS)/2)) "$c4"