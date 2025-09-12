#!/bin/bash
#written 1.19.25
#Updated 9.10.25
apt install sudo -y

# Define the cron job to be added
cron_job="0 3 * * 0 /root/update_script.sh"

# Check if the cron job already exists in the crontab
(crontab -l | grep -v -F "$cron_job"; echo "$cron_job") | crontab -

echo "Cron job added: $cron_job"

######### Setup SNMP (OPTIONAL) ###########
read -p "Do you want to install and configure SNMP? (y/n): " install_snmp
if [[ "$install_snmp" =~ ^[Yy](es)?$ ]]; then
    apt install snmp -y
    mv snmpd.conf /etc/snmp/snmpd.conf
    echo "Moved snmpd.conf to /etc/snmp/. MAKE SURE TO UPDATE THE SYSINFO!!!!"

    sed -i "s/sysLocation    UNCONFIGURED TEMPLATE. PLEASE DONT FORGET TO UPDATE ME!/sysLocation    $(hostname)/" /etc/snmp/snmpd.conf
    echo "SNMP hostname changed"
else
    echo "SNMP installation skipped."
fi

######### Setup Fail2ban (OPTIONAL) ###########
read -p "Do you want to install Fail2ban? (y/n): " install_f2b
if [[ "$install_f2b" =~ ^[Yy](es)?$ ]]; then
    apt install fail2ban -y
    systemctl enable fail2ban

    # Optional: create a basic jail.local for SSH protection
    if [ ! -f /etc/fail2ban/jail.local ]; then
        cat <<EOF > /etc/fail2ban/jail.local
[sshd]
enabled = true
port    = ssh
logpath = %(sshd_log)s
maxretry = 5
EOF
        systemctl restart fail2ban
        echo "Fail2ban Enabled"
    fi
else
    echo "Fail2ban installation skipped."
fi

######### Setup New Admin User ###########
USERNAME="CHANGEME"   # New Admin User to replace root login -----!!!!!!!!!!!!!!!!!! CHANGE THIS !!!!!!!!!!!!!!!!!!
PASSWORD="CHANGEME54321" # TEMPORARY PASSWORD FOR New account login 

# Create the user
useradd -m $USERNAME

# Set the password for the new user
echo "$USERNAME:$PASSWORD" | chpasswd

# Optional: force user to change password on first login
chage -d 0 $USERNAME

echo "User $USERNAME created and password set."

############## Lock Down Root Account #############
echo "Now Locking Down Root User"
usermod --append --groups sudo $USERNAME
sudo usermod root --shell /sbin/nologin
sudo passwd --lock root

############# Update and Reboot System ##############
echo "Now Updating System, Reboot Soon"

sudo apt update -y && sudo apt upgrade -y
sudo apt autoremove -y

sudo reboot now
