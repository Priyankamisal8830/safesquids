#!/bin/bash


THRESHOLD=5


echo "Checking for suspicious SSH login attempts using journalctl..."
journalctl _COMM=sshd --since "yesterday" | grep "Failed password" | awk '{print $(NF-3)}' | sort | uniq -c | sort -nr | while read ATTEMPTS IP; do
    if [ "$ATTEMPTS" -ge "$THRESHOLD" ]; then
        echo "Suspicious activity detected from IP: $IP - $ATTEMPTS failed attempts"
    fi
done
