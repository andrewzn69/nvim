{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  home.packages = with pkgs; [
    # language servers
    bash-language-server
    lua-language-server
    typescript-language-server
    vscode-langservers-extracted # css-lsp, html-lsp, json-lsp, eslint-lsp
    dockerfile-language-server
    gopls
    helm-ls
    hyprls
    nodePackages.intelephense
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
    nodePackages.prettier
    prettierd
    php83Packages.php-cs-fixer
    shellharden
    shfmt
    nodePackages.stylelint
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

  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixos/modules/neovim/config";
}
