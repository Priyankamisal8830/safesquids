#!/bin/bash


check_firewall() {
  echo "Verifying firewall status and configuration..."

  
  if command -v iptables >/dev/null 2>&1; then
    echo "iptables status:"
    sudo iptables -L -n -v
  else
    echo "iptables command not found."
  fi

  
  if command -v ufw >/dev/null 2>&1; then
    echo "ufw status:"
    sudo ufw status verbose
  else
    echo "ufw command not found."
  fi

  echo
}


report_open_ports() {
  echo "Reporting open ports and associated services..."

  
  if command -v netstat >/dev/null 2>&1; then
    netstat -tuln
  elif command -v ss >/dev/null 2>&1; then
    ss -tuln
  else
    echo "netstat or ss command not found."
  fi

  echo
}


check_network_config() {
  echo "Checking network configurations..."

 
  ip_forwarding=$(sysctl net.ipv4.ip_forward | awk '{print $3}')
  if [ "$ip_forwarding" -eq 1 ]; then
    echo "IP forwarding is enabled."
  else
    echo "IP forwarding is disabled."
  fi

  
  ipv6_forwarding=$(sysctl net.ipv6.conf.all.forwarding | awk '{print $3}')
  if [ "$ipv6_forwarding" -eq 1 ]; then
    echo "IPv6 forwarding is enabled."
  else
    echo "IPv6 forwarding is disabled."
  fi

  
  echo "Checking for other common insecure configurations..."
  
  if ip link | grep -q 'PROMISC'; then
    echo "Warning: Network interface(s) in promiscuous mode detected."
  else
    echo "No network interfaces in promiscuous mode detected."
  fi

  echo
}


main() {
  echo "Starting firewall and network security audit..."
  check_firewall
  report_open_ports
  check_network_config
  echo "Firewall and network security audit complete."
}

main
