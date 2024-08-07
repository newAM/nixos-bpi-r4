{
  lib,
  linux_6_10,
  ...
}:
linux_6_10.override {
  structuredExtraConfig = with lib.kernel; {
    # Disable extremely unlikely features to reduce build storage requirements and time.
    FB = lib.mkForce no;
    DRM = lib.mkForce no;
    SOUND = no;
    INFINIBAND = lib.mkForce no;

    # PCIe
    PCIE_MEDIATEK = yes;
    PCIE_MEDIATEK_GEN3 = yes;
    # SD/eMMC
    MTD_NAND_ECC_MEDIATEK = yes;
    # Net
    BRIDGE = yes;
    HSR = yes;
    NET_DSA = yes;
    NET_DSA_TAG_MTK = yes;
    NET_DSA_MT7530 = yes;
    NET_VENDOR_MEDIATEK = yes;
    NET_MEDIATEK_SOC_WED = yes;
    NET_MEDIATEK_SOC = yes;
    MEDIATEK_GE_PHY = yes;

    # from https://github.com/frank-w/BPI-Router-Linux/blob/89b23e116975406fddc1610d24d4587495a75e64/arch/arm64/configs/mt7988a_bpi-r4_defconfig
    EEPROM_AT24 = yes;
    I2C_MUX = yes;
    I2C_MUX_PCA954x = yes;
    MT7915E = module;
    MT798X_WMAC = yes;
    PCS_MTK_USXGMII = yes;
    PHY_MTK_XFI_TPHY = yes;
    RTC_DRV_PCF8563 = yes;

    # Pinctrl
    EINT_MTK = yes;
    PINCTRL_MT7988 = yes;
    PINCTRL_MTK = yes;
    # Thermal
    MTK_THERMAL = yes;
    MTK_SOC_THERMAL = yes;
    MTK_LVTS_THERMAL = yes;
    # CLK
    COMMON_CLK_MEDIATEK = yes;
    COMMON_CLK_MT7988 = yes;
    # other
    MEDIATEK_WATCHDOG = yes;
    REGULATOR = yes;
    REGULATOR_FIXED_VOLTAGE = yes;
    REGULATOR_MT6380 = yes;
    SENSORS_PWM_FAN = yes;
  };
}
