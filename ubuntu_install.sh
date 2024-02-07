sudo apt-add-repository ppa:fish-shell/release-3
sudo apt update
sudo apt install fish -y
sudo apt-get install ripgrep
sudo apt install fzf
sudo apt-get install exa
sudo apt-get install gcc
sudo apt-get install g++
sudo apt-get install unzip

# Use snap to get a new enough version
sudo snap install nvim --classic

# ZZZ: Nice to use brew if we can, but this won't work until bew is autoinstalled.
# brew install stylua

# Download tree sitter cli from here:
# https://github.com/tree-sitter/tree-sitter/releases
# TODO automate this.

# Install google-cloud-cli
sudo apt-get install apt-transport-https ca-certificates gnupg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt-get update && sudo apt-get install google-cloud-cli

# TODO: not sure about htis
#ln -s ~/.config/.gitconfig ~/

ln -s ~/dotfiles/nvim  ~/.config/
ln -s ~/dotfiles/fish  ~/.config/
ln -s ~/dotfiles/pycodestyle  ~/.config/
