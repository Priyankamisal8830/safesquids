#!/bin/bash

system_load_monitor() {
  echo "System Load and CPU Usage"
  echo "------------------------"

  
  load_avg=$(uptime | awk -F'load average:' '{ print $2 }')

  
  cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4 " % user, " $6 " % system, " $8 " % idle"}')

  
  echo "Load Average (1m, 5m, 15m): $load_avg"
  echo "CPU Usage Breakdown:"
  echo "$cpu_usage"
}


system_load_monitor
