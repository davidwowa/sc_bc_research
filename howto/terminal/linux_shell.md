#Crypto
`echo MTI= | base64 --decode` // 12  
`echo 12 | base64 12` // MTI=  
`openssl sha -sha256 filename`  
`echo -n "A" | openssl dgst -sha512`  

#GETH
`./geth --datadir /Volumes/HDD-777/eth/ --cache 51200 --verbosity 2 --trie-cache-gens 240`  

#IOTA
`cat /dev/urandom |LC_ALL=C tr -dc 'A-Z9' | fold -w 81 | head -n 1` 

#SYSTEM
`sudo nano /etc/dphys-swapfile`  
`sudo dphys-swapfile setup && sudo dphys-swapfile swapon`  
check architecture `uname -a`

#PACKAGE MANAGER
`dpkg -l | grep packetname`  
List all installed packages `dpkg-query -l`

#SCREEN
create new screen `screen`  
create new screen with name foo `screen -S foo`  
to reattach it `screen -r foo`  
to multi display mode `screen -x foo`  
`Ctrl + A` then `D` detach new screen  
get detached screen `screen -r` 

#Watch
`watch -n3600 command args` every hour run command witch args  
`watch -n3600 ~/git/rpi_scripts/telegram/tg_send.sh "ETH current blockchain size $(du -sh ~/Library/Ethereum/geth/chaindata)"`  

#PROZESSES
Get more process information `ps -p <pid or proc name> -o pid,vsz=MEMORY -o user,group=GROUP -o comm,args=ARGS`  
`ps -e | grep minerd`  
get logs from running process `tail -f /proc/<pid>/fd/1` and `tail -f /proc/'ps -e | grep minerd'/fd/1`  

##VIM
Select all content in vim : `% y +`  
Undo `:u`  
Set line numbers `:set number`  
Go to linenumber 48 `:48`   
Go to end of file `Shift G after Esc`  
Show statusline with line number etc. `:set ruler`  
Convert between windows and unix `:set ff=unix`  
Delete line `Shift D`  

#FILES AND FOLDERS
Number of Files in Folder
ls -l | wc -l
for file in .[^.]*; do rm "$file"; done
//SEARCH
find . -name "*poster*"
//Show disk usage
df -h
// date sort
ls -t
ls -rt
// under mac os
mdls foldername // get more info

#File encoding between dos and unix
__use other programms__
`dos2unix FILENAME`  
`unix2dos FILENAME`  
__vim__
`:set ff=unix`  
`:set ff=dos`

// FILE REPRESENTAION
xxd -b filename // show file as binary table
xxd filename // show file in HEX-Format
xxd file | less // option less enable with enter scrolling
hexdump // is alternative

//
#!/bin/bash
while IFS='' read -r line || [[ -n "$line" ]]; do
    echo "Text read from file: $line"
done < "$1"

// LOGS
Analyse all log-data
zcat -f access.log* | goaccess
Generate report from log-data
zcat -f access.log* | goaccess -a -o report.html

// CHURCHTOOLS
stat -f '%A %a %N' churchtools-3.13d.zip

// OSX
Hostname change OSX
"scutil --set HostName" mac

// GIT
gitt add .
git commit -m "commit"
push -u origin master

// NETWORK
nmap --stats-every 1s gsgsgs.hopto.org
nmap -sP 192.168.2.1/24
arp -a -n

// get ip addr
curl ipinfo.io/ip

sudo nmap -sP 192.168.1.0/24 | awk '/^Nmap/{ip=$NF}/B8:27:EB/{print ip}'

// CALCULATING IN BASH
echo "143.90+86.18+100+10" | bc -l

// STRINGS IN TERMINAL
grep -r 'balance' mist/

// UNKNOWN
Alias test='apt-get update usw'
last
