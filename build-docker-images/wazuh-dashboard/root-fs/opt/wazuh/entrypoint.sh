#!/bin/bash
# Wazuh Docker Copyright (C) 2017, Wazuh Inc. 
# License GPLv2

# Load environment
source /opt/wazuh/env.sh

if [[ "$1" = "/opt/wazuh/run.sh" ]]; then
    /opt/wazuh/setup.sh
fi

echo ""
exec "$@"