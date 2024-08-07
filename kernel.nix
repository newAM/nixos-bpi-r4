{
  linux_6_10,
  fetchFromGitHub,
  ...
}:
linux_6_10.override {
  argsOverride = {
    src = fetchFromGitHub {
      owner = "frank-w";
      repo = "BPI-Router-Linux";
      # 6.10-main HEAD 2024-08-06
      rev = "7f8ea2c961d9b931b185d9fa440d904f66d9a786";
      hash = "sha256-k4ou1blQxtE2KxuM4366ShbH0y4UZ8JqpDcZD9B5JoI=";
    };
    version = "6.10.0-bpi-r4";
    modDirVersion = "6.10.0-bpi-r4";
  };

  # https://github.com/frank-w/BPI-Router-Linux/blob/89b23e116975406fddc1610d24d4587495a75e64/arch/arm64/configs/mt7988a_bpi-r4_defconfig
  defconfig = "mt7988a_bpi-r4_defconfig";
}
