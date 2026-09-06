dotfiles
========

My dotfiles, installed by [batfiles](https://github.com/abatkin/batfiles).

`batfiles.toml` at the root of this repository declares where everything
belongs; `batfiles sync` makes the home directory match. There is no install
script any more.

# Installing #

On a fresh machine:

```shell
git clone https://github.com/abatkin/dotfiles ~/dotfiles

# batfiles publishes no binaries yet, so build it:
git clone https://github.com/abatkin/batfiles.git ~/code/batfiles
cargo install --path ~/code/batfiles

batfiles sync
```

The repository defaults to `~/dotfiles`, so `sync` needs no arguments. To see
what it would do without doing any of it:

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

**Nothing is backed up.** `install_dotfile` moved an existing regular file to
`<name>.old` and carried on. Batfiles refuses instead, and stops the whole run:

    error: ~/.zshrc already exists and is a regular file; move it aside and run sync again

There is no backup policy yet. The practical consequence is that adopting this
on a machine with hand-written dotfiles means moving them aside by hand, one
refusal at a time, since the run stops at the first one rather than reporting
all of them.

**A failed download or clone stops the run too.** `install.sh` guarded the
network work behind `LOCAL_ONLY` and never let it break the local half; here,
a `sync` with no network fails at `oh-my-zsh` and never reaches a single
symlink. Individual entries of the two bundle lists are the exception -- one
unreachable plugin is a warning, and the rest of the list still installs.

**`BLACKLIST_VIM_MODULES` and `~/.dotfiles-local` do nothing now.** Nothing
reads that file any more. The per-machine vim bundle blacklist wants to disable
one entry of a bundle list, which is `disable-action vim-bundles.YouCompleteMe`
-- an address form batfiles has specified but not built.

**Submodules are not cloned**, by `git-clone-list` or by anything else. Neither
did `install_bundles`, so nothing regressed, but it is why YouCompleteMe needs
the `submodule update` in `POST-INSTALL.md` before it will build.

**`55-nvim.sh`'s directory-symlink guard is gone.** Batfiles follows a symlinked
parent component by design, so on the old whole-directory-symlink layout it
would install *through* the link rather than refusing. That migration is done
and the guard was vestigial.

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
