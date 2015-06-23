#!/bin/bash
sudo mkdir -p /home/ubuntu/.ssh/
sudo groupadd ubuntu
sudo useradd ubuntu -g ubuntu -d /home/ubuntu -s /bin/bash
sudo adduser ubuntu sudo
sudo cp ~/.ssh/authorized_keys /home/ubuntu/.ssh/
sudo chown -R ubuntu:ubuntu /home/ubuntu
sudo echo "ubuntu ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/ubuntu_no_sudo_password
sudo chmod 0440 /etc/sudoers.d/ubuntu_no_sudo_password