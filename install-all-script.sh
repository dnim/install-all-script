#!/bin/bash

# Check if Python 3.10 is installed
if ! command -v python3.10 &> /dev/null
then
    echo "Python 3.10 is not installed. Installing it now..."
    brew install python@3.10
else
    echo "Python 3.10 is already installed."
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null
then
    echo "Docker is not installed. Installing it now..."
    brew install docker
    sudo /opt/homebrew/bin/dockerd --unattended &>/dev/null &
else
    echo "Docker is already installed."
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null
then
    echo "Docker Compose is not installed. Installing it now..."
    brew install docker-compose
else
    echo "Docker Compose is already installed."
fi

# Check if Node.js and npm are installed
if ! command -v node &> /dev/null || ! command -v npm &> /dev/null
then
    echo "Node.js or npm is not installed."
    
    # Offer user a selection of the latest five Node.js versions to choose from using nvm
    echo "Please select a version of Node.js to install:"
    nvm install $(nvm ls-remote --lts | tail -n5 | sed 's/^\s*//' | sed 's/\s.*$//' | fzf)
    
    # Set the selected version of Node.js as the default using nvm
    nvm alias default $(node -v)
    
    # Install the corresponding version of npm using the selected version of Node.js
    npm install -g npm@$(npm -v | awk -F'[.]' '{ print $1"."$2 }')
    
    echo "Node.js and npm have been installed."
else
    echo "Node.js and npm are already installed."
fi
