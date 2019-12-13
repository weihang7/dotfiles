#
# zshrc.zsh - Example starter zshrc
#
# Sets up oh-my-zsh, some completions, fixes ^H and backspace, and more.
#
# Author
#   Jake Zimmerman <jake@zimmerman.io>
#
# Usage
#   Move this file to `~/.zshrc`
#
# Notes
#   This is an example _starter_ zshrc. What I mean by this is that it's more
#   of a skeleton zshrc. It's been crafted with the assumption that you're
#   coming from bash and you already have some bash config that you're weary to
#   part with. The content here aims to be minimally invasive, and since zsh is
#   largely compatible with bash, the rest of your config should fit right in.
#
#   By default, though, it depends on two external plugins (so it's not as
#   minimal as it could be). These are oh-my-zsh[1] and
#   zsh-syntax-highlighting[2].
#
#   To install oh-my-zsh, just run
#
#     git clone https://github.com/robbyrussell/oh-my-zsh ~/.oh-my-zsh
#
#   After installing oh-my-zsh, to install zsh-syntax-highlighting run
#
#     git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
#
#   There are other options to install these extras which you can find by
#   reading their READMEs[1][2]. Depending on the route you end up taking, you
#   might have to adjust some of the settings in the file below.
#
#   [1]: https://github.com/robbyrussell/oh-my-zsh
#   [2]: https://github.com/zsh-users/zsh-syntax-highlighting
#
# License
#   MIT License (c) 2016 Jake Zimmerman


# --- Oh My Zsh specific ------------------------------------------------------
#
# I'm not using oh-my-zsh for too much. Mostly, it makes adding completion
# plugins and prompts easier, but it could be removed if you don't want that
# many completion plugins.
#
# It messes around with and adds things like aliases and other things, so it's
# not for everyone, but it generally works just fine.

# Configure zsh-syntax-highlighting (it's an oh-my-zsh plugin)
# (Uses the defaults plus 'brackets', which tell if parens, etc. are unmatched)
ZSH_HIGHLIGHT_HIGHLIGHTERS+=(main brackets)

# One of the many oh-my-zsh themes shipped by default
ZSH_THEME=avit

export ZSH="$HOME/.oh-my-zsh/"
plugins=(zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# Change zsh-syntax-highlighting comment color once the defaults have been set
# (Gray in Solarized color palette)
ZSH_HIGHLIGHT_STYLES[comment]='fg=green,bold'

# -----------------------------------------------------------------------------


# General zshzle options
setopt autocd                     # cd by just typing in a directory name
setopt completealiases            # tab completion includes aliases
setopt nomatch                    # warn me if a glob doesn't match anything
setopt no_case_glob               # globbing is case insensitive
setopt interactive_comments       # commands preceded with '#' aren't run
setopt menu_complete              # Show completions like Vim (cycle through)
export MENU_COMPLETE=1
#setopt extendedglob              # use #, ^, and ~ as glob characters.
                                  # I've disabled this because it makes zsh
                                  # behave more like bash, at the price of
                                  # giving up features I didn't really use.
                                  # (Uncommented, you have to put quotes
                                  # around these characters to use them)


# Don't try to strip the space between the end of a line and a | character
# (See http://superuser.com/questions/613685/)
ZLE_REMOVE_SUFFIX_CHARS=$' \t\n;&'


# Make ^H and backspace behave correctly
bindkey "^H" backward-delete-char

bindkey -e

# Initialize zsh history files
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000


zstyle :compinstall filename $HOME/.zshrc

# I really like Vim's "menu completion" style of tab completion where it lists
# all your options
zstyle ':completion:*:*:*:*:*' menu ''
# This is an attempt to combat oh-my-zsh's poor attempt at fuzzy
# spell-correcting tab completion
# zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={a-zA-Z}'
# Tab completed files will have the same colors as used for `ls --color`
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
# zsh has this really cool feature where you can attach descriptions to any tab
# completion entry. I personally don't like them.
# zstyle ':completion:*' verbose false

# Turn on all the completion stuff
autoload -Uz compinit && compinit
autoload -Uz promptinit && promptinit

# Use zsh's awesome pattern move:
# zmv '*.c' '*.cpp' and it Just Works™ :o
autoload -Uz zmv


# man pages don't exist for zsh builtins (things like setopt, fg, bg, jobs,
# etc.). Including this snippet lets us run things like 'help setopt' to get
# help.
unalias run-help 2> /dev/null
autoload run-help
# (again, this path is specific to zsh installed through Homebrew)
HELPDIR=/usr/local/share/zsh/help
alias help="run-help"

### afsperms <arguments to fs sa> -- Recursively runs fs sa on a directory
### cc <arguments to gcc> -- Invokes gcc with the flags you will usually use
### valgrind-leak <arguments to valgrind> -- Invokes valgrind in the mode to show all leaks
### hidden <arguments to ls> -- Displays ONLY the hidden files
### killz <program name> -- Kills all programs with the given program name
### shell -- Displays the name of the shell being used
### get_cs_afs_access -- Sets up cross-realm authentication with CS.CMU.EDU so you can access files stored there.

# More features may be added later as thought of or requested.


# ----- guard against non-interactive logins ---------------------------------
[ -z "$PS1" ] && return


# ----- convenient alias and function definitions ----------------------------

# color support for ls and grep
alias grep='grep --color=auto'
if [[ `uname` = "Darwin" || `uname` = "FreeBSD" ]]; then
  alias ls='ls -G'
else
  alias ls='ls --color=auto'
fi

alias killz='killall -9 '
alias hidden='ls -a | grep "^\..*"'
alias rm='rm -v'
alias cp='cp -v'
alias mv='mv -v'
alias shell='ps -p $$ -o comm='
alias sml='rlwrap sml'
alias math='rlwrap MathKernel'
alias coin='rlwrap coin'

alias cc='gcc -Wall -W -ansi -pedantic -O2 '
alias valgrind-leak='valgrind --leak-check=full --show-reachable=yes'

afsperms(){ find $1 -type d -exec fs sa {} $2 $3 \; ; }
get_cs_afs_access() {
    # Script to give a user with an andrew.cmu.edu account access to cs.cmu.edu
    # See https://www.cs.cmu.edu/~help/afs/cross_realm.html for information.

    # Get tokens. This might create the user, but I'm not sure that that's
    # reliable, so we'll also try to do pts createuser.
    aklog cs.cmu.edu

    pts createuser $(whoami)@ANDREW.CMU.EDU -cell cs.cmu.edu 2>&1 | grep -v "Entry for name already exists"

    aklog cs.cmu.edu

    echo "Be sure to add aklog cs.cmu.edu & to your ~/.bashrc"
}

# -----------------------------------------------------------------------------
# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe.sh ] && export LESSOPEN="|/usr/bin/lesspipe.sh %s"

# Turn off the ability for other people to message your terminal using wall
mesg n

export TERM=xterm-256color
export LC_CTYPE="en_US.UTF-8"

aklog cs.cmu.edu &
export GOPATH=$HOME/private/15440/P3/
