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
            path=/home/val/Pictures/hyprland-wp.jpg
          }
          ipc=true
          splash=false
        '';
    }
  ];
}
