now=$(date +"%r")
echo -e "\x1B[1;31mHello, Patrick"
echo -e "\x1B[1;31mThe current time is: $now"
echo -e "\x1B[1;36mQuote of the day:"
#!/bin/mksh
# ~/.profile
fortune

# Colors
RED='\[\e[91m\]'
BOLDYELLOW='\[\e[1;33m\]'
GREEN='\[\e[0;32m\]'
BLUE='\[\e[1;34m\]'
DARKBROWN='\[\e[1;33m\]'
DARKGRAY='\[\e[1;30m\]'
CUSTOMCOLORMIX='\[\e[1;30m\]'
DARKCUSTOMCOLORMIX='\[\e[1;32m\]'
LIGHTBLUE='\[\033[1;36m\]'
PURPLE='\[\e[1;35m\]'
NC='\[\e[0m\]' # No Color

# Shows the git branch if the directory is part of a GitHub repo
parse_git_branch()
{
 	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# Git commit shortened
git_quick_commit()
{
	git add -A
	if [ $# -eq 0 ]; then
    	git commit -m "Pushing Quick Commit";
	else
    	git commit -m "$*";
	fi
	git push;
}

# Opens a file in XCode
open_in_xcode()
{
	touch "$@"
	open -a Xcode "$@"
}

# SSH aliases
alias robosub='ssh robosub@acsweb.ucsd.edu'

export -f parse_git_branch
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
alias ls='ls -GFh'
alias hs='history | grep '  # Automatically filter your bash history
alias la='ls -a'  # E-Z-P-Z see everything
alias mv='mv -i'  # Prompts before overwriting
alias cp='cp -i'  
alias rm='rm -i'
alias dog='cat'
alias gitc='git_quick_commit' 
alias snow='bash ~/snow'
alias xcode='open_in_xcode'
alias cd..='cd ../'
alias ..='cd ../'
alias ...='cd ../../'
alias .2='cd ../../'
alias .3='cd ../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../../'
alias .6='cd ../../../../../../'

# Defines the command line appearance
export PS1="${BLUE}\\u ${BOLDYELLOW}[\\w] ${PURPLE}\$(parse_git_branch)${DARKCUSTOMCOLORMIX}$ ${NC}"

# Setting PATH for Python 3.6
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
export PATH

# MacPorts Installer addition on 2019-01-28_at_14:09:44: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

