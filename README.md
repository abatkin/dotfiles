dotfiles
========

My dotfiles, installed by [batfiles](https://github.com/abatkin/batfiles).

`batfiles.toml` at the root of this repository declares where everything
belongs; `batfiles sync` makes the home directory match. There is no install
script any more.

# Installing #

On a fresh machine, one command installs batfiles to `~/.local/bin`, clones
this repository to `~/dotfiles`, and syncs it:

```shell
curl -fsSL https://batfiles.dev/install.sh | sh -s -- clone https://github.com/abatkin/dotfiles
```

`clone` checks out the default branch, so this works once `batfiles.toml` is
on it. After that, `batfiles update` upgrades batfiles itself; nothing else
does.

On a machine that already has the checkout, run `sync` from anywhere. The
repository defaults to `~/dotfiles`, so it needs no arguments:

```shell
batfiles sync
```

A machine set up by the old `install.sh` already has links into `~/dotfiles`,
and batfiles accepts them as they are. So on such a machine `sync` only updates
the clones and repairs anything that has drifted.

To see what it would do without doing any of it:

```shell
batfiles sync --dry-run
```

Or a slice at a time, by group -- the groups are `oh-my-zsh`, `vim`, `home`,
`bin`, `confs`, and `nvim`:

```shell
batfiles apply-group --group nvim
```

Then work through `POST-INSTALL.md`, which covers everything `sync` does not
install: rofi, the CLI tools, the fonts, the `~/.zshrc-local-*` hooks, and
building YouCompleteMe.

# What changed when install.sh went away #

The manifest is a translation of the numbered installers, and the comments in
`batfiles.toml` say which installer each action came from. Five places where it
is not a faithful translation, listed so they are not rediscovered later.

**Backups are named differently.** `install_dotfile` moved whatever was in the
way to `<name>.old`. Batfiles renames it to
`<name>.batfiles-backup-<timestamp>` beside it, never overwriting an earlier
backup, and then installs. `--no-overwrite` leaves such things alone instead,
and `--interactive` asks about each one. Templates that are `copy` actions
(the mise, atuin, launch-entries, and lazyvim.json seeds) are never replaced;
they install only where nothing is.

**A failed `oh-my-zsh` update stops the run.** `install.sh` guarded the network
work behind `LOCAL_ONLY`; here, a `sync` with no network fails at `oh-my-zsh`,
the first action, before any symlink. To sync offline, skip it:

```shell
batfiles sync --skip-action oh-my-zsh
```

The rest of the network work is fine without it: pathogen is fetched only when
it is missing, and an unreachable entry of either bundle list is a warning
while the rest of the list carries on.

**`BLACKLIST_VIM_MODULES` and `~/.dotfiles-local` do nothing now.** Nothing
reads that file any more. To leave a bundle off some machines, give its line in
`vim/bundles.txt` a condition:

```text
https://github.com/Valloric/YouCompleteMe.git unless="vars.skip_ycm"
```

and on each machine that should not have it, `batfiles vars set skip_ycm true`.
`vars.` makes the variable optional, so machines that never set it get the
bundle.

**Submodules are not cloned**, by `git-clone-list` or by anything else. Neither
did `install_bundles`, so nothing regressed, but it is why YouCompleteMe needs
the `submodule update` in `POST-INSTALL.md` before it will build.

**`55-nvim.sh`'s directory-symlink guard is gone.** On the old layout, where
`~/.config/nvim` was itself a link into this repository, batfiles refuses
rather than installing through it (`cannot install .../nvim/init.lua into
~/.config/nvim/init.lua, which is inside it`). Remove the link and sync again.
That migration is done, so the guard was vestigial.

Two paths in this repository are still installed by nothing, exactly as under
`install.sh`: `confs/statusline-command.sh` and `eclipse-customizations/`.

# Configuration Notes #

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
| eza     | https://eza.rocks/                    | `ls` alternative           | eza     | eza     |
| skim    | https://github.com/lotabout/skim      | Interactive fuzzy finder   | skim    | skim    |
| bat     | https://github.com/sharkdp/bat        | Fancy `cat`                | bat     | bat     |
| ack     | https://beyondgrep.com/               | `grep` alternative         | ack     | -       |
| ripgrep | https://github.com/BurntSushi/ripgrep | Another `grep` alternative | ripgrep | ripgrep |
| dua     | https://github.com/Byron/dua-cli      | Interactive `du`           | -       | dua-cli |
| sd      | https://github.com/chmln/sd           | Find and replace in files  | sd      | sd      |
| hexyl   | https://github.com/sharkdp/hexyl      | Command line hex viewer    | -       | hexyl   |
