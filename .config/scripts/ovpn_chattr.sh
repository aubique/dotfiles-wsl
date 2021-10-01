#!/bin/bash
export OPENVPN_PATH=$XDG_CONFIG_HOME/vpn

ovpn_dns_up () {
    echo 'nameserver 208.67.222.222' | sudo tee /etc/resolv.conf
    echo 'nameserver 208.67.220.220' | sudo tee -a /etc/resolv.conf
    echo 'nameserver 192.168.1.254' | sudo tee -a /etc/resolv.conf
    #sudo cp $OPENVPN_PATH/wsl.conf /etc/wsl.conf
    sudo chattr +i /etc/resolv.conf
    echo && echo 'OpenVPN mode for DNS: ON' && echo
}

ovpn_dns_off () {
    sudo chattr -i /etc/resolv.conf
    echo "nameserver $NAMESERV" | sudo tee /etc/resolv.conf
    #sudo rm -f /etc/wsl.conf
    echo && echo 'OpenVPN mode for DNS: OFF' && echo
}

shopt -s expand_aliases
source ~/.bash_aliases

sudo mkdir -p /run/openvpn
ovpn_dns_up
wait

sudo openvpn --writepid /run/openvpn/vpn.pid --cd /etc/openvpn/ --config $XDG_CONFIG_HOME/vpn/client1.ovpn #--daemon
#PID_OVPN=$!

#wait $PID_OVPN
echo 'OpenVPN is getting closed...'
ovpn_dns_off
echo 'resolv.conf has been restored to the default settings'

