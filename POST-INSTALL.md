# Post Installation Tasks


## Installing rofi
1. Install [rofi](https://github.com/davatorium/rofi) from somewhere ([wayland fork](https://github.com/lbonn/rofi))
2. Symlink whichever `rofi` you want into `~/bin/rofi`
3. Customize `~/.config/launch-entries.ini`

## Installing Starship
1. Install [rust](https://www.rust-lang.org/tools/install)
2. Install [Starship](https://starship.rs/) `cargo install starship --locked`
3. Install [FiraCode Nerd Font](https://www.nerdfonts.com/font-downloads)
4. Install google-noto-emoji-fonts and google-noto-emoji-color-fonts - apparently FiraCode Nerd Font does not in fact contain all the required emojis, and freetype (or whatever) doesn't always fallback properly. The latter in particular is needed for kitty

Put the following into `~/.zshrc-local-pre`:

```shell
ZSH_THEME=none
SHOW_AWS_PROMPT=false
```

Put the following into `~/.zshrc-local-post`:

```shell
eval "$(starship init zsh)"
```

## Setting up awscli
Put the following into `~/.zshrc-local-pre`:

```shell
export AWS_PAGER=
plugins=(aws)
```


