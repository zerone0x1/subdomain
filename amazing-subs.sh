#!/bin/bash
mkdir $1
cd $1
curl -s "https://jldc.me/anubis/subdomains/$1" | grep -Po "((http|https):\/\/)?(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | sort -u >1.txt
curl -s "https://otx.alienvault.com/api/v1/indicators/domain/$1/url_list?limit=100&page=1" | grep -o '"hostname": *"[^"]*' | sed 's/"hostname": "//' | sort -u >2.txt
curl -s "https://api.hackertarget.com/hostsearch/?q=$1" | sed 's/,.*//'  >3.txt
curl -s "https://jldc.me/anubis/subdomains/$1" | grep -Po "((http|https):\/\/)?(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | sort -u >4.txt
subfinder -d $1 -all -o 5.txt
assetfinder -subs-only $1 > 6.txt
cat 1.txt 2.txt 3.txt 4.txt 5.txt 6.txt >all-subs.txt
httpx -l all-subs.txt -o live.txt
#count output for all subdomains txt files
for file in *.txt; do
    echo "$file: $(cat "$file" | wc -l)"
done
