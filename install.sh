#!/usr/bin/env bash
set -euo pipefail

# dotfiles installer
# - installs dependencies (best-effort)
# - bootstraps zsh/vim/tmux tooling
# - creates symlinks in $HOME

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
BACKUP_DIR="${BACKUP_DIR:-$HOME/dotfiles_old}"

FILES=(
  p10k.zsh
  tmux.conf
  zshrc
  aliases
  p10k-robbyrussell.zsh
  vimrc
)

log() { printf '%s\n' "$*"; }
section() { printf '\n==> %s\n' "$*"; }

command_exists() { command -v "$1" >/dev/null 2>&1; }

install_pkg() {
  local pkg="$1"
  if command_exists brew; then
    brew list "$pkg" >/dev/null 2>&1 || brew install "$pkg"
  elif command_exists apt-get; then
    sudo apt-get install -y "$pkg"
  elif command_exists dnf; then
    sudo dnf install -y "$pkg"
  elif command_exists pacman; then
    sudo pacman -S --noconfirm "$pkg"
  else
    log "Skipping package install for $pkg (no supported package manager found)."
  fi
}

install_packages() {
  section "Installing packages"

  if command_exists apt-get; then
    sudo apt-get update -y
  elif command_exists brew; then
    brew update
  fi

  install_pkg git
  install_pkg curl
  install_pkg zsh
  install_pkg tmux
  install_pkg vim
  if command_exists eza || command_exists exa; then
    log "eza/exa already installed."
  else
    if ! install_pkg eza; then
      install_pkg exa || log "Failed to install eza or exa."
    fi
  fi

  # npm is used for diff-so-fancy
  if ! command_exists npm; then
    install_pkg node
  fi
}

install_oh_my_zsh() {
  section "Installing oh-my-zsh"

  if [ -d "$HOME/.oh-my-zsh" ]; then
    log "oh-my-zsh already installed."
    return
  fi

  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

install_zsh_plugins() {
  section "Installing zsh plugins and theme"

  local custom_dir="$HOME/.oh-my-zsh/custom"
  local plugins_dir="$custom_dir/plugins"
  local themes_dir="$custom_dir/themes"

  mkdir -p "$plugins_dir" "$themes_dir"

  if [ ! -d "$themes_dir/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$themes_dir/powerlevel10k"
  else
    log "powerlevel10k already present."
  fi

  if [ ! -d "$plugins_dir/zsh-autosuggestions" ]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "$plugins_dir/zsh-autosuggestions"
  else
    log "zsh-autosuggestions already present."
  fi

  if [ ! -d "$plugins_dir/zsh-completions" ]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-completions.git "$plugins_dir/zsh-completions"
  else
    log "zsh-completions already present."
  fi

  if [ ! -d "$plugins_dir/zsh-syntax-highlighting" ]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$plugins_dir/zsh-syntax-highlighting"
  else
    log "zsh-syntax-highlighting already present."
  fi
}

install_vim_plug() {
  section "Installing vim-plug"

  local plug_path="$HOME/.vim/autoload/plug.vim"
  if [ -f "$plug_path" ]; then
    log "vim-plug already installed."
    return
  fi

  curl -fLo "$plug_path" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

install_tpm() {
  section "Installing tmux plugin manager (tpm)"

  local tpm_dir="$HOME/.tmux/plugins/tpm"
  if [ -d "$tpm_dir" ]; then
    log "tpm already installed."
    return
  fi

  git clone --depth=1 https://github.com/tmux-plugins/tpm "$tpm_dir"
}

install_diff_so_fancy() {
  section "Installing diff-so-fancy"

  if command_exists diff-so-fancy; then
    log "diff-so-fancy already installed."
    return
  fi

  if ! command_exists npm; then
    log "npm not found; skipping diff-so-fancy install."
    return
  fi

  npm install -g diff-so-fancy
}

install_fonts() {
  section "Installing Nerd Font (macOS)"

  if ! command_exists brew; then
    log "Homebrew not found; skipping Nerd Font install."
    return
  fi

  brew tap homebrew/cask-fonts >/dev/null 2>&1 || true
  if brew list --cask font-meslo-lg-nerd-font >/dev/null 2>&1; then
    log "Meslo Nerd Font already installed."
  else
    brew install --cask font-meslo-lg-nerd-font
  fi
}

backup_and_link() {
  section "Linking dotfiles"

  mkdir -p "$BACKUP_DIR"

  for file in "${FILES[@]}"; do
    local src="$DOTFILES_DIR/$file"
    local dest="$HOME/.${file}"

    if [ ! -e "$src" ]; then
      log "Skipping missing file: $src"
      continue
    fi

    if [ -L "$dest" ]; then
      log "Symlink already exists: $dest"
      continue
    fi

    if [ -e "$dest" ]; then
      log "Backing up existing $dest to $BACKUP_DIR"
      mv "$dest" "$BACKUP_DIR/"
    fi

    ln -s "$src" "$dest"
    log "Linked $dest -> $src"
  done
}

main() {
  if [ ! -d "$DOTFILES_DIR" ]; then
    log "Dotfiles directory not found: $DOTFILES_DIR"
    log "Set DOTFILES_DIR or run from the correct location."
    exit 1
  fi

  install_packages
  install_oh_my_zsh
  install_zsh_plugins
  install_vim_plug
  install_tpm
  install_diff_so_fancy
  install_fonts
  backup_and_link

  section "Done"
  log "If this is a new shell setup, restart your shell or run: exec zsh"
  log "For vim plugins, open vim and run: :PlugInstall"
  log "For tmux plugins, open tmux and press: Prefix + I"
  log "For iTerm2, set font to 'MesloLGS NF' in Settings > Profiles > Text."
}

main "$@"
