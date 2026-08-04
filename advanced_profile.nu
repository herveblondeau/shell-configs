# Fastfetch requires brew which in turn requires bash
fastfetch

# Zoxide must be installed (https://github.com/ajeetdsouza/zoxide?tab=readme-ov-file#installation)
alias c = z

# Neovim must be installed
alias vi = nvim
alias vim = nvim

# Bat must be installed (https://github.com/sharkdp/bat?tab=readme-ov-file#installation)
alias cat = bat

# Yazi must be installed
# https://yazi-rs.github.io/docs/quick-start
def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
}

# herdr must be installed
alias h = herdr
