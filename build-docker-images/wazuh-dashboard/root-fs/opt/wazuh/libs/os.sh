#!/bin/bash
# Wazuh Docker Copyright (C) 2017, Wazuh Inc. 
# License GPLv2

# Functions

########################
# Run initialization scripts
#
# Globals:
#   WAZUH_INIT_SCRIPTS_DIR
#   WAZUH_VOLUME_DIR
# Arguments:
#   None
# Returns:
#   None
#########################
start_inititization_scripts() {
    read -r -a init_scripts <<<"$(find "$WAZUH_INIT_SCRIPTS_DIR" -type f -name "*.sh" -print0 | xargs -0)"

    if [[ "${#init_scripts[@]}" -gt 0 ]] && [[ ! -f "$WAZUH_VOLUME_DIR"/.init_scripts_initialized ]]; then
        for f in "${init_scripts[@]}"; do
            case "$f" in
            *.sh)
                if [[ -x "$f" ]]; then
                    if ! "$f"; then
                        echo "Failed executing $f"
                        return 1
                    fi
                else
                    echo "Sourcing $f as it is not executable by the current user, any error may cause initialization to fail"
                    source "$f"
                fi
                ;;
            *)
                echo "Skipping $f, supported formats are: .sh"
                ;;
            esac
        done

        touch "$WAZUH_VOLUME_DIR"/.init_scripts_initialized
    fi
}

########################
# Run custom scripts
#
# Globals:
#   WAZUH_CUSTOM_SCRIPTS_DIR
# Arguments:
#   None
# Returns:
#   None
#########################
start_custom_scripts() {
    read -r -a init_scripts <<<"$(find "$WAZUH_CUSTOM_SCRIPTS_DIR" -type f -name "*.sh" -print0 | xargs -0)"

    if [[ "${#init_scripts[@]}" -gt 0 ]]; then
        for f in "${init_scripts[@]}"; do
            case "$f" in
            *.sh)
                if [[ -x "$f" ]]; then
                    if ! "$f"; then
                        echo "Failed executing $f"
                        return 1
                    fi
                else
                    echo "Sourcing $f as it is not executable by the current user, any error may cause initialization to fail"
                    source "$f"
                fi
                ;;
            *)
                echo "Skipping $f, supported formats are: .sh"
                ;;
            esac
        done
    fi
}
