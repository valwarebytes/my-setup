{pkgs, ...}: let
  user = "val";
in {
  hjem.users.${user} = {
    enable = true;
    directory = "/home/${user}";
  };

  programs.fish.enable = true;
  users.users.${user} = {
    shell = pkgs.fish;
  };
}
