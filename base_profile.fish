# GENERAL

# Global editing
set -x EDITOR "vi"

# Key bindings
function fish_user_key_bindings
    # Erase a preset binding (e.g., Ctrl+P for history search)
    # bind --erase --preset \cp
    bind ctrl-delete kill-word                       # Ctrl+Delete
    bind ctrl-backspace backward-kill-word                   # Ctrl+Backspace
    bind alt-backspace backward-kill-line
    bind alt-delete kill-line

    bind alt-h backward-char
    bind alt-l forward-char
    bind alt-k up-or-search
    bind alt-j down-or-search
    bind ctrl-h backward-word
    bind ctrl-l forward-word
    bind ctrl-alt-h beginning-of-line
    bind ctrl-alt-l end-of-line
    bind alt-shift-h backward-delete-char
    bind alt-shift-l delete-char
    bind ctrl-shift-h backward-kill-word
    bind ctrl-shift-l kill-word
    bind ctrl-alt-shift-h backward-kill-line
    bind ctrl-alt-shift-l kill-line

    bind ctrl-alt-f kill-word                        # Ctrl+Alt-F (used to extend Emacs movement shortcuts: Alt and Ctrl-F)
    bind ctrl-alt-b backward-kill-word               # Ctrl+Alt-B (used to extend Emacs movement shortcuts: Alt and Ctrl-B)
    # Previous:
    #bind \b backward-kill-word                      # Ctrl+Backspace
    #bind \e\[3\;5\~ kill-word                       # Ctrl+Delete

    bind alt-left 'prevd;commandline -f repaint'     # Force prevd to refresh the prompt
    bind alt-right 'nextd;commandline -f repaint'    # Force nextd to refresh the prompt
    # Previous:
    #bind \e\[1\;3D 'prevd;commandline -f repaint'   # Force prevd to refresh the prompt
    #bind \e\[1\;3C 'nextd;commandline -f repaint'   # Force nextd to refresh the prompt

end   


# Bash command shortcuts
abbr --add ll "ls -l"
abbr --add la "ls -la"
abbr --add p "pwd"
abbr --add l "ls -l"
abbr --add m "mv"
abbr --add r "rm -rf"
abbr --add rall "rm -rf ./*"
abbr --add c "cd"
abbr --add ul "cd ..;ll"
abbr --add cl "clear"
abbr --add g "grep -rli"
abbr --add e "exit"
abbr --add ip "ipconfig -all"
abbr --add k "kill -9"
abbr --add kp "npx kill-port"

function f
    if test (count $argv) -ne 1
        echo "1 parameter required: part of file/folder name to search"
        return
    end

    find . -iname "*$argv[1]*" -printf "%y %p\n" 2> /dev/null
end

function ff
    if test (count $argv) -ne 2
        echo "2 parameters required: folder to start the search from and part of file/folder name to search"
        return
    end

    find $argv[1] -iname "*$argv[2]*" -printf "%y %p\n" 2> /dev/null
end

function multicd
    echo cd (string repeat -n (math (string length -- $argv[1])) ../)
end
abbr --add upup --regex '^u+$' --function multicd

function multicd_then_l
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
    echo ls -l
end
abbr --add upupl --regex '^u+l$' --function multicd_then_l

# Powershell emulation
abbr --add dir "ls -l"

# Frequently accessed folders
abbr --add home "cd"
abbr --add root "cd /"
abbr --add doc "cd ~/Documents"
abbr --add dl "cd ~/Downloads"
abbr --add rep "cd ~/Source/Repos"
abbr --add ddev "cd ~/Dev"
abbr --add tmp "cd ~/Temp"
abbr --add temp "cd ~/Temp"

# GIT-SPECIFIC
# Command shortcuts
abbr --add ginit "git init"
abbr --add clone "git clone"
abbr --add log "git log --pretty=format:'%h%x09%an%x09%ad%x09%s'"
abbr --add logn "git log --pretty=format:'%h%x09%an%x09%ad%x09%s'|head -n"
abbr --add five "git log --pretty=format:'%h%x09%an%x09%ad%x09%s'|head -n 5"
abbr --add ten "git log --pretty=format:'%h%x09%an%x09%ad%x09%s'|head -n 10"
abbr --add twenty "git log --pretty=format:'%h%x09%an%x09%ad%x09%s'|head -n 20"
abbr --add twen "git log --pretty=format:'%h%x09%an%x09%ad%x09%s'|head -n 20"
abbr --add logg "git log --pretty=format:'%h%x09%an%x09%ad%x09%s'|grep -i"
abbr --add logf "git log --pretty=format:'%h%x09%an%x09%ad%x09%s' --name-only"
abbr --add logs "git log --graph --pretty=format='%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cD) %C(bold blue)<%an>%Creset' --abbrev-commit"
function logmulti
    # Check if the argument matches ^\d+$ (just in case, as this function should only be called when this regex is matched)
    set match (string match -r '^[0-9]+$' -- $argv[1])

    if test -n "$match"
        set number (string match -r '^[0-9]+$' -- $argv[1])
        echo "git log --pretty=format:'%h%x09%an%x09%ad%x09%s'|head -n" $number
    else
        # Not supposed to happen, just in case
        echo "Usage: N (e.g. 100 for last 100 commits)"
    end
end
abbr --add logmulti --regex '^\d+$' --function logmulti # does the same thing as logn, but faster to type
abbr --add branch "git branch -a"
abbr --add checkout "git checkout"
abbr --add pull "git pull"
abbr --add fetch "git fetch;git branch"
abbr --add merge "git merge --no-ff"
abbr --add push "git push"
abbr --add cm "git commit -m"
abbr --add cmm "git commit -m"
abbr --add commit "git commit -m"
abbr --add amend "git commit --amend"
abbr --add show "git show --pretty="format:'%h%x09%an%x09%ad%x09%s'""
abbr --add showw "showw --name-only"
abbr --add stage "git add ."
abbr --add unstage "git restore --staged ."
abbr --add blame "git blame -C -C -C"

# Soft resets the last commits
function reset
    if test (count $argv) -ne 1
        echo "1 parameter required: number of commits to soft reset"
        return
    end

    git reset HEAD~$argv[1]
end

# Hard resets the last commits
function reseth
    if test (count $argv) -ne 1
        echo "1 parameter required: number of commits to hard reset"
        return
    end

    git reset HEAD~$argv[1] --hard
end

# Interactively rebases the last commits
function rebase
    if test (count $argv) -ne 1
        echo "1 parameter required: number of commits to rebase"
        return
    end

    git rebase -i HEAD~$argv[1]
end

# Reverts the last commits
function revert
    if test (count $argv) -ne 1
        echo "1 parameter required: number of commits to revert"
        return
    end

    git revert -i HEAD~$argv[1]
end

#alias show="git diff-tree --no-commit-id --name-only -r" #https://www.w3docs.com/snippets/git/how-to-list-all-the-files-in-a-commit.html

# Creates an unnamed stash with the local changes
# Does nothing if there are no local changes
abbr --add stash "git add .;git stash"

# Creates a named stash with the local changes
# Does nothing if there are no local changes
abbr --add stashm "git add .;git stash push -m"

# Creates a named stash with the local changes
# Contrary to stashm, if there are no local changes, it creates a ".empty" file first
# Therefore, with stashmm, a stash is always created
function stashmm
    if test (count $argv) -ne 1
        echo "1 parameter required: stash name"
        return
    end

    set result (git status --porcelain)
    if [[ ! -n result ]] # --porcelain gives a simplified output
        touch .empty
    end

    stashm $argv[1];
end

# Applies a list of stashes
# The stash numbers must be supplied separated by spaces
function ap
    if test (count $argv) -ne 1
        echo "List of stash numbers to apply required, given by their numbers"
        echo "Example: ap 2 5 6 7"
        return
    end

    # https://stackoverflow.com/questions/9143865/how-to-combine-multiple-stashes-in-git
    # https://stackoverflow.com/questions/255898/how-to-iterate-over-arguments-in-a-bash-script
    for stashNumber in $argv
    do
        git add .
        git stash apply $stashNumber
        git reset
    end
end

# Renames a branch
function rename
    if [[ count $argv -ne 2 ]]
        echo "2 parameters required: current branch name and new branch name"
        return
    end

    git checkout $argv[1]
    git branch -m $argv[2]
    git push origin -u $argv[2]
    git push origin --delete $argv[1]
end

abbr --add list "git stash list"
abbr --add po "git stash pop;git restore --staged ."
abbr --add drop "git stash drop"
abbr --add md "git merge develop"
abbr --add mr "git merge release"
abbr --add mm "git merge master"
abbr --add chb "git checkout -b"
abbr --add diff "git diff HEAD --word-diff"

# https://stackoverflow.com/questions/3573410/what-is-the-shortest-way-to-swap-staged-and-unstaged-changes-in-git
function swap
    git commit -m Saved
    git branch save-staged
    git add .
    git commit -a -m Unstaged
    git rebase --onto HEAD^^ HEAD^
    git reset --hard save-staged
    git rebase --onto HEAD@{1} HEAD^
    git reset HEAD^
    git reset --soft HEAD^
    git branch -D save-staged
end

abbr --add main "git checkout main"
abbr --add mas "git checkout master"
abbr --add dev "git checkout develop"
abbr --add rel "git checkout release"

abbr --add st "git status"
abbr --add s "st"
abbr --add t "st" # to make up for the fact that the first character typed is sometimes not taken into account in the terminal
abbr --add sh "git stash"
abbr --add br "git branch"
abbr --add bra "git branch -a"
abbr --add brd "git branch -d"
abbr --add brdd "git branch -D"
abbr --add brm "git branch -m"
abbr --add ch "git checkout"
abbr --add chn "git checkout -b"
abbr --add ft "git fetch;git branch"
abbr --add pl "git pull"
abbr --add ph "git push"
abbr --add phf "git push --force"
abbr --add phd "git push origin --delete"
abbr --add phh "git push --set-upstream origin"
#abbr --add upd "git add .;stash;pl;po"
abbr --add babort "git bisect reset"
abbr --add mabort "git merge --abort"
abbr --add rabort "git revert --abort"
abbr --add undo "git checkout -f; git clean -fd"
abbr --add patch "git add --patch"
abbr --add prune "git fetch;git remote prune origin;git prune"
abbr --add cherry "git cherry-pick"

abbr --add ignore "git update-index --assume-unchanged"
abbr --add unignore "git update-index --no-assume-unchanged"

# NPM
abbr --add ninit "npm init"
abbr --add ni "npm install"
abbr --add nif "npm install --force"
abbr --add nig "npm install -g"
abbr --add nr "npm run"
abbr --add nci "npm ci"
abbr --add nps "jq -r '.scripts | to_entries[] | \"\(.key): \(.value)\"' package.json"
abbr --add npd "jq -r '.dependencies | to_entries[] | \"\(.key): \(.value)\"' package.json"
abbr --add npdd "jq -r '.devDependencies | to_entries[] | \"\(.key): \(.value)\"' package.json"

# ANGULAR
abbr --add nb "ng build"
abbr --add ns "ng serve"
abbr --add nins "npm install; ng serve"

# DOCKER
abbr --add di "docker image"
abbr --add dils "docker image ls"
abbr --add dilsa "docker image ls -a"
abbr --add dib "docker image build"
abbr --add dirm "docker image rm"
abbr --add dc "docker container"
abbr --add dcls "docker container ls"
abbr --add dclsa "docker container ls -a"
abbr --add dcs "docker container stop"
abbr --add dck "docker container kill"
abbr --add dcrm "docker container rm"
abbr --add dcrmall "docker container rm -f \$(docker container ls -a -q)"
abbr --add dcr "docker container run -it --rm"
abbr --add dcrd "docker container run -itd --rm"
abbr --add dv "docker volume"
abbr --add dp "docker pull"
abbr --add dps "docker ps"
abbr --add ds "docker search"
abbr --add dprune "docker system prune"
abbr --add dcstopall "docker container stop \$(docker container ls -a -q)"
abbr --add dversion "docker version"
abbr --add dinfo "docker info"
abbr --add dcud "docker compose up -d"
abbr --add dcd "docker compose down"

abbr --add sdi "sudo docker image"
abbr --add sdils "sudo docker image ls"
abbr --add sdilsa "sudo docker image ls -a"
abbr --add sdib "sudo docker image build"
abbr --add sdirm "sudo docker image rm"
abbr --add sdc "sudo docker container"
abbr --add sdcls "sudo docker container ls"
abbr --add sdclsa "sudo docker container ls -a"
abbr --add sdcs "sudo docker container stop"
abbr --add sdck "sudo docker container kill"
abbr --add sdcrm "sudo docker container rm"
abbr --add sdcrmall "sudo docker container rm -f \$(sudo docker container ls -a -q)"
abbr --add sdcr "sudo docker container run -it --rm"
abbr --add sdcrd "sudo docker container run -itd --rm"
abbr --add sdv "sudo docker volume"
abbr --add sdp "sudo docker pull"
abbr --add sdps "sudo docker ps"
abbr --add sds "sudo docker search"
abbr --add sdprune "sudo docker system prune"
abbr --add sdcstopall "sudo docker container stop \$(sudo docker container ls -a -q)"
abbr --add sdversion "sudo docker version"
abbr --add sdinfo "sudo docker info"
abbr --add sdcud "sudo docker compose up -d"
abbr --add sdcd "sudo docker compose down"

# KUBERNETES
abbr --add ku "kubectl"
abbr --add kaf "kubectl apply -f"
abbr --add kgp "kubectl get pods"
abbr --add kgs "kubectl get services"
abbr --add kgd "kubectl get deployments"
abbr --add kdp "kubectl describe pod"
abbr --add kds "kubectl describe service"
abbr --add kdd "kubectl describe deployment"

# DOTNET
abbr --add dn "dotnet new"
abbr --add da "dotnet add"
abbr --add db "dotnet build"
abbr --add cdb "clear;dotnet build"
abbr --add b "db" # to make up for the fact that the first character typed is sometimes not taken into account in the terminal
abbr --add dr "dotnet run"
abbr --add drp "dotnet run --project"
abbr --add cdrp "clear;dotnet run --project"
abbr --add rp "drp" # to make up for the fact that the first character typed is sometimes not taken into account in the terminal
abbr --add drw "dotnet watch run --non-interactive"
abbr --add drpw "dotnet watch run --non-interactive --project"
abbr --add dt "dotnet test"
abbr --add dtf "dotnet test --filter"
abbr --add dbdt "dotnet build;dotnet test"
abbr --add dus "dotnet user-secrets"

# https://learn.microsoft.com/en-us/ef/core/cli/dotnet
abbr --add def "dotnet ef"
abbr --add add-migration migration "def migrations add"
abbr --add remove-migration migration "def migrations remove"
abbr --add update-database database "def database update"
abbr --add update-db "update-database"

# PYTHON
abbr --add py "python"

abbr --add pss "ps -s | grep 'dotnet\|node'"
abbr --add ss "pss"
function knet
    kill $(ps aux | grep dotnet | awk '{print $argv[1]}')
end
function knode
    kill $(ps aux | grep node | awk '{print $argv[1]}')
    kp 4200
    kp 4300
    kp 5300
end
abbr --add kall "knet;knode"
