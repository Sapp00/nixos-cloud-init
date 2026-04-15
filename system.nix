{ lib, pkgs, ... }:

{
  networking.useNetworkd = true;
  networking.useDHCP = false;
  systemd.network = {
    enable = true;
    networks."10-eth" = {
      matchConfig.Name = "en*";
      networkConfig.DHCP = "yes";
    };
  };

  # kexec-capable kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "console=tty0"
    "console=ttyS0,115200"
    "ds=nocloud;s=/dev/sr0"
  ];

  systemd.services."serial-getty@ttys0".enable = true;

  # Grub
  boot = {
    loader.grub = {
      enable = true;
      efiSupport = true;
    };
    initrd.availableKernelModules = [ "virtio_net" "virtio_pci" "virtio_mmio" "virtio_blk" "virtio_scsi" "9p" "9pnet_virtio" "sr_mod"];
  };

  # SSH
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = true;
    };
  };

  # qemu
  services.qemuGuest.enable = true;

  # cloud-init support
  services.cloud-init = {
    enable = true;
    network.enable = true;
    settings = {
      # Force it to look for Proxmox's drive
      datasource_list = [ "ConfigDrive" "NoCloud" ];
      # Only run the modules that actually work on NixOS
      cloud_init_modules = [
        "migrator"
        "seed_random"
        "bootcmd"
        "set_hostname"
        "update_hostname"
        "update_etc_hosts"
      ];
      cloud_config_modules = [
        "runcmd"
        "ssh"
      ];
      cloud_final_modules = [
        "scripts-vendor"
        "scripts-user"
      ];
    };
  };

  # Force the service to not block the boot/rebuild even if it exits with status 1
  systemd.services.cloud-config.serviceConfig.PassEnvironment = "PATH";
  systemd.services.cloud-config.serviceConfig.SuccessExitStatus = "0 1";
  systemd.services.cloud-init.serviceConfig.SuccessExitStatus = "0 1";
  systemd.services.cloud-init-local.serviceConfig.SuccessExitStatus = "0 1";
  systemd.services.cloud-final.serviceConfig.SuccessExitStatus = "0 1";

# CRITICAL: Prevent nixos-rebuild switch from trying to restart cloud-init on a live system
  systemd.services.cloud-config.restartIfChanged = false;
  systemd.services.cloud-init.restartIfChanged = false;
  systemd.services.cloud-init-local.restartIfChanged = false;
  systemd.services.cloud-final.restartIfChanged = false;

  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = [
    pkgs.cloud-init
  ];

  users.allowNoPasswordLogin = false;
  users.mutableUsers = true;

  system.stateVersion = "25.11";

  users.users.admin = {
    isNormalUser = true;
    description = "Default user for access";
    extraGroups = [ "wheel" ];
  };
}
