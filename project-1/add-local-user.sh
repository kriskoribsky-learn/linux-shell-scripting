#!/bin/bash
#
# This script creates a new user on the local system.
# You will be prompted to enter the username (login), the person name, and a password.
# The username, password, and host for the account will be displayed.

# make sure the script is being executed with superuser privileges
if [[ "${UID}" -ne 0 ]]; then
    echo 'You need to run this command as a superuser.'
    exit 1
fi

# user prompts
read -p 'Enter the username to create: ' username
read -p 'Enter the full name of the person that will be using this account: ' fullname
read -p 'Enter the temporary password to use for the account: ' password

# user account creation
adduser --comment "${fullname}" --create-home ${username}

if [[ "${?}" -ne 0 ]]; then
    echo 'The account could not be created.'
    exit 1
fi

# set temp password
echo ${password} | passwd --stdin ${username} 

if [[ "${?}" -ne 0 ]]; then
    echo 'The password for the account could not be set.'
    exit 1
fi

# force password change on first login
passwd --expire ${username}

# results
echo
echo 'username:'
echo ${username}
echo
echo 'password:'
echo ${password}
echo
echo 'host:'
echo ${HOSTNAME}

exit 0