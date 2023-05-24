#!/bin/bash
#
# This script creates a new user on the local system.
# You must supply a username as an argument to the script.
# Optionally, you can also provide a comment for the account as an argument.
# A password will be automatically generated for the account.
# The username, password, and host for the account will be displayed.

# make sure the script is being executed with superuser privileges
if [[ "${UID}" -ne 0 ]]; then
    echo 'You need to run this command as a superuser.'
    exit 1
fi

# make sure the script is called with at least one argument
if [[ "${#}" -lt 1 ]]; then
    echo "Usage: ${0} USER_NAME [COMMENT]..."
    echo 'Please provide at least login name to create an account on the local system.'
    exit 1
fi

# save login and remove from argument list
username="${1}"; shift

# set separator to space and save full name
fullname="${@}"

# generate pseudo-random password
password=$(date +%N | sha256sum | head -c48)

if [[ "${?}" -ne 0 ]]; then
    echo 'Failed to generate random password for the account.'
    exit 1
fi

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
echo "${username}"
echo
echo 'password:'
echo "${password}"
echo
echo 'host:'
echo "${HOSTNAME}"

exit 0