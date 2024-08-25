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
