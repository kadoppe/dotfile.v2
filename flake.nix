{
  description = "NixOS & homa-manager configurations of kadoppe";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS hardware configurations
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # Hyprland
    hyprland.url = "github:hyprwm/Hyprland";
    hyprsome = {
      url = "github:sopa0/hyprsome";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      allSystems = [
        "aarch64-linux" # 64-bit ARM Linux
        # "x86_64-linux" # 64-bit x86 Linux
        "aarch64-darwin" # 64-bit ARM macOS
        # "x86_64-darwin" # 64-bit x86 macOS
      ];
      forAllSystems = inputs.nixpkgs.lib.genAttrs allSystems;
    in
    {
      # packages = forAllSystems (system: import ./pkgs inputs.nixpkgs.legacyPackages.${system});

      nixosConfigurations = (import ./hosts inputs).nixos;
      darwinConfigurations = (import ./hosts inputs).darwin;

      homeConfigurations = (import ./hosts inputs).home-manager;

      devShells = forAllSystems (
        system:
        let
          pkgs = inputs.nixpkgs.legacyPackages.${system};
          formatters = with pkgs; [
            nixfmt-rfc-style
            rustfmt
            stylua
            taplo
          ];
          scripts = [
            (pkgs.writeScriptBin "update-input" ''
              nix flake lock --override-input "$1" "$2" 
            '')
          ];
        in
        {
          default = pkgs.mkShell { packages = ([ pkgs.nh ]) ++ formatters ++ scripts; };
        }
      );

      formatter = forAllSystems (
        system:
        let
          pkgs = inputs.nixpkgs.legacyPackages.${system};
          formatters = with pkgs; [
            nixfmt-rfc-style
            rustfmt
            stylua
            taplo
          ];
          format = pkgs.writeScriptBin "format" ''
            PATH=$PATH:${pkgs.lib.makeBinPath formatters}
            ${pkgs.treefmt}/bin/treefmt --config-file ${./treefmt.toml}
          '';
        in
        format
      );
    };
}
