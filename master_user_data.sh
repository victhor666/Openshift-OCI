#!/bin/bash

sudo yum update -y
sudo yum install -y wget git zile nano net-tools docker-1.13.1 bind-utils iptables-services bridge-utils bash-completion kexec-tools sos psacct openssl-devel httpd-tools NetworkManager python-cryptography python2-pip python-devel python-passlib java-1.8.0-openjdk-headless "@Development Tools" -y >> /tmp/log.txt
sed -i -e "s/^enabled=1/enabled=0/" /etc/yum.repos.d/epel.repo
sudo systemctl unmask NetworkManager
sudo systemctl start NetworkManager
sudo systemctl enable NetworkManager
sudo yum -y --enablerepo=epel install ansible pyOpenSSL >> /tmp/log.txt
#instalamos ansible aqui
git clone https://github.com/openshift/openshift-ansible.git
cd openshift-ansible && git fetch && git checkout release-3.9 && cd ..

# sudo systemctl stop docker
# sudo systemctl restart docker
# sudo systemctl enable docker