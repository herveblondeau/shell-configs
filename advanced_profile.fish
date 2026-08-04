# Oh My Posh must be installed (https://ohmyposh.dev)
oh-my-posh init fish --config '/home/tigrou/ownCloud/Shell/Oh My Posh/herve.omp.json' | source

# Override prevd and nextd bindings as Oh My Posh doesn't refresh the prompt by default
function my_prevd
    prevd
    commandline -f execute
    oh-my-posh init fish --config '/home/tigrou/ownCloud/Shell/Oh My Posh/herve.omp.json' | source
end
function my_nextd
    nextd
    commandline -f execute
    oh-my-posh init fish --config '/home/tigrou/ownCloud/Shell/Oh My Posh/herve.omp.json' | source
end
bind alt-left 'my_prevd'
bind alt-right 'my_nextd'
# Previous:
#bind \e\[1\;3D 'my_prevd'
#bind \e\[1\;3C 'my_nextd'

# Zoxide must be installed (https://github.com/ajeetdsouza/zoxide?tab=readme-ov-file#installation)
zoxide init fish | source
abbr --erase c
abbr --add c "z"

# Neovim must be installed
alias nvim "/home/tigrou/Applications/nvim-linux-x86_64-v0.11.7.appimage"
abbr --add n nvim
abbr --add nv nvim
abbr --add v nvim
abbr --add vi nvim
abbr --add vim nvim
abbr --add vv "nvim ."
set -x EDITOR "nvim"

# Bat must be installed (https://github.com/sharkdp/bat?tab=readme-ov-file#installation)
abbr --add cat bat

# Eza must be installed
abbr --erase l
abbr --erase la
function l
    eza --long --header --icons --git $argv
end

function la
    eza --all --long --header --icons --git $argv
end

# eza must be installed
# Lists as a tree
# The following signatures are allowed:
# - lt: current folder content, depth level 100
# - lt N: current folder content, depth level N
# - lt pattern: content matching the pattern, depth level 100
# - lt N pattern: content matching the pattern, depth level N
function lt
    # Default depth
    set depth 100

    # No arguments → easy case
    if test (count $argv) -eq 0
        eza --long --header --icons --git --tree --level=$depth
        return
    end

    # First parameter handling
    set first $argv[1]

    # Detect whether first argument is an integer (only digits)
    if string match -qr '^[0-9]+$' -- $first
        # It's an integer → treat it as the depth override
        set depth $first
        # Remaining args become the pattern list, if any
        set patterns $argv[2..-1]
    else
        # It's not an integer → treat as pattern
        set patterns $argv
    end

    if test (count $patterns) -gt 0
        # Pass all patterns through
        eza --long --header --icons --git --tree --level=$depth $patterns
    else
        # No patterns → tree of current directory
        eza --long --header --icons --git --tree --level=$depth
    end
end
alias lt1 "lt 1"
alias lt2 "lt 2"
alias lt3 "lt 3"

function lta
    # Default depth
    set depth 100

    # No arguments → easy case
    if test (count $argv) -eq 0
        eza --long --header --icons --git --tree --level=$depth
        return
    end

    # First parameter handling
    set first $argv[1]

    # Detect whether first argument is an integer (only digits)
    if string match -qr '^[0-9]+$' -- $first
        # It's an integer → treat it as the depth override
        set depth $first
        # Remaining args become the pattern list, if any
        set patterns $argv[2..-1]
    else
        # It's not an integer → treat as pattern
        set patterns $argv
    end

    if test (count $patterns) -gt 0
        # Pass all patterns through
        eza --all --long --header --icons --git --tree --level=$depth $patterns
    else
        # No patterns → tree of current directory
        eza --all --long --header --icons --git --tree --level=$depth
    end
end
alias lta1 "lta 1"
alias lta2 "lta 2"
alias lta3 "lta 3"

# fd and eza must be installed
# - performs a non-fuzzy search in the current or a specific directory
function f
    if test (count $argv) -eq 1
        fd -H $argv[1] | xargs -r eza --icons --long --header --git --absolute 2>/dev/null
        return
    end

    if test (count $argv) -eq 2
        fd -H $argv[1] $argv[2] | xargs -r eza --icons --long --header --git --absolute 2>/dev/null
        return
    end

    echo "Usage: f <part of file/folder name to search?> <folder to start the search from?>"
end

# Searches a file and opens it
# All matches are displayed for selection via fzf, and the selection is opened with nvim
# Parameters:
# - filename: filename to fuzzy search
# - (optional) folder to search in
# Notes:
# - if no folder is specified, the search is performed in the following locations: recently opened files, zoxide frecent files, current folder, home folder
# - the -r flag can be passed to make the search recursive. This can make the search extremely slow depending on the hierarchy depth
function o
    set history_file ~/.nvim_opened_files
    set max_history 100

    # Parse arguments
    set -l recursive false
    set -l search_folder ""
    set -l query ""

    for arg in $argv
        if test "$arg" = "-r"
            set recursive true
        else if test -d "$arg"
            set search_folder "$arg"
        else
            set query "$arg"
        end
    end

    # Determine if we should limit depth
    set -l limit_depth true
    if test "$recursive" = true
        set limit_depth false
    end

    # Helper function to update history
    function __o_update_history --argument-names file hist_file max_hist
        set tmp_file "$hist_file.tmp"

        # Create history file if it doesn't exist
        if not test -f $hist_file
            touch $hist_file
        end

        # Remove duplicates
        grep -vFx -- "$file" $hist_file 2>/dev/null > $tmp_file
        mv $tmp_file $hist_file

        # Prepend file
        echo $file | cat - $hist_file > $tmp_file
        mv $tmp_file $hist_file

        # Trim to max_hist lines
        head -n $max_hist $hist_file > $tmp_file
        mv $tmp_file $hist_file
    end

    # Build file list in priority order with source markers
    # Format: "SOURCE|filepath" where SOURCE is: recent, zoxide, current, home, folder
    set -l all_files

    # If a specific folder is provided, search only there
    if test -n "$search_folder"
        # Search in the specified folder (files and directories)
        if test "$limit_depth" = true
            set folder_files (find "$search_folder" -maxdepth 1 \( -type f -o -type d \) 2>/dev/null | while read -l f; echo "folder|$f"; end)
        else
            set folder_files (find "$search_folder" \( -type f -o -type d \) 2>/dev/null | while read -l f; echo "folder|$f"; end)
        end
        if test (count $folder_files) -gt 0
            set all_files $all_files $folder_files
        end
    else
        # Normal mode: search in all sources

        # 1. Recent files (from history)
        if test -f $history_file
            # Filter out entries that no longer exist (files or directories)
            set recent_files (for f in (cat $history_file)
                if test -f "$f"; or test -d "$f"
                    echo "recent|$f"
                end
            end)
            if test (count $recent_files) -gt 0
                set all_files $all_files $recent_files
            end
        end

        # 2. Recent folders (from zoxide)
        set -l top_dirs (zoxide query -l | head -n 20)
        if test (count $top_dirs) -gt 0
            for dir in $top_dirs
                set files (find "$dir" -maxdepth 1 \( -type f -o -type d \) 2>/dev/null | while read -l f; echo "zoxide|$f"; end)
                if test (count $files) -gt 0
                    set all_files $all_files $files
                end
            end
        end

        # 3. Current folder
        if test "$limit_depth" = true
            set current_files (find . -maxdepth 1 \( -type f -o -type d \) 2>/dev/null | while read -l f; echo "current|$f"; end)
        else
            set current_files (find . \( -type f -o -type d \) 2>/dev/null | while read -l f; echo "current|$f"; end)
        end
        if test (count $current_files) -gt 0
            set all_files $all_files $current_files
        end

        # 4. Home folder
        if test "$limit_depth" = true
            set home_files (find "$HOME" -maxdepth 1 \( -type f -o -type d \) 2>/dev/null | while read -l f; echo "home|$f"; end)
        else
            set home_files (find "$HOME" \( -type f -o -type d \) 2>/dev/null | while read -l f; echo "home|$f"; end)
        end
        if test (count $home_files) -gt 0
            set all_files $all_files $home_files
        end
    end

    # Remove duplicates while preserving order (first occurrence wins)
    # Compare actual file paths, not the source|path format
    set -l unique_files
    set -l seen_paths
    for item in $all_files
        # Extract the path (everything after the first |)
        set parts (string split "|" "$item" -m 1)
        if test (count $parts) -eq 2
            set path $parts[2]
        else
            set path "$item"
        end

        # Check if we've seen this path before
        set found false
        for seen in $seen_paths
            if test "$path" = "$seen"
                set found true
                break
            end
        end

        if test "$found" = false
            set unique_files $unique_files $item
            set seen_paths $seen_paths $path
        end
    end
    set all_files $unique_files

    if test (count $all_files) -eq 0
        echo "No files found"
        return 1
    end

    # Format files with colored section markers for display
    set -l formatted_files
    for item in $all_files
        set parts (string split "|" "$item" -m 1)
        if test (count $parts) -eq 2
            set source $parts[1]
            set path $parts[2]
        else
            set source ""
            set path "$item"
        end

        # Add colored prefix based on source using printf for proper escape sequences
        switch $source
            case recent
                set formatted (printf '\033[1;32m● \033[0m%s' "$path")  # Green ●
            case zoxide
                set formatted (printf '\033[1;32m■ \033[0m%s' "$path")  # Green ■
            case current
                set formatted (printf '\033[1;33m■ \033[0m%s' "$path")  # Yellow ■
            case home
                set formatted (printf '\033[1;37m■ \033[0m%s' "$path")  # White ■
            case folder
                set formatted (printf '\033[1;34m■ \033[0m%s' "$path")  # Blue ■
            case '*'
                set formatted (printf '  %s' "$path")
        end
        set formatted_files $formatted_files $formatted
    end

    # Use fzf with multi-select to pick files/directories
    # Results are displayed in the order they were found (priority order)
    set -l header (printf '\033[1;32m● Recent\033[0m  \033[1;32m■ Zoxide\033[0m  \033[1;33m■ Current\033[0m  \033[1;37m■ Home\033[0m  \033[1;34m■ Folder\033[0m')
    if test -n "$query"
        set selected_formatted (printf "%s\n" $formatted_files | fzf --ansi --multi --query="$query" --prompt="Select file(s)/folder(s)> " --header="$header")
    else
        set selected_formatted (printf "%s\n" $formatted_files | fzf --ansi --multi --prompt="Select file(s)/folder(s)> " --header="$header")
    end

    if test -z "$selected_formatted"
        echo "No selection made"
        return 1
    end

    # Extract actual paths from selected items (remove color codes and prefix)
    set -l selected_files
    for item in $selected_formatted
        # Remove ANSI color codes (\033 or \x1b format) and prefix markers
        set path (echo "$item" | sed -E 's/\x1b\[[0-9;]*m//g' | sed -E 's/\033\[[0-9;]*m//g' | sed -E 's/^[●■] +//')
        set selected_files $selected_files "$path"
    end

    # Process each selected file/directory (update history and add to zoxide)
    for file in $selected_files
        # Update history
        __o_update_history "$file" "$history_file" $max_history

        # Add directory to zoxide (if it's a directory, add it; if it's a file, add its parent)
        if test -d "$file"
            zoxide add "$file" 2>/dev/null
        else
            set file_dir (dirname "$file")
            zoxide add "$file_dir" 2>/dev/null
        end
    end

    # Open all selected files in a single nvim instance
    nvim $selected_files
end

# Fastfetch requires brew which in turn requires bash
fastfetch

# VSCode must be installed
abbr --add ccode "code ."

# CSharpRepl (.NET tool) must be installed
abbr --add repl csharprepl

# Docker must be installed
function exca
    sudo docker run --name="excalidraw" --rm -p 8081:80 -d docker.io/excalidraw/excalidraw:latest
    echo "Excalidraw running at http://localhost:8081"
end
abbr --add stopexca "sudo docker container stop excalidraw"
function draw
    sudo docker run --name="drawio" --rm -p 8082:8080 -d jgraph/drawio
    echo "draw.io running at http://localhost:8082"
end
abbr --add stopdraw "sudo docker container stop drawio"

# Yazi must be installed
# https://yazi-rs.github.io/docs/quick-start
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

# LagyGit must be installed
abbr --add lg lazygit

# herdr must be installed
abbr --add h herdr

# fabric should be installed
abbr --add fa fabric
abbr --add fap "fabric --pattern="
function yts
    fabric -y $argv --pattern=youtube_summary
end
function yti
    fabric -y $argv --pattern=extract_ideas
end

# xsel must be installed
abbr --add pt "xsel --clipboard --output"
