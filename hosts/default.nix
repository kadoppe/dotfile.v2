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

  mkDarwinSystem = 
    {
      system,
      hostname,
      username, 
      modules,
    }:
    inputs.nix-darwin.lib.darwinSystem {
      inherit system modules;
      specialArgs = { 
        # inherit (nixpkgs) lib; 
        inherit inputs hostname username; 
      };
    };

  mkHomeManagerConfiguration =
    {
      system,
      username,
      homeDirectory,
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
            inherit username homeDirectory;
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

  darwin = {
    thunder = mkDarwinSystem {
      system = "aarch64-darwin";
      hostname = "thunder";
      username = "kadowaki";
      modules = [ ./thunder/nixos.nix ];
    };
  };

  home-manager = {
    "kadoppe@moca" = mkHomeManagerConfiguration {
      system = "aarch64-linux";
      username = "kadoppe";
      homeDirectory = "/home/kadoppe";
      overlays = [];
      modules = [ ./moca/home-manager.nix ];
    };
    "kadowaki@thunder" = mkHomeManagerConfiguration {
      system = "aarch64-darwin";
      username = "kadowaki";
      homeDirectory = "/Users/kadowaki";
      overlays = [];
      modules = [ ./thunder/home-manager.nix ];
    };
  };
}
