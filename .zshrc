# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$Path
plugins=(git z zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)


# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

ZSH_THEME="powerlevel10k/powerlevel10k"

# plugins=(git)

source $ZSH/oh-my-zsh.sh

alias nvimNew="NVIM_APPNAME=nvimNew"
alias modernNvim="NVIM_APPNAME=modern-neovim"
alias nvimBak="NVIM_APPNAME=nvimbak"
alias nvimkick="NVIM_APPNAME=kickstart nvim"
alias neovimPde="NVIM_APPNAME=neovim-pde"
export ASPNETCORE_ENVIRONMENT="Development"

alias nvim-chad="NVIM_APPNAME=NvChad nvim"
alias nvim-astro="NVIM_APPNAME=AstroNvim nvim"
alias kickstart="nvims kickstart"
alias python=/opt/homebrew/bin/python3
alias chromedriver=/opt/homebrew/bin/chromedriver


function nvims() {
  items=( "nvimNew" "neovim-pde" "modern-neovim" "nvimbak" "kickstart" "NvChad" "AstroNvim")
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $config == "default" ]]; then
    config=""
  fi
  NVIM_APPNAME=$config nvim $@
}

bindkey -s ^a "nvims\n"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# pnpm
export PNPM_HOME="/Users/andershakonsen/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm endeval 

## export PATH=/opt/homebrew/bin:/Users/andershakonsen/Library/pnpm:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/share/dotnet:~/.dotnet/tools:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin
export PATH="/opt/homebrew/bin:$PATH"

# bun completions
[ -s "/Users/andershakonsen/.bun/_bun" ] && source "/Users/andershakonsen/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export EDITOR="nvim"
## Moved this to tmux conf
# alias t="$HOME/.config/scripts/tmux-sessionizer.sh"
# # bindkey '^f' t
# function run_tmux_sessionizer {
#     $HOME/.config/scripts/tmux-sessionizer.sh "$@"
# }
# zle -N run_tmux_sessionizer
# bindkey '^f' run_tmux_sessionizer
# export tmuxsessionizer="/Users/andershakonsen/.config/scripts/tmux-sessionizer.sh"
# Enable vi mode

# Bind the function to Ctrl + F
# bindkey '^f' run_tmux_sessionizer


# bindkey  '^f' $tmuxsessionizer



[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# alias python=/usr/bin/python3
PATH=/bin:/usr/bin:/usr/local/bin:/sbin:${PATH}
export PATH

# Change cursor shape for different vi modes.
# Set cursor to block style using a zsh hook
precmd() { echo -ne "\e[2 q" }

