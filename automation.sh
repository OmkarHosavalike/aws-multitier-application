#!/bin/bash

log="/home/ec2-user/multitier.log"
touch $log

echo "Starting script at `date`" >> $log

echo "Initializing Terraform" >> $log 
terraform init

echo "Applying terraform template" >> $log
terraform apply --auto-approve

echo "Setting ansible configs and ansible setup script to executable mode" >> $log
export ANSIBLE_HOST_KEY_CHECKING=False
chmod +x preansible-tasks.sh

echo "Running pre-ansible play task script" >> $log
./preansible-tasks.sh

echo "Setting up frontend though ansible" >> $log
ansible-playbook -i inventory.ini frontend_setup.yml

echo "Setting up backend through ansible" >> $log
ansible-playbook -i inventory.ini backend_setup.yml

echo "Script executed successfully at `date`" >> $log
