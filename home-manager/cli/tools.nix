{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Utilities
    bat # cat alternative
    eza # ls alternative
    ghq # git repository manager
    httpie # http client
    jq # json parser
    lazydocker # docker tui
    lazygit # git tui
    nh # nix cli helper
    nurl # generate nix fetcher
    ripgrep # grep alternative
  ];
}
