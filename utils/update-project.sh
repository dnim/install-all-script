#!/bin/bash

# Source nvm
source ~/.nvm/nvm.sh
source /Users/sergeykorsik/programming/_sandbox/install-all-script.sh/utils/get_latest_node_version.sh

function extract_major_version {
  local version="$1"
  echo "$version" | sed -E 's/^>=([0-9]+\.[0-9]+\.[0-9]+).*$/\1/' | cut -d'.' -f1
}

function update_node() {
  # Parse input parameter
  local major_version=$(extract_major_version "$1")
  local latest_version=$(get_latest_node_version "$major_version")
  echo "Major version: $major_version, raw version: $1, latest_version: $latest_version"
  nvm install "$latest_version"
  nvm use "$latest_version" # TODO: installs version only for the inner shell 
}

# Define the list of URLs
urls=(
    "git@github.com:dnim/sort-it-right.git"
    "git@github.com:dnim/sort-it-left.git"
)

# Display menu and prompt user for input
display_menu() {
    echo "Select a project to clone or add a new URL:"
    for ((i=0; i<${#urls[@]}; i++)); do
        echo "$((i+1)). ${urls[i]}"
    done
    echo "$((i+1)). Add new URL"
    echo "$((i+2)). Exit"

    read -p "Enter a number: " choice

    if [[ $choice -eq $((i+2)) ]]; then
        exit
    elif [[ $choice -eq $((i+1)) ]]; then
        read -p "Enter a new URL: " new_url
        update_script "$new_url"
    elif [[ $choice -ge 1 && $choice -le $i ]]; then
        clone_repo "${urls[choice-1]}"
    else
        echo "Invalid choice. Please try again."
        display_menu
    fi
}

# Update script to include new URL
update_script() {
    local new_url=$1
    # Check that new URL is valid
    if ! echo "$new_url" | grep -Eq "^https://github.com/|^git@github.com:"; then
        echo "Invalid URL. Please enter a valid GitHub URL (e.g. https://github.com/username/repo or git@github.com:username/repo)."
        read -p "Enter a new URL: " new_url
        update_script "$new_url"
    fi

    # Check if URL already exists in the array
    for url in "${urls[@]}"; do
        if [[ "$url" == "$new_url" ]]; then
            echo "URL already exists in list."
            return
        fi
    done

    # Add new URL to the array
    urls+=("$new_url")

    # Update script file with new URL
    sed -i.bak "/^urls=(/c\urls=($(printf '%q\n' "${urls[@]}"))" "${BASH_SOURCE[0]}"

    echo "URL successfully added."
}

# Clone repository and install dependencies
clone_repo() {
    local repo_url=$1
    local repo_name=$(echo "${repo_url##*/}" | cut -d'.' -f1)

    if [[ -d "$repo_name" ]]; then
        cd "$repo_name"
    else
        git clone "$repo_url"
        cd "$repo_name"
    fi

    if [[ -f "package.json" ]]; then
        node_version=$(node -p "require('./package.json').engines.node")
        npm_version=$(node -p "require('./package.json').engines.npm")

        if [[ -n "$node_version" ]]; then
            update_node "$node_version"
            # nvm install "$node_version"
        fi

        if [[ -n "$npm_version" ]]; then
            npm install -g "npm@$npm_version"
        fi
    fi
}

# Main function
main() {
    display_menu
}

main
