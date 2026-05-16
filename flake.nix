{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware?ref=master";
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, ...} @ inputs: let
    inherit (nixpkgs) lib;
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

      ruby = lib.nixosSystem {
        modules = [
          inputs.hjem.nixosModules.default
          inputs.nixos-hardware.nixosModules.framework-16-7040-amd
          ./hosts/ruby/configuration.nix
        ];
      };
    };
  };
}
