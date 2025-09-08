# Fastfetch au démarrage
if [[ -o interactive ]]; then
  if [[ -z "$FASTFETCH_SHOWN" ]]; then
    export FASTFETCH_SHOWN=1
    fastfetch
  fi
fi

# Aliases minimalistes
alias ls='ls --color=auto --group-directories-first'
alias ll='ls -lh'
alias la='ls -lah'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias g='git'
alias v='nvim'
alias c='clear'
alias reload='source ~/.zshrc'
alias nemo='GTK_THEME=Tokyonight-Dark nemo'

eval "$(starship init zsh)"
alias theme='wal -i'
(cat ~/.cache/wal/sequences &)
alias theme='wal -i'
(cat ~/.cache/wal/sequences &)

# Created by `pipx` on 2025-08-02 20:52:06
export PATH="$PATH:/home/tco/.local/bin"
export LANG=fr_FR.UTF-8
export LC_ALL=fr_FR.UTF-8
export COLORTERM=truecolor
eval "$(dircolors -b 2>/dev/null || true)"

unset LS_COLORS
eval "$(dircolors -b 2>/dev/null || true)"
