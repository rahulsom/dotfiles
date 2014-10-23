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
  find /Library/Java -name "Home" -type d | grep -i java
  find /System/Library/Java/JavaVirtualMachines -name "Home" -type d | grep -i java
}

findJava() {
  listJavaHomes | while read -r i; do toJava "$i"; done | grep $1 | tr -s " " | cut -d " " -f 3
}


if [ "$1" = "" ]; then
  echo "Choose from:" >&2
  echo ""
  listJavaHomes | while read -r i; do toJava "$i"; done | sort -k 1 -n
  echo ""
  echo "${BACKGROUND_BLUE}${TEXT_WHITE}!JAVA_HOME=${JAVA_HOME}${RESET_FORMATTING}" >&2
elif [ "$1" = "-u" ]; then
  echo "${BACKGROUND_RED}${TEXT_WHITE}-JAVA_HOME=${JAVA_HOME}${RESET_FORMATTING}" >&2
  unset JAVA_HOME
  echo "${BACKGROUND_GREEN}${TEXT_WHITE}+JAVA_HOME=${JAVA_HOME}${RESET_FORMATTING}" >&2
else
  echo "${BACKGROUND_RED}${TEXT_WHITE}-JAVA_HOME=${JAVA_HOME}${RESET_FORMATTING}" >&2
  export JAVA_HOME=$(findJava $1)
  echo "${BACKGROUND_GREEN}${TEXT_WHITE}+JAVA_HOME=${JAVA_HOME}${RESET_FORMATTING}" >&2
fi
