#! /bin/bash
apt showsrc "$1" | grep -E "^Binary:" | cut -d":" -f2- | sed 's/\,/\n/g' | sed 's/\ /\n/g' | sed '/^$/d'
