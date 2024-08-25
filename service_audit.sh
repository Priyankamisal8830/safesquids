#!/bin/bash

list_running_services() {
  echo "Listing all running services..."

  
  if command -v systemctl >/dev/null 2>&1; then
    systemctl list-units --type=service --state=running
  elif command -v service >/dev/null 2>&1; then
    service --status-all 2>&1 | grep '[+]'
  else
    echo "Unsupported service manager. Please use systemd or init."
  fi

  echo
}


check_critical_services() {
  echo "Checking critical services..."

  
  if systemctl is-active --quiet sshd; then
    echo "sshd: running"
  else
    echo "sshd: not running"
  fi

  
  if command -v iptables >/dev/null 2>&1; then
    if iptables -L -n >/dev/null 2>&1; then
      echo "iptables: active"
    else
      echo "iptables: not active"
    fi
  else
    echo "iptables command not found."
  fi

  echo
}


check_open_ports() {
  echo "Checking for services listening on non-standard or insecure ports..."

  
  if command -v netstat >/dev/null 2>&1; then
    netstat -tuln
  elif command -v ss >/dev/null 2>&1; then
    ss -tuln
  else
    echo "netstat or ss command not found."
  fi

  
  insecure_ports=(1 7 9 19 21 23 25 53 69 111 135 137 139 445 514 1080 1433 1434 3306 3389 5432 5900)

  echo "Checking for insecure ports..."
  for port in "${insecure_ports[@]}"; do
    if ss -tuln | grep ":$port "; then
      echo "Warning: Service listening on port $port"
    fi
  done

  echo
}

main() {
  echo "Starting service audit..."
  list_running_services
  check_critical_services
  check_open_ports
  echo "Service audit complete."
}


main
