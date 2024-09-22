#!/bin/bash

# Use the provided INTERFACES_D or set to default if not provided
INTERFACES_D=${INTERFACES_D:-"/etc/network/interfaces.d"}
CMD_NAME="debiface-cli-sh"

# Function to check if interface file exists and ask for overwrite
f_is_interfaces() {
    if [ -f "${INTERFACES_D}/$1" ]; then
        while true; do
            read -p "Overwrite existing $1 [yes or no]? " answer
            case $answer in
                yes) rm "${INTERFACES_D}/$1"; break ;;
                no) exit 1 ;;
                *) echo "Please answer yes or no." ;;
            esac
        done
    fi
}

# Function to validate argument
f_is_arg() {
    if [[ "$1" =~ ^-- ]]; then
        echo "Error: $2: invalid argument" >&2
        exit 1
    fi
}

# Function to handle errors
log_error() {
    echo "Error: $1" >&2
    exit 1
}

# Function to log messages
log_message() {
    echo "$1"
}

# Function to validate IP address
validate_ip() {
    if [[ ! $1 =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        log_error "Invalid IP address: $1"
    fi
    IFS='.' read -r -a ip <<< "$1"
    for quad in "${ip[@]}"; do
        if [ "$quad" -gt 255 ]; then
            log_error "Invalid IP address: $1"
        fi
    done
}

# Function to validate netmask
validate_netmask() {
    validate_ip "$1"
    if [[ ! $1 =~ ^(255\.){3}[0-9]{1,3}$ ]]; then
        log_error "Invalid netmask: $1"
    fi
}

# Function to validate interface name
validate_interface() {
    if [[ ! $1 =~ ^[a-zA-Z0-9]+$ ]]; then
        log_error "Invalid interface name: $1"
    fi
}

# Function to handle file generation
handle_file_generation() {
    local config="$1"
    local iface="$2"
    local generate_file="$3"

    if [ "$generate_file" = true ]; then
        if [ ! -d "$INTERFACES_D" ]; then
            log_error "Interfaces directory not found: $INTERFACES_D"
        fi
        echo -e "$config" > "${INTERFACES_D}/$iface"
        log_message "Configuration for $iface created in ${INTERFACES_D}/$iface"
    else
        echo -e "$config"
    fi
}
