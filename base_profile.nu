# THIS FILE CONTAINS GENERAL ALIASES THAT DO NOT REQUIRE ANY EXTERNAL TOOL TO BE DEFINED

# GENERAL

# # Enable vi mode
# $env.config.edit_mode = "vi"

# Command shortcuts
alias p = pwd
alias l = ls -l
alias la = ls -la
alias m = mv
alias r = rm -rf
alias c = cd
alias u = cd ..
alias uu = cd ../..
alias uuu = cd ../../..
alias ul = u;l
alias uul = u;ul
alias uul = u;uul
alias uuul = u;uuul
alias cl = clear
alias g = grep -i
alias gr = grep -rli
alias e = exit
alias k = kill -9
alias kp = npx kill-port
def ddate [] {
    let now = date now
    let dddate = $"($now) | ($now | format date '%Y-%m-%d %H:%M:%S') | (($now | into int) / 1000)"
    print $dddate
}

def f [search_text?: string] {
    if ($search_text | is-empty) {
        print "1 parameter required: part of file/folder name to search"
        return
    }

    # TODO: SUPPRESS ERRORS (INACCESSIBLE FOLDERS FOR INSTANCE)
    l ** | find -i $search_text
}
def fa [search_text?: string] {
    if ($search_text | is-empty) {
        print "1 parameter required: part of file/folder name to search"
        return
    }

    # TODO: SUPPRESS ERRORS (INACCESSIBLE FOLDERS FOR INSTANCE)
    la ** | find -i $search_text
}
def ff [start_folder?: string search_text?: string] {
    if (($start_folder | is-empty) or ($search_text | is-empty)) {
        print "2 parameters required: folder to start the search from and part of file/folder name to search"
        return
    }

    # TODO: SUPPRESS ERRORS (INACCESSIBLE FOLDERS FOR INSTANCE)
    l $start_folder | find -i $search_text
}
def ffa [start_folder: string search_text: string] {
    if (($start_folder | is-empty) or ($search_text | is-empty)) {
        print "2 parameters required: folder to start the search from and part of file/folder name to search"
        return
    }

    # TODO: SUPPRESS ERRORS (INACCESSIBLE FOLDERS FOR INSTANCE)
    la $start_folder | find -i $search_text
}

# Powershell emulation
alias dir = ls -l

# GIT-SPECIFIC
alias ginit = git init
alias clone = git clone
alias status = git status
alias log = git log --pretty=format:'%h%x09%an%x09%ad%x09%s'
alias logn = log|head -n
alias five = logn 5
alias ten = logn 10
alias twenty = logn 20
alias twen = twenty
alias logf = log --name-only
alias logs = git log --graph --pretty=format='%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cD) %C(bold blue)<%an>%Creset' --abbrev-commit
alias branch = git branch -a
alias checkout = git checkout
alias pull = git pull
def fetch [] {
    git fetch
    git branch
}
alias merge = git merge --no-ff
alias push = git push
alias cm = git commit -m
alias cmm = git commit -m
alias commit = git commit -m
alias amend = git commit --amend
alias show = git show --pretty="format:'%h%x09%an%x09%ad%x09%s'"
alias showw = showw --name-only
alias stage = git add .
alias unstage = git restore --staged .
alias blame = git blame -C -C -C

def logg [nb_entries?: string search_text?: string] {
    if (($nb_entries | is-empty) or ($search_text | is-empty)) {
        print "2 parameters required: number of entries and text to search"
        return
    }

    logn $nb_entries | grep -i $search_text
}

# Soft resets the last commits
def reset [nb_commits?: int] {
    if ($nb_commits | is-empty) {
        print "1 parameter required: number of commits to soft reset"
        return
    }

    git reset $"HEAD~($nb_commits)"
}

# Hard resets the last commits
def reseth [nb_commits?: int] {
    if ($nb_commits | is-empty) {
        print "1 parameter required: number of commits to hard reset"
        return
    }

    git reset $"HEAD~($nb_commits)" --hard
}

# Interactively rebases the last commits
def rebase [nb_commits?: int] {
    if ($nb_commits | is-empty) {
        print "1 parameter required: number of commits to rebase"
        return
    }

    git rebase -i $"HEAD~($nb_commits)"
}

# Reverts the last commits
def revert [nb_commits?: int] {
    if ($nb_commits | is-empty) {
        print "1 parameter required: number of commits to revert"
        return
    }

    git revert -i $"HEAD~($nb_commits)"
}

alias show = git diff-tree --no-commit-id --name-only -r #https://www.w3docs.com/snippets/git/how-to-list-all-the-files-in-a-commit.htm

# Creates an unnamed stash with the local changes
# Does nothing if there are no local changes
def stash [] {
    stage
    git stash
}

# Creates a named stash with the local changes
# Does nothing if there are no local changes
def stashm [stash_name: string] {
    stage
    git stash push -m $stash_name
}

# Creates a named stash with the local changes
# Contrary to stashm, if there are no local changes, it creates a ".empty" file first
# Therefore, with stashmm, a stash is always created
def stashmm [stash_name: string] {
    if ($stash_name | is-empty) {
        print "1 parameter required: stash name"
        return
    }

    if (git status --porcelain | lines | length) == 0 {
        touch .empty
    }

    stashm $stash_name;
}

# Applies a list of stashes
# The stash numbers must be supplied separated by spaces
def ap [...stash_numbers] {
    for stashNumber in $stash_numbers {
        git add .
        git stash apply $stashNumber
        git reset
    }
}

# Renames a branch
def rename [current_name?: string new_name?: string] {
    if (($current_name | is-empty) or ($new_name | is-empty)) {
        print "2 parameters required: current name and new name"
        return
    }

    git checkout $current_name
    git branch -m $new_name
    git push origin -u $new_name
    git push origin --delete $current_name
}

alias list = git stash list
def po [] {
    git stash pop
    unstage
}
alias drop = git stash drop
alias md = git merge develop
alias mr = git merge release
alias mm = git merge master
alias chb = git checkout -b
alias diff = git diff --word-diff
alias diffn = git diff --name-only
alias diffh = git diff HEAD

# https://stackoverflow.com/questions/3573410/what-is-the-shortest-way-to-swap-staged-and-unstaged-changes-in-git
def swap [] {
    git commit -m Saved
    git branch save-staged
    stage
    git commit -a -m Unstaged
    git rebase --onto HEAD^^ HEAD^
    git reset --hard save-staged
    git rebase --onto HEAD@{1} HEAD^
    git reset HEAD^
    git reset --soft HEAD^
    git branch -D save-staged
}

alias main = git checkout main
alias mas = git checkout master
alias dev = git checkout develop
alias rel = git checkout release

alias st = git status
alias t = st # to make up for the fact that the first character typed is sometimes not taken into account in the termina
alias sh = git show
alias br = git branch
alias bra = git branch -a
alias brd = git branch -d
alias brdd = git branch -D
alias brm = git branch -m
alias ch = git checkout
alias chn = git checkout -b
def ft [] {
    git fetch
    git branch
}
alias pl = git pull
alias ph = git push
def plh [] {
    pl
    ph
}
alias phf = git push --force
alias phd = git push origin --delete
alias phh = git push --set-upstream origin
def upd [] {
    stage
    stash
    pl
    po
}
alias cabort = git cherry-pick --abort
alias mabort = git merge --abort
alias rabort = git revert --abort
def undo [] {
    git checkout -f
    git clean -fd
}
alias patch = git add --patch
def prune [] {
    git fetch
    git remote prune origin
    git prune
}
alias cherry = git cherry-pick

alias ignore = git update-index --assume-unchanged
alias unignore = git update-index --no-assume-unchanged

# NPM
alias ninit = npm init
alias ni = npm install
alias nif = npm install --force
alias nig = npm install -g
alias nr = npm run
alias nci = npm ci
alias nps = jq -r '.scripts | to_entries[] | \"\(.key): \(.value)\"' package.json
alias npd = jq -r '.dependencies | to_entries[] | \"\(.key): \(.value)\"' package.json
alias npdd = jq -r '.devDependencies | to_entries[] | \"\(.key): \(.value)\"' package.json

# ANGULAR
alias nb = ng build
alias ns = ng serve
def nins [] {
    ni
    ng serve
}

# DOCKER
alias di = docker image
alias dils = docker image ls
alias dilsa = docker image ls -a
alias dib = docker image build
alias dirm = docker image rm
alias dc = docker container
alias dcls = docker container ls
alias dclsa = docker container ls -a
alias dcs = docker container stop
alias dck = docker container kill
alias dcrm = docker container rm
alias dcrmall = docker container rm -f \$(docker container ls -a -q)
alias dcr = docker container run -it --rm
alias dcrd = docker container run -itd --rm
alias dv = docker volume
alias dp = docker pull
alias dps = docker ps
alias ds = docker search
alias dprune = docker system prune
alias dcstopall = docker container stop \$(docker container ls -a -q)
alias dversion = docker version
alias dinfo = docker info

# KUBERNETES
alias ku = kubectl
alias kaf = kubectl apply -f
alias kgp = kubectl get pods
alias kgs = kubectl get services
alias kgd = kubectl get deployments
alias kdp = kubectl describe pod
alias kds = kubectl describe service
alias kdd = kubectl describe deployment

# DOTNET
alias dn = dotnet new
alias da = dotnet add
alias db = dotnet build
def cdb [] {
    cl
    db
}
alias b = db # to make up for the fact that the first character typed is sometimes not taken into account in the terminal
alias dr = dotnet run
alias drp = dotnet run --project
def cdrp [] {
    cl
    drp
}
alias rp = drp # to make up for the fact that the first character typed is sometimes not taken into account in the terminal
alias drw = dotnet watch run --non-interactive
alias drpw = dotnet watch run --non-interactive --project
alias dt = dotnet test
alias dtf = dotnet test --filter
alias nuget = dotnet nuget
alias dwhy = dotnet nuget why

# https://learn.microsoft.com/en-us/ef/core/cli/dotnet
alias def = dotnet ef
alias add-migration = ef migrations add
alias remove-migration = ef migrations remove
alias update-database = ef database update
alias update-db = update-database

# PYTHON
alias py = python

def pss [] {
    ps | where name =~ 'dotnet|node'
}
alias ss = pss
def knet [] {
    ps | where name =~ dotnet | each {|p| kill $p.pid }
}
def knode [] {
    ps | where name =~ node | each {|p| kill $p.pid }
    kp 4200
    kp 4300
    kp 5300
}
def kall [] {
    knet
    knode
}

# Nushell
# do not show the default explanations
$env.config.show_banner = false;
# open in the user's home directory
cd $env.HOME;

$env.config.keybindings ++= [{
    name: completion_menu
    modifier: alt
    keycode: delete
    mode: emacs
    event: { edit: cleartolineend }
}]

$env.config.keybindings ++= [{
    name: completion_menu
    modifier: alt
    keycode: backspace
    mode: emacs
    event: { edit: cutfromlinestart }
}]

$env.config.keybindings ++= [{
    name: completion_menu
    modifier: control
    keycode: delete
    mode: emacs
    event: { edit: cutbigwordright }
}]

$env.config.keybindings ++= [{
    name: completion_menu
    modifier: control
    keycode: char_h
    mode: emacs
    event: { edit: cutbigwordleft }
}]

$env.config.keybindings ++= [{
    name: completion_menu
    modifier: control
    keycode: char_z
    mode: emacs
    event: { edit: undo }
}]

$env.config.keybindings ++= [{
    name: completion_menu
    modifier: control_shift
    keycode: char_z
    mode: emacs
    event: { edit: redo }
}]
