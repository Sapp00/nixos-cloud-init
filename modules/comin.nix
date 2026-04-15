{ lib, pkgs, config, ... }:

{
  services.comin = {
    enable = true;
    remotes = [{
      name = "origin";
      url = "git@github.com:Sapp00/nix-infra.git";
      auth.access_token_path = config.sops.secrets."github/access_token".path;
    }];
  };
}
