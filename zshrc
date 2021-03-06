# Determine OS
unameResult=$(uname -s)
case "${unameResult}" in
    Linux*) OS=Linux;;
    Darwin*) OS=Mac;;
    *) OS="UNKNOWN:${unameResult}"
esac
export OS

# Determine light or dark terminal
if [[ $OS == "Mac" ]]; then
    termname=$(osascript -e "tell first window of application \"iTerm2\" to return name of current settings as string" 2>/dev/null)
    if [[ $termname == "Solarized Light" ]]; then
        export BACKGROUND=light
    else
        export BACKGROUND=dark
    fi
    unset termname
elif [[ $OS == "Linux" ]]; then
    #TODO
    export BACKGROUND=dark
else
    export BACKGROUND=dark
fi

# Select modules to load
zstyle ':prezto:module:syntax-highlighting' color 'yes'

if [[ $OS == "Mac" ]]; then
    zstyle ':prezto:load' pmodule \
        'environment' \
        'utility' \
        'editor' \
        'directory' \
        'history' \
        'completion' \
        'git' \
        'macports' \
        'archive' \
        'syntax-highlighting' \
        'history-substring-search' \
        'autosuggestions'
elif [[ $OS == "Linux" ]]; then
    zstyle ':prezto:load' pmodule \
        'environment' \
        'utility' \
        'editor' \
        'directory' \
        'history' \
        'completion' \
        'git' \
        'archive' \
        'syntax-highlighting' \
        'history-substring-search' \
        'autosuggestions' \
        'pacman'
    zstyle ':prezto:module:pacman' frontend 'yay'
else
    zstyle ':prezto:load' pmodule \
        'environment' \
        'utility' \
        'editor' \
        'directory' \
        'history' \
        'completion' \
        'git' \
        'archive' \
        'syntax-highlighting' \
        'history-substring-search' \
        'autosuggestions'
fi

zstyle ':prezto:module:autosuggestions:color' found ''

# Vi key bindings
zstyle ':prezto:module:editor' key-bindings 'vi'
bindkey -M vicmd '/' history-incremental-search-backward

# Syntax highlighting colors and styles
if [[ $BACKGROUND == "light" ]]; then
    zstyle ':prezto:module:syntax-highlighting' styles \
        'unknown-token' 'fg=red' \
        'reserved-word' 'fg=red,bold' \
        'alias' 'fg=green' \
        'builtin' 'fg=green' \
        'function' 'fg=green' \
        'command' 'fg=green' \
        'precommand' 'fg=magenta' \
        'commandseparator' 'fg=magenta,bold' \
        'hashed-command' 'fg=red' \
        'path' 'fg=cyan' \
        'path-prefix' 'fg=cyan' \
        'globbing' 'fg=magenta' \
        'history-expansion' 'none' \
        'single-hyphen-option' 'none' \
        'double-hyphen-option' 'none' \
        'back-quoted-argument' 'none' \
        'single-quoted-argument' 'fg=cyan' \
        'double-quoted-argument' 'fg=cyan' \
        'dollar-quoted-argument' 'fg=cyan' \
        'back-double-quoted-argument' 'fg=cyan' \
        'back-dollar-quoted-argument' 'fg=cyan' \
        'assign' 'none' \
        'redirection' 'fg=magenta,bold' \
        'default' 'none'
else
    zstyle ':prezto:module:syntax-highlighting' styles \
        'unknown-token' 'fg=red' \
        'reserved-word' 'fg=red,bold' \
        'alias' 'fg=green' \
        'builtin' 'fg=green' \
        'function' 'fg=green' \
        'command' 'fg=green' \
        'precommand' 'fg=yellow' \
        'commandseparator' 'fg=magenta,bold' \
        'hashed-command' 'fg=red' \
        'path' 'fg=blue' \
        'path-prefix' 'fg=blue' \
        'globbing' 'fg=magenta' \
        'history-expansion' 'none' \
        'single-hyphen-option' 'none' \
        'double-hyphen-option' 'none' \
        'back-quoted-argument' 'none' \
        'single-quoted-argument' 'fg=cyan' \
        'double-quoted-argument' 'fg=cyan' \
        'dollar-quoted-argument' 'fg=cyan' \
        'back-double-quoted-argument' 'fg=cyan' \
        'back-dollar-quoted-argument' 'fg=cyan' \
        'assign' 'none' \
        'redirection' 'fg=magenta,bold' \
        'default' 'none'
fi

# Load Prezto modules
[ -f "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ] && source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"

# Load FZF modules
if [[ $OS == "Mac" ]]; then
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
elif [[ $OS == "Linux" ]]; then
    [ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
    [ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh
fi

# Set environment variables
export CC=clang
export CXX=clang++
export EDITOR=vim
export EDITOR_OPTS="-p"
export LANG=en_US.UTF-8
export KEYTIMEOUT=1
export FZF_DEFAULT_OPTS="-m --reverse"
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=white'
export PATH="$HOME/.local/bin:$PATH"

# Setting PATH for Python 3.6
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
export PATH

# MacPorts Installer addition adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

# Use ag for FZF
if which ag > /dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='ag -g ""'
    export FZF_CTRL_T_COMMAND='ag -g ""'
    export FZF_EDITOR_COMMAND='ag --follow -g ""'
fi
# Use rg for FZF (preferred over ag)
if which rg > /dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='rg --no-ignore --files'
    export FZF_CTRL_T_COMMAND='rg --no-ignore --files'
    export FZF_EDITOR_COMMAND='rg --no-ignore --files'
fi

# for gpg-agent
if [[ $OS == "Mac" ]]; then
    export SSH_AGENT_PID=""
    export SSH_AUTH_SOCK="$HOME/.gnupg/S.gpg-agent.ssh"
fi
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1

# Set window title
DISABLE_AUTO_TITLE="true"
echo -en "\033];prpaxson\007"

# Set prompt
autoload -U colors && colors
# ${fg[purple]%}\$(parse_git_branch)
#PROMPT="%B%{$fg[blue]%}%m %{%fg[yellow]%}[%~] {$fg[green]%}$ {$reset_color%}"
PROMPT='%n %3d $ '

# Set ls colors
if [[ $BACKGROUND == "light" ]]; then
    LS_COLORS=$LS_COLORS:'di=36:ln=35:ex=31'
else
    LS_COLORS=$LS_COLORS:'di=34:ln=33:ex=31'
fi
export LS_COLORS

# Functions
# Default to FZF for selecting file to edit if none given
function FZFEditor()
{
    if [[ -z "$EDITOR" ]]; then
        echo "no editor variable set"
        return
    fi
    if (( $# == 0 )) then
        setopt localoptions pipefail 2> /dev/null
        local files=()
        eval "${FZF_EDITOR_COMMAND:-$FZF_DEFAULT_COMMAND} | $(__fzfcmd) -m $FZF_EDITOR_OPTS" \
        | while read file; do
            files+=($file)
        done
        unset file
        $EDITOR $EDITOR_OPTS $files
    else
        $EDITOR $EDITOR_OPTS $@
    fi
}

# Indicator for normal/insert mode
function zle-line-init zle-keymap-select
{
    RPROMPT=${${KEYMAP/vicmd/[NORMAL]}/(main|viins)/}
    zle reset-prompt
    if [[ $KEYMAP == vicmd ]]; then
        echo -ne '\e[1 q'
    else
        echo -ne '\e[5 q'
    fi
}

# Exit detaches tmux
function exit()
{
    if [[ -z "$TMUX" ]]; then
        builtin exit
    else
        tmux detach
    fi
}

# Git commit shortened
function git_quick_commit()
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
function open_in_xcode()
{
	touch "$@"
	open -a Xcode "$@"
}

# Alias functions
alias extract='unarchive'
alias e='FZFEditor'
alias gitc='git_quick_commit'
alias xcode='open_in_xcode'

# SSH aliases
alias robosub='ssh robosub@acsweb.ucsd.edu'

# General aliases
alias ls='ls -GFh'
alias la='ls -A'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -v'
alias mkdir='mkdir -pv'
alias cd..='cd ../'
alias ..='cd ../'
alias ...='cd ../../'
alias .2='cd ../../'
alias .3='cd ../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../../'
alias .6='cd ../../../../../../'
alias ~='cd ~'
alias todo='topydo columns'
alias t='todo'
alias c='clear'
alias s='cd ~;clear'
alias shutdown='sudo shutdown now'
alias reboot='sudo reboot'
alias poweroff='sudo poweroff'
alias dog='cat'

# Display a message if system hasn't been updated within a week
# To reset the counter, run
# touch ~/.lastupdate
if [[ $(expr $(date +%s) - $(date -r ~/.lastupdate +%s)) -gt 604800 ]]; then
    echo -e "\033[31mWARNING: No updates within a week\033[0m"
fi

# Not connected through SSH
if [[ $OS == "Mac" || ( $OS == "Linux" && -n "$DISPLAY" ) ]]; then
    if [[ -z "$SSH_CLIENT" && -z "$SSH_TTY" && -z "$SSH_CONNECTION" ]]; then
        # Start a tmux session if not in one
        if [[ -z "$TMUX" ]]; then
            session_number=0
            while [[ -n "$(tmux list-clients -t ${session_number} 2>/dev/null)" ]]
            do
                (( session_number++ ))
            done
            tmux new-session -A -s $session_number
            unset session_number
        else
            echo "\033[31mHello, Patrick"
            # display a fortune (max once per day, saved in ~/.lastfortune)
            if [[ $(expr $(date +%s) - $(date -r ~/.lastfortune +%s)) -gt 86400 ]]; then
                fortune -a | tee ~/.lastfortune | cowsay
            fi
            # Load velocity module
            [ -f "${VELOCITY_DIR:-$HOME}/.velocity/velocity.zsh" ] && source "${VELOCITY_DIR:-$HOME}/.velocity/velocity.zsh"
        fi
    fi
fi

if [[ $OS == "Linux" && -z "$DISPLAY" && -n "$XDG_VTNR" && "$XDG_VTNR" -eq 1 ]]; then
    exec startx
fi
export PATH="/usr/local/opt/opencv@2/bin:$PATH"
