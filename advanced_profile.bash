# THIS FILE CONTAINS ALIASES THAT DEPEND ON EXTERNAL TOOLS TO BE INSTALLED
HOME_DIRECTORY=/home/tigrou

# Oh My Posh must be installed (https://ohmyposh.dev)
eval "$(oh-my-posh init bash --config $HOME_DIRECTORY/ownCloud/Shell/Oh\ My\ Posh/herve.omp.json)"

# Zoxide must be installed (https://github.com/ajeetdsouza/zoxide?tab=readme-ov-file#installation)
eval "$(zoxide init bash)"
unalias c
alias c=z

# Neovim must be installed
alias nvim=$HOME_DIRECTORY/Applications/nvim-linux-x86_64-v0.11.7.appimage
alias v=nvim
alias vi=nvim
alias vim=nvim
alias vv="nvim ."
export EDITOR=nvim

# Bat must be installed (https://github.com/sharkdp/bat?tab=readme-ov-file#installation)
# 2025-03-01: the first two aliases have been commented out as they are required on Linux Mint but not Fedora
#alias bat=batcat
#alias cat=batcat
alias cat=bat

# Fzf must be installed (https://github.com/junegunn/fzf?tab=readme-ov-file#setting-up-shell-integration)
# If fzf version is >= 0.48, use the recommended syntax:
source <(fzf --bash)
# If fzf version is < 0.48, manually source the completion and key bindings files:
#if [ -f /usr/share/bash-completion/completions/fzf.bash ]; then
#  . /usr/share/bash-completion/completions/fzf.bash
#fi
#if [ -f /usr/share/fzf/shell/key-bindings.bash ]; then
#  . /usr/share/fzf/shell/key-bindings.bash
#fi
export FZF_DEFAULT_OPTS='--no-height --no-reverse'
# - Bat, Chafa and Imgcat must be installed for fzf-preview.sh to work
export FZF_CTRL_T_OPTS="
  --header 'CTRL-Y: copy to clipboard, CTRL-/: change preview position'
  --color header:italic
  --preview '$HOME_DIRECTORY/.local/bin/fzf-preview.sh {}'
  --bind 'ctrl-y:execute-silent(echo {} | xclip -selection clipboard)+abort,ctrl-/:change-preview-window(down|hidden|)'
"
# - xclip must be installed
export FZF_CTRL_R_OPTS="
  --header 'CTRL-Y: copy to clipboard'
  --color header:italic
  --bind 'ctrl-y:execute-silent(echo -n {2..} | xclip -selection clipboard)+abort'
"
# - Tree must be installed
export FZF_ALT_C_OPTS="
  --header 'CTRL-Y: copy to clipboard, CTRL-/: change preview position'
  --color header:italic
  --preview 'tree -C {}'
  --bind 'ctrl-y:execute-silent(echo {} | xclip -selection clipboard)+abort,ctrl-/:change-preview-window(down|hidden|)'
"

# Eza must be installed
unalias l
function l() {
    if [[ $# -eq 1 ]]; then
        eza --long --header --icons --git $1
    else
        eza --long --header --icons --git
    fi
}

function ll() {
    if [[ $# -ne 1 ]]; then
        echo "1 parameter required: number of tree levels"
        return
    else
        eza --long --header --icons --git --tree --level=$1
    fi
}

function lt() {
    if [[ $# > 1 ]]; then
        echo "1 parameter maximum: number of tree levels (100 if not specified)"
        return
    elif [[ $# -eq 1 ]]; then
        eza --long --header --icons --git --tree --level=$1
    else
        eza --long --header --icons --git --tree --level=100
    fi
}
alias lt1="lt 1"
alias lt2="lt 2"
alias lt3="lt 3"

function lta() {
    if [[ $# > 1 ]]; then
        echo "1 parameter maximum: number of tree levels (100 if not specified)"
        return
    elif [[ $# -eq 1 ]]; then
        eza --all --long --header --icons --git --tree --level=$1
    else
        eza --all --long --header --icons --git --tree --level=100
    fi
}
alias lta1="lta 1"
alias lta2="lta 2"
alias lta3="lta 3"

# fzf-bash-completion.sh must be downloaded from https://github.com/lincheney/fzf-tab-completion/tree/master/bash (read https://github.com/lincheney/fzf-tab-completion?tab=readme-ov-file#bash)
source $HOME_DIRECTORY/.local/bin/fzf-bash-completion.sh
bind -x '"\t": fzf_bash_completion'

# fzf-git.sh must be downloaded from https://github.com/junegunn/fzf-git.sh (read https://junegunn.github.io/fzf/examples/git/)
source $HOME_DIRECTORY/.local/bin/fzf-git.sh
_fzf_git_fzf() {
  fzf "$@"
}

# Fastfetch must be installed
fastfetch

# VSCode must be installed
alias ccode="code ."

# CSharpRepl (.NET tool) must be installed
alias repl=csharprepl

# Docker must be installed
function exca() {
    sudo docker run --name="excalidraw" --rm -p 8081:80 -d docker.io/excalidraw/excalidraw:latest
    echo "Excalidraw running at http://localhost:8081"
}
alias stopexca="sudo docker container stop excalidraw"
function draw() {
    sudo docker run --name="drawio" --rm -p 8082:8080 -d jgraph/drawio
    echo "draw.io running at http://localhost:8082"
}
alias stopdraw="sudo docker container stop drawio"

# Yazi must be installed
# https://yazi-rs.github.io/docs/quick-start
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd < "$tmp"
    [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
}

# herdr must be installed
alias h=herdr

# fabric must be installed
alias fa=fabric
alias fap="fabric --pattern="
function yts() {
    fabric -y "$@" --pattern=youtube_summary
}
function yti() {
    fabric -y "$@" --pattern=extract_ideas
}

# xsel must be installed
alias pt="xsel --clipboard --output"
