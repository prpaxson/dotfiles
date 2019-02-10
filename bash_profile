now=$(date +"%r")
echo -e "\x1B[1;31mHello, Patrick"
echo -e "\x1B[1;31mThe current time is: $now"
echo -e "\x1B[1;36mQuote of the day:"
#!/bin/mksh
# ~/.profile
fortune

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

export PS1="${BLUE}\\u ${BOLDYELLOW}[\\w] ${PURPLE}\$(parse_git_branch)${DARKCUSTOMCOLORMIX}$ ${NC}"

parse_git_branch()
{
 git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

OpenInXcode()
{
	touch "$@"
	open -a Xcode "$@"
}

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
alias gitc='sh ~/.gitc/main.sh'
alias snow='bash ~/snow'
alias xcode='OpenInXcode'
ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/sublime
alias cd..='cd ../'
alias ..='cd ../'
alias ...='cd ../../'
alias .2='cd ../../'
alias .3='cd ../../../'
alias .4='cd ../../../../'k
alias .5='cd ../../../../../'
alias .6='cd ../../../../../../'

# Setting PATH for Python 3.6
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
export PATH

##
# Your previous /Users/prpaxson/.bash_profile file was backed up as /Users/prpaxson/.bash_profile.macports-saved_2019-01-28_at_14:09:44
##

# MacPorts Installer addition on 2019-01-28_at_14:09:44: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

