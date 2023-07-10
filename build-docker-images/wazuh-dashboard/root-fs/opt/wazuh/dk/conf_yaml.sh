#!/bin/bash
# Wazuh Docker Copyright (C) 2017, Wazuh Inc. 
# License GPLv2

########################
# Write a configuration setting value
#
# Arguments:
#   $1 - filepath
#   $2 - key
#   $3 - value
#   $4 - YAML type (string, int or bool)
# Returns:
#   None
#########################
conf_yaml() {
    local -r filepath="${1:?Missing filepath}"
    local -r key="${2:?Missing key}"
    local -r value="${3:-}"
    local -r type="${4:-string}"
    local -r tempfile=$(mktemp)

    case "$type" in
    string)
        yq eval "(.${key}) |= \"${value}\"" "$filepath" >"$tempfile"
        ;;
    int)
        yq eval "(.${key}) |= ${value}" "$filepath" >"$tempfile"
        ;;
    bool)
        yq eval "(.${key}) |= (\"${value}\" | test(\"true\"))" "$filepath" >"$tempfile"
        ;;
    *)
        error "Type unknown: ${type}"
        return 1
        ;;
    esac
    
    cp "$tempfile" "$filepath"
}