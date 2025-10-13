{
  description = "flake template for various devShells";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        # To import a flake module
        # 1. Add foo to inputs
        # 2. Add foo as a parameter to the outputs function
        # 3. Add here: foo.flakeModule

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
        };
      };
    };
}
