#!/usr/bin/env bash
function _cache() {
  case $CURRENT in
    2)  compadd -- validate clear getfile tree ;;
    3)  case $words[2] in
    	  getfile|validate) compadd -- $(find ~/.dotcache -type f| cut -d "/" -f 5- | grep -v "^$") ;;
    	  clear) 			compadd -- $(find ~/.dotcache | cut -d "/" -f 5- | grep -v "^$") ;;
    	  validate)         compadd -- 60 1440 10080 ;;
    	esac
    	;;
    4)  if [ "$words[2]" = "validate" ]; then
    		compadd -- $(find ~/.dotcache -type f| cut -d "/" -f 5- | grep -v "^$")
    	fi
    	;;
  esac
}

compdef _cache cache
