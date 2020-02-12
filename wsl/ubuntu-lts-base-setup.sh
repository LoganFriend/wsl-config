###############################################################################
# 
#
#
##############################################################################

# start with an update
sudo apt-get update

# CONFIGS
#==============================================================================

# Change mount point for c drive
touch /etc/wsl.conf
echo '[automount]' >> /etc/wsl.conf
echo 'root = /' >> /etc/wsl.conf
echo 'options = "metadata"' >> /etc/wsl.conf

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
sudo apt-get install \
    git tmux \
    zsh powerline \
    awscli nmap \
    build-essential gdb clang \
    cmake -y

# Install ruby, python 2, and python 3
sudo apt-get install -y \
    ruby \
    python python-pip ipython \
    python3 python3-pip ipython3 python3-venv

# Package Managers
udo apt-get install -y \
    npm

#install virtual environments and pipenv for python
pip3 install virtualenv pipenv

# R
sudo apt-get install -y \
    r-base

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

#oh-my-bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"

#Dotfiles
echo 'source /c/Users/logan/Files/6_scripts/dotfiles/.exports' >> ~/.bashrc 
echo 'source /c/Users/logan/Files/6_scripts/dotfiles/.aliases' >> ~/.bashrc 
echo 'source /c/Users/logan/Files/6_scripts/dotfiles/.functions' >> ~/.bashrc 

# OTHER
#==============================================================================

echo "You will need to restart your computer for changes to take effect"