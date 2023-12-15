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
    alias ll="lsd -lh --date='+%Y-%m-%d %H:%M:%S'"
    alias la="lsd -Alh --date='+%Y-%m-%d %H:%M:%S'"
    alias lt="lsd -A --tree --depth 2 --ignore-glob node_modules --ignore-glob .git"
fi

# macOS has no `md5sum`, so use `md5` as a fallback
command -v md5sum > /dev/null || alias md5sum="md5"

# macOS has no `sha1sum`, so use `shasum` as a fallback
command -v sha1sum > /dev/null || alias sha1sum="shasum"

# Empty the trash on all mounted volumes and the main HDD,
# Also, clear Apple's system logs to improve shell startup speed.
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"
