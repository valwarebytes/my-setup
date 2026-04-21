{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
  in {
    nixosConfigurations = {
      # # Workstation
      # jade = inputs.nixpkgs.lib.nixosSystem {
      #   inherit system;
      #   modules = [
      #     inputs.hjem.nixosModules.default
      #     ./hosts/jade/configuration.nix
      #   ];
      # };
      # Laptop
      ruby = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          inputs.hjem.nixosModules.default
          ./hosts/ruby/configuration.nix
        ];
      };
    };
  };
}
