# safesquids
Assignment

Set 1: Monitoring System Resources for a Proxy Serve

( 1 ):: Function: Function: top_applications

Purpose: Displays the top 10 most used applications by CPU and memory usage.

Script:

1. echo statements print headers and separators for readability.
2. ps aux command displays all running processes.
3. --sort=-%cpu sorts processes by CPU usage in descending order.
4. awk command processes the output:
    - NR==1 || NR<=11 selects the first line (header) and the next 10 lines (top 10 processes).
    - printf formats the output to display:
        - USER: username
        - PID: process ID
        - CPU/MEM: CPU/memory usage percentage
        - COMMAND: command name
5. head -n 10 limits the output to the top 10 processes.
6. The script repeats steps 2-5 for memory usage, sorting by --sort=-%mem.
Purpose: Displays the top 10 most used applications by CPU and memory usage.



(2)::Network Monitoring:
Purpose: Monitors network activity and displays key statistics.

Script:

1. connections variable stores the number of established connections using netstat.
2. packet_drops variable stores packet drop information for each interface using netstat and awk.
3. interface variable sets the network interface name (replace with your actual interface name).
4. Initial receive (initial_rx_bytes) and transmit (initial_tx_bytes) byte counts are retrieved from /proc/net/dev.
5. The script waits for 1 second using sleep.
6. Final receive (final_rx_bytes) and transmit (final_tx_bytes) byte counts are retrieved.
7. Receive (rx_bytes) and transmit (tx_bytes) byte differences are calculated.
8. Inbound (mb_in) and outbound (mb_out) traffic in megabytes is calculated using bc for decimal calculations.
9. The script displays the network monitoring statistics.



(3):: Disk Usage
Function: disk_usage_monitor

Purpose: Monitors disk usage and displays key statistics, highlighting high usage.

Script:

1. df_output variable stores the output of df command with selected columns.
2. echo statements print headers and separators.
3. while loop reads each line of df_output.
4. usage variable extracts the usage percentage using awk and tr.
5. if statement checks if usage is above 80%.
6. If true, prints the line in red using ANSI escape codes (\e[31m and \e[0m).
7. Otherwise, prints the line normally.



4.System Load:
Function: system_load_monitor

Purpose: Monitors system load and CPU usage, displaying key statistics.

Script:

1. load_avg variable stores the output of uptime command, parsing the load average using awk.
2. cpu_usage variable stores the output of top command, parsing the CPU usage breakdown using awk.
3. echo statements print headers and separators.
4. The script displays the load average and CPU usage breakdown.


5.Memory Usage:
Function: memory_usage_monitor

Purpose: Monitors memory usage and swap space, displaying key statistics.

Script:

1. memory_stats variable stores the output of free -h command.
2. total_mem, used_mem, free_mem, total_swap, used_swap, and free_swap variables extract relevant values from memory_stats using awk.
3. echo statements print headers and memory statistics.


6.Process Monitoring:
Function: process_monitor

Purpose: Monitors processes, displaying key statistics.

Script:

1. active_processes variable stores the total number of active processes using ps aux and wc -l.
2. echo statements print headers and separators.
3. ps aux commands with --sort options display top processes by CPU and memory usage.
4. awk commands format the output, displaying:
    - Username
    - PID
    - CPU/Memory percentage
    - Command name
5. head -n 5 limits the output to the top 5 processes.
6. The script displays the total active processes, subtracting 1 to exclude the header line.


7.Service Monitoring:
Function: service_monitor

Purpose: Monitors the status of specified services.

Script:

1. services array stores the names of services to monitor.
2. for loop iterates over each service in the array.
3. systemctl command checks if the service is running.
4. if statement sets the status variable to "running" or "not running" based on the service's state.
5. Special handling for iptables service:
    - iptables -L command checks if the service is active (i.e., has rules configured).
    - status variable updated to "active" or "inactive" accordingly.
6. echo statement prints the service name and its status



8.Custom Dashboard:
Disk usage
2. Memory usage
3. Network activity
4. Processes
5. Services
6. System load and CPU usage
7. Top applications by CPU and memory usage

Each script displays relevant information and statistics, helping you monitor and troubleshoot system performance




















Set 2: Script for Automating Security Audits and Server Hardening on Linux Servers


1.User and Group Audits:
Purpose: Performs a security audit on user accounts and passwords.

Script:

1. list_users_groups function:
    - Lists all users and groups on the server.
    - Uses cut to extract usernames from /etc/passwd and group names from /etc/group.
2. check_uid_0 function:
    - Checks for users with UID 0 (root privileges).
    - Uses awk to find users with UID 0 in /etc/passwd.
    - Reports non-standard users with UID 0 (i.e., not the default "root" user).
3. check_user_passwords function:
    - Checks for users without passwords or with weak passwords.
    - Uses awk to find users without passwords in /etc/shadow.
    - Uses grep and awk to find users with weak or disabled passwords (indicated by "*!" or "!!" in /etc/shadow).
4. main function:
    - Calls the three checking functions in sequence.
    - Displays messages indicating the start and end of the audit.



2.File and Directory Permissions:
Purpose: Audits file and directory permissions for security risks.

Script:

1. check_world_writable function:
    - Finds world-writable files and directories using find command.
    - Displays detailed information about each file/directory using ls -ld.
2. check_ssh_permissions function:
    - Finds .ssh directories in /home and checks their permissions.
    - Displays directory names and permissions using awk.
    - Checks for the presence of authorized_keys files in .ssh directories.
    - Finds files in .ssh directories and checks their permissions.
3. check_suid_sgid function:
    - Finds files with SUID and SGID bits set using find command.
    - Displays detailed information about each file using ls -l.
4. main function:
    - Calls the three checking functions in sequence.
    - Displays a message indicating the start and end of the audit.

Functions:

- check_world_writable: Checks for world-writable files and directories.
- check_ssh_permissions: Checks permissions on .ssh directories and files.
- check_suid_sgid: Checks for files with SUID and SGID bits set.
- main: Coordinates the audit and displays messages.



3.Service Audits:
Purpose: Audits services and ports for security risks.

Script:

1. list_running_services function:
    - Lists all running services using systemctl or service command.
    - Checks for the availability of systemctl and service commands.
2. check_critical_services function:
    - Checks the status of critical services (sshd and iptables).
    - Uses systemctl to check if sshd is running.
    - Uses iptables -L to check if iptables is active.
3. check_open_ports function:
    - Checks for services listening on non-standard or insecure ports.
    - Uses netstat or ss command to display listening ports.
    - Defines an array of insecure ports to check.
    - Loops through the array and checks for services listening on each port.
4. main function:
    - Calls the three checking functions in sequence.
    - Displays messages indicating the start and end of the audit.

Functions:

- list_running_services: Lists all running services.
- check_critical_services: Checks the status of critical services.
- check_open_ports: Checks for services listening on insecure ports.
- main: Coordinates the audit and displays messages.



4.Firewall and Network Security:
purpose: Audits firewall and network security configurations for potential risks.

Script:

1. check_firewall function:
    - Checks the status and configuration of the firewall using iptables and ufw commands.
    - Displays the status of iptables and ufw if available.
2. report_open_ports function:
    - Reports open ports and associated services using netstat or ss command.
    - Displays listening ports and services.
3. check_network_config function:
    - Checks network configurations for potential security risks.
    - Checks if IP forwarding is enabled or disabled.
    - Checks if IPv6 forwarding is enabled or disabled.
    - Checks for network interfaces in promiscuous mode.
4. main function:
    - Calls the three checking functions in sequence.
    - Displays messages indicating the start and end of the audit.

Functions:

- check_firewall: Checks firewall status and configuration.
- report_open_ports: Reports open ports and associated services.
- check_network_config: Checks network configurations for security risks.
- main: Coordinates the audit and displays messages.





5.IP and Network Configuration Checks:
Purpose: Audits IP addresses and network configurations for potential security risks.

Script:

1. is_private_ip function:
    - Determines if an IP address is private or public.
    - Checks for private IP address ranges (10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16).
2. get_ip_addresses function:
    - Retrieves all IP addresses assigned to the server using ip command.
    - Extracts IP addresses from the output using awk and cut.
3. check_ip_addresses function:
    - Categorizes IP addresses as private or public using is_private_ip function.
    - Checks for sensitive services (SSH) exposed on public IP addresses.
4. main function:
    - Calls the check_ip_addresses function to start the audit.
    - Displays messages indicating the start and end of the audit.

Functions:

- is_private_ip: Determines if an IP address is private or public.
- get_ip_addresses: Retrieves all IP addresses assigned to the server.
- check_ip_addresses: Categorizes IP addresses and checks for service exposure.
- main: Coordinates the audit and displays messages.




6.Security Updates and Patching:
Purpose: Audits security updates and patching configurations for Debian-based and Red Hat-based systems.

Script:

1. check_debian_updates function:
    - Checks for available security updates on Debian-based systems using apt-get and yum commands.
    - Checks if unattended-upgrades is installed for automatic updates.
2. check_redhat_updates function:
    - Checks for available security updates on Red Hat-based systems using yum and dnf commands.
    - Checks if dnf-automatic is installed for automatic updates.
3. ensure_auto_updates function:
    - Ensures the server is configured for regular security updates.
    - Checks for the presence of unattended-upgrades on Debian-based systems.
    - Checks for the presence of dnf-automatic on Red Hat-based systems.
4. main function:
    - Calls the three checking functions in sequence.
    - Displays messages indicating the start and end of the audit.

Functions:

- check_debian_updates: Checks for security updates on Debian-based systems.
- check_redhat_updates: Checks





7.Log Monitoring:
Purpose: Detects suspicious SSH login attempts by analyzing journalctl logs.

Script:

1. Sets a threshold value (THRESHOLD=5) for suspicious activity.
2. Uses journalctl to retrieve SSH login attempts from the previous day.
3. Filters logs for "Failed password" messages.
4. Extracts the IP address from each log entry using awk.
5. Counts and sorts the IP addresses by the number of failed attempts.
6. Loops through the sorted list and checks if the number of attempts exceeds the threshold.
7. If suspicious activity is detected, prints a warning message with the IP address and number of failed attempts.



9.Custom Security Checks:
Purpose: Runs custom security checks defined in a configuration file.

Script:

1. Specifies the configuration file path (CONFIG_FILE="/etc/security/custom_checks.conf").
2. Defines a function run_check to execute a single check:
    - Takes two arguments: check_name and check_command.
    - Prints a message indicating the check is running.
    - Executes the check_command using eval.
    - Prints a message indicating the check is complete.
3. Checks if the configuration file exists.
4. If the file exists, reads it line by line:
    - Skips empty lines and comments (starting with #).
    - Extracts the check_name and check_command from each line using awk.
    - Calls the run_check function with the extracted values.
5. If the configuration file does not exist, prints an error message.




10.Reporting and Alerting:









