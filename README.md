# Dotfiles
Store my dotfiles and spread them across different computers easily.
This works by adding files I need to copy across different machines to the filelist.
All these files are files in your ~. If you normally store them someplace else, too bad.
This isn't designed to work that way, it should work out of the box on clean machines with internet access.
Enjoy.

## Installing
1. Clone the repo: **git clone https://github.com/hb0nes/dotfiles.git**
2. Change directory to cloned repo: **cd dotfiles**
3. Run: **./dotsync.sh**
    1. **./dotsync pull** - prompts you to pull either all the files or individually acknowledge them.
    2. **./dotsync push** - prompts you to push either all the files or individually acknowledge them. *Please note this is only for people with write access*
    3. **./dotsync first-run** - first installs zsh and oh-my-zsh, then follows pull. 
    4. **./dotsync debug** - prints the directory it'll copy from/to. See source.
*Note: These config files work best with wsl-term. Download it here: https://github.com/goreliu/wsl-terminal*
*Tip: Pick the base16-monokai theme*

## Errors
If after pulling you get an error for YouCompleteMe, try compiling it by:
1. **cd ~/.vim/bundle/YouCompleteMe/**
2. **./install.py --clang-completer**
If you can't compile, you need dependencies. Google it.

## Changing repo to HTTP/SSH 
*for easier pushing/pulling*
### Check current remote connection
git remote -v
### Change remote url from HTTP to SSH
git remote set-url origin git@github.com:hb0nes/dotfiles.git
