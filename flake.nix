{
  description = "flake template for various devShells";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.treefmt-nix.flakeModule
      ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem =
        { pkgs, ... }:
        {
          devShells.default = pkgs.mkShell {
            name = "nix devshell";
            buildInputs = with pkgs; [
              nixd
              nixfmt-rfc-style
              statix
              deadnix
            ];
          };
          # formatter
          treefmt = {
            projectRootFile = "flake.nix";
            programs.deadnix.enable = true;
            programs.nixfmt.enable = true;
            programs.nixfmt.package = pkgs.nixfmt-rfc-style;
            programs.jsonfmt.enable = true;
          };
        };
      flake = {
        templates = rec {
          default = nix;
          nix = {
            path = ./templates/nix;
            description = ''
              A basic Nix devShell.
            '';
          };
          cpp = {
            path = ./templates/cpp;
            description = ''
              A basic cpp devShell with cmake.
            '';
          };
          md = {
            path = ./templates/md;
            description = ''
              A basic markdown devShell.
            '';
          };
        };
      };
    };
}
