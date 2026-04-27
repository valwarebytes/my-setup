{pkgs, ...}: let
  my-sddm-theme = pkgs.where-is-my-sddm-theme.override {
    themeConfig.General = {
      passwordCursorColor = "#12ff12"; # fo4 green
    };
  };
in {
  environment.systemPackages = [my-sddm-theme];

  services.displayManager.sddm = {
    enable = true;
    theme = "where_is_my_sddm_theme";
    extraPackages = [
      pkgs.kdePackages.qt5compat
      my-sddm-theme
    ];
  };
}
