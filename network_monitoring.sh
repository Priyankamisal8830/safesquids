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

