{ config, pkgs, runtimePath, ... }:
{
  home.username = "jonathan";
  home.homeDirectory = "/Users/jonathan";
  home.stateVersion = "23.11"; # Please read docs

  home.packages = with pkgs; [
    cachix
    direnv
    node2nix

    git
    pandoc
    ripgrep

    bat
    eza
    htop
    neofetch
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
    ".emacs.d/init.el".source   = linkfile (runtimePath ./emacs.d/init.el);
    ".emacs.d/custom.el".source = linkfile (runtimePath ./emacs.d/custom.el);

    ".zshrc".source             = linkfile (runtimePath ./zsh.d/zshrc);
    ".zprofile".source          = linkfile (runtimePath ./zsh.d/zprofile);
  };

  home.sessionVariables = {
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
