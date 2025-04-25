#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

#PS1='\[\033[01;37m\]\t \[\033[01;32m\]\u\[\033[00m\]@\[\033[01;36m\]\h\[\033[00m\] \[\033[01;33m\]\W\[\033[00m\]$\[\033[00m\] '
PS1='\[\033[01;32m\]\u\[\033[00m\]@\[\033[01;36m\]\h\[\033[00m\] \[\033[01;33m\]\W\[\033[00m\]$\[\033[00m\] '


alias la='lsd -Al1 --color=auto'
alias lt='lsd -Al1 --color=auto --tree --depth=2'

alias please='sudo'

export EDITOR='nvim'

if [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

eval "$(fzf --bash)"
FZF_ALT_C_COMMAND=""

eval "$(navi widget bash)"

lfcd() {
	local tempfile="$(mktemp)"
	lf -last-dir-path="$tempfile" "$@"
	if [ -f "$tempfile" ] && [ -d "$(cat "$tempfile")" ]; then
		cd "$(cat "$tempfile")" || return
	fi
	rm -f "$tempfile"
}


