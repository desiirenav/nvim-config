{inputs}: final: prev:
with final.pkgs.lib; let
  pkgs = final;
  mkNvimPlugin = src: pname:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.lastModifiedDate;
    };

  pkgs-locked = inputs.nixpkgs.legacyPackages.${pkgs.system};

  mkNeovim = pkgs.callPackage ./mkNeovim.nix {
      inherit (pkgs-locked) wrapNeovimUnstable neovimUtils;
    };

  all-plugins = with pkgs.vimPlugins; [
    nord-nvim
    nvim-treesitter.withAllGrammars
    luasnip
    nvim-cmp
    cmp_luasnip
    lspkind-nvim
    cmp-nvim-lsp
    cmp-nvim-lsp-signature-help
    cmp-buffer
    cmp-path
    cmp-nvim-lua
    cmp-cmdline
    cmp-cmdline-history
    telescope-nvim
    telescope-fzy-native-nvim
    vim-unimpaired
    eyeliner-nvim
    nvim-surround
    nvim-treesitter-textobjects
    nvim-ts-context-commentstring
    nvim-unception
    sqlite-lua
    plenary-nvim
    nvim-web-devicons
    vim-repeat
    which-key-nvim
  ];

  extraPackages = with pkgs; [
    lua-language-server
    nil 
  ];
in {
  nvim-pkg = mkNeovim {
    plugins = all-plugins;
    inherit extraPackages;
  };

  nvim-dev = mkNeovim {
    plugins = all-plugins;
    inherit extraPackages;
    appName = "nvim-dev";
    wrapRc = false;
  };

  # This can be symlinked in the devShell's shellHook
  nvim-luarc-json = final.mk-luarc-json {
    plugins = all-plugins;
  };
}
