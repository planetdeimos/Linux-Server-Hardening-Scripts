#!/bin/sh
PASSWORD=""

ILOUSER= # Create user in ILO4 UI
ILO4= #ILO IP Address
LO=1500
HI=9000
HI2=11000

for PID in 16 30 31 32 33 34 35 36 37 38 42 43 44 45 47 48 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65
do
sshpass -p $PASSWORD ssh ILOUSER@ILO4 -o KexAlgorithms=+diffie-hellman-group14-sha1 -o HostKeyAlgorithms=+ssh-rsa -o StrictHostKeyChecking=no "fan pid $PID lo $LO"
sshpass -p $PASSWORD ssh ILOUSER@ILO4 -o KexAlgorithms=+diffie-hellman-group14-sha1 -o HostKeyAlgorithms=+ssh-rsa -o StrictHostKeyChecking=no "fan pid $PID hi $HI"
done

for PID in 01 02
do
sshpass -p $PASSWORD ssh ILOUSER@ILO4 -o KexAlgorithms=+diffie-hellman-group14-sha1 -o HostKeyAlgorithms=+ssh-rsa -o StrictHostKeyChecking=no "fan pid $PID lo $LO"
sshpass -p $PASSWORD ssh ILOUSER@ILO4 -o KexAlgorithms=+diffie-hellman-group14-sha1 -o HostKeyAlgorithms=+ssh-rsa -o StrictHostKeyChecking=no "fan pid $PID hi $HI2"
done
