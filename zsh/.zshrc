# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd
unsetopt extendedglob
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/nixos/.zshrc'

# Aliases
alias nrs='sudo nixos-rebuild switch --flake /etc/nixos/#nixos'
alias ls='ls --color'

# Editor
export EDITOR="nvim"
export VISUAL="nvim"

autoload -Uz compinit
compinit

# Zinit setup
export ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d "$ZINIT_HOME" ] && mkdir -p "$(dirname $ZINIT_HOME)" && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

source "$ZINIT_HOME/zinit.zsh"

# Plugins: load lazily to reduce startup time
zinit light-mode for \
    zsh-users/zsh-completions \
    zsh-users/zsh-autosuggestions \
    zsh-users/zsh-syntax-highlighting

# Starship prompt
export STARSHIP_CONFIG="$HOME/.config/starship.toml"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
export DIRENV_CONFIG="$HOME/.config/direnv"
eval "$(direnv hook zsh)"
# End of lines added by compinstall
