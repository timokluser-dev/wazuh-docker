#!/bin/bash
# Wazuh Docker Copyright (C) 2017, Wazuh Inc. 
# License GPLv2

# Load libraries
source /opt/wazuh/dk/conf_yaml.sh

# Functions

########################
# Configure Wazuh APP YAML
# Globals:
#   WAZUH_APP_*
# Arguments:
#   None
# Returns:
#   None
#########################
configure_wazuh_app_yaml() {
    conf_yaml "$WAZUH_APP_CONF_FILE" "pattern" "$WAZUH_APP_PATTERN"
    conf_yaml "$WAZUH_APP_CONF_FILE" "checks.pattern" "$WAZUH_APP_CHECKS_PATTERN" "bool"
    conf_yaml "$WAZUH_APP_CONF_FILE" "checks.template" "$WAZUH_APP_CHECKS_TEMPLATE" "bool"
    conf_yaml "$WAZUH_APP_CONF_FILE" "checks.api" "$WAZUH_APP_CHECKS_API" "bool"
    conf_yaml "$WAZUH_APP_CONF_FILE" "checks.setup" "$WAZUH_APP_CHECKS_SETUP" "bool"
    conf_yaml "$WAZUH_APP_CONF_FILE" "extensions.pci" "$WAZUH_APP_EXTENSIONS_PCI" "bool"
    conf_yaml "$WAZUH_APP_CONF_FILE" "extensions.gdpr" "$WAZUH_APP_EXTENSIONS_GDPR" "bool"
    conf_yaml "$WAZUH_APP_CONF_FILE" "extensions.hipaa" "$WAZUH_APP_EXTENSIONS_HIPAA" "bool"
    conf_yaml "$WAZUH_APP_CONF_FILE" "extensions.nist" "$WAZUH_APP_EXTENSIONS_NIST" "bool"
    conf_yaml "$WAZUH_APP_CONF_FILE" "extensions.tsc" "$WAZUH_APP_EXTENSIONS_TSC" "bool"
    conf_yaml "$WAZUH_APP_CONF_FILE" "extensions.audit" "$WAZUH_APP_EXTENSIONS_AUDIT" "bool"
    conf_yaml "$WAZUH_APP_CONF_FILE" "extensions.oscap" "$WAZUH_APP_EXTENSIONS_OSCAP" "bool"
    conf_yaml "$WAZUH_APP_CONF_FILE" "extensions.ciscat" "$WAZUH_APP_EXTENSIONS_CISCAT" "bool"
    conf_yaml "$WAZUH_APP_CONF_FILE" "extensions.aws" "$WAZUH_APP_EXTENSIONS_AWS" "bool"
    conf_yaml "$WAZUH_APP_CONF_FILE" "extensions.gcp" "$WAZUH_APP_EXTENSIONS_GCP" "bool"
    conf_yaml "$WAZUH_APP_CONF_FILE" "extensions.virustotal" "$WAZUH_APP_EXTENSIONS_VIRUSTOTAL" "bool"
    conf_yaml "$WAZUH_APP_CONF_FILE" "extensions.osquery" "$WAZUH_APP_EXTENSIONS_OSQUERY" "bool"
    conf_yaml "$WAZUH_APP_CONF_FILE" "extensions.docker" "$WAZUH_APP_EXTENSIONS_DOCKER" "bool"
    conf_yaml "$WAZUH_APP_CONF_FILE" "timeout" "$WAZUH_APP_TIMEOUT" "int"
    conf_yaml "$WAZUH_APP_CONF_FILE" "ip.selector" "$WAZUH_APP_API_SELECTOR" "bool"

    # Convert to array.
    # conf_yaml "$WAZUH_APP_CONF_FILE" "ip.ignore" "$WAZUH_APP_IP_IGNORE"

    conf_yaml "$WAZUH_APP_CONF_FILE" "wazuh.monitoring.enabled" "$WAZUH_APP_WAZUH_MONITORING_ENABLED" "bool"
    conf_yaml "$WAZUH_APP_CONF_FILE" "wazuh.monitoring.frequency" "$WAZUH_APP_WAZUH_MONITORING_FREQUENCY" "int"
    conf_yaml "$WAZUH_APP_CONF_FILE" "wazuh.monitoring.shards" "$WAZUH_APP_WAZUH_MONITORING_SHARDS" "int"
    conf_yaml "$WAZUH_APP_CONF_FILE" "wazuh.monitoring.replicas" "$WAZUH_APP_WAZUH_MONITORING_REPLICAS" "int"
}