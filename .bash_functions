##########################
#  Function Definitions  #
##########################


##################################################
#  Calls `git diff` and opens result in Sublime  #
#  ${@} The Git arguments                        #
##################################################
git_diff_sublime () {
  git diff -w $@ > ~/Logs/Local/Git/.diff && subl ~/Logs/Local/Git/.diff
}

get_demoenv () {
  DEMOENV_REGEX=^bm-rrd-[0-9]{5}$
  JIRA_REGEX=^RRD-[0-9]{5}$
  NUM_REGEX=^[0-9]{5}$
  lowercase=$(echo "${1}" | awk '{print tolower($0)}')

  if [[ "${1}" =~ ${JIRA_REGEX} ]]; then
    echo "bm-${lowercase}"
  elif [[ "${1}" =~ ${NUM_REGEX} ]]; then
    echo "bm-rrd-${lowercase}"
  elif [[ "${1}" =~ ${DEMOENV_REGEX} ]]; then
    echo "${1}"
  else
    exit 0
  fi
}

create_demoenv () {
  DEMOENV_REGEX=^bm-rrd-[0-9]{5}$
  ENV_NAME=$(get_demoenv ${1})

  if [[ "${ENV_NAME}" =~ ${DEMOENV_REGEX} ]]; then
    ~/Repos/gitops-eu/demoenv/helm-demoenvs/create_env.py "$(get_demoenv ${1})"
  else
    echo "Invalid input..."
    exit 0
  fi
}

open_demoenv () {
  DEMOENV_REGEX=^bm-rrd-[0-9]{5}$
  ENV_NAME=$(get_demoenv ${1})

  if [[ "${ENV_NAME}" =~ ${DEMOENV_REGEX} ]]; then
    google-chrome "https://accounts-${ENV_NAME}.dev.rrilabs.com"
  else
    echo "Invalid input..."
    exit 0
  fi
}

run_demoenv () {
  DEMOENV_REGEX=^bm-rrd-[0-9]{5}$
  ENV_NAME=$(get_demoenv ${1})

  if [[ "${ENV_NAME}" =~ ${DEMOENV_REGEX} ]]; then
    echo "Running: yarn ui:spa:demoenv ${ENV_NAME}"
    yarn ui:spa:demoenv ${ENV_NAME}
  else
    echo "Invalid input..."
    exit 0
  fi
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
#########################################
#  Output a string surrounded by a box  #
#  ${1} The string to output            #
#########################################
echo_box() {
  content="|  ${1}  |"
  length=${#content}-2
  border="+"
  padding="|"

  for ((i = 0; i < length; i++)); do
    border="${border}-"
    padding="${padding} "
  done

  border="${border}+"
  padding="${padding}|"

  echo "${border}"
  echo "${padding}"
  echo "${content}"
  echo "${padding}"
  echo "${border}"
}