local return_code='%(?..%{$fg[red]%}%? ↵%{$reset_color%})'
local git_branch

if [[ "$DISABLE_GIT_PROMPT" != "true" ]]; then
  git_branch='$(git_prompt_status)%{$reset_color%}$(git_prompt_info)$(git_prompt_short_sha)'
fi

ZSH_THEME_GIT_PROMPT_SHA_BEFORE=" %{$fg[red]%}("
ZSH_THEME_GIT_PROMPT_SHA_AFTER=")%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[cyan]%}+ "
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}~ "
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}x "
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%}> "
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[magenta]%}! "
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[red]%}* "

function collapse_pwd {
    echo $(pwd | sed -e "s,^$HOME,~,")
}

PROMPT='%{$fg[green]%}[%!]%{$reset_color%}%{$fg[magenta]%}%n%{$reset_color%}%{$fg[cyan]%}@%{$reset_color%}%{$fg[yellow]%}%m%{$reset_color%}%{$fg[red]%} %{$reset_color%}%{$fg[cyan]%}${PWD/#$HOME/~}%{$reset_color%}%{$fg[red]%}%{$reset_color%}%{$fg[cyan]%}>%{$reset_color%} '
RPROMPT=" ${return_code} ${git_branch}"
