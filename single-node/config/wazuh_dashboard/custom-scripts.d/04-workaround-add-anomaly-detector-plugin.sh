# Load libraries
source /opt/wazuh/libs/log.sh

# Load environment
source /opt/wazuh/wazuh-dashboard/env.sh

info "04-workaround-add-anomaly-detector"

plugins=$(${WAZUH_DASHBOARD_BIN_DIR}/opensearch-dashboards-plugin list)

if ! [[ $plugins =~ "anomalyDetectionDashboards" ]]; then
	${WAZUH_DASHBOARD_BIN_DIR}/opensearch-dashboards-plugin --allow-root install anomalyDetectionDashboards
fi
