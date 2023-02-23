#!/bin/bash

# Check if the configuration file exists
if [ ! -f config.sh ]; then
  echo "Creating configuration file..."
  echo '#!/bin/bash' > config.sh
fi

# Source the configuration file to retrieve the value of ROOT_DEV_FOLDER
source config.sh

# Prompt the user for a new value of ROOT_DEV_FOLDER
read -p "Enter the new root dev folder (full path or starting with ~): " new_root_dev_folder

# Update the value of ROOT_DEV_FOLDER in the configuration file
echo "export ROOT_DEV_FOLDER=\"$new_root_dev_folder\"" > config.sh

# Source the configuration file again to update the value of ROOT_DEV_FOLDER in this script
source config.sh

# Display the new value of ROOT_DEV_FOLDER
echo "The new root dev folder is: $ROOT_DEV_FOLDER"
