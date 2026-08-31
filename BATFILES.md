# Managing these dotfiles with batfiles

This branch adds a `batfiles.toml` that covers every part of `install.sh` that
only touches local files. Everything that reaches the network is still the
shell script's, because batfiles cannot express it yet.

The tracking issue on the batfiles side is rewrite step 3.8; step 4.8 is where
`install.sh` is retired outright.

## Running it

    batfiles --batfiles-dir ~/dotfiles-test sync --dry-run
    batfiles --batfiles-dir ~/dotfiles-test sync

Or a slice at a time, by group:

    batfiles --batfiles-dir ~/dotfiles-test apply-group --group nvim

The groups are `oh-my-zsh`, `vim`, `home`, `bin`, `confs`, and `nvim`.

On a fresh machine, `install.sh` still has to run **first**: it is what puts
`~/.oh-my-zsh` and `~/.vim/bundle` on disk, and the batfiles actions install
into directories those steps create.

`install.sh` is unchanged and still does everything it used to. Its converted
steps are now redundant rather than wrong: `install_dotfile` returns early on a
symlink already pointing into the repository, so running it after a `sync` is a
no-op for those. Pruning the converted installers out of it is worth doing once
`sync` has a few real runs behind it, not before.

## What batfiles does now

| Installer                    | Actions                                                                   |
|------------------------------|---------------------------------------------------------------------------|
| `15-setup-oh-my-zsh.sh`      | `omz-custom`, `omz-plugins` — the two `symlink-dir` loops                  |
| `20-setup-vim.sh`            | `vim-after`                                                               |
| `30-setup-dotfiles.sh`       | `rcfiles` — all of it                                                     |
| `40-setup-binfiles.sh`       | `binfiles` — all of it, `mkdir ~/bin` included                            |
| `50-setup-confs.sh`          | `kitty`, `starship`, `rofi`, `mise-*`, `atuin-config`, `launch-entries` — all of it |
| `55-nvim.sh`                 | `nvim-init`, `nvim-config`, `nvim-plugins`, `nvim-lazyvim-json`, `nvim-local-*` |

Two things about the mapping are worth stating, because they are places where
the manifest is shorter than the script rather than a translation of it:

- **The `mkdir -p` calls are gone.** Every batfiles action creates the parents
  of what it installs, and `symlink-dir`'s `dest-dir` is created whether or not
  there is anything to put in it. Only `~/.config/nvim-local/lua/{config,plugins}`
  needed `create-dir`, because nothing installs into those.
- **The `if [[ ! -e ]]` guards are gone.** That is what `copy` means: it seeds
  where nothing is and keeps what it finds. The four of them —
  `~/.config/mise/config.toml`, `~/.config/atuin/config.toml`,
  `~/.config/launch-entries.ini`, and nvim's `lazyvim.json` — are all plain
  `copy` actions.

## What is still install.sh's

Four things, all of them network work:

| Installer                    | What it does                                     | Blocked on            |
|------------------------------|--------------------------------------------------|-----------------------|
| `10-download-oh-my-zsh.sh`   | clone or pull oh-my-zsh into `~/.oh-my-zsh`      | `git-clone`, step 4.3 |
| `20-setup-vim.sh` (part)     | `curl` pathogen into `~/.vim/autoload`           | `fetch-url`, step 4.1 |
| `20-setup-vim.sh` (part)     | `vim/bundles.txt` into `~/.vim/bundle`           | `git-clone-list`, steps 4.4 and 4.5 |
| `15-setup-oh-my-zsh.sh` (part) | `zsh-bundles.txt` into `~/.oh-my-zsh/custom/plugins` | `git-clone-list`, steps 4.4 and 4.5 |

## What is missing beyond the fetching

These are the places where the manifest is not a faithful translation, listed
so they are not rediscovered later.

**Backups.** `install_dotfile` moved an existing regular file to `<name>.old`
and carried on. Batfiles refuses instead, and stops the whole run:

    error: ~/.zshrc already exists and is a regular file; move it aside and run sync again

That is the intended behavior for now — there is no backup policy yet, and
`--no-overwrite` and `--interactive` are parsed but rejected. The practical
consequence is that adopting this on a machine with hand-written dotfiles means
moving them aside by hand first, one refusal at a time, since the run stops at
the first one rather than reporting all of them. Batfiles tracks that second
half as "Keep going past the first failure" in `rewrite/steps.md`.

**`55-nvim.sh`'s directory-symlink guard has no equivalent.** Batfiles follows a
symlinked parent component by design, so on the old whole-directory-symlink
layout it would install *through* the link rather than refusing. That migration
is done and the guard is vestigial; noted only so the difference is not
mistaken for a bug later.

**`BLACKLIST_VIM_MODULES` and `~/.dotfiles-local` have no equivalent.** The
per-machine vim bundle blacklist is read from a sourced shell file. What it
wants is to disable one entry of a bundle list, which is
`disable-action vim-bundles.YouCompleteMe` — an address form that is specified
but unbuilt, tracked as "Address individual `git-clone-list` entries" in
`rewrite/steps.md`. Moot until `git-clone-list` lands either way.

**`nvim/seed/lazyvim.json` is new.** `55-nvim.sh` wrote that JSON inline with
`write_file`. Batfiles has no action that writes literal content, so the file is
now checked in and seeded with `copy`. `nvim/lazyvim.json` stays gitignored;
the seed lives beside it rather than at that path.

**Nothing uses `[default-disabled]`.** Nothing in this repository is expensive
enough to want switched off on a fresh machine yet, and the section is not read
by anything until batfiles step 8.3.

**Two paths in the repository are installed by nothing**, in `install.sh` and
here alike: `confs/statusline-command.sh` and `eclipse-customizations/`. Left
as they are.
