#!/bin/zsh
alias ghcurl="curl -H \"Authorization: Bearer $GH_TOKEN\""

function gh_getdata() {
	local URL=$1
	local JSONPATH=$2

    local count=1
    local page=1
    while (( count > 0 )); do
      ghcurl -s "$URL?per_page=100&page=$page" | jq -r "$JSONPATH" > /tmp/gh.txt
      count=$(wc -l /tmp/gh.txt | tr -s " " | cut -d " " -f 2)
      cat /tmp/gh.txt
      rm /tmp/gh.txt
      ((page+=1))
    done
}

function gh() {
  if [ "$1" = "compute" ]; then
    if [ "$2" = "-m" ];  then
  	  gh_getdata "https://api.github.com/user/repos" ".[].full_name"
  	elif [ "$2" = "-u" ]; then
  	  gh_getdata "https://api.github.com/users/$3/repos" ".[].name"
  	elif [ "$2" = "-o" ]; then
  	  gh_getdata "https://api.github.com/orgs/$3/repos" ".[].name"
  	fi
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
	  local -a subcmds=('-m:my repos' '-u:user' '-o:organization')
	  _describe 'gh' subcmds
      ;;
    3)
      case ${words[2]} in
        -m)
		  cache validate 10080 gh_repos || gh compute -m ${words[3]}> $(cache getfile gh_repos)
      	  compadd -- $(cat $(cache getfile gh_repos))
        ;;
      	-u|-o)
      	  compadd -- $(ls -1 ~/src/gh)
      esac
      ;;
    4)
      case ${words[2]} in
      	-u|-o)
      	  cache validate 10080 gh/${words[3]} || gh compute ${words[2]} ${words[3]} ${words[4]} > $(cache getfile gh/${words[3]})
      	  compadd -- $(cat $(cache getfile gh/${words[3]}))
      	;;
      esac
  esac
}

compdef _gh gh
