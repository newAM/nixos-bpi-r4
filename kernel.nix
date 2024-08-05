{
  linux_6_9,
  fetchFromGitHub,
  ...
}:
linux_6_9.override {
  argsOverride = {
    src = fetchFromGitHub {
      owner = "frank-w";
      repo = "BPI-Router-Linux";
      # 6.9-main HEAD 2024-08-05
      rev = "89b23e116975406fddc1610d24d4587495a75e64";
      hash = "sha256-nyFWd5GGhrk7EdmhpchI9GAsVTuAkdTaRbAUUdisUVo=";
    };
    version = "6.9.0-bpi-r4";
    modDirVersion = "6.9.0-bpi-r4";
  };

  # https://github.com/frank-w/BPI-Router-Linux/blob/89b23e116975406fddc1610d24d4587495a75e64/arch/arm64/configs/mt7988a_bpi-r4_defconfig
  defconfig = "mt7988a_bpi-r4_defconfig";
}
