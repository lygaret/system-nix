{
  description = "httpbin";

  inputs = {
    nixpkgs.url    = "github:nixos/nixpkgs/nixos-unstable";
    flakeutils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flakeutils, ... }:
    # flakeutils.lib.eachDefaultSystem (system:
    let system = "aarch64-darwin"; in
      let
        pkgs   = import nixpkgs { inherit system; };
        python = pkgs.python3.withPackages (ps: with ps; [
          gunicorn
          httpbin
        ]);
      in {
        packages.${system}.default = pkgs.writeShellApplication {
          name = "httpbin";
          text = ''
            ${python}/bin/gunicorn httpbin:app "$@"
          '';

          runtimeInputs = [ python ];
        };
      };
}
