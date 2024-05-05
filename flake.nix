{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    rose-pine-moon = {
      url = "https://raw.githubusercontent.com/rnd195/marp-community-themes/live/themes/rose-pine-moon.css";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      rose-pine-moon,
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      packages.${system}.default = (
        pkgs.writeShellScriptBin "marp-build" "${pkgs.marp-cli}/bin/marp --theme ${rose-pine-moon} $1"
      );

      devShells.${system}.default = pkgs.mkShell { packages = with pkgs; [ marp-cli ]; };

      formatter.${system} = pkgs.nixfmt-rfc-style;
    };
}
