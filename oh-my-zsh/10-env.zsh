export EDITOR=vim
export VISUAL=vim
export PAGER=less

# Also setup JAVA_HOME, ANT_HOME, PATH
[[ -n $MAVEN_HOME && -e $MAVEN_HOME ]] && export PATH="$MAVEN_HOME/bin:$PATH"
[[ -n $ANT_HOME && -e $ANT_HOME ]] && export PATH="$ANT_HOME/bin:$PATH"
[[ -n $JAVA_HOME && -e $JAVA_HOME ]] && export PATH="$JAVA_HOME/bin:$PATH"
[[ -e $HOME/bin ]] && export PATH="$HOME/bin:$PATH"

