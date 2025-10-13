{
  description = "A flake for c-cpp devShells";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
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
            name = "c-cpp devShell";
            buildInputs = with pkgs; [
              clang-tools
              vcpkg
              vcpkg-tool
              cmake
              cmake-format
              cmake-language-server
              cmake-lint
            ];
          };
        };
    };
}
