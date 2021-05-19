bindkey '^[[B' down-line-or-history
bindkey '^[[A' up-line-or-history

bindkey '^[OB' down-line-or-history
bindkey '^[OA' up-line-or-history

bindkey '^[OD' backward-word
bindkey '^[OC' forward-word

bindkey -M viins '^r' history-incremental-search-backward
bindkey -M vicmd '^r' history-incremental-search-backward

bindkey -M viins '\e[H' beginning-of-line
bindkey -M viins '\e[F' end-of-line
bindkey -M viins '\e[3~' delete-char

bindkey -M vicmd '\e[H' beginning-of-line
bindkey -M vicmd '\e[F' end-of-line
bindkey -M vicmd '\e[3~' delete-char


