#!/bin/bash

process_monitor() {
  echo "Process Monitoring"
  echo "------------------"


  active_processes=$(ps aux | wc -l)


  echo "Top 5 Processes by CPU Usage:"
  ps aux --sort=-%cpu | awk 'NR==1 || NR<=6 {printf "%-10s %-6s %-10s %s\n", $1, $2, $3, $11}' | head -n 5

  echo


  echo "Top 5 Processes by Memory Usage:"
  ps aux --sort=-%mem | awk 'NR==1 || NR<=6 {printf "%-10s %-6s %-10s %s\n", $1, $2, $4, $11}' | head -n 5

  echo


  echo "Total Active Processes: $((active_processes - 1))"  # Subtract 1 to exclude the header line
}


process_monitor
