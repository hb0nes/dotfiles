# Dotfiles
Store my dotfiles and spread them across different computers easily.

## Installing
1. Clone the repo: **git clone https://github.com/hb0nes/dotfiles**
2. Change directory to cloned repo: **cd dotfiles**
3. Run: **./dotsync.sh**
    1. **./dotsync pull** - prompts you to pull either all the files or individually acknowledge them.
    2. **./dotsync push** - prompts you to push either all the files or individually acknowledge them. *Please note this is only for people with write access*
    3. **./dotsync first-run** - first installs zsh and oh-my-zsh, then follows pull. 
    4. **./dotsync debug** - prints the directory it'll copy from/to. See source.

## Changing HTTP/SSH
### Check current remote connection
git remote -v
### Change remote url from HTTP to SSH
git remote set-url origin git@github.com:hb0nes/dotfiles.git

