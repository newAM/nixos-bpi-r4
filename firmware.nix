{
  buildArmTrustedFirmware,
  fetchFromGitHub,
  dtc,
  ubootTools,
}:
(buildArmTrustedFirmware rec {
  # https://github.com/frank-w/u-boot/blob/7154cf66405cfb42855f2e4f419dece0639e6dd1/build.sh#L33C37-L33C50
  extraMakeFlags = ["USE_MKIMAGE=1" "DRAM_USE_COMB=1" "BOOT_DEVICE=sdmmc" "bl2" "bl31"];
  platform = "mt7988";
  extraMeta.platforms = ["aarch64-linux"];
  filesToInstall = ["build/${platform}/release/bl2.img" "build/${platform}/release/bl31.bin"];
})
.overrideAttrs (oA: {
  src = fetchFromGitHub {
    owner = "mtk-openwrt";
    repo = "arm-trusted-firmware";
    # mtksoc HEAD 2024-08-02
    rev = "bacca82a8cac369470df052a9d801a0ceb9b74ca";
    hash = "sha256-n5D3styntdoKpVH+vpAfDkCciRJjCZf9ivrI9eEdyqw=";
  };
  version = "2.10.0-mtk";
  nativeBuildInputs = oA.nativeBuildInputs ++ [dtc ubootTools];
})
