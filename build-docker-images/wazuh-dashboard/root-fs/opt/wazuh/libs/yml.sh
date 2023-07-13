#!/bin/bash
# Wazuh Docker Copyright (C) 2017, Wazuh Inc. 
# License GPLv2

########################
# Write a configuration setting value
#
# Arguments:
#   $1 - path
#   $2 - key
#   $3 - value
#   $4 - YML type (string, int or bool)
# Returns:
#   None
#########################
yml_set_value() {
    local -r path="${1:?Missing path}"
    local -r key="${2:?Missing key}"
    local -r value="${3:-}"
    local -r type="${4:-}"
    local -r path_temp=$(mktemp)


    case "$type" in
    string)
        yq e "(.${key}) |= \"${value}\"" "$path" > "$path_temp"
        ;;
    bool)
        yq e "(.${key}) |= (\"${value}\" | test(\"true\"))" "$path" > "$path_temp"
        ;;
    *)
        yq e "(.${key}) |= ${value}" "$path" > "$path_temp"
        ;;
    esac
    
    cp "$path_temp" "$path"
}


########################
# Coerce a string value to a array
#
# Arguments:
#   $1 - string
# Returns:
#   None
#########################
yml_coerce_array_property() {
    local -r string="${1:?Missing string}"

    echo $(yq -o=json ". | split(\",\")" - <<< "$string")
}