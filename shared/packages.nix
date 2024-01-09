{ pkgs }:

with pkgs; [
  # General packages for development and system management
  watch
  fish
  direnv
  act
  alacritty
  aspell
  aspellDicts.en
  bash-completion
  bat
  btop
  coreutils
  difftastic
  du-dust
  gcc
  git-filter-repo
  killall
  neofetch
  openssh
  pandoc
  sqlite
  wget
  zip
  kind

  # Encryption and security tools
  _1password
  age
  age-plugin-yubikey
  gnupg
  libfido2
  pinentry
  yubikey-manager

  # Cloud-related tools and SDKs
  kubernetes-helm
  k9s
  docker
  docker-compose
  awscli2
  flyctl
  google-cloud-sdk
  go_1_21
  gopls
  ngrok
  ssm-session-manager-plugin
  #pulumi-bin # package is lagging behind upstream pulumi
  terraform
  terraform-ls
  tflint

  # Media-related packages
  emacs-all-the-icons-fonts
  imagemagick
  dejavu_fonts
  ffmpeg
  fd
  font-awesome
  glow
  hack-font
  jpegoptim
  meslo-lgs-nf
  noto-fonts
  noto-fonts-emoji
  pngquant

  # Node.js development tools
  fzf
  nodePackages.live-server
  nodePackages.nodemon
  nodePackages.prettier
  nodePackages.npm
  nodejs

  # Source code management, Git, GitHub tools
  gh

  # Text and terminal utilities
  starship
  htop
  hunspell
  iftop
  jetbrains-mono
  jq
  ripgrep
  slack
  tree
  tmux
  unrar
  unzip
  zsh-powerlevel10k

  # Python packages
  black
  python311
  python311Packages.virtualenv
]
