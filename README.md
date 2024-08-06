# NixOS on the Banana Pi R4

I was inspired by the [NixOS router blog] to use NixOS for a router.

In that blog the author uses a [Banana Pi R3].
Since then [Banana Pi R4] has been released.

I did not find any prior information about running NixOS on the [Banana Pi R4].
Hopefully this repository can help the next person.

This is not a complete reference, the [NixOS router blog] goes into more detail.
Most of the information for the R3 bootflow applies to the R4.

## ARM Trusted Firmware (ATF)

* `2.7.0-mtk` -> `2.10.0-mtk`. Likely unnecessary.
* Replaced `DRAM_USE_DDR4=1` with `DRAM_USE_COMB=1`.

## u-boot

* Removed the patches for a consistent MAC, conflicts on the latest version.
* Updated the environment file addresses. Likely has bugs.

## Kernel

* Used Frank Wunderlich's kernel fork containing patches for the R4.

## Status

Boots into an interactive shell.
Contains an error during stage 1 that needs to be fixed.

See `bootlog.txt` for more information.

[nixos-sbc]: https://github.com/nakato/nixos-sbc
[Banana Pi R3]: https://wiki.banana-pi.org/Banana_Pi_BPI-R3
[Banana Pi R4]: https://wiki.banana-pi.org/Banana_Pi_BPI-R4
[NixOS router blog]: https://github.com/ghostbuster91/blogposts/blob/a2374f0039f8cdf4faddeaaa0347661ffc2ec7cf/router2023/main.md
