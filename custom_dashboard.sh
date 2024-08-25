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
#!/bin/bash

memory_usage_monitor() {
  echo "Memory Usage"
  echo "-------------"


  memory_stats=$(free -h)


  total_mem=$(echo "$memory_stats" | awk '/Mem:/ {print $2}')
  used_mem=$(echo "$memory_stats" | awk '/Mem:/ {print $3}')
  free_mem=$(echo "$memory_stats" | awk '/Mem:/ {print $4}')
  total_swap=$(echo "$memory_stats" | awk '/Swap:/ {print $2}')
  used_swap=$(echo "$memory_stats" | awk '/Swap:/ {print $3}')
  free_swap=$(echo "$memory_stats" | awk '/Swap:/ {print $4}')


  echo "Total Memory: $total_mem"
  echo "Used Memory: $used_mem"
  echo "Free Memory: $free_mem"
  echo "Total Swap: $total_swap"
  echo "Used Swap: $used_swap"
  echo "Free Swap: $free_swap"
}


memory_usage_monitor
#!/bin/bash

network_monitor() {

  connections=$(netstat -an | grep ESTABLISHED | wc -l)


  packet_drops=$(netstat -i | awk 'NR>2 {print $1 ": " $4 " drops"}')


  interface="eth0"  # Replace with your actual network interface name


  initial_rx_bytes=$(grep "$interface" /proc/net/dev | awk '{print $2}')
  initial_tx_bytes=$(grep "$interface" /proc/net/dev | awk '{print $10}')


  sleep 1


  final_rx_bytes=$(grep "$interface" /proc/net/dev | awk '{print $2}')
  final_tx_bytes=$(grep "$interface" /proc/net/dev | awk '{print $10}')


  rx_bytes=$((final_rx_bytes - initial_rx_bytes))
  tx_bytes=$((final_tx_bytes - initial_tx_bytes))


  mb_in=$(echo "scale=2; $rx_bytes / 1024 / 1024" | bc)
  mb_out=$(echo "scale=2; $tx_bytes / 1024 / 1024" | bc)


  echo "Network Monitoring"
  echo "------------------"
  echo "Concurrent Connections: $connections"
  echo "Packet Drops:"
  echo "$packet_drops"
  echo "Network Traffic:"
  echo "MB In: $mb_in MB"
  echo "MB Out: $mb_out MB"
  echo
}


network_monitor

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
#!/bin/bash

service_monitor() {
  echo "Service Monitoring"
  echo "------------------"


  services=("sshd" "nginx" "httpd" "iptables")


  for service in "${services[@]}"; do
    if systemctl list-units --type=service --state=running | grep -q "$service"; then
      status="running"
    else
      status="not running"
    fi


    if [ "$service" == "iptables" ]; then
      if iptables -L > /dev/null 2>&1; then
        status="active"
      else
        status="inactive"
      fi
    fi


    echo "$service: $status"
  done
}


service_monitor
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
