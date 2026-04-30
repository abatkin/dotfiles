#!/usr/bin/env bash
# Stage: download/update oh-my-zsh into ~/.oh-my-zsh.
# Sourced by install.sh; must not call `exit`.

clone_or_update https://github.com/robbyrussell/oh-my-zsh.git "$HOME/.oh-my-zsh"
