#!/bin/bash

set -e

# Base directory for the framework
FRAMEWORK_ROOT="$(dirname "$0")"

# Directory for subcommands
SUBCOMMANDS_DIR="${FRAMEWORK_ROOT}/subcommands"

# Directory for shared libraries
LIB_DIR="${FRAMEWORK_ROOT}/lib"

# Source common library
source "${LIB_DIR}/common.sh"

# Main usage function
usage() {
    echo "Usage: $0 <subcommand> [options]"
    echo ""
    echo "Available subcommands:"
    echo "  bonding    Create bonding interface configuration"
    echo "  dsr        Create Direct Server Return (DSR) interface configuration"
    echo "  standard   Create standard interface configuration"
    echo "  list       List all configured interfaces"
    echo "  show       Show configuration for a specific interface"
    echo "  destroy    Remove configuration for a specific interface"
    echo ""
    echo "For help on a specific subcommand, use: $0 <subcommand> --help"
}

# Main execution logic
if [ $# -eq 0 ]; then
    usage
    exit 1
fi

SUBCOMMAND="$1"
shift

if [ "$SUBCOMMAND" = "--help" ]; then
    usage
    exit 0
fi

SUBCOMMAND_SCRIPT="${SUBCOMMANDS_DIR}/${SUBCOMMAND}"

if [ ! -f "$SUBCOMMAND_SCRIPT" ]; then
    log_error "Unknown subcommand '$SUBCOMMAND'"
    usage
    exit 1
fi

# Execute the subcommand
INTERFACES_D="$INTERFACES_D" source "$SUBCOMMAND_SCRIPT"
