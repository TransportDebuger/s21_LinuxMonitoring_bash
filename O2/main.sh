#!/bin/bash

# HOSTNAME
hostname=$(hostname)

# TIMEZONE
timezone=$(timedatectl | grep 'Time zone' | awk '{print $3, $4, $5}')

# USER
user=$(whoami)

# OS
os=$(cat /etc/os-release | grep PRETTY_NAME | cut -d '"' -f 2)

# DATE
date=$(date +"%d %b %Y %H:%M:%S")

# UPTIME
uptime=$(awk '{print $1}' /proc/uptime)
uptime_human=$(uptime -p | sed 's/^up //')

# IP
ip=$(hostname -I | awk '{print $1}')

# MASK
mask=$(ifconfig | grep ${ip} | head -n 1 | awk '{print $4}')

# GATEWAY
gateway=$(route -n | grep 'UG[ \t]' | awk '{print $2}')

# RAM_TOTAL
ram_total=$(free -h | grep Mem: | awk '{printf "%.3f GB\n", $2/1024}')

# RAM_USED
ram_used=$(free -h | grep Mem: | awk '{printf "%.3f GB\n", ($2-$7)/1024}')

# RAM_FREE
ram_free=$(free -h | grep Mem: | awk '{printf "%.3f GB\n", $7/1024}')

# SPACE_ROOT
space_root=$(df -h / | tail -n 1 | awk '{printf "%.2f MB\n", $2*1000}')
space_root_used=$(df -h / | tail -n 1 | awk '{printf "%.2f MB\n", $3*1000}')
space_root_free=$(df -h / | tail -n 1 | awk '{printf "%.2f MB\n", $4*1000}')

echo "HOSTNAME = ${hostname}"
echo "TIMEZONE = ${timezone}"
echo "USER = ${user}"
echo "OS = ${os}"
echo "DATE = ${date}"
echo "UPTIME = ${uptime_human}"
echo "UPTIME_SEC = ${uptime}"
echo "IP = ${ip}"
echo "MASK = ${mask}"
echo "GATEWAY = ${gateway}"
echo "RAM_TOTAL = ${ram_total}"
echo "RAM_USED = ${ram_used}"
echo "RAM_FREE = ${ram_free}"
echo "SPACE_ROOT = ${space_root}"
echo "SPACE_ROOT_USED = ${space_root_used}"
echo "SPACE_ROOT_FREE = ${space_root_free}"

read -p "Do you want to save this information to a file? (Y/n): " answer
if [[ $answer == "Y" || $answer == "y" ]]; then
    filename=$(date +"%d_%m_%y_%H_%M_%S.status")
    
    echo "HOSTNAME = ${hostname}" > $filename
    echo "TIMEZONE = ${timezone}" >> $filename
    echo "USER = ${user}" >> $filename
    echo "OS = ${os}" >> $filename
    echo "DATE = ${date}" >> $filename
    echo "UPTIME = ${uptime_human}" >> $filename
    echo "UPTIME_SEC = ${uptime}" >> $filename
    echo "IP = ${ip}" >> $filename
    echo "MASK = ${mask}" >> $filename
    echo "GATEWAY = ${gateway}" >> $filename
    echo "RAM_TOTAL = ${ram_total}" >> $filename
    echo "RAM_USED = ${ram_used}" >> $filename
    echo "RAM_FREE = ${ram_free}" >> $filename
    echo "SPACE_ROOT = ${space_root}" >> $filename
    echo "SPACE_ROOT_USED = ${space_root_used}" >> $filename
    echo "SPACE_ROOT_FREE = ${space_root_free}" >> $filename

    echo "Information saved to $filename."
else
    echo "Exit without saving information."
fi