#!/bin/bash
# Wazuh Docker Copyright (C) 2017, Wazuh Inc. 
# License GPLv2

set -o errexit
set -o nounset
set -o pipefail

# Load libraries
source /opt/wazuh/wazuh-dashboard/libs/wazuh_dashboard.sh
source /opt/wazuh/libs/os.sh

# Load environment
source /opt/wazuh/wazuh-dashboard/env.sh

# Validations
validate_environment_variables

# Configurate
configure_wazuh_app_yaml
configure_wazuh_dashboard_yaml
configure_wazuh_dashboard_keystore

#  Execution scripts
start_inititization_scripts
start_custom_scripts