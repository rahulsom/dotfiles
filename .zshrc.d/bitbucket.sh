#!/bin/zsh
alias bbcurl="curl -H \"X-Auth-Token: $BB_TOKEN\" -H \"X-Auth-User: $BB_USER\""
function bb() {
  if [ "$1" = "refresh" ]; then
    mkdir -p ~/.bb
    bbcurl -s "$BB_HOME/projects?limit=1000" | jq -r '.values[]  | .key'
  elif [ "$1" = "tree" ]; then
    tree -L 2 ~/src/bb
  else
    local PROJECT=$1
    local REPO=$2
    if [ "$1" = "" ]; then
      echo "Need PROJECT."
    elif [ "$2" = "" ]; then
      echo "Need REPO."
    else
      if [ -d ~/src/bb/$PROJECT/$REPO ]; then
        cd ~/src/bb/$PROJECT/$REPO
      else
        mkdir -p ~/src/bb/$PROJECT
        cd ~/src/bb/$PROJECT
        git clone $BB_SSH/$PROJECT/$REPO.git
        cd ~/src/bb/$PROJECT/$REPO
      fi
    fi
  fi
}

function _bb() {
  case $CURRENT in
    2)
      cache validate 10080 bb_projects || bb refresh > $(cache getfile bb_projects)
      # local -a commands projects
      # commands=('refresh:refresh list of projects' 'tree:print tree of cloned projects')
      # projects=($(cat ~/.bb/projects.json| jq '.values[]  | .key + ":" + .description' | sed -e "s/'/\\'/g" | sed -e "s/\"/'/g"))
      # echo $projects
      # _describe commands -- projects
      compadd -- $(cat $(cache getfile bb_projects)) tree
      ;;
    3) compadd -- $(bbcurl -s "$BB_HOME/projects/$words[2]/repos?limit=1000" | jq -r ".values[].slug") ;;
  esac
}

compdef _bb bb
