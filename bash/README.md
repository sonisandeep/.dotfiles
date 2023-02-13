# bash
Bash Script and Functions

In your home directory .bashrc add the below

```
export REPOS_DIR="$HOME""/.dotfiles"
export BASH_REPO_DIR="$REPOS_DIR""/bash"
if [ -f "$BASH_REPO_DIR"/.bashrc.sh ]; then
    . "$BASH_REPO_DIR"/.bashrc.sh
fi
```
