#!/bin/bash

###############################################################################
# 
#
#
##############################################################################

# start with an update / upgrade
sudo apt-get update -y && sudo apt-get upgrade -y

# CONFIGS
#==============================================================================

# Change mount point for c drive
sudo touch /etc/wsl.conf
sudo chmod 333 wsl.conf
grep -qxF '[automount]' /etc/wsl.conf || echo '[automount]' >> /etc/wsl.conf
grep -qxF 'root = /' /etc/wsl.conf || echo 'root = /' >> /etc/wsl.conf
grep -qxF 'options = "metadata"' /etc/wsl.conf || echo 'options = "metadata"' >> /etc/wsl.conf

# Add symlinks to user home
cd $HOME
ln -s /c/Users/logan/Desktop/ 
ln -s /c/Users/logan/Downloads/ 
ln -s /c/Users/logan/Pictures/ 
ln -s /c/Users/logan/Videos/ 
ln -s /c/Users/logan/Files/ 


# INSTALLS
#==============================================================================

# General
sudo apt-get install -y \
    git tmux \
    awscli nmap \
    build-essential gdb clang cmake

# Install ruby, R, python 2, and python 3
sudo apt-get install -y \
    ruby \
    r-base \
    python python-pip ipython \
    python3 python3-pip ipython3 python3-venv

# Package Managers
sudo apt-get install -y \
    npm

#install virtual environments and pipenv for python
pip3 install virtualenv pipenv

# docker dependencies
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common


# DOCKER
#==============================================================================

# Download and add Docker's official public PGP key.
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Verify the fingerprint.
sudo apt-key fingerprint 0EBFCD88

# Add the `stable` channel's Docker upstream repository.
#
# If you want to live on the edge, you can change "stable" below to "test" or
# "nightly". I highly recommend sticking with stable!
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Update the apt package list (for the new apt repo).
sudo apt-get update -y

# Install the latest version of Docker CE.
sudo apt-get install -y docker-ce

# Allow your user to access the Docker CLI without needing root access.
sudo usermod -aG docker $USER

# Install docker-compose
sudo apt-get install docker-compose -y

# GIT
#==============================================================================

git config --global user.name "LoganFriend"
git config --global user.email "loganfriend@charter.net"
git config --global core.editor vim

# BASH
#==============================================================================

# Zsh / Oh-My-Zsh
if command -v zsh &> /dev/null && command -v git &> /dev/null && command -v wget &> /dev/null; then
	echo -e "ZSH and Git are already installed\n"
else
	if sudo apt install -y zsh git wget || sudo dnf install -y zsh git wget || sudo yum install -y zsh git wget || sudo brew install git zsh wget ; then
		echo -e "ZSH and Git Installed\n"
	else
		echo -e "Can't install ZSH or Git\n" && exit
	fi
fi

if mv -n ~/.zshrc ~/.zshrc-backup-$(date +"%Y-%m-%d"); then	# backup .zshrc
	echo -e "Backed up the current .zshrc to .zshrc-backup-date\n"
fi

echo -e "Installing oh-my-zsh\n"
if git clone --depth=1 git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh; then
	echo -e "Installed OH-MY-ZSH\n"
fi

cp -f .zshrc ~/

# INSTALL FONTS

if git clone --depth=1 https://github.com/powerline/fonts.git --depth=1 ~/.quickzsh/powerline_fonts; then :
else
	cd ~/.quickzsh/powerline_fonts && git pull
fi

if ~/.quickzsh/powerline_fonts/install.sh && rm -rf ~/.quickzsh/powerline_fonts; then
	echo -e "\npowerline_fonts Installed\n"
else
	echo -e "\npowerline_fonts Installation Failed\n"
fi


wget -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete.ttf -P ~/.fonts/
wget -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/RobotoMono/Regular/complete/Roboto%20Mono%20Nerd%20Font%20Complete.ttf -P ~/.fonts/

fc-cache -fv ~/.fonts

# Plugins

if git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k; then :
else
	cd ~/.oh-my-zsh/custom/themes/powerlevel10k && git pull
fi

if git clone --depth 1 https://github.com/supercrabtree/k $HOME/.oh-my-zsh/custom/plugins/k; then :
else
	cd ~/.oh-my-zsh/custom/plugins/k && git pull
fi

# OTHER
#==============================================================================

#Dotfiles
cd $HOME
git clone https://github.com/LoganFriend/dotfiles.git
cp .zshrc ~/.zshrc

#in case you want to use the other dotfiles in another .zshrc file
#grep -qxF 'source $HOME/dotfiles/.exports' ~/.zshrc  || echo 'source $HOME/dotfiles/.exports' >> ~/.zshrc 
#grep -qxF 'source $HOME/dotfiles/.aliases' ~/.zshrc  || echo 'source $HOME/dotfiles/.aliases' >> ~/.zshrc 
#grep -qxF 'source $HOME/dotfiles/.functions' ~/.zshrc  || echo 'source $HOME/dotfiles/.functions' >> ~/.zshrc 

# Fix on-my-zsh permission issues
chmod 555 $HOME/.oh-my-zsh

# FINISH
#==============================================================================

echo -e "\nSudo access is needed to change default shell\n"

if chsh -s $(which zsh) && /bin/zsh -i -c upgrade_oh_my_zsh; then
	echo -e "Installation Successful, exit terminal and enter a new session"
else
	echo -e "Something is wrong"
fi
exit

echo "You will need to restart your computer for changes to take effect (specifically the changes to where the c drive is mounted)"