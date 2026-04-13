{
  description = "NixOS QCOW2 bootstrap image (cloud-init + kexec)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    disko.url = "github:nix-community/disko";
    comin = {
      url = "github:nlewo/comin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, disko, comin }:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.bootstrap = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        comin.nixosModules.comin
        disko.nixosModules.disko
        ./disko.nix
        ./system.nix
        ./comin.nix
      ];
    };
  };
}
