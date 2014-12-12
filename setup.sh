#!/bin/bash
#Ssniffer is a script that use sslstrip2 dns2proxy dcpdump and ettercap
#use setup.sh to install correctly dependencies
#to sniffing passwords
#Author bartx <bartx @ mail.com>
# - SSLStrip2 (https://github.com/LeonardoNve/sslstrip2)
# - DNS2Proxy (https://github.com/LeonardoNve/dns2proxy)
# - Ettercap-NG (http://ettercap.sourceforge.net/)
#Save the starting location path
if [ $USER != 'root' ]; then
	echo "You must be root to execute the script!"
	exit
fi

if [ -f /usr/bin/sslstrip2 ]; then
echo "sslstrip2 already installed"
else
echo "Downloading sslstrip2"
wget -O sslstrip2-master.zip https://github.com/LeonardoNve/sslstrip2/archive/master.zip &&
echo "Unzipping sslstrip2"
unzip sslstrip2-master.zip
echo "Installing sslstrip2"
mv sslstrip2-master /opt/sslstrip2
echo "Cleating symbolic link in /usr/bin/sslstrip2"
echo "python /opt/sslstrip2/sslstrip.py" > /usr/bin/sslstrip2
chmod +x /usr/bin/sslstrip2
echo "Creating backbox menu for sslstrip2" > /usr/share/applications/backbox-sslstrip2.desktop
echo "[Desktop Entry]" >> /usr/share/applications/backbox-sslstrip2.desktop
echo "Type=Application" >> /usr/share/applications/backbox-sslstrip2.desktop
echo "Name=sslstrip2" >> /usr/share/applications/backbox-sslstrip2.desktop
echo "Version=1.0" >> /usr/share/applications/backbox-sslstrip2.desktop
echo "Encoding=UTF-8" >> /usr/share/applications/backbox-sslstrip2.desktop
echo "Comment=sslstrip2" >> /usr/share/applications/backbox-sslstrip2.desktop
echo 'Exec=sh -c "sudo sslstrip2; bash"' >> /usr/share/applications/backbox-sslstrip2.desktop
echo "Icon=utilities-terminal" >> /usr/share/applications/backbox-sslstrip2.desktop
echo "Terminal=true" >> /usr/share/applications/backbox-sslstrip2.desktop
echo "Categories=BackBox-Sniffing;" >> /usr/share/applications/backbox-sslstrip2.desktop
fi

if [ -f /usr/bin/dns2proxy ]; then
echo "dns2proxy already installed"
else
echo "Unzipping dns2proxy"
wget -O dns2proxy-master.zip https://github.com/LeonardoNve/dns2proxy/archive/master.zip &&
unzip dns2proxy-master.zip
echo "Installing dns2proxy"
mv dns2proxy-master /opt/dns2proxy
echo "Cleating symbolic link in /usr/bin/dns2proxy"
echo 'cd /opt/dns2proxy/ && sudo exo-open --launch TerminalEmulator "python dns2proxy.py"'> /usr/bin/dns2proxy
chmod +x /usr/bin/dns2proxy
echo "Creating backbox menu for dns2proxy" > /usr/share/applications/backbox-dns2proxy.desktop
echo "[Desktop Entry]" >> /usr/share/applications/backbox-dns2proxy.desktop
echo "Type=Application" >> /usr/share/applications/backbox-dns2proxy.desktop
echo "Name=dns2proxy" >> /usr/share/applications/backbox-dns2proxy.desktop
echo "Version=1.0" >> /usr/share/applications/backbox-dns2proxy.desktop
echo "Encoding=UTF-8" >> /usr/share/applications/backbox-dns2proxy.desktop
echo "Comment=dns2proxy" >> /usr/share/applications/backbox-dns2proxy.desktop
echo 'Exec=sh -c "sudo dns2proxy; bash"' >> /usr/share/applications/backbox-dns2proxy.desktop
echo "Icon=utilities-terminal" >> /usr/share/applications/backbox-dns2proxy.desktop
echo "Terminal=true" >> /usr/share/applications/backbox-dns2proxy.desktop
echo "Categories=BackBox-Sniffing;" >> /usr/share/applications/backbox-dns2proxy.desktop
fi

if [ -f /usr/bin/ssniffer ]; then
echo "ssniffer already installed"
exit
fi


wget https://github.com/bartx84/ssniffer/raw/master/ssniffer.sh &&


mv ssniffer.sh /opt/
chmod +x /opt/ssniffer.sh
ln -s /opt/ssniffer.sh /usr/bin/ssniffer
echo "Creating backbox menu for ssniffer" > /usr/share/applications/backbox-ssniffer.desktop
echo "[Desktop Entry]" >> /usr/share/applications/backbox-ssniffer.desktop
echo "Type=Application" >> /usr/share/applications/backbox-ssniffer.desktop
echo "Name=ssniffer" >> /usr/share/applications/backbox-ssniffer.desktop
echo "Version=1.0" >> /usr/share/applications/backbox-ssniffer.desktop
echo "Encoding=UTF-8" >> /usr/share/applications/backbox-ssniffer.desktop
echo "Comment=ssniffer" >> /usr/share/applications/backbox-ssniffer.desktop
echo 'Exec=sh -c "sudo ssniffer; bash"' >> /usr/share/applications/backbox-ssniffer.desktop
echo "Icon=utilities-terminal" >> /usr/share/applications/backbox-ssniffer.desktop
echo "Terminal=true" >> /usr/share/applications/backbox-ssniffer.desktop
echo "Categories=BackBox-Sniffing;" >> /usr/share/applications/backbox-ssniffer.desktop
echo "Ssniffer and dempendencies completed"
