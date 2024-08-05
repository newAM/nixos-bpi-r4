{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./sdimg.nix
  ];

  boot = {
    enableContainers = false; # pulls in nixos-containers
    kernelPackages = pkgs.linuxKernel.packagesFor pkgs.linuxKernel_bpir4;
    kernelParams = [
      "console=ttyS0,115200"
      # keep boot clocks on
      # should not be required long-term
      "clk_ignore_unused=1"
      # open a shell upon failure
      "boot.debug1"
      # print early messages over UART
      "earlycon=uart8250,mmio32,0x11000000"
      "earlyprintk"
    ];
    consoleLogLevel = 7;
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
    initrd = {
      # We exclude a number of modules included in the default list.
      # A non-insignificant amount do not apply to embedded hardware like this.
      includeDefaultModules = false;
      kernelModules = ["mii"];
      availableKernelModules = ["nvme"];
      # gzip is known safe; bz2, lzma and lz4 should work as well, but not zstd.
      compressor = lib.mkDefault "gzip";
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/0b5e3376-c7e9-4284-9514-9c3b51244f19"; # must match sdimg.nix
    fsType = "ext4";
  };

  hardware.deviceTree.filter = "mt7988a-bananapi-bpi-r4.dtb";
  hardware.deviceTree.overlays = [
    {
      name = "BananaPi BPiR4 Enable SD card interface";
      dtsFile = ./mt7988a-bananapi-bpi-r4-sd.dts;
    }
  ];

  environment.noXlibs = true;

  documentation = {
    enable = false;
    doc.enable = false;
    info.enable = false;
    man.enable = false;
    nixos.enable = false;
  };

  boot.postBootCommands = ''
    # On the first boot do some maintenance tasks
    if [ -f /nix-path-registration ]; then
      set -euo pipefail
      set -x
      # Figure out device names for the boot device and root filesystem.
      rootPart=$(${pkgs.util-linux}/bin/findmnt -n -o SOURCE /)
      # Remove BTRFS SubVol from rootPart if it exists
      rootPart=''${rootPart//\[*/}
      rootDevice=$(lsblk -npo PKNAME $rootPart)
      partNum=$(lsblk -npo PARTN $rootPart)

      # Resize the root partition and the filesystem to fit the disk
      echo ",+," | sfdisk -N$partNum --no-reread $rootDevice
      ${pkgs.parted}/bin/partprobe
      ${pkgs.e2fsprogs}/bin/resize2fs $rootPart

      # Register the contents of the initial Nix store
      ${config.nix.package.out}/bin/nix-store --load-db < /nix-path-registration

      # nixos-rebuild also requires a "system" profile and an /etc/NIXOS tag.
      touch /etc/NIXOS
      ${config.nix.package.out}/bin/nix-env -p /nix/var/nix/profiles/system --set /run/current-system

      # Prevents this from running on later boots.
      rm -f /nix-path-registration
    fi
  '';

  system.stateVersion = "24.11";
}
