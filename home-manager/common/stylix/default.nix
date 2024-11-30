{pkgs, ...}: {
  stylix = {
    enable = true;
    image = ../../assets/wallpapers/leaves.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/one-dark.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
  };
}
