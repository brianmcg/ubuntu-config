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


#####################
#  Program aliases  #
#####################
alias pgen="openssl rand -base64 20"
alias vim="vi"

####################
#  Custom aliases  #
####################
alias cc='color_convert'
alias la="ls -A"
alias lh="ls -lh"
alias ll="ls -l"
alias ls="ls -I 'NTUSER*' -I 'ntuser*' -F --color=always"
alias mkdird='mkdir $(date '+%d-%b-%Y')'
alias mkdirp='mkdir -p'
alias pa='pull_all'
alias rmesc='remove_escape_characters'

######################
#  Function aliases  #
######################
alias de='get_demoenv'
alias cde='create_demoenv'
alias ode='open_demoenv'
alias rde='run_demoenv'
