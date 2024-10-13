{ pkgs, ... }:
{
  programs = {
    fish.enable = true;
    # starship = {
    #   enable = true;
    # };
    # git = {
    #   enable = true;
    # };
    # neovim = {
    #   enable = true;
    #   defaultEditor = true;
    #   viAlias = true;
    #   vimAlias = true;
    # };
  };

  environment.systemPackages = with pkgs; [
    git
  ];
}
