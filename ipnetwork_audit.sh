#!/bin/bash


is_private_ip() {
  local ip="$1"
  if [[ "$ip" =~ ^10\. ]] || [[ "$ip" =~ ^172\.(1[6-9]|2[0-9]|3[0-1])\. ]] || [[ "$ip" =~ ^192\.168\. ]]; then
    echo "private"
  else
    echo "public"
  fi
}


get_ip_addresses() {
  echo "Getting all IP addresses assigned to the server..."

  
  ip_addresses=$(ip -o -4 addr show | awk '{print $4}' | cut -d/ -f1)
  
  echo "$ip_addresses"
}


check_ip_addresses() {
  echo "Categorizing IP addresses and checking service exposure..."

  ip_addresses=$(get_ip_addresses)
  
  if [ -z "$ip_addresses" ]; then
    echo "No IP addresses found."
    return
  fi

  echo "IP Address Summary:"
  for ip in $ip_addresses; do
    category=$(is_private_ip "$ip")
    echo "IP Address: $ip - Type: $category"
    
   
    if [[ "$category" == "public" ]]; then
      echo "Checking sensitive services on public IP: $ip"
      
      if ss -tuln | grep -q ":22 "; then
        echo "Warning: SSH service is exposed on public IP $ip."
      fi
    fi
  done

  echo
}


main() {
  echo "Starting IP and network configuration checks..."
  check_ip_addresses
  echo "IP and network configuration checks complete."
}


main
