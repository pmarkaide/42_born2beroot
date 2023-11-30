#!/bin/bash
arc=$(uname -a)
pcpu=$(grep "physical id" /proc/cpuinfo | sort| uniq | wc -l) 
vcpu=$(grep "^processor" /proc/cpuinfo | wc -l)
fram=$(free -m | awk '$1 == "Mem:" {print $2}')
uram=$(free -m | awk '$1 == "Mem:" {print $3}')
pram=$(free | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')
fdisk=$(df -BG | grep '^/dev/' | grep -v '/boot$' | awk '{ft += $2} END {print ft}')
udisk=$(df -BM | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} END {print ut}')
pdisk=$(df -BM | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} {ft+= $2} END {printf("%d"), ut/ft*100}')
cpul=$(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $2 + $3}')
lb=$(last -x | grep reboot|awk '{print $5,$6,$7,$8}'|head -1)
lvmu=$(if [ $(lsblk | grep "lvm" | wc -l) -eq 0 ]; then echo no; else echo yes; fi)
ctcp=$(ss -neopt state established | grep -v Process| wc -l)
ulog=$(users | wc -w)
ip=$(hostname -I)
mac=$(ip link show | grep "ether" | awk '{print $2}')
cmds=$(journalctl _COMM=sudo | grep COMMAND | wc -l)
wall "
 _______  _______              _______  __   __  _______  _______  __   __  _______  ______   
|       ||       |            |       ||  | |  ||       ||       ||  | |  ||   _   ||    _ | 
|    ___||_     _|            |    _  ||  | |  ||_     _||       ||  |_|  ||  |_|  ||   | ||  
|   |___   |   |              |   |_| ||  |_|  |  |   |  |       ||       ||       ||   |_||_ 
|    ___|  |   |              |    ___||       |  |   |  |      _||       ||       ||    __  |
|   |      |   |     _____    |   |    |       |  |   |  |     |_ |   _   ||   _   ||   |  | |
|___|      |___|    |_____|   |___|    |_______|  |___|  |_______||__| |__||__| |__||___|  |_|
#Architecture: $arc
#CPU physical: $pcpu
#vCPU: $vcpu
#Memory Usage: $uram/${fram}MB ($pram%)
#Disk Usage: $udisk/${fdisk}Gb ($pdisk%)
#CPU load: $cpul
#Last boot: $lb
#LVM use: $lvmu
#Connections TCP: $ctcp ESTABLISHED
#User log: $ulog
#Network: IP $ip ($mac)
#Sudo: $cmds cmd"
