#!/bin/bash

if [[ "${UID}" -ne 0 ]]; then
    echo 'You need to run this command as a superuser.'
    exit 1
fi

read -p 'Enter the username to create: ' username

read -p 'Enter the full name of the person that will be using this account: ' fullname

echo $username
echo $fullname



exit 0