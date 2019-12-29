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
ZSH_HIGHLIGHT_HIGHLIGHTERS+=(main brackets pattern)

# One of the many oh-my-zsh themes shipped by default
# ZSH_THEME=avit
export PS1="%n@%m:%~%# "

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

# WSL (aka Bash for Windows) doesn't work well with BG_NICE
[ -d "/mnt/c" ] && [[ "$(uname -a)" == *Microsoft* ]] && unsetopt BG_NICE


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
alias coin='rlwrap coin'

alias valgrind-leak='valgrind --leak-check=full --show-reachable=yes'

# -----------------------------------------------------------------------------
# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe.sh ] && export LESSOPEN="|/usr/bin/lesspipe.sh %s"

# Turn off the ability for other people to message your terminal using wall
mesg n

typeset -A ZSH_HIGHLIGHT_STYLES

# ZSH_HIGHLIGHT_STYLES[command]=fg=white,bold
# ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'

LS_COLORS='no=00:fi=00:di=34:ow=34;40:ln=35:pi=30;44:so=35;44:do=35;44:bd=33;44:cd=37;44:or=05;37;41:mi=05;37;41:ex=01;31:*.cmd=01;31:*.exe=01;31:*.com=01;31:*.bat=01;31:*.reg=01;31:*.app=01;31:*.txt=32:*.org=32:*.md=32:*.mkd=32:*.h=32:*.hpp=32:*.c=32:*.C=32:*.cc=32:*.cpp=32:*.cxx=32:*.objc=32:*.cl=32:*.sh=32:*.bash=32:*.csh=32:*.zsh=32:*.el=32:*.vim=32:*.java=32:*.pl=32:*.pm=32:*.py=32:*.rb=32:*.hs=32:*.php=32:*.htm=32:*.html=32:*.shtml=32:*.erb=32:*.haml=32:*.xml=32:*.rdf=32:*.css=32:*.sass=32:*.scss=32:*.less=32:*.js=32:*.coffee=32:*.man=32:*.0=32:*.1=32:*.2=32:*.3=32:*.4=32:*.5=32:*.6=32:*.7=32:*.8=32:*.9=32:*.l=32:*.n=32:*.p=32:*.pod=32:*.tex=32:*.go=32:*.sql=32:*.csv=32:*.sv=32:*.svh=32:*.v=32:*.vh=32:*.vhd=32:*.bmp=33:*.cgm=33:*.dl=33:*.dvi=33:*.emf=33:*.eps=33:*.gif=33:*.jpeg=33:*.jpg=33:*.JPG=33:*.mng=33:*.pbm=33:*.pcx=33:*.pdf=33:*.pgm=33:*.png=33:*.PNG=33:*.ppm=33:*.pps=33:*.ppsx=33:*.ps=33:*.svg=33:*.svgz=33:*.tga=33:*.tif=33:*.tiff=33:*.xbm=33:*.xcf=33:*.xpm=33:*.xwd=33:*.xwd=33:*.yuv=33:*.nef=33:*.NEF=33:*.aac=33:*.au=33:*.flac=33:*.m4a=33:*.mid=33:*.midi=33:*.mka=33:*.mp3=33:*.mpa=33:*.mpeg=33:*.mpg=33:*.ogg=33:*.opus=33:*.ra=33:*.wav=33:*.anx=33:*.asf=33:*.avi=33:*.axv=33:*.flc=33:*.fli=33:*.flv=33:*.gl=33:*.m2v=33:*.m4v=33:*.mkv=33:*.mov=33:*.MOV=33:*.mp4=33:*.mp4v=33:*.mpeg=33:*.mpg=33:*.nuv=33:*.ogm=33:*.ogv=33:*.ogx=33:*.qt=33:*.rm=33:*.rmvb=33:*.swf=33:*.vob=33:*.webm=33:*.wmv=33:*.doc=31:*.docx=31:*.rtf=31:*.odt=31:*.dot=31:*.dotx=31:*.ott=31:*.xls=31:*.xlsx=31:*.ods=31:*.ots=31:*.ppt=31:*.pptx=31:*.odp=31:*.otp=31:*.fla=31:*.psd=31:*.7z=1;35:*.apk=1;35:*.arj=1;35:*.bin=1;35:*.bz=1;35:*.bz2=1;35:*.cab=1;35:*.deb=1;35:*.dmg=1;35:*.gem=1;35:*.gz=1;35:*.iso=1;35:*.jar=1;35:*.msi=1;35:*.rar=1;35:*.rpm=1;35:*.tar=1;35:*.tbz=1;35:*.tbz2=1;35:*.tgz=1;35:*.tx=1;35:*.war=1;35:*.xpi=1;35:*.xz=1;35:*.z=1;35:*.Z=1;35:*.zip=1;35:*.ANSI-30-black=30:*.ANSI-01;30-brblack=01;30:*.ANSI-31-red=31:*.ANSI-01;31-brred=01;31:*.ANSI-32-green=32:*.ANSI-01;32-brgreen=01;32:*.ANSI-33-yellow=33:*.ANSI-01;33-bryellow=01;33:*.ANSI-34-blue=34:*.ANSI-01;34-brblue=01;34:*.ANSI-35-magenta=35:*.ANSI-01;35-brmagenta=01;35:*.ANSI-36-cyan=36:*.ANSI-01;36-brcyan=01;36:*.ANSI-37-white=37:*.ANSI-01;37-brwhite=01;37:*.log=01;32:*~=01;32:*#=01;32:*.bak=01;33:*.BAK=01;33:*.old=01;33:*.OLD=01;33:*.org_archive=01;33:*.off=01;33:*.OFF=01;33:*.dist=01;33:*.DIST=01;33:*.orig=01;33:*.ORIG=01;33:*.swp=01;33:*.swo=01;33:*,v=01;33:*.gpg=34:*.gpg=34:*.pgp=34:*.asc=34:*.3des=34:*.aes=34:*.enc=34:*.sqlite=34:';
export LS_COLORS

export TERM=xterm-256color
export LC_CTYPE="en_US.UTF-8"
