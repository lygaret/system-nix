{ config, pkgs, system, runtimePath, ... }:
{
  home.username = "jonathan";
  home.homeDirectory = "/Users/jonathan";
  home.stateVersion = "23.11"; # Please read docs

  home.packages = with pkgs; [
    direnv
    cachix
    devenv
    node2nix

    emacs-lsp-booster

    bat   # cat with source highlighting
    delta # diff with source highlighting, same color schemes as bat
    eza   # better ls
    neofetch

    git
    htop
    pandoc
    ripgrep
    jq
  ];

  launchd.enable = true;
  launchd.agents = {
    emacsd = {
      enable = true;
      config = {
        Label              = "gnu.emacs.daemon";
        KeepAlive          = true;
        RunOnLoad          = true;

        ProgramArguments   = [
          "/bin/zsh" "--login" "-i" "-c"
          "/Applications/Emacs.app/Contents/MacOS/Emacs --daemon"
        ];

        StandardOutPath    = "/tmp/emacs-daemon.stdout.log";
        StandardErrPath    = "/tmp/emacs-daemon.stderr.log";
      };
    };
  };

  home.file = let
    linkfile = config.lib.file.mkOutOfStoreSymlink;
  in {
    "local/.editorconfig".source = linkfile (runtimePath ./config/editorconfig);

    ".config/git/config".source  = linkfile (runtimePath ./config/git.d/config);

    ".emacs.d/init.el".source   = linkfile (runtimePath ./config/emacs.d/init.el);
    ".emacs.d/custom.el".source = linkfile (runtimePath ./config/emacs.d/custom.el);

    ".zshrc".source             = linkfile (runtimePath ./config/zsh.d/zshrc);
    ".zshenv".source            = linkfile (runtimePath ./config/zsh.d/zshenv);
  };

  home.sessionVariables = {
  };

  programs.home-manager.enable = true;
}
