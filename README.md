# debiface-cli-sh

`debiface-cli-sh` is a command-line interface tool for generating and managing network interface configurations on Debian-based systems. It provides a interface way to create, list, show, and destroy network interface configurations.

This is an implementation using [skeleton-cli-sh](https://github.com/zinrai/skeleton-cli-sh).

## Features

- Generate configurations for standard, bonding, and DSR (Direct Server Return) interfaces
- List existing interface configurations
- Show details of a specific interface configuration
- Remove interface configurations
- Output configurations to stdout or directly to configuration files

## Requirements

- Debian-based system
- Bash shell
- `ifupdown` package installed (provides `/etc/network/interfaces.d/` directory)
- `ifenslave` package installed (required for network bonding)

## Usage

The general syntax for using debiface-cli-sh is:

```
$ ./debiface-cli.sh <subcommand> [options]
```

For help on a specific subcommand, use:

```
$ ./debiface-cli.sh <subcommand> --help
```

### Examples

1. Create a standard interface configuration:
   ```
   $ ./debiface-cli.sh standard -a -i eth0 -p 192.0.2.1 -n 255.255.255.0 -g 192.0.2.254
   ```

2. Create a bonding interface configuration:
   ```
   $ ./debiface-cli.sh bonding -a -i bond0 -p 192.0.2.1 -n 255.255.255.0 -g 192.0.2.254 -r eth0 -s "eth0 eth1"
   ```

3. List all configured interfaces:
   ```
   $ ./debiface-cli.sh list
   ```

4. Show configuration for a specific interface:
   ```
   $ ./debiface-cli.sh show eth0
   ```

5. Remove an interface configuration:
   ```
   $ ./debiface-cli.sh destroy eth0
   ```

## File Generation

By default, debiface-cli-sh outputs configurations to stdout. To generate configuration files in `/etc/network/interfaces.d/`, use the `-f` or `--file` option:

```
$ ./debiface-cli.sh standard -a -i eth0 -p 192.0.2.1 -n 255.255.255.0 -g 192.0.2.254 -f
```

## Testing

The test suite uses a mock `/etc/network/interfaces.d/` directory to avoid modifying the actual system configuration. To run the tests:

```
$ ./tests/test_framework.sh
```

## License

This project is licensed under the [MIT License](./LICENSE).
