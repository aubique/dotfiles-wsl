#!/usr/bin/env bash

if [[ ! -v INSIDE_GENIE ]]; then
  exec /usr/bin/genie -s
fi

# TMUX
if [[ -z "$TMUX" ]]; then
  if tmux has-session 2>/dev/null; then
    exec tmux attach
  else
    bash -l -c "tmux new-session -c MAIN"
  fi
fi

#if [[ -z "$TMUX" ]]; then
#  tmux new-window -n "DIR $(basename $PWD)" -t TMUX
#  nbTerm=$(tmux list-clients | grep TMUX | wc -l)
#  if [[ $nbTerm -eq 0 ]]; then
#    tmux attach -t TMUX || tmux new-session -s TMUX
#  #else
#  #  exit 0;
#  fi
#fi

