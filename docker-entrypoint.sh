#!/bin/sh
set -e
LINDA_DATA=/home/linda/.linda
cd /home/linda/lindad

if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for Lindad"

  set -- Lindad "$@"
fi

if [ $(echo "$1" | cut -c1) = "-" ] || [ "$1" = "Lindad" ]; then
  mkdir -p "$LINDA_DATA"
  chmod 700 "$LINDA_DATA"
  chown -R linda "$LINDA_DATA"

  echo "$0: setting data directory to $LINDA_DATA"

  set -- "$@" -datadir="$LINDA_DATA"
fi

if [ "$1" = "Lindad" ] || [ "$1" = "linda-cli" ] || [ "$1" = "linda-tx" ]; then
  echo
  exec gosu linda "$@"
fi

echo
exec "$@"
