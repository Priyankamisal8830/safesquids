#!/bin/bash

disk_usage_monitor() {
  echo "Disk Usage Monitor"
  echo "------------------"

  
  df_output=$(df -h --output=source,fstype,size,used,avail,pcent,target | grep -E '^/dev/')

  echo "Filesystem      Type      Size  Used  Avail  Use%  Mounted on"
  echo "$df_output" | while read -r line; do
    usage=$(echo "$line" | awk '{print $5}' | tr -d '%')  
    if [ "$usage" -ge 80 ]; then
      echo -e "\e[31m$line\e[0m"  
    else
      echo "$line"
    fi
  done
}


disk_usage_monitor
