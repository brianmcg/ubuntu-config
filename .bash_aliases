#######################
#  Alias definitions  #
#######################

###########################################################
#  Enable color support of ls and also add handy aliases  #
###########################################################
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls -F --color=auto'
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

alias ll='ls -alF'
alias la='ls -a'
alias l='ls -CF'

#################
#  Git aliases  #
#################
alias gs='git status'
alias ga='git add'
alias gd='git_diff_sublime'
alias gdo='git_diff_open'
alias gc='git commit'
alias go='git checkout'
alias gr='git reset'
alias gl='git log'
alias gb='git branch'
alias gsc='git stash && git stash clear'
alias gpo='git push origin'
alias gla='git shortlog -s -n --all'

####################
#  Custom aliases  #
####################
alias pgen="openssl rand -base64 20"
alias vim="vi"
alias mkdird='mkdir $(date '+%d-%b-%Y')'
alias mkdirp='mkdir -p'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias explorer='nautilus'

######################
#  Function aliases  #
######################
alias rmesc='remove_escape_characters'
alias pa='pull_all'
alias de='get_demoenv'
alias cde='create_demoenv'
alias ode='open_demoenv'
alias rde='run_demoenv'
alias cc='color_convert'
