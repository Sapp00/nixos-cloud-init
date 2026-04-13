{ lib, pkgs, ... }:

{
  services.comin = {
    enable = true;
    remotes = [{
      name = "origin";
      url = "git@github.com:your-username/your-repo.git";
      auth.access_token_path = "/etc/ssh/github_deploy_key"; # The baked-in key
    }];
  };
}
