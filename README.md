dotfiles
========

My dotfiles

# Configuration Notes #

 * The file `~/.dotfiles-local` can be used to make local changes during installation
   * Set `BLACKLIST_VIM_MODULES` to a list of VIM modules to skip installing
 * `~/.zshrc-local` is for additions AFTER all other ZSH scripts have been run
 * `~/.zshrc-local-pre` is for additions BEFORE all other ZSH scripts have been run
   * In particular, set `JAVA_HOME`, `ANT_HOME` and `MAVEN_HOME` here
   * Also useful are updates to `fpath` (`fpath=(~/foo $fpath)`) and plugins (`plugins=(a b c)`)

# Interesting Software #

| Command | URL                                   | Description                | RPM     | Cargo   |
|---------|---------------------------------------|----------------------------|---------|---------|
| jq      | https://stedolan.github.io/jq/        | JSON Query/formatting tool | jq      | -       |
| fd      | https://github.com/sharkdp/fd         | `find` alternative         | fd-find | fd-find |
| exa     | https://the.exa.website/              | `ls` alternative           | exa     | exa     |
| skim    | https://github.com/lotabout/skim      | Interactive fuzzy finder   | skim    | skim    |
| bat     | https://github.com/sharkdp/bat        | Fancy `cat`                | bat     | bat     |
| ack     | https://beyondgrep.com/               | `grep` alternative         | ack     | -       |
| ripgrep | https://github.com/BurntSushi/ripgrep | Another `grep` alternative | ripgrep | ripgrep |
| dua     | https://github.com/Byron/dua-cli      | Interactive `du`           | -       | dua-cli |
| sd      | https://github.com/chmln/sd           | Find and replace in files  | sd      | sd      |
| hexyl   | https://github.com/sharkdp/hexyl      | Command line hex viewer    | -       | hexyl   |

