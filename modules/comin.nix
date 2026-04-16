{ lib, pkgs, config, ... }:

{
  services.comin = {
    enable = true;
    remotes = [{
      name = "origin";
      url = "https://github.com/Sapp00/nix-infra.git";
      branches.main.name = "main";
      auth.access_token_path = config.sops.secrets."github/access_token".path;
    }];
  };
}
