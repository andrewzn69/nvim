{
  description = "neovim config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      homeModules.default = nixpkgs.lib.modules.importApply ./hm-module.nix { inherit nixpkgs; };

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = [
            pkgs.stylua
            pkgs.lua51Packages.luacheck
          ];
        };

        smoke-test = pkgs.mkShellNoCC {
          packages = [
            pkgs.neovim
            pkgs.git
            # nvim-treeshitter downloads parsers with curl and builds them with C compiler and tree-shitter cli
            pkgs.curl
            pkgs.gcc
            pkgs.tree-sitter
          ];
        };

        renovate-package-name-overrides = pkgs.mkShellNoCC {
          packages = [
            pkgs.neovim-unwrapped
          ];
        };
      });
    };
}
