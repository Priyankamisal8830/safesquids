#!/bin/bash


check_debian_updates() {
  echo "Checking for available security updates (Debian-based)..."

  if command -v apt-get >/dev/null 2>&1; then
    
    sudo yum update -q
    
    
    sudo yum upgrade -s | grep "^Inst" | grep -i security

    
    if dpkg -l | grep -q unattended-upgrades; then
      echo "unattended-upgrades is installed."
      sudo systemctl status unattended-upgrades
    else
      echo "unattended-upgrades is not installed. Consider installing it for automatic updates."
    fi
  else
    echo "apt-get command not found. This may not be a Debian-based system."
  fi

  echo
}


check_redhat_updates() {
  echo "Checking for available security updates (Red Hat-based)..."

  if command -v yum >/dev/null 2>&1; then
    
    sudo yum check-update --security
    
    
    if rpm -q dnf-automatic >/dev/null 2>&1; then
      echo "dnf-automatic is installed."
      sudo systemctl status dnf-automatic.timer
    else
      echo "dnf-automatic is not installed. Consider installing it for automatic updates."
    fi
  elif command -v dnf >/dev/null 2>&1; then
    
    sudo dnf check-update --security
    
    
    if rpm -q dnf-automatic >/dev/null 2>&1; then
      echo "dnf-automatic is installed."
      sudo systemctl status dnf-automatic.timer
    else
      echo "dnf-automatic is not installed. Consider installing it for automatic updates."
    fi
  else
    echo "yum or dnf command not found. This may not be a Red Hat-based system."
  fi

  echo
}


ensure_auto_updates() {
  echo "Ensuring server is configured for regular security updates..."

  
  if command -v apt-get >/dev/null 2>&1; then
    if dpkg -l | grep -q unattended-upgrades; then
      echo "unattended-upgrades is installed and should handle regular updates."
    else
      echo "Consider installing unattended-upgrades for automatic updates."
    fi
  fi

  
  if command -v yum >/dev/null 2>&1 || command -v dnf >/dev/null 2>&1; then
    if rpm -q dnf-automatic >/dev/null 2>&1; then
      echo "dnf-automatic is installed and should handle regular updates."
    else
      echo "Consider installing dnf-automatic for automatic updates."
    fi
  fi

  echo
}

main() {
  echo "Starting security updates and patching audit..."
  check_debian_updates
  check_redhat_updates
  ensure_auto_updates
  echo "Security updates and patching audit complete."
}


main
