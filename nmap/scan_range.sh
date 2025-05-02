#!/bin/bash

# Use: ./scan_range.sh <start_ip> <end_ip>
# Scans IPs in range of 192.168.1.1 to 192.168.1.254

#Parameters
SUBNET=$1
START=$2
END=$3

# Timestamp for log file
TIMESTAMP=$(date +%Y%m%d%H%M%S)
LOG_FILE="nmap_scan_${SUBNET}_${START}_${END}_${TIMESTAMP}.txt"

#Check for three arguments
if [ "$#" -ne 3 ]; then
    echo "Use: $0 <subnet> <start_ip> <end_ip>"
    echo "Example: $0 192.168.1 1 254"
    exit 1
fi

#Start scan
for i in $(seq $START $END); do
    TARGET="${SUBNET}.${i}"
    echo "Scanning ${TARGET} ..."
    echo "===== $TARGET =====" >> "$LOGFILE"
    nmap -sP "$TARGET" >> "$LOGFILE" 
    echo "" >> "$LOGFILE"
    echo ""
done 

echo "---------- Scan complete: $(date) ----------" >> "$LOGFILE"
echo "Check $LOGFILE for details"

# NOTE
# This script uses -sP (ping scan) for speed, consider using -sV for version detection
# Some networks block ping scans, -sP might not work on all networks
# DO NOT RUN SCANS AGAINST NETWORKS YOU DONT HAVE PERMISSION TO TEST