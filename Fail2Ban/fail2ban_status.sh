#!/bin/bash

# Fail2Ban status script for SSH jail

echo "=== Fail2Ban Status (sshd) ==="
sudo fail2ban-client status sshd

echo""
echo "=== Recent Bans in /var/log/fail2ban.log ==="
sudo tail -n 20 /var/log/fail2ban.log

echo""
echo "=== Current Date and Time ==="
date 
