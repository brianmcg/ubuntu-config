##########################
#  Function Definitions  #
##########################

##################################################
#  Set the git label for prompt                  #
##################################################
set_git_label() {
  local branch
  local branch_label
  local status_label

  # Get git branch label
  if branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null); then
    if [[ "${branch}" == "HEAD" ]]; then
      branch='detached*'
    fi

    branch_label="${branch}"
  else
    branch_label=""
  fi

  # Get git status label
  if [[ "$(git status --porcelain 2> /dev/null)" != "" ]]; then
    status_label='*'
  else
    status_label=''
  fi

  # Set full git label
  if [[ $branch_label ]]; then
    git_label=" ❖──(${branch_label}${status_label})"
  else
    git_label=""
  fi
}

##################################################
#  Calls `git diff` and opens result in Sublime  #
#  ${@} The Git arguments                        #
##################################################
git_diff_sublime () {
  git diff -w $@ > ~/Logs/Local/Git/.diff && subl ~/Logs/Local/Git/.diff
}

###################################
#  Open changed files in Sublime  #
#  ${@} The Git arguments         #
###################################
git_diff_open () {
  for file in $(git diff $@ --name-only)
  do
    subl $file
  done
}

##########################
#  Unzip all file types  #
#  ${1} The file path    #
##########################
extract () {
  if [ -f "$1" ] ; then
    case $1 in
      *.tar.bz2) tar xjf "$1" ;;
      *.tar.gz) tar xzf "$1" ;;
      *.bz2) bunzip2 "$1" ;;
      *.rar) rar x "$1" ;;
      *.gz) gunzip "$1" ;;
      *.tar) tar xf "$1" ;;
      *.tbz2) tar xjf "$1" ;;
      *.tgz) tar xzf "$1" ;;
      *.zip) unzip "$1" ;;
      *.Z) uncompress "$1" ;;
      *.7z) 7z x "$1" ;;
      *) echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}
