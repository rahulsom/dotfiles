#!/bin/bash
jvmUpdateCache() {
  if [ "$1" = "silent" ]; then
    CHANGE_TIME=$(find ~/.jvm-cache -mmin +1440 | wc -l)
    if [ $CHANGE_TIME = 1 ]; then
      if [ ! -f ~/.jvm-cache.old ]; then
        cp ~/.jvm-cache ~/.jvm-cache.old
      fi
      curl -fjs -m 90 -A "jvm.sh/0.1" \
          "https://javaversionmanager.appspot.com/builds?tags=$TAGS" > ~/.jvm-cache &
    fi
  else
    curl -j -m 90 -A "jvm.sh/0.1" --progress-bar \
        "https://javaversionmanager.appspot.com/builds?tags=$TAGS" > ~/.jvm-cache
  fi
}

jvmListAvailable() {
  cat ~/.jvm-cache | cut -d $'\t' -f 1 | column -x
}

jvmHelp() {
  echo "jvm"
  echo "   h       - Help"
  echo "   ls      - List installed versions"
  echo "   ls -a   - List available versions"
  echo "   update  - Update list of candidates"
  echo "   u <ver> - Use version"
  echo "   u       - Unset version"
  echo "   i <ver> - Install version"
  echo ""
}

jvmBefore() {
  echo "${BACKGROUND_RED}${TEXT_WHITE}-JAVA_HOME=${JAVA_HOME}${RESET_FORMATTING}" >&2
}
jvmAfter() {
  echo "${BACKGROUND_GREEN}${TEXT_WHITE}+JAVA_HOME=${JAVA_HOME}${RESET_FORMATTING}" >&2
}
jvmUnchanged() {
  echo "${BACKGROUND_BLUE}${TEXT_WHITE}JAVA_HOME=${JAVA_HOME}${RESET_FORMATTING}" >&2
}
jvmNotifyUpdates() {
  if [ -f ~/.jvm-cache.old ]; then
    /usr/bin/diff ~/.jvm-cache.old ~/.jvm-cache > /dev/null
    if [ $? != 0 ]; then
      echo "There is a change in the available versions of java. Run 'jvm ls -a' to see available versions"
      rm ~/.jvm-cache.old
    fi
  fi
}

macosToJava() {
  JDKDIR=$(basename $(dirname $(dirname $1)))
  JDKVER=$(echo $JDKDIR| sed -e "s/[A-Za-z]//g" | sed -e "s/^1.//g" | sed -e "s/\.$//g")
  if [ $(echo $JDKVER | grep -c _) = 0 ]; then
    JDKVER=${JDKVER}_0
  fi
  JDKVER=$(echo $JDKVER | sed -e "s/\.0_/u/g")
  printf "%10s   %s\n" "$JDKVER" "$1"
}

macosListLocal() {
  find /Library/Java                            -name "Home" -type d 2>/dev/null| grep -i java
  find /System/Library/Java/JavaVirtualMachines -name "Home" -type d 2>/dev/null| grep -i java
}

macosInstallJava() {
  VER=$1

  URL=$(cat ~/.jvm-cache | grep ^$VER | cut -d $'\t' -f 4 | sed -e 's/otn/otn-pub/g' | sed -e 's/otn-pub-pub/otn-pub/g')
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
  macosListLocal | while read -r JAVALINE; do macosToJava "$JAVALINE"; done | grep $1 | head -1 | tr -s " " | cut -d " " -f 3
}


TAGS="macos,jdk,x64,dmg"

COMMAND=$1
if [ "$COMMAND" = "" ]; then
  COMMAND=h
fi
case "$COMMAND" in
  h)
    jvmHelp
    jvmUnchanged
    jvmNotifyUpdates
    ;;
  updateSilent)
    jvmUpdateCache silent
    ;;
  update)
    jvmUpdateCache
    echo ""
    jvmListAvailable
    echo ""
    jvmUnchanged
    jvmNotifyUpdates
    ;;
  ls)
    if [ "$2" = "-a" ]; then
      jvmListAvailable
    else
      macosListLocal | while read -r JAVALINE; do macosToJava "$JAVALINE"; done | sort -k 1 -n
    fi
    echo ""
    jvmUnchanged
    jvmNotifyUpdates
    jvmUpdateCache silent
    ;;
  i)
    macosInstallJava $2
    jvmNotifyUpdates
    jvmUpdateCache silent
    ;;
  u)
    jvmBefore
    if [ "$2" = "" ]; then
        unset JAVA_HOME
    else
        export JAVA_HOME=$(findJava $2)
    fi
    jvmAfter
    jvmNotifyUpdates
    jvmUpdateCache silent
    ;;
  *)
    echo "Unknown command '$COMMAND'"
    jvmHelp
    jvmUnchanged
    jvmNotifyUpdates
    jvmUpdateCache silent
    ;;
esac
