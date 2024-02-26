{
  description = "Home Manager configuration of jonathan";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    emacs-lsp-booster = {
      url = "github:slotThe/emacs-lsp-booster-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, devenv, home-manager, emacs-lsp-booster, ... }:
    let
      system = "aarch64-darwin";
      pkgs   = nixpkgs.legacyPackages.${system};
      lib    = nixpkgs.lib;

      home-overlays = {
        nixpkgs.overlays = [
          devenv.overlays.default
          emacs-lsp-booster.overlays.default
        ];
      };

      runtimeRoot = "/Users/jonathan/local/system";
      runtimePath = path:
        let
          # This is the `self` that gets passed to a flake `outputs`.
          rootStr = toString self;
          pathStr = toString path;
        in
          assert lib.assertMsg
            (lib.hasPrefix rootStr pathStr)
            "${pathStr} does not start with ${rootStr}";
          runtimeRoot + lib.removePrefix rootStr pathStr;
    in {
      homeConfigurations."jonathan" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./home.nix
          home-overlays
        ];

        # use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          inherit system runtimePath;
        };
      };
    };
}
