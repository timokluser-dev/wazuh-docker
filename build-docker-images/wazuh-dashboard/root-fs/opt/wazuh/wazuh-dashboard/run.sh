#!/bin/bash
# Wazuh Docker Copyright (C) 2017, Wazuh Inc. 
# License GPLv2

set -o errexit
set -o nounset
set -o pipefail

# Load libraries
source /opt/wazuh/libs/log.sh

# Load environment
source /opt/wazuh/wazuh-dashboard/env.sh

info "** Start Wazuh dashboard **"
exec $WAZUH_DASHBOARD_BIN_DIR/opensearch-dashboards -c $WAZUH_DASHBOARD_CONF_FILE