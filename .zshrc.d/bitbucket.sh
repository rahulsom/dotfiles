#!/bin/zsh
function bb() {
  if [ "$1" = "refresh" ]; then
    mkdir -p ~/.bb
    curl -H "X-Auth-Token: $BB_TOKEN" \
        -H "X-Auth-User: $BB_USER" \
        -s "$BB_HOME/projects?limit=1000" > ~/.bb/projects.json
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
      if [ ! -e ~/.bb/projects.json ]; then
        bb refresh
      fi
      if test $(find "~/.bb/projects.json" -mmin +5); then
        bb refresh
      fi
      # local -a commands projects
      # commands=('refresh:refresh list of projects' 'tree:print tree of cloned projects')
      # projects=($(cat ~/.bb/projects.json| jq '.values[]  | .key + ":" + .description' | sed -e "s/'/\\'/g" | sed -e "s/\"/'/g"))
      # echo $projects
      # _describe commands -- projects
      compadd -- $(cat ~/.bb/projects.json| jq -r '.values[]  | .key') refresh tree
      ;;
    3) compadd -- $(curl -H "X-Auth-Token: $BB_TOKEN" \
          -H "X-Auth-User: $BB_USER" \
          -s "$BB_HOME/projects/$words[2]/repos?limit=1000" | jq -r ".values[].slug") ;;
  esac
}

compdef _bb bb
