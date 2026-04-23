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
            path=/path/to/wallpaper.jpg
          }
          ipc=true
          splash=false
        '';
    }
  ];
}
