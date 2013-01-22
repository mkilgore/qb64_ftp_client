#!/bin/sh
for i in "$@"
do
  if ! grep -q Copyright $i
  then
    cat /mnt/data/git/qb64_ftp_client/license.txt $i >$i.new && mv $i.new $i
  fi
done

