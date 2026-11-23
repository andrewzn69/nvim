{
  config,
  lib,
  pkgs,
  ...
}:

let
  restorePlugins = pkgs.writeShellApplication {
    name = "nvim-restore-plugins";
    runtimeInputs = [
      config.programs.neovim.finalPackage
      pkgs.git
    ];
    runtimeEnv = {
      LOCKFILE = "${./lua/plugins/lazy-lock.json}";
      PROFILE_BIN = "${config.home.profileDirectory}/bin";
    };
    text = builtins.readFile ./scripts/restore-plugins.sh;
  };
in

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withRuby = true;
    withPython3 = true;
    sideloadInitLua = true;
  };

  home.packages = with pkgs; [
    # language servers
    astro-language-server
    bash-language-server
    lua-language-server
    # typescript-language-server
    vscode-langservers-extracted # css-lsp, html-lsp, json-lsp, eslint-lsp
    dockerfile-language-server
    gopls
    pyright
    helm-ls
    hyprls
    intelephense
    nixd
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
    phpPackages.php-cs-fixer
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

  xdg.configFile."nvim" = {
    source = ./.;
    onChange = "run ${lib.getExe restorePlugins}";
  };
}
