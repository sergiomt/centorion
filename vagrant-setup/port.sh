#!/bin/bash

	if ! grep -q "Port 22" "/etc/ssh/sshd_config"; then
		echo "Port NOT 22 found"
	else
		echo "Port 22 found"
	fi
