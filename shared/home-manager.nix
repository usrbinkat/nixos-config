{ config, pkgs, lib, ... }:

let name = "Kat Morgan";
    user = "usrbinkat";
    email = "kat@braincraft.io"; in
{
  # Direnv
  direnv = {
    enable = true;
    #nix-direnv.enaable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    # https://direnv.net/man/direnv.toml.1.html
    # https://mipmip.github.io/home-manager-option-search/?query=direnv
    # https://github.com/nix-community/nix-direnv
    #config = {
    #  "load_dotenv" = "true";
    #  "warn_timeout" = "1m";
    #};
  };
  # Shared shell configuration
  zsh.enable = true;
  zsh.autocd = true;
  zsh.cdpath = [ "~/.local/share/src" ];
  zsh.enableAutosuggestions = true;
  zsh.enableCompletion = true;
  zsh.syntaxHighlighting.enable = true;
  zsh.plugins = [
    {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    }
    {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./config;
        file = "p10k.zsh";
    }
  ];
  zsh.initExtraFirst = ''
    if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
      . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
    fi

    # Define variables for directories
    export PATH=$HOME/.pnpm-packages/bin:$HOME/.pnpm-packages:$PATH
    export PATH=$HOME/.npm-packages/bin:$HOME/bin:$PATH
    export PATH=$HOME/.local/share/bin:$PATH
    export PATH=/opt/homebrew/bin:$PATH
    export PNPM_HOME=~/.pnpm-packages

    # Remove history data we don't want to see
    export HISTIGNORE="pwd:ls:cd"

    # Ripgrep alias
    alias search=rg -p --glob '!node_modules/*'  $@

    # Emacs is my editor
    export ALTERNATE_EDITOR=""
    export EDITOR="emacsclient -t"
    export VISUAL="emacsclient -c -a emacs"

    e() {
        emacsclient -t "$@"
    }

    # nix shortcuts
    shell() {
        nix-shell '<nixpkgs>' -A "$1"
    }

    # pnpm is a javascript package manager
    alias pn=pnpm
    alias px=pnpx

    # Use difftastic, syntax-aware diffing
    alias diff=difft

    # Always color ls and group directories
    alias ls='ls --color=auto'
  '';

  git = {
    enable = true;
    ignores = [ "*.swp" ];
    userName = name;
    userEmail = email;
    lfs = {
      enable = true;
    };
    extraConfig = {
      init.defaultBranch = "main";
      core = { 
            editor = "vim";
            autocrlf = "input";
      };
      commit.gpgsign = false;
      pull.rebase = true;
      rebase.autoStash = true;
    };
  };

  vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [ vim-airline vim-airline-themes vim-startify vim-tmux-navigator ];
    settings = { ignorecase = true; };
    extraConfig = ''
      "" General
      set number
      set history=1000
      set nocompatible
      set modelines=0
      set encoding=utf-8
      set scrolloff=3
      set showmode
      set showcmd
      set hidden
      set wildmenu
      set wildmode=list:longest
      set cursorline
      set ttyfast
      set nowrap
      set ruler
      set backspace=indent,eol,start
      set laststatus=2
      set clipboard=autoselect

      " Dir stuff
      set nobackup
      set nowritebackup
      set noswapfile
      set backupdir=~/.config/vim/backups
      set directory=~/.config/vim/swap

      " Relative line numbers for easy movement
      set relativenumber
      set rnu

      "" Whitespace rules
      set tabstop=8
      set shiftwidth=2
      set softtabstop=2
      set expandtab

      "" Searching
      set incsearch
      set gdefault

      "" Statusbar
      set nocompatible " Disable vi-compatibility
      set laststatus=2 " Always show the statusline
      let g:airline_theme='bubblegum'
      let g:airline_powerline_fonts = 1

      "" Local keys and such
      let mapleader=","
      let maplocalleader=" "

      "" Change cursor on mode
      :autocmd InsertEnter * set cul
      :autocmd InsertLeave * set nocul

      "" File-type highlighting and configuration
      syntax on
      filetype on
      filetype plugin on
      filetype indent on

      "" Paste from clipboard
      nnoremap <Leader>, "+gP

      "" Copy from clipboard
      xnoremap <Leader>. "+y

      "" Move cursor by display lines when wrapping
      nnoremap j gj
      nnoremap k gk

      "" Map leader-q to quit out of window
      nnoremap <leader>q :q<cr>

      "" Move around split
      nnoremap <C-h> <C-w>h
      nnoremap <C-j> <C-w>j
      nnoremap <C-k> <C-w>k
      nnoremap <C-l> <C-w>l

      "" Easier to yank entire line
      nnoremap Y y$

      "" Move buffers
      nnoremap <tab> :bnext<cr>
      nnoremap <S-tab> :bprev<cr>

      "" Like a boss, sudo AFTER opening the file to write
      cmap w!! w !sudo tee % >/dev/null

      let g:startify_lists = [
        \ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
        \ { 'type': 'sessions',  'header': ['   Sessions']       },
        \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      }
        \ ]

      let g:startify_bookmarks = [
        \ '~/.local/share/src',
        \ ]

      let g:airline_theme='bubblegum'
      let g:airline_powerline_fonts = 1
      '';
     };

  alacritty = {
    enable = true;
    settings = {
      cursor = {
        style = "Block";
      };

      window = {
        opacity = 0.93;
        padding = {
          x = 2;
          y = 2;
        };
      };

      font = {
        normal = {
          family = "UbuntuMono Nerd Font Propo"; # CHANGED
          style = "Regular";
        };
        size = lib.mkMerge [
          (lib.mkIf pkgs.stdenv.hostPlatform.isLinux 10)
          (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin 14)
        ];
      };

      dynamic_padding = false;
      decorations = "full";
      title = "Terminal";
      class = {
        instance = "Alacritty";
        general = "Alacritty";
      };

      colors = {
        primary = {
          background = "0x1f2528";
          foreground = "0xc0c5ce";
        };

        normal = {
          black = "0x1f2528";
          red = "0xec5f67";
          green = "0x99c794";
          yellow = "0xfac863";
          blue = "0x6699cc";
          magenta = "0xc594c5";
          cyan = "0x5fb3b3";
          white = "0xc0c5ce";
        };

        bright = {
          black = "0x65737e";
          red = "0xec5f67";
          green = "0x99c794";
          yellow = "0xfac863";
          blue = "0x6699cc";
          magenta = "0xc594c5";
          cyan = "0x5fb3b3";
          white = "0xd8dee9";
        };
      };
    };
  };

  starship = {
    enable = true;
    enableZshIntegration = true;
  };

  ssh = {
    enable = true;
    compression = true;
    forwardAgent = true;
    matchBlocks = {
      mordor = {
        hostname = "192.168.1.21";
        user = "kc2admin";
        forwardAgent = true;
        identityFile = "~/.ssh/id_rsa.studio";
      };
      honeypot = {
        hostname = "192.168.1.91";
        user = "usrbinkat";
        forwardAgent = true;
        identityFile = "~/.ssh/id_rsa.studio";
      };
      vyos = {
        hostname = "192.168.1.1";
        user = "vyos";
        port = 2222;
        forwardAgent = true;
        identityFile = "~/.ssh/id_rsa.studio";
      };
      qotom = {
        hostname = "192.168.1.2";
        user = "kc2admin";
        forwardAgent = true;
        identityFile = "~/.ssh/id_rsa.studio";
      };
      herethegpu = {
        hostname = "75.26.213.116";
        user = "kat";
        forwardAgent = true;
        identityFile = "~/.ssh/id_rsa.studio";
      };
      tpi00 = {
        hostname = "192.168.1.70";
        user = "ubuntu";
        forwardAgent = true;
        identityFile = "~/.ssh/id_rsa";
      };
      tpi01 = {
        hostname = "192.168.1.71";
        user = "ubuntu";
        forwardAgent = true;
        identityFile = "~/.ssh/id_rsa";
      };
      tpi02 = {
        hostname = "192.168.1.72";
        user = "ubuntu";
        forwardAgent = true;
        identityFile = "~/.ssh/id_rsa";
      };
      tpi03 = {
        hostname = "192.168.1.73";
        user = "ubuntu";
        forwardAgent = true;
        identityFile = "~/.ssh/id_rsa";
      };
    };
    extraConfig = lib.mkMerge [
      ''
        AddKeysToAgent yes

        Host github.com
          Hostname github.com
          IdentitiesOnly yes
      ''
      (lib.mkIf pkgs.stdenv.hostPlatform.isLinux
        ''
          IdentityFile /home/${user}/.ssh/id_github
        '')
      (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
        ''
          IdentityFile /Users/${user}/.ssh/id_github
        '')
    ];
  };

  tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      sensible
      yank
      prefix-highlight
      {
        plugin = power-theme;
        extraConfig = ''
           set -g @tmux_power_theme 'violet'
        '';
      }
      {
        plugin = resurrect; # Used by tmux-continuum

        # Use XDG data directory
        # https://github.com/tmux-plugins/tmux-resurrect/issues/348
        extraConfig = ''
          set -g @resurrect-dir '$HOME/.cache/tmux/resurrect'
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-pane-contents-area 'visible'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '5' # minutes
        '';
      }
    ];
    terminal = "screen-256color";
    prefix = "C-a";
    escapeTime = 10;
    historyLimit = 50000;
    extraConfig = ''
      # Remove Vim mode delays
      set -g focus-events on

      # Enable full mouse support
      set -g mouse on

      # -----------------------------------------------------------------------------
      # Key bindings
      # -----------------------------------------------------------------------------

      # Unbind default keys
      unbind C-b

      # remap prefix from 'C-b' to 'C-a'
      set-option -g prefix C-a
      bind-key C-a send-prefix

      # Split panes, vertical or horizontal
      #unbind '"'
      #unbind %
      bind-key x split-window -v
      bind-key v split-window -h

      # Move around panes with vim-like bindings (h,j,k,l)
      bind-key -n M-k select-pane -U
      bind-key -n M-h select-pane -L
      bind-key -n M-j select-pane -D
      bind-key -n M-l select-pane -R

      # Smart pane switching with awareness of Vim splits.
      # This is copy paste from https://github.com/christoomey/vim-tmux-navigator
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
        | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
      bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
      bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
      bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
      bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
      tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
      if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
        "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
      if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
        "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R
      bind-key -T copy-mode-vi 'C-\' select-pane -l
      '';
    };
}
