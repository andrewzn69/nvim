{ config, pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withRuby = true;
    withPython3 = true;
  };

  home.packages = with pkgs; [
    # language servers
    astro-language-server
    bash-language-server
    lua-language-server
    typescript-language-server
    vscode-langservers-extracted # css-lsp, html-lsp, json-lsp, eslint-lsp
    dockerfile-language-server
    gopls
    helm-ls
    hyprls
    intelephense
    nil
    jinja-lsp
    prisma-language-server
    rust-analyzer
    tailwindcss-language-server
    terraform-ls
    texlab
    tinymist
    vue-language-server
    yaml-language-server
    marksman
    clang-tools

    # formatters
    black
    biome
    isort
    prettier
    prettierd
    php83Packages.php-cs-fixer
    shellharden
    shfmt
    stylelint
    stylua
    yamlfmt

    # treesitter
    tree-sitter

    # linters and tools
    shellcheck
    markdownlint-cli
    tflint
    yamllint
    bibtex-tidy
    jq
    nixfmt
  ];

  home.activation.nvimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ln -sfn ${config.home.homeDirectory}/.config/nixos/modules/neovim/config ${config.home.homeDirectory}/.config/nvim
  '';
}
