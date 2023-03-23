#!/bin/bash

#Parse Apache Log 
# 101.236.44.127 - - [24/Oct/2017:04:11:14 -0500] "Get / HTTP/1.1" 200 225 "-" "Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.94 Safari/537.36"

#Read in file

#Arguments using the position, they start at $1
APACHE_LOG="$1"

#Check if file exists
if [[ ! -f ${APACHE_LOG} ]]
then
        echo "Please specify the path to a log file."
        exit 1
fi

# Looking for web scanners
sed -e "s/\[//g" -e "s/\"//g" ${APACHE_LOG} | \
egrep -i "test|shell|echo|passwd|select|phpmyadmin|setup|admin|w00t|" | \

awk ' BEGIN { format = "%-15s %-20s %-6s %-6s %-5s %s\n"
                printf format, "IP", "Date", "Method", "Status", "Size", "URI"
                printf format, "--", "----", "------", "------", "----", "---"}


{ printf format, $1, $4, $6, $9, $10, $7 }'

# Take the IPs from the log file, sort them, and put them into a separate file
awk ' { print $1 } ' ${APACHE_LOG} | sort -u | tee -a apachelogIPs.txt

# Puts the bad IPs into a separate bad IP table file
for badIPs in $(cat apachelogIPs.txt)
do
        echo "iptables -A INPUT -s ${badIPs} -j DROP" | tee -a badIPSIPTables.txt
done
