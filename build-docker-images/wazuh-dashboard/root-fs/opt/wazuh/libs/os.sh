#!/bin/bash
# Wazuh Docker Copyright (C) 2017, Wazuh Inc. 
# License GPLv2


########################
# Run custom initialization scripts
# Globals:
#   WAZUH_INITSCRIPTS_DIR
#   WAZUH_VOLUME_DIR
# Arguments:
#   None
# Returns:
#   None
#########################
start_inititization_scripts() {
    read -r -a init_scripts <<<"$(find "$WAZUH_INITSCRIPTS_DIR" -type f -name "*.sh" -print0 | xargs -0)"

    if [[ "${#init_scripts[@]}" -gt 0 ]] && [[ ! -f "$WAZUH_VOLUME_DIR"/.user_scripts_initialized ]]; then
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

        touch "$WAZUH_VOLUME_DIR"/.user_scripts_initialized
    fi
}

