#!/bin/bash 
#deployed 12.6.22   
sudo apt update -y && apt upgrade -y  

#Clean Up  
sudo apt autoremove -y  
#make sure all the updates are applied   

sudo reboot now  
