# Alias command
# View all active ports
alias ssp="ss -lntup"
# View number of processes running per user
alias psu="ps hax -o user | sort | uniq -c | sort -hr"
# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'
