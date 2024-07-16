{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/9355fa86e6f27422963132c2c9aeedb0fb963d93";
    nix.url = "github:NixOS/nix/9300f855fcafe5b2b495f62b796837e5c08ccea3";
  };
  outputs = { nixpkgs, nix, ... }: {
    packages.x86_64-linux.default =
      let
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
      in pkgs.runCommand "nixpkgs-formatted"
      {
        nativeBuildInputs = [
          nix.packages.x86_64-linux.nix
          pkgs.gitMinimal
        ];
      }
      ''
        set -euo pipefail
        export NIX_STATE_DIR=$(mktemp -d)

        echo "a.nix:"
        nix-instantiate --parse ${./a.nix} | tee a
        echo "b.nix:"
        nix-instantiate --parse ${./b.nix} | tee b
        echo "Diff:"
        git -P diff --no-index --word-diff a b
      '';
  };
}
