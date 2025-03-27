# ![arch-setup](./logo.svg)

![Arch Linux](https://img.shields.io/badge/Arch%20Linux-1793D1?logo=arch-linux&logoColor=fff)
![MIT License](https://img.shields.io/badge/license-MIT-green)

My personal Arch Linux setup.

## What is this?

This repository contains the scripts and configurations I use to setup Arch Linux on my machines.

## When should I use this?

The setups in this repository are tailored to my personal preferences and use cases.
I recommend not using this repository directly, but rather as a reference for your own setup.

## Usage

Note that old setups may be outdated due to packages being removed or renamed.

### Setting up a system

1. Boot into the Arch Linux live environment.
2. Choose a setup from the `YYYY-MM-DD` directories.
3. Retrieve the `install.sh` script and adjust it to your needs.
4. Run the script to install the system.

### Post Installation

Some settings cannot be configured during the installation process.
To configure these settings, use the `postinstall.sh` script in the setup directory.

### Examples

In the live environment:

```sh
curl -o install.sh https://raw.githubusercontent.com/MoritzRS/arch-setup/main/2025-03-27/install.sh
vim install.sh
bash install.sh
```

On the installed system:

```sh
curl -o postinstall.sh https://raw.githubusercontent.com/MoritzRS/arch-setup/main/2025-03-27/postinstall.sh
vim postinstall.sh
bash postinstall.sh
```

## Development

This repository grows with my personal needs.
It only includes arch-linux specific configurations and scripts.
New setups will always be placed in a new directory with the date of the setup as the name.
The system setup scripts will be named `install.sh` and the optional post installation scripts will be named `postinstall.sh`.

## Related

- [My Dotfiles](https://github.com/MoritzRS/dotfiles)

## License

MIT © MoritzRS
