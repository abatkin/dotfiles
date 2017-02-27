# Disables url-quote-magic
zle -A .self-insert self-insert

DIRSTACKSIZE=20

zstyle ':filter-select' case-insensitive yes # for zaw

zle -C complete-files complete-word _generic
zstyle ':completion:complete-files:*' completer _files
bindkey "\e[Z" complete-files


