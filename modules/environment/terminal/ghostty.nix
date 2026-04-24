{...}: {
  hjem.extraModules = [
    {
      files.".config/ghostty/config".text =
        /*
        hyprlang
        */
        ''
          theme = Catppuccin Mocha
          background-opacity = 0.7
        '';
    }
  ];
}
