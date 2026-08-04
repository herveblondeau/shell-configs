# Shell/Linux

Personal shell configuration: aliases, key bindings, functions, and other
tweaks to make day-to-day shell use more convenient. These files are meant
to be sourced from each shell's own config (e.g. `config.fish`, `.bashrc`,
`.zshrc`).

## Shells covered

- **fish** — the main, daily-driver shell. Gets the most attention and is
  kept up to date first.
- **bash**, **zsh**, **posix**, **nu** — still maintained and expected to
  work, but may lag behind the fish profile in terms of features and
  polish.

## File naming

- `base_profile.*` — no external tools required beyond the shell itself.
  Safe to source on any machine.
- `advanced_profile.*` — depends on external tools/programs being
  installed. Source these only on machines where those tools are set up.
- Other `*_profile.*` files integrate a specific external tool (named in
  the file) and should only be sourced if that tool is installed.

Exact contents (which aliases, bindings, functions, etc.) are intentionally
not documented here since they may change frequently — read the relevant file
for specifics.
