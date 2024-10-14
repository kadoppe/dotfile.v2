{
  inputs,
  pkgs,
  username,
  ...
}:
{
  imports =
    [
       # ../../modules/core
      # ../../modules/desktop
      # ../../modules/programs/flatpak.nix
      # ../../modules/programs/hyprland.nix
      # ../../modules/programs/media.nix
      # ../../modules/programs/nix-ld.nix
      # ../../modules/programs/secureboot.nix
      # ../../modules/programs/shell.nix
      # ../../modules/programs/steam.nix
    ]
    ++ (with inputs.nixos-hardware.nixosModules; [
      # common-cpu-amd
      # common-gpu-amd
      # common-pc-ssd
    ]);

  # boot = {
  #   loader = {
  #     systemd-boot.enable = true;
  #     efi.canTouchEfiVariables = true;
  #   };
  #   kernelPackages = pkgs.linuxPackages_xanmod_latest;
  # };

  # Don't touch this
  system.stateVersion = 5;

  services.nix-daemon.enable = true;

  environment = {
    shells = [ pkgs.fish ];
    systemPackages = with pkgs; [
      git
      m-cli
      mas
      nix-output-monitor
    ];
  };

  # users.users."${username}" = {
  #   isNormalUser = true;
  #   shell = pkgs.fish;
  #   extraGroups = [
  #     "networkmanager"
  #     "wheel"
  #     "audio"
  #     "video"
  #   ];
  # };
  #
  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     default_session = {
  #       command = ''
  #         ${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland
  #       '';
  #       user = username;
  #     };
  #   };
  # };
}
