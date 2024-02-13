{
  description = "Home Manager configuration of jonathan";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
      lib = nixpkgs.lib;
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
        modules = [ ./home.nix ];

        # use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = { inherit runtimePath; };
      };
    };
}
