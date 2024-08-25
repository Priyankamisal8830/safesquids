#!/bin/bash

check_world_writable() {
  echo "Scanning for world-writable files and directories..."

  echo "World-writable files and directories:"
  find / -perm -002 -type f -exec ls -ld {} \; 2>/dev/null
  find / -perm -002 -type d -exec ls -ld {} \; 2>/dev/null

  echo
}


check_ssh_permissions() {
  echo "Checking .ssh directories for secure permissions..."

 
  find /home -type d -name '.ssh' -exec ls -ld {} \; 2>/dev/null | awk '{print "Directory: " $9 " - Permissions: " $1}'

  
  find /home -type d -name '.ssh' -exec test ! -d {}/authorized_keys \; -print 2>/dev/null

  
  find /home -type f -path '*/.ssh/*' -exec ls -l {} \; 2>/dev/null | awk '{print "File: " $9 " - Permissions: " $1}'

  echo
}


check_suid_sgid() {
  echo "Reporting files with SUID and SGID bits set..."

  echo "SUID files:"
  find / -perm -4000 -type f -exec ls -l {} \; 2>/dev/null

  echo "SGID files:"
  find / -perm -2000 -type f -exec ls -l {} \; 2>/dev/null

  echo
}


main() {
  echo "Starting file and directory permissions audit..."
  check_world_writable
  check_ssh_permissions
  check_suid_sgid
  echo "Permissions audit complete."
}

main
