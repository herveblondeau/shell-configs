# THIS FILE DOESN'T REQUIRE ANY EXTERNAL TOOL TO BE INSTALLED
# Based mostly on https://www.youtube.com/watch?v=ud7YxC33Z3w (kept the zsh plugins/customization, discarded the powerlevel10k part)

# # Enable vi mode
# set -o vi
# 
# ## Set cursor shape for vi modes (works in most modern terminals)
# function zle-keymap-select {
#   if [[ ${KEYMAP} == vicmd ]]; then
#     # Normal mode: block cursor
#     print -Pn "\e[1 q"
#   else
#     # Insert mode: beam cursor
#     print -Pn "\e[5 q"
#   fi
# }
# zle -N zle-keymap-select
# 
# ## Also set cursor shape when starting the shell
# function zle-line-init {
#   if [[ ${KEYMAP} == vicmd ]]; then
#     print -Pn "\e[1 q"
#   else
#     print -Pn "\e[5 q"
#   fi
# }
# zle -N zle-line-init

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

# Add zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Load completions
autoload -U compinit && compinit

zinit cdreplay -q

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory # share history between shell windows
setopt hist_ignore_space # do not store commands prefixed with a space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no

# Key bindings to ensure BEGIN, END, CTRL-LEFT and CTRL-RIGHT can be used to navigate within a line
# Notes:
# - taken from ChatGPT
# - bindkey assigns key sequences to specific Zsh editing functions
# - beginning-of-line and end-of-line correspond to Home and End
# - backward-word and forward-word allow moving between words
# - select-word-style bash makes Ctrl+Left and Ctrl+Right behave like in Bash
# - actual key codes may differ depending on the terminal, in which case the correct codes can be obtained by running _cat_ and pressing the desired keys
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
# Enable zsh line editor (ZLE)
autoload -U select-word-style
select-word-style bash
# Bind Home and End
bindkey "^[[H" beginning-of-line  # Home key
bindkey "^[[F" end-of-line        # End key
bindkey "^[[1~" beginning-of-line # Alternative Home
bindkey "^[[4~" end-of-line       # Alternative End
# Bind Ctrl+Left and Ctrl+Right to move by word
bindkey "^[[1;5D" backward-word  # Ctrl+Left
bindkey "^[[1;5C" forward-word   # Ctrl+Right
# Set the correct behavior for the DELETE key
bindkey "^[[3~" delete-char
