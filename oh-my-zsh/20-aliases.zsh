alias ant='ant -logger org.apache.tools.ant.listener.AnsiColorLogger'
alias ll='ls --color=tty -lrt'
alias kde=". ~/kde/env.sh && cd ~/kde/src"
alias vi=vim
alias ccp="xclip -selection c"

if [[ ! -z "$GREP_OPTIONS" ]]; then
  alias grep="grep $GREP_OPTIONS"
  export GREP_OPTIONS=
fi

