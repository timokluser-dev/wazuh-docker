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

if [[ "$1" = "/opt/wazuh/wazuh-dashboard/run.sh" ]]; then
    info "** Start Wazuh dashboard setup **"
    /opt/wazuh/wazuh-dashboard/setup.sh
    info "** End Wazuh dashboard setup **"
fi

echo ""
exec "$@"