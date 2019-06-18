dotfiles
========

My dotfiles

# Configuration Notes #

 * The file `~/.dotfiles-local` can be used to make local changes during installation
   * Set `BLACKLIST_VIM_MODULES` to a list of VIM modules to skip installing
 * `~/.zshrc-local` is for additions AFTER all other ZSH scripts have been run
 * `~/.zshrc-local-pre` is for additions BEFORE all other ZSH scripts have been run
   * In particular, set `JAVA_HOME`, `ANT_HOME` and `MAVEN_HOME` here

# Interesting Software #

* [jq](https://stedolan.github.io/jq/) - JSON query/formatting tool
* [fd](https://github.com/sharkdp/fd) - `find` alternative
* [bat](https://github.com/sharkdp/bat) - `cat` alternative
* [ack](https://beyondgrep.com/) - `grep` alternative

