# Wazuh Docker Copyright (C) 2017, Wazuh Inc. (License GPLv2)
FROM ubuntu:focal-20230624 AS build

ARG WAZUH_VERSION
ARG WAZUH_TAG_REVISION
ARG INSTALL_DIR=/usr/share/wazuh-dashboard
ARG WAZUH_UI_REVISION=1

# Update and install dependencies
RUN apt-get update && apt install curl libcap2-bin xz-utils -y

# Create Install dir
RUN mkdir -p $INSTALL_DIR

# Add root-fs
COPY build-root-fs /

# Download and extract Wazuh dashboard base
RUN bash dl_base.sh

# Generate certificates
RUN bash config.sh

# Install Wazuh APP
RUN chmod 775 /install_wazuh_app.sh
RUN bash /install_wazuh_app.sh

# Create and set permissions to data directories
RUN mkdir -p $INSTALL_DIR/data/wazuh && chown -R 101:101 $INSTALL_DIR/data/wazuh && chmod -R 775 $INSTALL_DIR/data/wazuh
RUN mkdir -p $INSTALL_DIR/data/wazuh/config && chown -R 101:101 $INSTALL_DIR/data/wazuh/config && chmod -R 775 $INSTALL_DIR/data/wazuh/config
RUN mkdir -p $INSTALL_DIR/data/wazuh/logs && chown -R 101:101 $INSTALL_DIR/data/wazuh/logs && chmod -R 775 $INSTALL_DIR/data/wazuh/logs

################################################################################
# Build stage 1 (the current Wazuh dashboard image):
#
# Copy wazuh-dashboard from stage 0
# Add entrypoint
# Add wazuh_app_config
################################################################################
FROM ubuntu:focal-20230624

# Set environment variables
ENV USER="wazuh-dashboard" \
    GROUP="wazuh-dashboard" \
    NAME="wazuh-dashboard" \
    WAZUH_DASHBOARD_BASE_DIR="/usr/share/wazuh-dashboard"

# Install dependencies
RUN apt update && \
    apt install -y \
        wget \
        libnss3-dev \
        fonts-liberation \
        libfontconfig1 && \
    wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 && \
    chmod a+x /usr/local/bin/yq

# Create wazuh-dashboard user and group
RUN getent group $GROUP || groupadd -r -g 1000 $GROUP
RUN useradd --system \
            --uid 1000 \
            --no-create-home \
            --home-dir $WAZUH_DASHBOARD_BASE_DIR \
            --gid $GROUP \
            --shell /sbin/nologin \
            --comment "$USER user" \
            $USER

# Copy and set permissions to scripts
COPY root-fs /

# Copy Install dir from build stage to current image
COPY --from=build --chown=1000:1000 $WAZUH_DASHBOARD_BASE_DIR $WAZUH_DASHBOARD_BASE_DIR

# Set workdir
WORKDIR $WAZUH_DASHBOARD_BASE_DIR

# Use the user wazuh-dashboard
USER wazuh-dashboard

# Services ports
EXPOSE 443

ENTRYPOINT [ "/opt/wazuh/wazuh-dashboard/entrypoint.sh" ]

CMD [ "/opt/wazuh/wazuh-dashboard/run.sh" ]