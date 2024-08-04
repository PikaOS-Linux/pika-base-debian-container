#! /bin/bash
./get_depend_tree.py "$1" | sed 's/\,/\n/g' | sed 's/\ /\n/g' | sed '/^$/d'
