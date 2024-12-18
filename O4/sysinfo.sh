#!/bin/bash

if [ $# -ne 4 ]; then
    echo "Error: Wrong parameters count. It mast have 4 parameters"
    exit 1
fi

for i in "$@"; do
    if ! [[ $i =~ ^[1-6]$ ]]; then
        echo "Error! Incorrect $i. Values mast be in diapason 1 to 6."
        exit 1
    fi
done

colors=(white red green blue purple black)

bg_names=$1
fg_names=$2
bg_values=$3
fg_values=$4

if [[ $bg_names -eq $fg_names || $bg_values -eq $fg_values ]]; then
    echo "Error: Values of the font and background colors are equal!"
    exit 1
fi

bg_name=${colors[$((bg_names - 1))]}
fg_name=${colors[$((fg_names - 1))]}
value_bg_name=${colors[$((bg_values - 1))]}
value_fg_name=${colors[$((fg_values - 1))]}

set_color() {
    local bg="${1}"
    local fg="${2}"
    case "$bg" in
        white) bg_code="47";;
        red) bg_code="41";;
        green) bg_code="42";;
        blue) bg_code="44";;
        purple) bg_code="45";;
        black) bg_code="40";;
    esac
    case "$fg" in
        white) fg_code="37";;
        red) fg_code="31";;
        green) fg_code="32";;
        blue) fg_code="34";;
        purple) fg_code="35";;
        black) fg_code="30";;
    esac
    printf "\e[%s;%sm" "$bg_code" "$fg_code"
}

# Вывод заголовков
print_out() {
    set_color "$bg_name" "$fg_name"
    echo -n "${1} = "
    set_color "$value_bg_name" "$value_fg_name"
    echo -n "${2}"
    tput sgr0
    echo
}

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

print_out "HOSTNAME = " "${hostname}"
print_out "TIMEZONE = " "${timezone}"
print_out "USER = " "${user}"
print_out "OS = " "${os}"
print_out "DATE = " "${date}"
print_out "UPTIME = " "${uptime_human}"
print_out "UPTIME_SEC = " "${uptime}"
print_out "IP = " "${ip}"
print_out "MASK = " "${mask}"
print_out "GATEWAY = " "${gateway}"
print_out "RAM_TOTAL = " "${ram_total}"
print_out "RAM_USED = " "${ram_used}"
print_out "RAM_FREE = " "${ram_free}"
print_out "SPACE_ROOT = " "${space_root}"
print_out "SPACE_ROOT_USED = " "${space_root_used}"
print_out "SPACE_ROOT_FREE = " "${space_root_free}"
