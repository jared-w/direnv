{
  description = "direnv -- unclutter your .profile";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs?rev=73369f8d0864854d1acfa7f1e6217f7d6b6e3fa1";

  outputs = { self, nixpkgs }:
    let
      suportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs suportedSystems;
      pkgsFor = system: import nixpkgs { inherit system; };
    in
    {
      packages = forAllSystems (system: {
        direnv = import ./default.nix { pkgs = pkgsFor system; };
      });

      defaultPackage = forAllSystems (system: self.packages.${system}.direnv);
      devShell = forAllSystems (system: import ./shell.nix { pkgs = pkgsFor system; });
    };
}
