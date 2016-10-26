alias ant='ant -logger org.apache.tools.ant.listener.AnsiColorLogger'
alias ll='ls --color=tty -lrtN'
alias ls='ls --color=tty -N'
alias kde=". ~/kde/env.sh && cd ~/kde/src"
alias vi=vim
alias ccp="xclip -selection c"

if [[ ! -z "$GREP_OPTIONS" ]]; then
  alias grep="grep $GREP_OPTIONS"
  export GREP_OPTIONS=
fi

alias urldecode='python -c "import sys, urllib as ul; print ul.unquote_plus(sys.argv[1])"'

