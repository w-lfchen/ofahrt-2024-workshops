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
      packages.${system} =
        let
          files = [
            "flakes"
            "rust"
          ];
        in
        nixpkgs.lib.genAttrs files (
          name:
          pkgs.stdenv.mkDerivation {
            name = "ofahrt-2024-${name}-slides";
            src = ./.;
            buildInputs = with pkgs; [ marp-cli ];
            buildPhase = ''
              marp --theme ${rose-pine-moon} ${name}.md
            '';
            installPhase = ''
              mkdir -p $out
              cp ${name}.html $out
            '';
          }
        )
        // {
          all = pkgs.symlinkJoin {
            name = "ofahrt-2024-all-slides";
            paths = builtins.map (name: self.packages.${system}.${name}) files;
          };
          default = self.packages.${system}.all;
        };

      devShells.${system}.default = pkgs.mkShell { packages = with pkgs; [ marp-cli ]; };

      formatter.${system} = pkgs.nixfmt-rfc-style;
    };
}
