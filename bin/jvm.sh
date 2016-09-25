#!/bin/bash
java_update() {
    TAGS="macos,jdk,x64,dmg"
    curl "https://javaversionmanager.appspot.com/versions?tags=$TAGS" > ~/.jvm-cache
}

java_ls_all() {
    cat ~/.jvm-cache | cut -d $'\t' -f 1 | column -x
}

toJava() {
  JDKDIR=$(basename $(dirname $(dirname $1)))
  JDKVER=$(echo $JDKDIR| sed -e "s/[A-Za-z]//g" | sed -e "s/^1.//g" | sed -e "s/\.$//g")
  if [ $(echo $JDKVER | grep -c _) = 0 ]; then
    JDKVER=${JDKVER}_0
  fi
  JDKVER=$(echo $JDKVER | sed -e "s/\.0_/u/g")
  printf "%10s   %s\n" "$JDKVER" "$1"
}

java_ls() {
  find /Library/Java -name "Home" -type d 2>/dev/null| grep -i java
  find /System/Library/Java/JavaVirtualMachines -name "Home" -type d 2>/dev/null| grep -i java
}

installJava() {
  VER=$1
  if [ "$VER" = "" ]; then

  fi
  URL=$(cat ~/.jvm-cache | grep ^$VER | cut -d $'\t' -f 4 | sed -e 's/otn/otn-pub/g')
  echo "Will download from $URL"
  JDKFILE=$(basename $URL)
  echo "Will download to $HOME/Downloads/$JDKFILE"

  curl --junk-session-cookies --progress-bar \
        -L -b "oraclelicense=a" "$URL" -o "$HOME/Downloads/$JDKFILE"

  MOUNTDIR=$(echo $(hdiutil mount ~/Downloads/"$JDKFILE" | tail -1 | awk '{$1=$2=""; print $0}') | xargs -0 echo)
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

help() {
    echo "jvm"
    echo "   h       - Help"
    echo "   ls      - List installed versions"
    echo "   ls -a   - List available versions"
    echo "   update  - Update list of candidates"
    echo "   u <ver> - Use version"
    echo "   u       - Unset version"
    echo "   i <ver> - Install version"
}

java_before() {
    echo "${BACKGROUND_RED}${TEXT_WHITE}-JAVA_HOME=${JAVA_HOME}${RESET_FORMATTING}" >&2
}
java_after() {
    echo "${BACKGROUND_GREEN}${TEXT_WHITE}+JAVA_HOME=${JAVA_HOME}${RESET_FORMATTING}" >&2
}
java_unchanged() {
    echo "${BACKGROUND_BLUE}${TEXT_WHITE}JAVA_HOME=${JAVA_HOME}${RESET_FORMATTING}" >&2
}

COMMAND=$1
if [ "$COMMAND" = "" ]; then
    COMMAND=h
fi
case "$COMMAND" in
    h)
        help
        java_unchanged
        ;;
    update)
        java_update
        java_ls
        java_unchanged
        ;;
    ls)
        if [ "$2" = "-a" ]; then
            java_ls_all
        else
            java_ls | while read -r JAVALINE; do toJava "$JAVALINE"; done | sort -k 1 -n
        fi
        echo ""
        java_unchanged
        ;;
    i)
        installJava $2
        ;;
    u)
        java_before
        if [ "$2" = "" ]; then
            unset JAVA_HOME
        else
            export JAVA_HOME=$(findJava $2)
        fi
        java_after
        ;;
esac
