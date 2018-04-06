#!/bin/zsh
function gh() {

  if [ "$1" = "refresh" ]; then
    echo "Refreshing..."
    local count=1
    local page=1
    echo -n "" > ~/.gh_repos
    echo "refresh" >> ~/.gh_repos
    echo "tree" >> ~/.gh_repos
    while (( count > 0 )); do
      echo -n "\r$(wc -l ~/.gh_repos | tr -s " " | cut -d " " -f 2) Repos and counting...                    "
      curl -s "https://api.github.com/user/repos?per_page=100&page=$page" \
          -H "Authorization: Bearer $GH_TOKEN" | jq -r ".[].full_name" > /tmp/gh.txt
      count=$(wc -l /tmp/gh.txt | tr -s " " | cut -d " " -f 2)
      cat /tmp/gh.txt >> ~/.gh_repos
      rm /tmp/gh.txt
      ((page+=1))
    done
    echo "\r$(wc -l ~/.gh_repos | tr -s " " | cut -d " " -f 2) Repos indexed.                    "
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
      test -e ~/.gh_repos || gh refresh
      test $(find "~/.gh_repos" -mmin +5 2>/dev/null) && gh refresh
      compadd -- $(cat ~/.gh_repos) ;;
  esac
}

compdef _gh gh
