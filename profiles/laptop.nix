{...}: {
  imports = [
    ./common.nix # shared configuration portion of all my machines
    # Rest is modules unique to the laptop
  ];
}
