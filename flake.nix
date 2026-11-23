{
  description = "neovim config";

  outputs =
    { self }:
    {
      homeModules.default = ./hm-module.nix;
    };
}
