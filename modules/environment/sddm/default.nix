{pkgs, ...}: let
  my-sddm-theme = pkgs.where-is-my-sddm-theme.override {
    themeConfig.General = {
      passwordCursorColor = "#00ff00"; # solid green
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
