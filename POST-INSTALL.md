# Post Installation Tasks


## YouCompleteMe

`vim-bundles` clones YouCompleteMe but does not build it, and it is unusable
until it is built. Batfiles clones no submodules either, so fetch those first:

```shell
git -C ~/.vim/bundle/YouCompleteMe submodule update --init --recursive
cd ~/.vim/bundle/YouCompleteMe
./install.py --clang-completer --go-completer --rust-completer --java-completer --ts-completer
```

That needs `cmake gcc-g++ python3-devel npm`, on top of the basic development
tools (`groupinstall 'development tools'`).

## rofi
1. Install [rofi](https://github.com/davatorium/rofi) from somewhere ([wayland fork](https://github.com/lbonn/rofi))
2. Symlink whichever `rofi` you want into `~/bin/rofi`
3. Customize `~/.config/launch-entries.ini`

## Installing CLI tools and enhancements
1. Install [rust](https://www.rust-lang.org/tools/install) - `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
2. Install [mise](https://mise.jdx.dev/installing-mise.html) - `curl https://mise.run | sh`
3. Install [FiraCode Nerd Font](https://www.nerdfonts.com/font-downloads)
4. Install google-noto-emoji-fonts and google-noto-emoji-color-fonts - apparently FiraCode Nerd Font does not in fact contain all the required emojis, and freetype (or whatever) doesn't always fallback properly. The latter in particular is needed for kitty

Put the following into `~/.zshrc-local-pre`:

```shell
plugins=(aws starship zoxide task)
export DISABLE_SKIM_KEYBINDINGS=1
export AWS_PAGER=
eval "$(mise activate zsh)"
```

Other useful plugins include: gh nvm

Other usefulu software include:

```shell
mise use -g aqua:cli/cli
```

Put the following into `~/.zshrc-local-post`:

```shell
eval "$(atuin init zsh --disable-ai --disable-up-arrow)"
```
