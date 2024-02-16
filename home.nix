{ config, pkgs, devenvPkgs, system, runtimePath, ... }:
{
  home.username = "jonathan";
  home.homeDirectory = "/Users/jonathan";
  home.stateVersion = "23.11"; # Please read docs

  home.packages = with pkgs; [
    direnv
    node2nix

    cachix
    devenvPkgs.default

    git
    pandoc
    ripgrep

    bat
    eza
    htop
    neofetch
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
    ".emacs.d/init.el".source   = linkfile (runtimePath ./emacs.d/init.el);
    ".emacs.d/custom.el".source = linkfile (runtimePath ./emacs.d/custom.el);

    ".zshrc".source             = linkfile (runtimePath ./zsh.d/zshrc);
    ".zshenv".source            = linkfile (runtimePath ./zsh.d/zshenv);
  };

  home.sessionVariables = {
  };

  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "Jonathan Raphaelson";
    userEmail = "jonathan@ada-marie.com";

    extraConfig = {
      init = {
        defaultBranch = "main";
      };

      user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAa396Z/jGhCHAYkVn2KOouarbCBim0NTJgcURkVEvVQ";

      commit.gpgSign = true;
      tag.gpgSign = true;

      gpg = {
        format = "ssh";

        ssh = {
          program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
        };
      };
    };
  };
}
