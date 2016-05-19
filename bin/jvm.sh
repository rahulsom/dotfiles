#!/bin/bash
toJava() {
  JDKDIR=$(basename $(dirname $(dirname $1)))
  JDKVER=$(echo $JDKDIR| sed -e "s/[A-Za-z]//g" | sed -e "s/^1.//g" | sed -e "s/\.$//g")
  if [ $(echo $JDKVER | grep -c _) = 0 ]; then
    JDKVER=${JDKVER}_0
  fi
  JDKVER=$(echo $JDKVER | sed -e "s/\.0_/u/g")
  printf "%10s   %s\n" "$JDKVER" "$1"
}

listJavaHomes() {
  find /Library/Java -name "Home" -type d 2>/dev/null| grep -i java
  find /System/Library/Java/JavaVirtualMachines -name "Home" -type d 2>/dev/null| grep -i java
}

installJava() {
  VER=$1
  JDKFILE="jdk-$VER-macosx-x64.dmg"
  echo "Downloading $JDKFILE..." >&2
  curl --insecure --junk-session-cookies --location --remote-name --progress-bar --output "~/Downloads/$JDKFILE"  \
       --header "Cookie: oraclelicense=accept-securebackup-cookie" \
       "http://download.oracle.com/otn-pub/java/jdk/$VER-b14/$JDKFILE"
  MOUNTDIR=$(echo `hdiutil mount ~/Downloads/"$JDKFILE" | tail -1 | awk '{$1=$2=""; print $0}'` | xargs -0 echo)
  sudo installer -pkg "$MOUNTDIR/"*.pkg -target /
  hdiutil unmount "$MOUNTDIR"
}

findJava() {
  listJavaHomes | while read -r JAVALINE; do toJava "$JAVALINE"; done | grep $1 | head -1 | tr -s " " | cut -d " " -f 3
}

validateJava() {
  if [ "$JAVA_HOME" = "" ]; then
    return 1
  fi
}

if [ "$1" = "" ]; then
  if [ $(basename $SHELL) = "zsh" ]; then
    if [ $ZSH_SUBSHELL -gt 1 ]; then
      HIDE_COMMENTS=1
    fi
  fi
  test $HIDE_COMMENTS || echo "Choose from:" >&2
  test $HIDE_COMMENTS || echo "" >&2
  listJavaHomes | while read -r JAVALINE; do toJava "$JAVALINE"; done | sort -k 1 -n
  test $HIDE_COMMENTS || echo "" >&2
  test $HIDE_COMMENTS || echo "${BACKGROUND_BLUE}${TEXT_WHITE}JAVA_HOME=${JAVA_HOME}${RESET_FORMATTING}" >&2
  unset HIDE_COMMENTS
elif [ "$1" = "install" ]; then
  [[ $2 =~ ^[5-9]u[0-9][0-9]$ ]] && installJava "$2" || echo "Please use right version format (e.g. 8u66)" >&2
elif [ "$1" = "-u" ]; then
  echo "${BACKGROUND_RED}${TEXT_WHITE}-JAVA_HOME=${JAVA_HOME}${RESET_FORMATTING}" >&2
  unset JAVA_HOME
  echo "${BACKGROUND_GREEN}${TEXT_WHITE}+JAVA_HOME=${JAVA_HOME}${RESET_FORMATTING}" >&2
else
  echo "${BACKGROUND_RED}${TEXT_WHITE}-JAVA_HOME=${JAVA_HOME}${RESET_FORMATTING}" >&2
  export JAVA_HOME=$(findJava $1)
  echo "${BACKGROUND_GREEN}${TEXT_WHITE}+JAVA_HOME=${JAVA_HOME}${RESET_FORMATTING}" >&2
  validateJava
fi
