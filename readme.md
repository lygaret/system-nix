dots and home-local packgaes configuration

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

---

other tools and plugins

- [sideberry for firefox](https://addons.mozilla.org/en-US/firefox/addon/sidebery/)
- [obsidian](https://obsidian.md) for notes
