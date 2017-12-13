#!/bin/bash

#https://stackoverflow.com/questions/12471951/text-alignment-center-shell-script
#COLUMNS=$(tput cols)
#c1="---kill erlang beams---"
#c2="---kill erlang childs---"
#c3="---done---"

#printf "%*s\n" $(((${#c1}+$COLUMNS)/2)) "$c1"
echo "exit beam.smp"
killall beam.smp

#printf "%*s\n" $(((${#c2}+$COLUMNS)/2)) "$c2"
echo "exit erl_child_setup"
killall erl_child_setup

echo "end"
#printf "%*s\n" $(((${#c3}+$COLUMNS)/2)) "$c3"