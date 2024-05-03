---
marp: true
math: mathjax
---
<style>
section {
  background: #1e1e2e;
  color: #cdd6f4;
}
h1 {
  color: #cdd6f4;
  font-size: 200%;
  margin-bottom: -.3em;
}
</style>

# Nix Flakes
## Perfekte Workflows <br> leicht gemacht

![bg right:60% 80%](https://upload.wikimedia.org/wikipedia/commons/thumb/2/28/Nix_snowflake.svg/886px-Nix_snowflake.svg.png)

---
# Struktur des Workshops

![bg right:60% 80%](https://upload.wikimedia.org/wikipedia/commons/thumb/2/28/Nix_snowflake.svg/886px-Nix_snowflake.svg.png)

---
# Nix
## Was war das nochmal?
- Nix als DSL
- Package Manager Nix
- Github-Repo nixpkgs
- Linux-Distro NixOS

---
# Features
- Reproduzierbarkeit
- Deklarativität
- Isolierung

---
# Lockfiles
## Wunderbares Dependency Management in Build-Systemen
z.B. npm (`package-lock.json`) oder Cargo (`Cargo.lock`)
```toml
[[package]]
name = "serde"
version = "1.0.192"
source = "registry+https://github.com/rust-lang/crates.io-index"
checksum = "bca2a08484b285dcb282d0f67b26cadc0df8b19f8c12502c13d966bf9482f001"
dependencies = [
 "serde_derive",
]
```
*Beispielhafter Eintrag aus einer `Cargo.lock`-Datei*
- Eindeutige Festlegung der Dependency
- Absicherung durch Hashes

---
# Nix Channels
Sehr iterativer Ansatz für ein auf Deklarativität aufbauendes System
```sh
sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
sudo nix-channel --update nixos
```
*Beispielhafte Management-Commands für Nix Channels*

$\leadsto$ Reproduzierbar (da auf Commits festgelegt), aber nicht sonderlich ergonomisch

## Die Lösung: Nix Flakes

---
# Warum Flakes?
- Lockfiles (`flake.lock`)
- Neue CLI-API (`nix <subcommand>`)
- Sehr gute Integration mit anderen Flakes
- Flake Registry
- Einfach zu nutzen
- Streamlining vieler Prozesse
- Popularität

---
# Grundlagen
- Eine `flake.nix`-Datei pro Projekt
- Flakes besitzen Inputs, diese werden dann in `flake.lock` gepinnt
- Flakes deklarieren Outputs-Funktion, diese kann alles zurückgeben
  - Üblicherweise Derivations, Dev-Shells, ...

---
# Meine erste Flake
`nix flake init` initialisiert Flake in aktuellem Verzeichnis
```nix
{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

    packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

  };
}
```

---
# Häufige Flake Outputs
- `packages."<system>"."<name>" = derivation;`
  Wird gebaut mit `nix build .#<name>`
- `devShells."<system>"."<name>" = derivation;`
  Entwicklungsumgebungen; Aktivierung durch `nix develop .#<name>`
- `formatter."<system>" = derivation;`
  Formatter, Nutzung durch `nix fmt`
- `overlays."<name>" = final: prev: { };`
  Nixpkgs Overlays, können gut in anderen Flakes genutzt werden
- `nixosModules."<name>" = ...`
  NixOS-Module, können für Systemkonfigurationen verwendet werden
- `nixosConfigurations."<hostname>" = {};`
  Ganze Systemkonfigurationen; `nixos-rebuild switch --flake .#<hostname>`

---
# Wichtige Befehle
### Zuerst: Experimental Features `nix-command flakes` aktivieren
- `nix build`: Baue Flake Output in den Nix Store, erstelle `result`-Symlink
- `nix run`: Führe Programm aus Flake aus
- `nix develop`: Starte Entwicklungsumgebung
- `nix flake <subcommand>`: Verwalte Flakes
  - `nix flake update`: Update Inputs in `flake.lock`
  - `nix flake show`: Liste Outputs einer Flake
  - `nix flake check`: Teste verschiedene Dinge

---
# Flake-Grundlage für ein Projekt
Achtung: Subjektivität!
```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      packages.${system} = {
        "<name>" = {};
        default = self.packages.${system}."<name>";
      };

      devShells.${system}.default = pkgs.mkShell { packages = with pkgs; [ hello ]; };

      formatter.${system} = pkgs.nixfmt-rfc-style;
    };
}
```

---
# Beispiele für Flakes und Workflows
