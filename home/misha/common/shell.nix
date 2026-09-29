# Zsh configuration
{ pkgs, ... }:
{
  home.sessionPath = [
    "$HOME/.bun/bin"
  ];

  home.sessionVariables = {
    NIXPKGS_ALLOW_UNFREE = "1";
  };

  programs.fzf.enable = true;

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "docker"
        "docker-compose"
        "uv"
        "command-not-found"
        "dotenv"
        "golang"
        "sudo"
      ];
    };

    initContent = ''
      # Bun completions
      [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

      # Pure prompt
      fpath+=("${pkgs.pure-prompt}/share/zsh/site-functions")
      autoload -U promptinit && promptinit
      prompt pure

      # fzf-tab
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh

      # SSH completion from ~/.ssh/config
      zstyle ':completion:*:ssh:*' users
      zstyle ':completion:*:ssh:*' hosts $(grep "^Host " ~/.ssh/config 2>/dev/null | grep -v "[?*]" | awk '{print $2}' | tr -d '\r' | tr '\n' ' ')
    '';
  };
}
