#!/bin/bash
# Wazuh Docker Copyright (C) 2017, Wazuh Inc. 
# License GPLv2

# Load libraries
source /opt/wazuh/libs/yml.sh
source /opt/wazuh/libs/fs.sh
source /opt/wazuh/libs/log.sh

# Functions

########################
# Configure Wazuh APP YAML
#
# Globals:
#   WAZUH_APP_*
# Arguments:
#   None
# Returns:
#   None
#########################
configure_wazuh_app_yaml() {
    configurations=(
        "pattern;WAZUH_DASHBOARD_APP_PATTERN"
        "checks.pattern;WAZUH_APP_CHECKS_PATTERN;bool"
        "checks.template;WAZUH_APP_CHECKS_TEMPLATE;bool"
        "checks.api;WAZUH_APP_CHECKS_API;bool"
        "checks.setup;WAZUH_APP_CHECKS_SETUP;bool"
        "extensions.pci;WAZUH_APP_EXTENSIONS_PCI;bool"
        "extensions.gdpr;WAZUH_APP_EXTENSIONS_GDPR;bool"
        "extensions.hipaa;WAZUH_APP_EXTENSIONS_HIPAA;bool"
        "extensions.nist;WAZUH_APP_EXTENSIONS_NIST;bool"
        "extensions.tsc;WAZUH_APP_EXTENSIONS_TSC;bool"
        "extensions.audit;WAZUH_APP_EXTENSIONS_AUDIT;bool"
        "extensions.oscap;WAZUH_APP_EXTENSIONS_OSCAP;bool"
        "extensions.ciscat;WAZUH_APP_EXTENSIONS_CISCAT;bool"
        "extensions.aws;WAZUH_APP_EXTENSIONS_AWS;bool"
        "extensions.gcp;WAZUH_APP_EXTENSIONS_GCP;bool"
        "extensions.virustotal;WAZUH_APP_EXTENSIONS_VIRUSTOTAL;bool"
        "extensions.osquery;WAZUH_APP_EXTENSIONS_OSQUERY;bool"
        "extensions.docker;WAZUH_APP_EXTENSIONS_DOCKER;bool"
        "timeout;WAZUH_APP_TIMEOUT"
        "ip.selector;WAZUH_APP_API_SELECTOR;bool"
        "wazuh.monitoring.enabled;WAZUH_APP_WAZUH_MONITORING_ENABLED;bool"
        "wazuh.monitoring.frequency;WAZUH_APP_WAZUH_MONITORING_FREQUENCY"
        "wazuh.monitoring.shards;WAZUH_APP_WAZUH_MONITORING_SHARDS"
        "wazuh.monitoring.replicas;WAZUH_APP_WAZUH_MONITORING_REPLICAS"
    )

    if ! file_exists "$WAZUH_DASHBOARD_APP_CONF_FILE"; then
        touch $WAZUH_DASHBOARD_APP_CONF_FILE
        
        for config in "${configurations[@]}"; do
            IFS=';' read -ra params <<< "$config"
            if [[ ! -z "${!params[1]+x}" ]]; then
                yml_set_value "$WAZUH_DASHBOARD_APP_CONF_FILE" "${params[0]}" "${!params[1]}" "${params[2]}"
            fi
        done

        configurations_with_array_type=(
            "ip.ignore;WAZUH_APP_IP_IGNORE"
        )
        
        for config in "${configurations_with_array_type[@]}"; do
            IFS=';' read -ra params <<< "$config"
            if [[ ! -z "${!params[1]+x}" ]]; then
                yml_set_value "$WAZUH_DASHBOARD_APP_CONF_FILE" "${params[0]}" "$(yml_coerce_array_property ${!params[1]})"
            fi
        done

        yml_set_value "$WAZUH_DASHBOARD_APP_CONF_FILE" "hosts" "$(get_hosts_from_environment_variables)"
    fi
    
}

########################
# Configure the Wazuh Dashboard YAML
#
# Globals:
#   WAZUH_DASHBOARD_*
# Arguments:
#   None
# Returns:
#   None
#########################
configure_wazuh_dashboard_yaml() {
    configurations=(
        "server.host;WAZUH_DASHBOARD_SERVER_HOST;string"
        "server.port;WAZUH_DASHBOARD_SERVER_PORT"
        "opensearch.hosts;WAZUH_DASHBOARD_OPENSEARCH_HOSTS;string"
        "opensearch.ssl.verificationMode;WAZUH_DASHBOARD_OPENSEARCH_SSL_VERIFICATION_MODE;string"
        "opensearch_security.multitenancy.enabled;WAZUH_DASHBOARD_OPENSEARCH_SECURITY_MUTITENANCY_ENABLED;bool"
        "server.ssl.enabled;WAZUH_DASHBOARD_SERVER_SSL_ENABLED;bool"
        "server.ssl.key;WAZUH_DASHBOARD_SERVER_SSL_KEY;string"
        "server.ssl.certificate;WAZUH_DASHBOARD_SERVER_SSL_CERTIFICATE;string"
        "uiSettings.overrides.defaultRoute;WAZUH_DASHBOARD_UISETTINGS_OVERRIDES_DEFAULTROUTE;string"
    )

    if ! file_exists "$WAZUH_DASHBOARD_CONF_FILE"; then
        touch $WAZUH_DASHBOARD_CONF_FILE
        
        for config in "${configurations[@]}"; do
            IFS=';' read -ra params <<< "$config"
            if [[ ! -z "${!params[1]+x}" ]]; then
                yml_set_value "$WAZUH_DASHBOARD_CONF_FILE" "${params[0]}" "${!params[1]}" "${params[2]}"
            fi
        done

        configurations_with_array_type=(
            "opensearch.requestHeadersWhitelist;WAZUH_DASHBOARD_OPENSEARCH_REQUESTHEADERSWHITELIST"
            "opensearch_security.readonly_mode.roles;WAZUH_DASHBOARD_OPENSEARCH_SECURITY_READONLY_MODE_ROLES"
            "opensearch.ssl.certificateAuthorities;WAZUH_DASHBOARD_SERVER_SSL_CERTIFICATEAUTHORITIES"
        )
        
        for config in "${configurations_with_array_type[@]}"; do
            IFS=';' read -ra params <<< "$config"
            if [[ ! -z "${!params[1]+x}" ]]; then
                yml_set_value "$WAZUH_DASHBOARD_CONF_FILE" "${params[0]}" "$(yml_coerce_array_property ${!params[1]})"
            fi
        done

    fi
}

########################
# Configure the Wazuh Dashboard Keystore
#
# Globals:
#   WAZUH_DASHBOARD_*
# Arguments:
#   None
# Returns:
#   None
#########################
configure_wazuh_dashboard_keystore() {
    if ! file_exists "$WAZUH_DASHBOARD_KEYSTORE_FILE"; then
        yes | $WAZUH_DASHBOARD_BIN_DIR/opensearch-dashboards-keystore create --allow-root
    fi

    echo $WAZUH_DASHBOARD_USERNAME | $WAZUH_DASHBOARD_BIN_DIR/opensearch-dashboards-keystore add opensearch.username --force --stdin --allow-root
    echo $WAZUH_DASHBOARD_PASSWORD | $WAZUH_DASHBOARD_BIN_DIR/opensearch-dashboards-keystore add opensearch.password --force --stdin --allow-root
}

########################
# Get the hosts from environment variables
#
# Globals:
#   WAZUH_DASHBOARD_APP_HOSTS_*
# Arguments:
#   None
# Returns:
#   String - An JSON stringify with the host configuration
#########################
get_hosts_from_environment_variables() {
    configurations=$(yq e ".hosts=[]" - <<< "{}")

    for host in $(env | grep '^WAZUH_DASHBOARD_APP_HOSTS_' | cut -d'_' -f5 | sort -u); do
        local name=$(echo "$host" | tr '[:upper:]' '[:lower:]')
        local env_prefix="WAZUH_DASHBOARD_APP_HOSTS_${host}"

        local env_host_url="${env_prefix}_URL"
        local env_host_port="${env_prefix}_PORT"
        local env_host_username="${env_prefix}_USERNAME"
        local env_host_password="${env_prefix}_PASSWORD"
        local env_host_run_as="${env_prefix}_RUN_AS"

        local config=$(yq e ".${name}={}" - <<< "{}")

        if [[ ! -z "${!env_host_url+x}" ]]; then
            config=$(yq e ".${name}.url=\"${!env_host_url}\"" - <<< "$config")
        fi

        if [[ ! -z "${!env_host_port+x}" ]]; then
            config=$(yq e ".${name}.port=${!env_host_port}" - <<< "$config")
        fi

        if [[ ! -z "${!env_host_username+x}" ]]; then
            config=$(yq e ".${name}.username=\"${!env_host_username}\"" - <<< "$config")
        fi

        if [[ ! -z "${!env_host_password+x}" ]]; then
            config=$(yq e ".${name}.password=\"${!env_host_password}\"" - <<< "$config")
        fi

        if [[ ! -z "${!env_host_run_as+x}" ]]; then
            config=$(yq e ".${name}.run_as=(\"${!env_host_run_as}\" | test(\"true\"))" - <<< "$config")
        fi

        configurations=$(yq e ".hosts += $(yq -o=json '.' - <<< "$config")" - <<< "$configurations")
    done

    echo "$(yq -o=json ".hosts" - <<< "$configurations")"
}