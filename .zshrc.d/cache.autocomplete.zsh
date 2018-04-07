#!/usr/bin/env bash
function _cache() {
  case $CURRENT in
    2)  compadd -- validate clear getfile ;;
    3)  if [ "$words[2]" = "getfile" ]; then
    		compadd -- $(find ~/.dotcache | cut -d "/" -f 5- | grep -v "^$")
    	fi
    	if [ "$words[2]" = "validate" ]; then
    		compadd -- 60 1440 10080
    	fi
    	;;
    4)  if [ "$words[2]" = "validate" ]; then
    		compadd -- $(find ~/.dotcache | cut -d "/" -f 5- | grep -v "^$")
    	fi
    	;;
  esac
}
compdef _cache cache
