# Get rid of the fish greeting.
function fish_greeting
end

# TODO: Add keybinding to open current line in vim to edit.
#TODO: setup autojump

# Env vars
source ~/.config/env.fish
export VISUAL=nvim
export EDITOR="$VISUAL"

# Keybindings
# bind \cH kill-whole-line
#bind \cJ accept-autosuggestion execute
#bind \cJ "cd $(find . -type d -print | fzf)"

# TODO: these fzf functions should do nothing if not result is selected. ie if you ctrl+c out of fzf search box.
function cd_fzf;
	cd "$(find . -type d -print | fzf)"
end


function history_fzf;
	history | fzf
end

function nvim_fzf;
	nvim "$(find . -print | fzf)"
end

bind \co nvim_fzf
bind \cj cd_fzf

# General aliases
alias rm='rm -r'
alias cp='cp -r'
alias mkdir='mkdir -p'

# Git aliases
alias g='git'
alias gs='git status'
alias gc='git commit -v'
alias gb='git branch'
alias ga='git add'
alias gl='git log'
alias gm='git merge'
alias gd='git diff'
# alias gco='git checkout'
# Alias for activating env
function gco
	if test (count $argv) -lt 1; or test $argv[1] = "--help"
		# | xargs just strips the whitespaces.
		git checkout (git branch | fzf | sed s/\*// | xargs)

	else
		git checkout $argv[1]
	end
  end

alias gcm='git checkout main'
alias gnb='git checkout -b'
alias gbd='git branch -D'
alias btm='bottom'

# Use regex to delete bunch of branches
function rgbd; 
	git branch -D $(string trim $(git branch --list $argv[1]))
end

alias vi='nvim'
alias vim='nvim'
alias p='python'

# Docker aliases
#Avoid having to type sudo the entire time.
alias docker='sudo docker'
# Remove all docker images.
alias di_rm='sudo docker rmi -f (docker images -aq)'
# Remove all docker containers.
alias dc_rm='sudo docker rm -vf (docker ps -aq)'

alias lsp='pip install python-lsp-server[all] black'

# The next line updates PATH for the Google Cloud SDK.
# TODO this shouldn't point to Downloads.
if [ -f '/home/dzedcpt/Downloads/google-cloud-sdk/path.fish.inc' ]; . '/home/dzedcpt/Downloads/google-cloud-sdk/path.fish.inc'; end

# TODO setup command line fzf
# should work for finding directories and for searching through history
# TODO install exa
if command -v exa > /dev/null
	abbr -a l 'exa'
	abbr -a ls 'exa'
	abbr -a ll 'exa -l'
	abbr -a lll 'exa -la'
else
	abbr -a l 'ls'
	abbr -a ll 'ls -l'
	abbr -a lll 'ls -la'
end


# Kanagawa Fish shell theme
# A template was taken and modified from Tokyonight:
# https://github.com/folke/tokyonight.nvim/blob/main/extras/fish_tokyonight_night.fish
set -l foreground c5c9c5 normal
set -l selection 2D4F67 brcyan
set -l comment a6a69c brblack
set -l red C4746E red
set -l orange FF9E64 brred
set -l yellow c4b28a yellow
set -l green 8a9a7b green
set -l purple a292a3s magenta
set -l cyan 7AA89F cyan
set -l pink D27E99 brmagenta

# Syntax Highlighting Colors
set -g fish_color_normal $foreground
set -g fish_color_command $cyan
set -g fish_color_keyword $pink
set -g fish_color_quote $yellow
set -g fish_color_redirection $foreground
set -g fish_color_end $orange
set -g fish_color_error $red
set -g fish_color_param $purple
set -g fish_color_comment $comment
set -g fish_color_selection --background=$selection
set -g fish_color_search_match --background=$selection
set -g fish_color_operator $green
set -g fish_color_escape $pink
set -g fish_color_autosuggestion $comment

# Completion Pager Colors
set -g fish_pager_color_progress $comment
set -g fish_pager_color_prefix $cyan
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_description $comment



# Configure the prompt. Keeping it nice and simple
# TODO: Would like to put a little * next to the branch name if there are uncommited changes.
function fish_prompt
	
	set_color purple
	if test "$OS" = "Linux"
		echo -n "$hostname:"
	else if test "$OS" = "Darwin"
		echo -n "local:"
	end

  	# Echo where I am.
	set_color blue
	echo -n (basename $PWD)

	# Git status stuff
	# TOOD: Would be cool if this changed colours based on the git status.
	set -l git_branch (git branch 2>/dev/null | sed -n '/\* /s///p')
	if test "$git_branch" 
	    set_color green
        echo -n "($git_branch)"
	end

	# Conda env stuff
	if test "$CONDA_DEFAULT_ENV"
		set_color C4746E 
		echo -n "[$CONDA_DEFAULT_ENV]"
	end
	# Print new line
	echo

	set_color normal
    echo -n "> "

end

# Conda init

# Update PATH for the Google Cloud SDK.
if [ -f '/Users/me/google-cloud-sdk/path.fish.inc' ]; . '/Users/me/google-cloud-sdk/path.fish.inc'; end

set OS $(uname)

if test "$OS" = "Linux"
	# Linus specific config
	alias klog='tail -f /var/log/kern.log'
    eval /home/jed/miniconda3/bin/conda "shell.fish" "hook" $argv | source
else if test "$OS" = "Darwin"
	# Mac specific config
    eval /Users/me/miniconda3/bin/conda "shell.fish" "hook" $argv | source
end

alias nspeed="curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -"
# How much disk space left?
alias dspace="sudo du -hsx /* | sort -rh | head -n 40"


alias node-pools="gcloud container node-pools list --cluster=ponos-cluster --location=europe-west4-a | cut -f1 -d' '"

function vm; 
	set cmd $argv[1]
	if test "$cmd" = "ls";
		gcloud compute instances list;
	else if test "$cmd" = "start"
		gcloud compute instances start $(gcloud compute instances list | fzf | cut -d ' ' -f1);
	else if test "$cmd" = "stop"
		gcloud compute instances stop $(gcloud compute instances list | fzf | cut -d ' ' -f1);
	else if test "$cmd" = "ssh"
		gcloud compute ssh jed@$(gcloud compute instances list | fzf | cut -d ' ' -f1);
	else
		echo "Unkown cmd: $cmd"
	end
end

# Alias for jumping to a file.
alias gt ='cd $(find . -type d -print | fzf)'
# Alias for activating env
function activate
	if test (count $argv) -lt 1; or test $argv[1] = "--help"
		conda activate (conda env list | sed '/^#/d' | fzf | cut -d ' ' -f1)
	else
		conda activate $argv[1]
	end
  end
alias deactivate="conda deactivate"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# <<< conda initialize <<<

# Prevent conda from automatically loading an env on login.
conda config --set auto_activate_base False
# Prevent conda from putting the env name on the end of the prompt line.
conda config --set changeps1 False

if test "$OS" = "Linux"
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
end

# Not sure if this make any difference tbh

# Function to edit command in nvim
function edit_cmd --description 'Input command in external editor'
        set -l f (mktemp /tmp/fish.cmd.XXXXXXXX)
        if test -n "$f"
            set -l p (commandline -C)
            commandline -b > $f
            nvim -c 'set ft=fish' $f
            commandline -r (more $f)
            commandline -C $p
            command rm $f
        end
    end

bind \cV 'edit_cmd'



function py; 
	set cmd $argv[1]
	if test "$cmd" = "lsp";
		pip install python-lsp-server black isort
	else if test "$cmd" = "clean"
		pip freeze | grep -v "^-e" | xargs pip uninstall -y
	else
		# By default just run the python command.
		python $argv
	end
end


