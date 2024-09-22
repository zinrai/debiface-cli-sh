#!/bin/bash

# Set and export INTERFACES_D for testing
export INTERFACES_D="./etc/network/interfaces.d"

# Ensure the test directory exists
setup_test_environment() {
    mkdir -p "$INTERFACES_D"
}

# Clean up the test environment
cleanup_test_environment() {
    rm -rf "./etc"
}

# Test main usage
test_main_usage() {
    output=$(./debiface-cli-sh)
    if [[ $output == *"Usage: ./debiface-cli-sh <subcommand> [options]"* ]]; then
        echo "PASS: Main usage test"
    else
        echo "FAIL: Main usage test"
    fi
}

# Test bonding subcommand (stdout)
test_bonding_subcommand_stdout() {
    output=$(./debiface-cli-sh bonding -a -i bond0 -p 192.0.2.1 -n 255.255.255.0 -g 192.0.2.254 -r eth0 -s "eth0 eth1")
    if [[ $output == *"iface bond0 inet static"* && $output != *"Configuration for bond0 created in"* ]]; then
        echo "PASS: Bonding subcommand stdout test"
    else
        echo "FAIL: Bonding subcommand stdout test"
    fi
}

# Test bonding subcommand (file generation)
test_bonding_subcommand_file() {
    ./debiface-cli-sh bonding -a -i bond0 -p 192.0.2.1 -n 255.255.255.0 -g 192.0.2.254 -r eth0 -s "eth0 eth1" -f
    if [ -f "$INTERFACES_D/bond0" ]; then
        echo "PASS: Bonding subcommand file generation test"
    else
        echo "FAIL: Bonding subcommand file generation test"
    fi
}

# Test DSR subcommand (stdout)
test_dsr_subcommand_stdout() {
    output=$(./debiface-cli-sh dsr -a -i dsr0 -p 192.0.2.1)
    if [[ $output == *"iface dsr0 inet static"* && $output != *"Configuration for dsr0 created in"* ]]; then
        echo "PASS: DSR subcommand stdout test"
    else
        echo "FAIL: DSR subcommand stdout test"
    fi
}

# Test standard subcommand (stdout)
test_standard_subcommand_stdout() {
    output=$(./debiface-cli-sh standard -a -i eth0 -p 192.0.2.1 -n 255.255.255.0 -g 192.0.2.254)
    if [[ $output == *"iface eth0 inet static"* && $output != *"Configuration for eth0 created in"* ]]; then
        echo "PASS: Standard subcommand stdout test"
    else
        echo "FAIL: Standard subcommand stdout test"
    fi
}

# Test list subcommand
test_list_subcommand() {
    # Create a test file
    touch "$INTERFACES_D/test_interface"
    output=$(./debiface-cli-sh list)
    if [[ $output == *"test_interface"* ]]; then
        echo "PASS: List subcommand test"
    else
        echo "FAIL: List subcommand test"
    fi
}

# Test show subcommand
test_show_subcommand() {
    ./debiface-cli-sh standard -a -i eth0 -p 192.0.2.1 -n 255.255.255.0 -g 192.0.2.254 -f
    output=$(./debiface-cli-sh show eth0)
    if [[ $output == *"iface eth0 inet static"* ]]; then
        echo "PASS: Show subcommand test"
    else
        echo "FAIL: Show subcommand test"
    fi
}

# Test destroy subcommand
test_destroy_subcommand() {
    ./debiface-cli-sh standard -a -i eth1 -p 192.0.2.2 -n 255.255.255.0 -g 192.0.2.254 -f
    ./debiface-cli-sh destroy eth1
    if [ ! -f "$INTERFACES_D/eth1" ]; then
        echo "PASS: Destroy subcommand test"
    else
        echo "FAIL: Destroy subcommand test"
    fi
}

# Run tests
setup_test_environment
test_main_usage
test_bonding_subcommand_stdout
test_bonding_subcommand_file
test_dsr_subcommand_stdout
test_standard_subcommand_stdout
test_list_subcommand
test_show_subcommand
test_destroy_subcommand
cleanup_test_environment

echo "All tests completed."
