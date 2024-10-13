inputs:
let
  mkNixosSystem =
    {
      system,
      hostname,
      username,
      modules,
    }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system modules;
      specialArgs = {
        inherit inputs hostname username;
      };
    };

  mkHomeManagerConfiguration =
    {
      system,
      username,
      overlays,
      modules,
    }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        inherit system overlays;
        config = {
          allowUnfree = true;

          # FIX: How to solve this?
          permittedInsecurePackages = [ "electron-25.9.0" ];
        };
      };
      extraSpecialArgs = {
        inherit inputs username;
        theme = (import ../themes) "tokyonight-moon";
        pkgs-stable = import inputs.nixpkgs-stable {
          inherit system overlays;
          config = {
            allowUnfree = true;
          };
        };
      };
      modules = modules ++ [
        {
          home = {
            inherit username;
            homeDirectory = "/home/${username}";
            stateVersion = "22.11";
          };
          programs.home-manager.enable = true;
          programs.git.enable = true;
        }
      ];
    };
in
{
  nixos = {
    moca = mkNixosSystem {
      system = "aarch64-linux";
      hostname = "moca";
      username = "kadoppe";
      modules = [ ./moca/nixos.nix ];
    };
  };

  home-manager = {
    "kadoppe@moca" = mkHomeManagerConfiguration {
      system = "aarch64-linux";
      username = "kadoppe";
      modules = [ ./moca/home-manager.nix ];
    };
  };
}
