{...}: {
  imports = [
    ./hardware-configuration.nix # ruby's
    ../../profiles/laptop.nix # ruby is my host laptop
  ];

  networking.hostName = "ruby";
}
