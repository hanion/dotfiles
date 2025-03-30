#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

#PS1='\[\033[01;37m\]\t \[\033[01;32m\]\u\[\033[00m\]@\[\033[01;36m\]\h\[\033[00m\] \[\033[01;33m\]\W\[\033[00m\]$\[\033[00m\] '
PS1='\[\033[01;32m\]\u\[\033[00m\]@\[\033[01;36m\]\h\[\033[00m\] \[\033[01;33m\]\W\[\033[00m\]$\[\033[00m\] '


alias la='lsd -AlF1 --color=auto'
alias lt='lsd -AlF1 --color=auto --tree --depth=2'
alias ll='ranger'

alias vim=/usr/bin/nvim
alias rm='trash-put'

alias please='sudo'

export EDITOR='nvim'


if [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

eval "$(fzf --bash)"
FZF_ALT_C_COMMAND=""

eval "$(navi widget bash)"

ranger_cd() {
	local tempfile="$(mktemp)"
	ranger --choosedir="$tempfile" "$@"
	if [ -f "$tempfile" ]; then
		cd "$(cat "$tempfile")" || return
	fi
	rm -f "$tempfile"
}
alias r='ranger_cd'


alias note='ranger ~/note'

# note grep name
noteg() {
	local file
	file=$(grep -rIl --exclude={import.sh,center.sh} --exclude-dir={.obsidian,journal} . ~/note | 
		fzf --preview "bat --style=numbers --color=always --line-range=:100 {}") || return

	[[ -n "$file" ]] && nvim "$file"
}

# note fzf content
notef() {
	local selection file line
	selection=$(grep -rnI --exclude={import.sh,center.sh} --exclude-dir={.obsidian,journal} . ~/note | 
		fzf --delimiter : --nth=2.. --preview 'bat --style=numbers --color=always --highlight-line {2} {1}') || return

	file=$(cut -d: -f1 <<< "$selection")
	line=$(cut -d: -f2 <<< "$selection")

	[[ -n "$file" ]] && [[ -n "$line" ]] && nvim +"$line" "$file"
}


