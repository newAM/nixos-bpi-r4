{
  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    overlay = final: prev: {
      dtbs_bpi4 = prev.callPackage ./dtbs.nix {};
      firmware_bpir4 = prev.callPackage ./firmware.nix {};
      linuxKernel_bpir4 = prev.callPackage ./kernel.nix {};
      uboot_bpir4 = prev.callPackage ./uboot.nix {};
    };

    nixpkgsAttrs = {
      system = "x86_64-linux";
      crossSystem.config = "aarch64-unknown-linux-gnu";
      overlays = [overlay];
    };

    pkgs = import nixpkgs nixpkgsAttrs;
  in {
    packages.x86_64-linux = {
      inherit
        (pkgs)
        dtbs_bpi4
        firmware_bpir4
        linuxKernel_bpir4
        uboot_bpir4
        ;
    };

    nixosConfigurations.bpir4 = nixpkgs.lib.nixosSystem {
      modules = [
        ./configuration.nix
        {nixpkgs = nixpkgsAttrs;}
      ];
    };

    checks.x86_64-linux = {
      inherit
        (pkgs)
        dtbs_bpi4
        firmware_bpir4
        linuxKernel_bpir4
        uboot_bpir4
        ;
    };
  };
}
