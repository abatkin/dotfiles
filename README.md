dotfiles
========

My dotfiles

# Install #

Run the driver from anywhere:

```shell
./install.sh                 # full install / update
./install.sh --dry-run       # show what would change, do nothing
./install.sh --local-only    # skip git clone/pull (no network)
./install.sh --only confs    # only run stages whose name contains "confs"
./install.sh --skip vim,oh-my-zsh
./install.sh --help
```

Stages live in `install/*.sh` and are sourced in lexical order by `install.sh`,
sharing helpers from `lib/common.sh`. `~/.dotfiles-local` is sourced once at the
top of the run, so vars like `LOCAL_ONLY=true` or `BLACKLIST_VIM_MODULES="foo bar"`
set there apply to every stage.

# Configuration Notes #

 * The file `~/.dotfiles-local` can be used to make local changes during installation
   * Set `BLACKLIST_VIM_MODULES` to a list of VIM modules to skip installing
 * `~/.zshrc-local` is run as part of the oh-my-zshrc as the last "plugin"
 * `~/.zshrc-local-pre` is for additions BEFORE all other ZSH scripts have been run
 * `~/.zshrc-local-post` is for additions AFTER all other ZSH scripts have been run
   * In particular, set `JAVA_HOME`, `ANT_HOME` and `MAVEN_HOME` here
   * Also useful are updates to `fpath` (`fpath=(~/foo $fpath)`) and plugins (`plugins=(a b c)`)

# Interesting Software #

| Command | URL                                   | Description                | RPM     | Cargo   |
|---------|---------------------------------------|----------------------------|---------|---------|
| jq      | https://stedolan.github.io/jq/        | JSON Query/formatting tool | jq      | -       |
| fd      | https://github.com/sharkdp/fd         | `find` alternative         | fd-find | fd-find |
| exa     | https://eza.rocks/                    | `ls` alternative           | eza     | eza     |
| skim    | https://github.com/lotabout/skim      | Interactive fuzzy finder   | skim    | skim    |
| bat     | https://github.com/sharkdp/bat        | Fancy `cat`                | bat     | bat     |
| ack     | https://beyondgrep.com/               | `grep` alternative         | ack     | -       |
| ripgrep | https://github.com/BurntSushi/ripgrep | Another `grep` alternative | ripgrep | ripgrep |
| dua     | https://github.com/Byron/dua-cli      | Interactive `du`           | -       | dua-cli |
| sd      | https://github.com/chmln/sd           | Find and replace in files  | sd      | sd      |
| hexyl   | https://github.com/sharkdp/hexyl      | Command line hex viewer    | -       | hexyl   |

