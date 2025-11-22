{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  environment.systemPackages = with pkgs; [
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

    # linters and tools
    shellcheck
    markdownlint-cli
    tflint
    yamllint
    bibtex-tidy
    jq
    nixfmt
  ];

  # create symlink to neovim config, TODO: do it with home-manager
  system.userActivationScripts.neovimConfig = ''
    if [ ! -L /home/zemn/.config/nvim ]; then
      rm -rf /home/zemn/.config/nvim
      ln -sf /home/zemn/.config/nixos/modules/neovim/config /home/zemn/.config/nvim
    fi
  '';
}
