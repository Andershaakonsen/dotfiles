# Enable Powerlevel10k instant prompt for fast startup
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set PATH environment variable
export PATH="/opt/homebrew/bin:$PATH" # Prioritize Homebrew binaries
export PATH="$HOME/Library/pnpm:$PATH" # Add pnpm to PATH
export PATH="$HOME/.bun/bin:$PATH" # Add bun to PATH

# Aliases
alias dw='dotnet watch'


# Path to Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Set Zsh theme to Powerlevel10k
ZSH_THEME="powerlevel10k/powerlevel10k"

# Specify plugins to load (oh-my-zsh plugins and others)
plugins=(git fast-syntax-highlighting zsh-autosuggestions)

# Source Oh My Zsh script to load configurations
source $ZSH/oh-my-zsh.sh

# Customization for 'pnpm' environment
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
    *":$PNPM_HOME:"*) ;; # Check if $PNPM_HOME is already in $PATH
    *) export PATH="$PNPM_HOME:$PATH" ;; # Add $PNPM_HOME to $PATH if not present
esac

# Configure editor preference
export EDITOR="nvim"

# Lazy load nvm (Node Version Manager)
autoload -U add-zsh-hook
load-nvm() {
  unset -f nvm node npm npx # Remove the stubs
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # Load nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # Load nvm bash_completion
  nvm "$@" # Call nvm after loading
}
nvm() { load-nvm; }
node() { load-nvm; node "$@"; }
npm() { load-nvm; npm "$@"; }
npx() { load-nvm; npx "$@"; }

# Lazy load fzf bindings and completion
load-fzf() {
  unset -f load-fzf # Remove this function after it's run
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
}
add-zsh-hook precmd load-fzf

# Initialize zoxide for smarter directory navigation, lazily
z() {
  eval "$(zoxide init zsh)"
  z "$@"
}

# Source bun shell completions, if available
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Source Powerlevel10k theme customization, if available
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
