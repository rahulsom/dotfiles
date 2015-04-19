#!/bin/bash -e

# set -x
# trap read debug

function evalCurrVersion() {
  PLUGIN_FILE=$(ls -1 *GrailsPlugin.groovy)
  VERSION_LINE=$(cat $PLUGIN_FILE| sed -e "s/\/\/.*//"| sed -e "s/^ *$//g" | grep -v "^$" | grep "def *version")
  CURR_VER=$(echo $VERSION_LINE | sed -e "s/def *version *=//g" | sed -e "s/'//g" | sed -e 's/"//g' | sed -e "s/ *//g")
}

function changeVersion() {
  NEW_VER=$1
  evalCurrVersion
  REL_VER_LINE=$(echo "$VERSION_LINE" | sed -e "s/$CURR_VER/$NEW_VER/g")
  cat $PLUGIN_FILE > /tmp/oldfile
  cat /tmp/oldfile | sed -e "s/$VERSION_LINE/$REL_VER_LINE/g" > $PLUGIN_FILE
}

function askUserForDevVersion() {
  LAST_DIGIT=$(echo $RELEASE_VER | sed -e "s/.*\.//g")
  NEW_LAST_DIGIT=$(echo $LAST_DIGIT + 1 | bc)
  NEW_VERSION=$(echo $RELEASE_VER | sed -e "s/$LAST_DIGIT$/$NEW_LAST_DIGIT/g")
  echo "What's the next version in develop? [${NEW_VERSION}-SNAPSHOT]: "
  NEW_VERSION_USER=$(read)
  if [ "$NEW_VERSION_USER" = "" ]; then
    NEW_VERSION_USER=${NEW_VERSION}-SNAPSHOT
  fi
}

evalCurrVersion
if [ $(echo "$CURR_VER" | grep '\-SNAPSHOT' -c) = 0 ]; then
  echo "Cannot release a non snapshot version"
  exit 1
fi

echo "Release begins"
RELEASE_VER=$(echo "$CURR_VER" | sed -e 's/-SNAPSHOT//g')
git flow release start $RELEASE_VER

changeVersion $RELEASE_VER
git add .; git commit -m "Updating version for release $RELEASE_VER"
git flow release finish $RELEASE_VER

askUserForDevVersion

changeVersion $NEW_VERSION_USER
git add .; git commit -m "Setting next development version"

git push --tags
git push --all
