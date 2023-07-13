#!/bin/bash
# Wazuh Docker Copyright (C) 2017, Wazuh Inc. 
# License GPLv2

########################
# Check if the file or directory exist 
#
# Arguments:
#   $1 - path
# Returns:
#   boolean
#########################
file_exists() {
	local -r path="${1:?Missing path}"

    if [[ -f "$path" ]]; then
        true
    else
        false
    fi
}
