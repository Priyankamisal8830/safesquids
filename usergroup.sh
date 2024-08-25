#!/bin/bash


list_users_groups() {
  echo "Listing all users and groups on the server..."
  echo "Users:"
  cut -d: -f1 /etc/passwd
  echo

  echo "Groups:"
  cut -d: -f1 /etc/group
  echo
}
check_uid_0() {
  echo "Checking for users with UID 0..."
  awk -F: '$3 == 0 { print "User with UID 0: " $1 }' /etc/passwd

  echo "Reporting non-standard users with UID 0:"
  awk -F: '$3 == 0 && $1 != "root" { print "Non-standard user with UID 0: " $1 }' /etc/passwd
  echo
}

check_user_passwords() {
  echo "Checking users without passwords or with weak passwords..."

  echo "Users without passwords:"
  awk -F: '($2 == "" || $2 == "*" || $2 == "!!") { print "User without password: " $1 }' /etc/shadow
  echo

  echo "Weak password detection requires a more complex approach. Currently, checking for default entries:"
  grep '^[^:]*:[*!]:' /etc/shadow | awk -F: '{ print "User with weak or disabled password: " $1 }'
  echo
}


main() {
  echo "Starting security audit..."
  list_users_groups
  check_uid_0
  check_user_passwords
  echo "Security audit complete."
}

main
