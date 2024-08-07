{
  linuxPackages_6_10,
  fetchurl,
  ...
}:
linuxPackages_6_10.kernel.overrideAttrs (oldAttrs: {
  pname = "linux-bpi-r4-dtbs";
  buildFlags = ["dtbs"];
  installTargets = ["dtbs_install"];
  installFlags = ["INSTALL_DTBS_PATH=$(out)/dtbs"];
  postInstall = null;
  postPatch = let
    commit = "89b23e116975406fddc1610d24d4587495a75e64";

    mtDtsName = "mt7988a.dtsi";
    mtDts = fetchurl {
      url = "https://raw.githubusercontent.com/frank-w/BPI-Router-Linux/${commit}/arch/arm64/boot/dts/mediatek/${mtDtsName}";
      hash = "sha256-Hb/46yPl3EVIHh0EV8ljHHE169xKsV3OODWzs/kxd8w=";
    };

    bpiDtsName = "mt7988a-bananapi-bpi-r4.dts";
    bpiDts = fetchurl {
      url = "https://raw.githubusercontent.com/frank-w/BPI-Router-Linux/${commit}/arch/arm64/boot/dts/mediatek/${bpiDtsName}";
      hash = "sha256-ePrRfSi6jLTJxLSh8nX9IqhI7XswwkNt9VkyAkFBZcU=";
    };
  in
    oldAttrs.postPatch
    + ''
      cp ${bpiDts} arch/arm64/boot/dts/mediatek/${bpiDtsName}
      cp ${mtDts} arch/arm64/boot/dts/mediatek/${mtDtsName}
    '';
})
