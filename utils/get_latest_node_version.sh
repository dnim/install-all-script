#!/bin/bash
function get_latest_node_version {
  local major_version="$1"
  local latest_version=$(nvm ls-remote --lts | awk '{print $1}' | grep "^v16\." | sort -r | head -n 1)
  echo "${latest_version#v}"
}
