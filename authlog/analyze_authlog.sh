#!/bin/bash

# Use: ./analyze_authlog.sh [number of lines]
# If no given argument, shows last 100 lines

LOGFILE="/var/log/auth.log"
LINES=${1:-100}
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTFILE="authlog_analysis_$TIMESTAMP.txt"

# Writes both to file and terminal
log() {
  echo -e "$1" | tee -a "$OUTFILE"
}

# Checks for file
if [ ! -f "$LOGFILE" ]; then
    echo "auth.log not found. Check the log's location or run the script with sudo"
    exit 1
fi

echo "=== Analyzing the last $LINES lines from $LOGFILE ==="
ehco ""

# 1. Failed logins
echo "--- Failed loggins ---"
grep "Failed password" "$LOGFILE" | tail -n $LINES| tee -a "$OUTFILE"

# 2. Users that dont exist
echo ""
echo "--- Attemps with invalid usernames ---"
grep "Invalid user" "$LOGFILE" | tail -n $LINES| tee -a "$OUTFILE"

# 3. Successful root/logins
echo ""
echo "--- Root-logins ---"
grep "Accepted.*root" "$LOGFILE" | tail -n $LINES| tee -a "$OUTFILE"

# 4. Sudo-usage
echo ""
echo "--- Use of sudo ---"
grep "sudo" "$LOGFILE" | tail -n $LINES | tee -a "$OUTFILE"

# 5. IP-addresses with multiple failed attempts
echo""
echo "--- IP-addresses with multiple failed attempts ---"
grep "Failed password" "$LOGFILE" | awk '{print $(NF-3)}' | sort | uniq -c | sort -nr | head | tee -a "$OUTFILE"

echo ""
echo "=== Analysis Complete and saved to $OUTFILE ==="