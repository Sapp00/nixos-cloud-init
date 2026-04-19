{ lib, pkgs, config, ... }:

{
  services.comin = {
    enable = true;
    hostname = "DYNAMIC";
    remotes = [{
      name = "origin";
      url = "https://github.com/Sapp00/nix-infra.git";
      branches.main.name = "main";
      auth.access_token_path = config.sops.secrets."github/access_token".path;
    }];
  };

  systemd.services.comin = {
    serviceConfig.ExecStart = lib.mkForce (
      let
        # Manually forged Comin command
        args = "--remote name=origin,url=https://github.com/Sapp00/nix-infra.git,auth.access_token_path=/run/secrets/github/access_token";
      in
      "${pkgs.comin}/bin/comin ${args}"
    );
  };
}
