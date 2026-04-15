{
  description = "NixOS bootstrap image (cloud-init+comin)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    disko.url = "github:nix-community/disko";
    comin = {
      url = "github:nlewo/comin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = { self, nixpkgs, disko, comin, sops-nix }:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.bootstrap = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        sops-nix.nixosModules.sops
        comin.nixosModules.comin
        disko.nixosModules.disko
        ./modules/sops.nix
        ./modules/comin.nix
        ./disko.nix
        ./system.nix
      ];
    };
  };
}
