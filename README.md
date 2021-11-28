# dotfiles

## Install Script
To install dotfiles, first run ./install.sh. This will create symlinks for each respective dotfile in ~/, each of which will point back to the file in this dir.

## Manual Installations
### zsh
  - Install [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)
  - `sudo apt install zsh-syntax-highlighting`
  - Copy [powerlevel10k](https://github.com/romkatv/powerlevel10k) to .oh-my-zsh/custom/themes    
  - Copy [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md#oh-my-zsh) to .oh-my-zsh/custom/plugins
  - Copy [zsh-completions](https://github.com/zsh-users/zsh-completions) to .oh-my-zsh/custom/plugins

### vim
  - Download plugin manager: [vim-plug](https://github.com/junegunn/vim-plug)
  - Run `:PlugInstall`
 
### tmux
  - Download plugin manager: [tpm](https://github.com/tmux-plugins/tpm)
  - Install plugins by launching tmux and entering `Prefix + I`

### misc
  - [diff-so-fancy](https://github.com/so-fancy/diff-so-fancy): Makes git diff look better
    - `npm install -g diff-so-fancy`
    - Follow [usage](https://github.com/so-fancy/diff-so-fancy#usage) instructions to complete install
