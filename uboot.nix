{
  buildUBoot,
  fetchFromGitHub,
  firmware_bpir4,
  armTrustedFirmwareTools,
}:
(buildUBoot
  {
    defconfig = "mt7988_sd_rfb_defconfig";
    extraMeta.platforms = ["aarch64-linux"];

    extraConfig = ''
      CONFIG_AUTOBOOT=y
      CONFIG_BOOTDELAY=1
      CONFIG_USE_BOOTCOMMAND=y
      # Use bootstd and bootflow over distroboot for extlinux support
      CONFIG_BOOTSTD_DEFAULTS=y
      CONFIG_BOOTSTD_FULL=y
      CONFIG_CMD_BOOTFLOW_FULL=y
      CONFIG_BOOTCOMMAND="bootflow scan -lb"
      CONFIG_DEVICE_TREE_INCLUDES="nixos-mmcboot.dtsi"
      # Disable saving env, it isn't tested and probably doesn't work.
      CONFIG_ENV_IS_NOWHERE=y
      CONFIG_LZ4=y
      CONFIG_BZIP2=y
      CONFIG_ZSTD=y
      # Boot on root ext4 support
      CONFIG_CMD_EXT4=y

      CONFIG_ENV_SOURCE_FILE="mt7988-nixos"
      # Unessessary as it's not actually used anywhere, value copied verbatum into env
      CONFIG_DEFAULT_FDT_FILE="mediatek/mt7988a-bananapi-bpi-r4.dtb"
      # Big kernels
      CONFIG_SYS_BOOTM_LEN=0x6000000
    '';
    postBuild = ''
      fiptool create --soc-fw ${firmware_bpir4}/bl31.bin --nt-fw u-boot.bin fip.bin
      cp ${firmware_bpir4}/bl2.img bl2.img
    '';
    filesToInstall = ["bl2.img" "fip.bin"];
  })
.overrideAttrs (oA: {
  nativeBuildInputs = oA.nativeBuildInputs ++ [armTrustedFirmwareTools];
  postPatch =
    oA.postPatch
    + ''
      cp ${./mt7988-nixos.env} board/mediatek/mt7988/mt7988-nixos.env
      # Should include via CONFIG_DEVICE_TREE_INCLUDES, but regression in
      # makefile is causing issues.
      # Regression caused by a958988b62eb9ad33c0f41b4482cfbba4aa71564.
      #
      # For now, work around issue by copying dtsi into tree and referencing
      # it in extraConfig using the relative path.
      cp ${./mt7988-mmcboot.dtsi} arch/arm/dts/nixos-mmcboot.dtsi
    '';
})
