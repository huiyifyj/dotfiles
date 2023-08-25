# Alias command
# View all active ports
alias ssp="ss -lntup"
# View number of processes running per user
alias psu="ps hax -o user | sort | uniq -c | sort -hr"
# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'

# docker abbreviation
alias d="docker"
alias dc="docker compose"

# git abbreviation
alias g="git"
# avoid switching to `ghostscript` when using `gs`
alias gs="g s"

# Using [lsd](https://github.com/lsd-rs/lsd) instead of `ls`
if command -v lsd >/dev/null 2>&1; then
    alias ls="lsd"
    alias ll="lsd -lh"
    alias la="lsd -al"
    alias lt="lsd -A --tree --depth 2 --ignore-glob node_modules --ignore-glob .git"
fi
