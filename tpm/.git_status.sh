#!/bin/bash

if [ -z "$1" ]; then
  printf " "
else
  printf " #[fg=colour8]| #[fg=cyan]$1 "
fi
