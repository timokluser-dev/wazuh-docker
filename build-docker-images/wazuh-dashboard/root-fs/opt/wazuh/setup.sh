#!/bin/bash
# Wazuh Docker Copyright (C) 2017, Wazuh Inc. 
# License GPLv2

# Load libraries
source /opt/wazuh/libs/wazuh_dashboard.sh
source /opt/wazuh/libs/wazuh_app.sh

# Load environment
source /opt/wazuh/env.sh

# Configure the wazuh.yaml file.
configure_wazuh_app_yaml
# Configure the wazuh-dashboard.yaml file.
configure_wazuh_dashboard_yaml