#!/bin/bash
# Wazuh Docker Copyright (C) 2017, Wazuh Inc. 
# License GPLv2

# Load libraries
source /opt/wazuh/wazuh-dashboard/libs/wazuh_dashboard.sh

# Load environment
source /opt/wazuh/wazuh-dashboard/env.sh

# Configurate
configure_wazuh_app_yaml
configure_wazuh_dashboard_yaml
configure_wazuh_dashboard_keystore

#  Execution scripts
# start_inititization_scripts
# start_execution_scripts