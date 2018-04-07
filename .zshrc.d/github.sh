#!/bin/zsh
alias ghcurl="curl -H \"Authorization: Bearer $GH_TOKEN\""
function gh() {

  if [ "$1" = "compute" ]; then
    local count=1
    local page=1
    while (( count > 0 )); do
      ghcurl -s "https://api.github.com/user/repos?per_page=100&page=$page" \
          | jq -r ".[].full_name" > /tmp/gh.txt
      count=$(wc -l /tmp/gh.txt | tr -s " " | cut -d " " -f 2)
      cat /tmp/gh.txt
      rm /tmp/gh.txt
      ((page+=1))
    done
  elif [ "$1" = "tree" ]; then
    tree -L 2 ~/src/gh
  else
    local REPO=$1
    if [ "$1" = "" ]; then
      echo "Need REPO."
    else
      if [ -d ~/src/gh/$REPO ]; then
        cd ~/src/gh/$REPO
      else
        local repoDir=$(dirname $REPO)
        mkdir -p ~/src/gh/$repoDir
        cd ~/src/gh/$repoDir
        hub clone $REPO
        cd ~/src/gh/$REPO
      fi
    fi
  fi
}

function _gh() {
  case $CURRENT in
    2)
      cache validate 10080 gh_repos || gh compute > $(cache getfile gh_repos)
      compadd -- $(cat $(cache getfile gh_repos)) ;;
  esac
}

compdef _gh gh
