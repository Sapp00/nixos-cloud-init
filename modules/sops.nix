{
  # Configure sops to use the machine's age key
  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    age.keyFile = "/var/lib/sops-nix/key.txt";
  };

  sops.secrets."github/access_token" = {
    sopsFile = ../secrets/secrets.yaml;
  };
}
