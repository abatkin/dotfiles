alias ant='ant -logger org.apache.tools.ant.listener.AnsiColorLogger'
alias ll='ls --color=tty -lrtN'
alias ls='ls --color=tty -N'
alias vi=vim

if [[ ! -z "$GREP_OPTIONS" ]]; then
  alias grep="grep $GREP_OPTIONS"
  export GREP_OPTIONS=
fi

alias urldecode='python -c "import sys, urllib as ul; print ul.unquote_plus(sys.argv[1])"'


if [[ -e /usr/share/skim/shell/key-bindings.zsh && -z $DISABLE_SKIM_KEYBINDINGS ]]; then
  . /usr/share/skim/shell/key-bindings.zsh
fi

alias xl='exa --group-directories-first --classify --git'
alias xll='xl -l -s modified'

alias skvi='f(){ x="$(sk --bind "ctrl-p:toggle-preview" --ansi --preview="bat {} --color=always" --preview-window=right:60%:hidden)"; [[ $? -eq 0 ]] && vim "$x" || true }; f'
export SKIM_DEFAULT_COMMAND="rg --files || fd || find ."


if [[ -e $HOME/.zshrc-local ]]; then
  . $HOME/.zshrc-local
fi

