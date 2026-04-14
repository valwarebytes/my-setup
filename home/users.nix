{...}: let
  user = "val";
in {
  users.users.${user} = {
    isNormalUser = true;
    description = "Primary User";
    extraGroups = ["networkmanager" "wheel" "docker"];
  };
}
