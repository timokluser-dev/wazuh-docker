#!/bin/bash
# Wazuh Docker Copyright (C) 2017, Wazuh Inc. 
# License GPLv2

# Load libraries
source /opt/wazuh/libs/log.sh

# Functions

########################
# Check if the provided argument is an integer
#
# Arguments:
#   $1 - Value to check
# Returns:
#   Boolean
#########################
is_int() {
    local -r int="${1:?missing value}"
    if [[ "$int" =~ ^-?[0-9]+ ]]; then
        true
    else
        false
    fi
}

########################
# Validate if the provided argument is a valid port
#
# Arguments:
#   $1 - Port to validate
# Returns:
#   Boolean and error message
#########################
is_port() {
    local value
    local unprivileged=0

    # Parse flags
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            -unprivileged)
                unprivileged=1
                ;;
            --)
                shift
                break
                ;;
            -*)
                stderr_print "unrecognized flag $1"
                return 1
                ;;
            *)
                break
                ;;
        esac
        shift
    done

    if [[ "$#" -gt 1 ]]; then
        echo "too many arguments provided"
        return 2
    elif [[ "$#" -eq 0 ]]; then
        stderr_print "missing port argument"
        return 1
    else
        value=$1
    fi

    if [[ -z "$value" ]]; then
        echo "the value is empty"
        return 1
    else
        if ! is_int "$value"; then
            echo "value is not an integer"
            return 2
        elif [[ "$value" -lt 0 ]]; then
            echo "negative value provided"
            return 2
        elif [[ "$value" -gt 65535 ]]; then
            echo "requested port is greater than 65535"
            return 2
        elif [[ "$unprivileged" = 1 && "$value" -lt 1024 ]]; then
            echo "privileged port requested"
            return 3
        fi
    fi
}