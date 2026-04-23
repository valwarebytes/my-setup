{...}: {
  hjem.extraModules = [
    {
      files.".config/hypr/hyprpaper.conf".text =
        /*
        hyprlang
        */
        ''
          wallpaper {
            monitor=
            fit_mode=cover
            path=/home/val/Pictures/hyprland-wp.webp
          }
          ipc=true
          splash=false
        '';
    }
  ];
}
