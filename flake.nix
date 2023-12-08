{
  description = "Project Dirac";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, utils, pre-commit-hooks, rust-overlay }:
    with utils.lib;
    with nixpkgs.lib;
    eachSystem defaultSystems (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ rust-overlay.overlays.default ];
        };
      in
      rec {
        # nix develop
        devShells.default = pkgs.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
          nativeBuildInputs = with pkgs; [ typst typstfmt ];
        };

        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              nixpkgs-fmt.enable = true;

              shellcheck.enable = true;
              shfmt.enable = true;

              typstfmt = {
                enable = true;
                name = "Typst Format";
                entry = "${pkgs.typstfmt}/bin/typstfmt";
                files = "\\.(typ)$";
              };
            };
          };
        };
      });
}
