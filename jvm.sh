#!/bin/bash

listJavaHomes() {
  echo "Choose from:" >&2
  find /Library/Java -name "Home" -type d | grep -i java
  find /System/Library/Java/JavaVirtualMachines -name "Home" -type d | grep -i java
}

echo "Before: JAVA_HOME=${JAVA_HOME}" >&2
if [ "$1" = "" ]; then
  listJavaHomes
elif [ "$1" = "-u" ]; then
  unset JAVA_HOME
else
  export JAVA_HOME=$1
fi
echo "After : JAVA_HOME=${JAVA_HOME}" >&2