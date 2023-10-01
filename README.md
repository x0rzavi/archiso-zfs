# Arch Linux Live/Rescue CD with ZFS support
[![Build ArchISO](https://github.com/x0rzavi/archiso-zfs/actions/workflows/archiso.yml/badge.svg)](https://github.com/x0rzavi/archiso-zfs/actions/workflows/archiso.yml)

## [Download](https://github.com/x0rzavi/archiso-zfs/releases/latest) here

## List of patches & descriptions
1. `0001-cachyOS-kernel.patch` - Default to a more performant kernel from [CachyOS](https://github.com/CachyOS)
2. `0002-zstd-compression.patch` - Use zstd compression wherever applicable to speedup ISO building times
3. `0003-increase-cowspace.patch` - Increase cowspace size to remove the LiveISO freespace headroom
4. `0004-ssh-public-key.patch` - Personalized ssh public key for x0rzavi
5. `0005-wifi-PSK.patch` - Personalized wifi PSK for x0rzavi
6. `0006-ZFS-support.patch` - Add ZFS support for improved filesystem capabilites
7. `0007-disable-reflector.patch` - Disable reflector systemd service and pre-add objectively better mirrors as a preset
8. `0008-tty-bigger-font.patch` - Increase the default tty font size to reduce stress on the eyes
9. `0009-performance-kernel-cmdline.patch` - Remove kernel securtiy mitigations and watchdogs support to improve performance
10. `0010-local-user-x0rzavi.patch` - Personalized local user for x0rzavi with preset password - `1229`
11. `0011-trust-custom-repo.patch` - Add custom repo GPG keys
12. `0012-post-setup-mechanism.patch` - Add script and mechanism to post setup stuffs after ISO boot
13. `0013-customize-ISO-metadata.patch` - Personalized ISO metadata
14. `0014-seatd-setup.patch` - Add seatd functionality for WMs
15. `0015-pacman-configuration.patch` - Improve upon the default pacman configuration
16. `0016-nbfc-linux-zenmonitor-setup.patch` - Add required configurations for nbfc-linux and zenmonitor support
17. `0017-required-packages.patch` - Add list of essential packages
18. `0018-local-repo.patch` - Implement local repo in pacman config
19. `0019-Hyprland-config.patch` - Add default Hyprland config to speedup workflow
20. `0020-Ryzenadj-script.patch` - Add Ryzenadj helper script for faster performance boosts