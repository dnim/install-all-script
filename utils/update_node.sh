#!/bin/bash

update_node() {
  # Parse input parameter
  version=$(echo "$1" | sed -E 's/^>=([0-9]+\.[0-9]+\.[0-9]+).*$/\1/')

  # Install nvm if not installed
  if ! command -v nvm &> /dev/null
  then
      curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
      source ~/.bashrc
  fi

  # Use nvm to install the most suitable version
  nvm install $(nvm ls-remote --lts | grep "$version" | tail -n 1)
}