#!/bin/bash

top_applications() {
  echo "Top 10 Most Used Applications"
  echo "------------------------------"

  echo "Top 10 Applications by CPU Usage:"
  echo "USER       PID   CPU    COMMAND"
  ps aux --sort=-%cpu | awk 'NR==1 || NR<=11 {printf "%-10s %-6s %-5s %s\n", $1, $2, $3, $11}' | head -n 10

  echo

  echo "Top 10 Applications by Memory Usage:"
  echo "USER       PID   MEM    COMMAND"
  ps aux --sort=-%mem | awk 'NR==1 || NR<=11 {printf "%-10s %-6s %-5s %s\n", $1, $2, $4, $11}' | head -n 10

  echo
}


top_applications
