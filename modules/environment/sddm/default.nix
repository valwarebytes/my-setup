{pkgs, ...}: {
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.theme = "where_is_my_sddm_theme";
  services.displayManager.sddm.extraPackages = [pkgs.kdePackages.qt5compat];

  # wayland.enable = true; # not sure i need this experimental wayland support
}
