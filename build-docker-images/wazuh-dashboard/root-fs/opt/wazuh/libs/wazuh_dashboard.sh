#!/bin/bash
# Wazuh Docker Copyright (C) 2017, Wazuh Inc. 
# License GPLv2

# Load libraries
source /opt/wazuh/dk/conf_yaml.sh

# Functions

########################
# Configure Wazuh Dashboard YAML
# Globals:
#   WAZUH_DASHBOARD_*
# Arguments:
#   None
# Returns:
#   None
#########################
configure_wazuh_dashboard_yaml() {
    conf_yaml "$WAZUH_DASHBOARD_CONF_FILE" "server.host" "$WAZUH_DASHBOARD_HOST"
    conf_yaml "$WAZUH_DASHBOARD_CONF_FILE" "server.port" "$WAZUH_DASHBOARD_PORT_NUMBER" "int"
    conf_yaml "$WAZUH_DASHBOARD_CONF_FILE" "opensearch.hosts" "https://${WAZUH_DASHBOARD_OPENSEARCH_HOSTS}:${WAZUH_DASHBOARD_OPENSEARCH_PORT_NUMBER}"
}