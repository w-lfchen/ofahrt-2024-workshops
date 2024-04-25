{
  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      packages.${system}.default = (pkgs.writeShellScriptBin "marp-build" "${pkgs.marp-cli}/bin/marp $1");

      devShells.${system}.default = pkgs.mkShell { packages = with pkgs; [ marp-cli ]; };

      formatter.${system} = pkgs.nixfmt-rfc-style;
    };
}
