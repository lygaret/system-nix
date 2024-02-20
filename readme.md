system configuration

* nix for package management
* home-manager for files and shell environment
* devenv for development environments and tools
* nix flakes for one-off packaging

---

to apply:

- `home-manager --flake ./system switch`

to apply globally:

- `nix registry add flake:localsys git+file:///path/to/repo`
- `home-manager --flake localsys switch`

to run tools:

- `nix run localsys#tools/httpbin -- --bind 0.0.0.0:12345`
