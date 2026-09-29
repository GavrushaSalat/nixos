# Overlay definitions: unstable channel + external flake packages
{ inputs }:
{
  unstable = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };

  claude-code = final: _prev: {
    claude-code = inputs.claude-code-nix.packages.${final.stdenv.hostPlatform.system}.claude-code;
  };

  claude-desktop = inputs.claude-desktop.overlays.default;

  codex-desktop = final: _prev: {
    codex-desktop = inputs.codex-desktop-linux.packages.${final.stdenv.hostPlatform.system}.codex-desktop;
  };

  firefox-nightly = final: _prev: {
    firefox-nightly-bin = inputs.firefox-nightly.packages.${final.stdenv.hostPlatform.system}.firefox-nightly-bin;
  };
}
