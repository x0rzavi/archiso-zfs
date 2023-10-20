#########
Changelog
#########

[XX] - YYYY-MM-DD
=================

Added
-----

Changed
-------

Deprecated
----------

Fixed
-----

Removed
-------

[73] - 2023-09-29
=================

Added
-----

- Add bolt to releng for authorizing and otherwise managing Thunderbolt and USB4 devices.
- Add ``uefi-ia32.systemd-boot.esp`` and ``uefi-ia32.systemd-boot.eltorito`` boot modes that use systemd-boot for IA32
  UEFI. The boot modes of baseline and releng are not changed.
- Add GRUB configuration file ``/boot/grub/loopback.cfg`` to the releng and baseline profiles. It sets the necessary
  boot parameters required for booting the ISO image as a file on a file system.

Fixed
-----

- Add ``/etc/localtime`` to the baseline profile to ensure the ISO can be booted successfully without triggering
  questions from systemd-firstboot.

[72] - 2023-08-29
=================

Added
-----

- Add tpm2-tools to releng to allow clearing, creating and reading keys on the TPM.
- Add sequoia-sq and openpgp-card-tools as additional tooling for working with OpenPGP certificates and smartcards.

Changed
-------

- Moved custom ``mkinitcpio.conf`` files to ``/etc/mkinitcpio.conf.d/archiso.conf``.
- Mount ``/etc/pacman.d/gnupg`` on tmpfs with option ``noswap`` instead of using ramfs. This ensures there is a limit to
  the file system size.
- Enable systemd-networkd's support for IPv6 Privacy Extensions globally instead of per-connection.
- Moved custom ``sshd_config`` files to ``/ssh/sshd_config.d/10-archiso.conf``
- Use pcsclite for interfacing with smartcards, since both gnupg and opgpcard support it.

Fixed
-----

- Sign the root file system image only once.
- Make sure xorriso does not read its configuration files to prevent interference and unintended behavior.

[71] - 2023-05-28
=================

Added
-----

- Added classes for Memtest86+ and UEFI Shell menuentries.
- Add foot-terminfo and wezterm-terminfo packages to releng to support terminal emulators using them. E.g. when
  installing via SSH.
- Add a new ``-r`` option to ``mkarchiso`` that deletes the working directly after the build.
- Add support for mDNS announce and resolve.

Changed
-------

- Increase EROFS compression for the baseline profile by using an extreme LZMA compression level and enabling the
  experimental compressed fragments and data deduplication features.
- Identify the ISO volume via a UUID instead of a file system label in all boot loader configuration files.
- Update ``pacman.conf`` to match the one shipped with pacman 6.0.2-7 which removes the community repository.

Fixed
-----

- Wait for ``network-online.target`` to become active before trying to download the script passed via the ``script=``
  boot parameter.
- Subdirectories from ``grub/`` are copied to the ISO.
- Modify the commandline options to a ``cp`` command in ``mkarchiso`` so that the entire script does not exit with
  failure when a custom ``.bashrc`` file is supplied with the archiso configuration. This fix was needed after
  **GNU Coreutils** recently changed the behaviour of the ``-n`` (or ``--no-clobber``) commandline option to the ``cp``
  command.
- Ensure ``SOURCE_DATE_EPOCH`` is read from the ``build_date`` file before ``profiledef.sh`` is sourced to ensure the
  variable has a correct value when used inside ``profiledef.sh``.

[70] - 2023-02-27
=================

Added
-----

- Support *file system transposition* to simplify boot medium preparation for UEFI boot via extracting the ISO image
  contents to a drive. ``grub.cfg`` does not hardcode the ISO volume label anymore, instead GRUB will search for volume
  with a ``/boot/grub/YYYY-mm-dd-HH-MM-SS-00.uuid`` file on it.
- Preload GRUB's NTFS modules for UEFI that allegedly have native NTFS support. GRUB's exFAT and UDF modules are also
  preloaded in case someone finds them useful.

Changed
-------

- Identify the ISO volume via a UUID instead of a file system label to avoid collisions of multiple ISOs created in the
  same month.
- Honor ``SOURCE_DATE_EPOCH`` in the ``date`` command used by ``profiledef.sh`` of the shipped profiles.
- Do not duplicate ``grub.cfg`` in both ISO 9660 and the EFI system partition / El Torito image. GRUB will search for
  the ISO volume and load the ``grub.cfg`` from there.
- Moved GRUB files on ISO 9660 from ``/EFI/BOOT/`` to a boot-platform neutral place ``/boot/grub/``. This does not apply
  to the EFI binaries that remain in the default/fallback boot path.
- Move ``grubenv`` to ``/boot/grub/grubenv`` on ISO 9660 so that it is together with the rest of GRUB-specific files.
  Additionally write more variables in it. The previous ``/${install_dir}/grubenv`` (``/arch/grubenv`` for releng)
  is deprecated and a future archiso release will not create this file anymore.
- Moved syslinux directory from ``/syslinux/`` to ``/boot/syslinux/`` to keep most boot loader files in ``/boot/``.
- Update ``README.transfer`` documentation and convert it to reStructuredText.
- Use ``console`` as grub's ``terminal_output``, as ``gfxterm`` leads to a blank screen on some hardware.

Removed
-------

- Do not place memtest86+ in netboot artifacts.

[69] - 2022-12-24
=================

Added
-----

- Add Memtest86+ to x86_64 UEFI GRUB boot menu.

Changed
-------

- Check if the GPG public key file was successfully placed in the work directory before trying to use it.
- Open the file descriptors for code signing certificates and GPG public key as read only. Nothing from the within the
  ``pacstrap`` invoked chroot should ever be allowed to write outside of it.
- Error out early if any of the code signing certificate files passed with option ``-c`` do not exist.
- Use LZMA compressed EROFS image for the baseline profile. Now that xz 5.4 is out and erofs-utils is built with LZMA
  support, using a higher compression is possible.
- Add ``/etc/machine-id`` with special value ``uninitialized``. The final id is generated at boot time, and systemd's
  first-boot mechanim (see ``First Boot Semantics`` in ``machine-id(5)``) applies. No functional change unless that
  ``ConditionFirstBoot=yes`` is true and passive unit ``first-boot-complete.target`` activates for ordering.

[68] - 2022-10-30
=================

Changed
-------

- Do not explicitly enable ``qemu-guest-agent.service`` as it will be started by a udev rule.
- Remove existing signature (``.sig``) files and do not sign them when signing netboot artifacts. This is mostly
  applicable when re-running ``mkarchiso``  after a failure.
- Replace ``archiso_kms`` with ``kms`` in ``mkinitcpio.conf``. The hook is available in mkinitcpio since version 32.

[67] - 2022-09-25
=================

Added
-----

- The ability to generate rootfs signatures using openssl CMS module if ``-c`` is given.

Changed
-------

- Order ``pacman-init.service`` before ``archlinux-keyring-wkd-sync.service`` since
  ``archlinux-keyring-wkd-sync.service`` needs an initialized pacman keyring.
- Order ``pacman-init.service`` after ``time-sync.target`` since ``pacman-init.service`` may otherwise create local
  signatures that are not valid on target systems after installation.

[66] - 2022-08-28
=================

Added
-----

- Add ``efibootimg`` to ``mkarchiso`` to abstract the FAT image path.
- Unset ``LANGUAGE`` since ``LC_ALL=C.UTF-8``, unlike ``LC_ALL=C``, does not override ``LANGUAGE``.
- Copy all files from the ``grub`` directory to ISO9660 and the FAT image, not just only ``grub.cfg``.
- Touching ``/usr/lib/clock-epoch`` to to help ``systemd`` with screwed or broken RTC.

Changed
-------

- Disable GRUB's shim_lock verifier and preload more modules. This allows reusing the GRUB EFI binaries when repacking
  the ISO to support Secure Boot with custom signatures.

[65] - 2022-06-30
=================

Added
-----

- Configure the locale for the baseline profile to ``C.UTF-8`` so that a UTF-8 locale is used.
- Add ``uefi-x64.grub.esp`` and ``uefi-x64.grub.eltorito`` boot mode to support x86_64 UEFI boot on x86_64 machines.
- Use ``mkfs.erofs``'s ``ztailpacking`` option in the baseline profile to reduce the image size.

Changed
-------

- Change the releng profile's locale from ``en_US.UTF-8`` to ``C.UTF-8``.
- Set ``LC_ALL`` to ``C.UTF-8`` instead of ``C`` in mkarchiso since it is now available and non-UTF-8 locales should be
  avoided.

Removed
-------

- Remove the custom pacman hook that ran ``locale-gen`` on glibc install from the releng profile. The used locale now
  ships with the glibc package itself.
- Remove "Copy to RAM" boot entries since the ``archiso`` mkinitcpio hook enables it automatically when there is enough
  free RAM.

[64] - 2022-05-30
=================

Added
-----

- Add ``uefi-ia32.grub.esp`` boot mode to support IA32 UEFI boot on x86_64 machines.
- Add GRUB configuration files to profiles.
- Add accessible ``copytoram`` entry.
- Enable beeps in systemd-boot menu.

Changed
-------

- Fix systemd-boot menu entry sorting by using the ``sort-key`` option.

[63] - 2022-04-30
=================

Added
-----

- Add dmidecode to the list of packages in the releng profile.
- Add open-iscsi to the list of packages in the releng profile to allow installing Arch on an iSCSI target.
- Add open-vm-tools and hyperv to the list of packages and enable their services to provide better integration with the
  VMware and Hyper-V hypervisors.

Changed
-------

- Mount /etc/pacman.d/gnupg on ramfs instead of tmpfs to ensure its contents never land in swap.
- Configure reflector to return only mirrors that support both IPv4 and IPv6.


[62.1] - 2022-04-05
===================

Removed
-------

- Easter egg

[62] - 2022-03-31
=================

Changed
-------

- Fix the PXE support. PXELINUX was having trouble finding the kernel and initrds. Now, archiso forces syslinux to
  interpret all TFTP paths as absolute. That seems to have solved the issue.
- Disable systemd-gpt-auto-generator, which we do not need, in both baseline and releng profiles. It avoids the error
  message about it failing during boot.

[61] - 2022-01-31
=================

Added
-----

- Add linux-firmware-marvell to the list of packages in the releng profile (e.g. for Surface Pro 6 WiFi support)
- Add documentation to systemd-networkd configuration files
- Add information about the use of changelog and merge requests to the contributing guidelines
- Make the CI pipelines more efficient by automatically cancelling running pipelines if they are superseded by a newer
  commit and by only running build pipelines on code or profile changes

Changed
-------

- Fix an issue where mkarchiso is failing to raise an error when the ``mmd`` and ``mcopy`` commands are not found
- Fix an issue where the architecture detection in mkarchiso fails due to an unset ``arch`` variable in the profile

Removed
-------

[60] - 2021-12-28
=================

Added
-----

- Add `BB8E6F1B81CF0BB301D74D1CBF425A01E68B38EF` in the Releases section of the README, giving maintainer power to
  nl6720.

Changed
-------

- Show a more descriptive message when no code signing certificate is used

Removed
-------

- Remove unused archiso_shutdown hook from the releng profile's mkinitcpio config

[59] - 2021-11-30
=================

Added
-----

- Add mailmap file for easier author integration with git
- Add grub and refind to the package list of the releng profile

Changed
-------

- Replace use of date with printf
- Silence command output more efficiently when using --quiet
- Modify curl call to retry up to ten times before giving up on downloading an automated script

Removed
-------

- Remove requirement on setting a Boot mode when building a netboot image

[58] - 2021-08-25
=================

Added
-----

- Add support for ``gpg``'s ``--sender`` option

Changed
-------

- Change the way ``mkarchiso`` uses ext4 images to copying files to it directly instead of mounting (this action now
  does not require elevated privileges anymore)
- Add version files when using ``netboot`` buildmode as well
- Update the sshd configuration to be compatible with openssh 8.7p1
- Overhaul the used ``gpg`` options
- Fix use of potentially unbound variables
- Refactor the validation functions to have fewer large functions and less code duplication

Removed
-------

- Remove all files related to ``mkinitcpio`` integration, as they now live in
  https://gitlab.archlinux.org/archlinux/mkinitcpio/mkinitcpio-archiso

[57] - 2021-07-30
=================

Added
-----

- Add a missing line in the systemd-networkd-wait-online.service in the baseline profile

Changed
-------

- Adapt systemd-networkd configuration to systemd ≥ 249
- Improve documentation in ``mkarchiso`` and systemd-networkd related configuration files
- Fix an issue that may prevent continuing an aborted build of the ``netboot`` or ``iso`` buildmode

Removed
-------

- Remove SPDX license identifier from files that are not eligible for copyright (e.g. configuration files)

[56.1] - 2021-07-11
===================

Added
-----

Changed
-------

- Simplify gitlab CI setup by using ci-scripts (shared amongst several projects)
- Fix an issue with the unsetting of environment variables before using pacstrap/arch-chroot
- Remove termite-terminfo from the releng profile's list of packages (it is not in the official repositories anymore)
- Set LC_ALL instead of LANG

[56] - 2021-07-01
=================

Added
-----

- Add pacman >= 6 compatible configuration
- Add documentation for the `script` boot parameter

Changed
-------

- Clear environment variables before working in chroot
- Update Arch Wiki URLs
- Pass SOURCE_DATE_EPOCH to chroot
- Enable parallel downloads in profile pacman configurations
- Generalize the approach of interacting with ucode images
- Execute the netboot build mode for the baseline profile in CI

[55] - 2021-06-01
=================

Added
-----

- Add integration for pv when using the copytoram boot parameter so that progress on copying the image to RAM is shown
- Add experimental support for EROFS by using it for the rootfs image in the baseline profile

Changed
-------

- Change information on IRC channel, as Arch Linux moved to Libera Chat
- Fix a regression, that would prevent network interfaces to be configured under certain circumstances

[54] - 2021-05-13
=================

Added
-----

- Add the concept of buildmodes to mkarchiso, which allows for building more than the default .iso artifact
  (sequentially)
- Add support to mkarchiso and both baseline and releng profiles for building a bootstrap image (a compressed
  bootstrapped Arch Linux environment), by using the new buildmode `bootstrap`
- Add support to mkarchiso and both baseline and releng profiles for building artifacts required for netboot with iPXE
  (optionally allowing codesigning on the artifacts), by using the new buildmode `netboot`
- Add qemu-guest-agent and virtualbox-guest-utils-nox to the releng profile and enable their services by default to
  allow interaction between hypervisor and virtual machine if the installation medium is booted in a virtualized
  environment

Changed
-------

- Always use the .sig file extension when signing the rootfs image, as that is how mkinitcpio-archiso expects it
- Fix for CI and run_archiso scripts to be compatible with QEMU >= 6.0
- Increase robustness of CI by granting more time to reach the first prompt
- Change CI to build all available buildmodes of the baseline and releng profiles (baseline's netboot is currently
  excluded due to a bug)
- Install all implicitly installed packages explicitly for the releng profile
- Install keyrings more generically when using pacman-init.service
- Consolidate CI scripts so that they may be shared between the archiso, arch-boxes and releng project in the future and
  expose their configuration with the help of environment variables

[53] - 2021-05-01
=================

Added
-----

- Add ISO name to grubenv
- Add further metrics to CI, so that number of packages and further image sizes can be tracked
- Add IMAGE_ID and IMAGE_VERSION to /etc/os-release

Changed
-------

- Revert to an invalid GPT for greater hardware compatibility
- Fix CI scripts and initcpio script to comply with stricter shellcheck
- Fix an issue where writing to /etc/machine-id might override a file outside of the build directory
- Change gzip flags, so that compressed files are created reproducibly
- Increase default serial baud rate to 115200
- Remove deprecated documentation and format existing documentation

[52] - 2021-04-01
=================

Added
-----

- Add usbmuxd support
- Add EROFS support (as an experimental alternative to squashfs)
- Add creation of zsync control file for delta downloads
- Add sof-firmware for additional soundcard support
- Add support for recursively setting file permissions on folders using profiledef.sh
- Add support for mobile broadband devices with the help of modemmanager
- Add information on PGP signatures of tags
- Add archinstall support

Changed
-------

- Remove haveged
- Fix various things in relation to gitlab CI
- Change systemd-networkd files to more generically setup networkds for devices
- Fix the behavior of the `script=` kernel commandline parameter to follow redirects
- Change the amount of mirrors checked by reflector to 20 to speed up availability of the mirrorlist

[51] - 2021-02-01
=================

Added
-----

- VNC support for `run_archiso`
- SSH enabled by default in baseline and releng profiles
- Add cloud-init support to baseline and releng profiles
- Add simple port forwarding to `run_archiso` to allow testing of SSH
- Add support for loading cloud-init user data images to `run_archiso`
- Add version information to images generated with `mkarchiso`
- Use pacman hooks for things previously done in `customize_airootfs.sh` (e.g. generating locale, uncommenting mirror
  list)
- Add network setup for the baseline profile
- Add scripts for CI to build the baseline and releng profiles automatically

Changed
-------

- Change upstream URL in vendored profiles to archlinux.org
- Reduce the amount of sed calls in mkarchiso
- Fix typos in `mkarchiso`
- mkinitcpio-archiso: Remove resolv.conf before copy to circumvent its use
- Remove `customize_airootfs.sh` from the vendored profiles
- Support overriding more variables in `profiledef.sh` and refactor their use in `mkarchiso`
- Cleanup unused code in `run_archiso`
