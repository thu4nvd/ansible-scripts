#! /bin/bash

set -e

echo " * Setting root password"
sudo su - root -c 'echo root:123 | /usr/sbin/chpasswd'

echo " * Creating /root/.ssh directory"
sudo su - root -c 'mkdir -p /root/.ssh'

echo " * Adding synchronized ssh keys"
for file in `sudo su - root -c "ls /vagrant/pubkeys/*.pub"`; do
    sudo su - root -c "cat $file >> /root/.ssh/authorized_keys"
done

#if want to all vm ssh-able to each other, copy the private key of host machine to all of them
echo " * Adding private ssh keys - omni_rsa"
#for file in `sudo su - root -c "ls /vagrant/pubkeys/omni_rsa"`; do
#    sudo su - root -c "mv $file  /root/.ssh/"
sudo su - root -c "cp /vagrant/pubkeys/omni_rsa /root/.ssh/id_rsa"
#done

echo " * Enabling ssh root login"
sudo su - root -c "sed -i '/^PermitRootLogin\ no/d' /etc/ssh/sshd_config"
sudo su - root -c "sed -i '/^DenyUsers\ root/d' /etc/ssh/sshd_config"
sudo su - root -c "sed -i '/^GSSAPIAuthentication\ yes/d' /etc/ssh/sshd_config"
sudo su - root -c "systemctl restart sshd" 

#if [ $# -eq 2 ]; then
#    echo " * Change default gateway"
#    sudo su - root -c "sed -i /GATEWAY/d /etc/sysconfig/network"
#    sudo su - root -c "echo GATEWAY=$1"
#    sudo su - root -c "ip route replace default via $1 dev $2"
#fi

echo " * Done"
