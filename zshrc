# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="crunch"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git rvm brew rails osx ruby)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=/Users/joe/.rvm/gems/ruby-1.9.3-p0@neoteric_development/bin:/Users/joe/.rvm/gems/ruby-1.9.3-p0@global/bin:/Users/joe/.rvm/rubies/ruby-1.9.3-p0/bin:/Users/joe/.rvm/bin:/Users/joe/.homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/git/bin:/usr/X11/bin:/Users/joemsak/bin:$PATH
export PATH="/Users/joe/Applications:/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:/Users/joe/.homebrew/bin:$PATH"
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export DOTFILES=$HOME/code/dotfiles
export MANPATH=/opt/local/share/man:$MANPATH

alias r='rails'
alias mate='vim'
alias vim='~/Applications/MacVim.app/Contents/MacOS/vim'
alias gpgp='git pull && git push'
alias gptags='git push && git push --tags'
alias git='xcrun git'
alias rake='noglob rake'
alias nt='nosetests --rednose'

if [ -e /usr/share/terminfo/x/xterm-256color ]; then
  export TERM='xterm-256color'
else
  export TERM='xterm-color'
fi
export RUBY_HEAP_MIN_SLOTS=1000000
export RUBY_GC_HEAP_INIT_SLOTS=1000000
export RUBY_HEAP_SLOTS_INCREMENT=1000000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=1000000000
export RUBY_HEAP_FREE_MIN=500000

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
export RACK_ENV=development

hitch() {
  command hitch "$@"
  if [[ -s "$HOME/.hitch_export_authors" ]] ; then source "$HOME/.hitch_export_authors" ; fi
}
alias unhitch='hitch -u'
export PATH=~/code/depot_tools:"$PATH"
