#!/bin/bash

# Define the list of URLs
urls=()

# Function to display the menu
function display_menu() {
    # Clear the screen
    clear

    # Display the menu
    echo "Select a project to clone:"
    for i in "${!urls[@]}"; do
        echo "$((i+1)). ${urls[$i]}"
    done

    # Add the option to add a new URL
    echo "$(( ${#urls[@]} + 1 )). Add a new URL"

    # Add the option to exit the script
    echo "$(( ${#urls[@]} + 2 )). Exit"

    # Prompt the user to make a selection
    read -rp "Enter your choice: " choice

    # Handle the user's selection
    case $choice in
        [1-$((${#urls[@]}))])
            # Clone the selected project
            update_script "${urls[$((choice-1))]}"
            ;;
        $(( ${#urls[@]} + 1 )))
            # Prompt the user to enter a new URL
            read -rp "Enter the URL of the project you want to clone: " url

            # Check if the URL is valid
            if [[ $url =~ ^(git@|https:\/\/)([a-zA-Z0-9_-]+@)?([a-zA-Z0-9.-]+)(:[0-9]+)?(\/|:)(.*)\.git$ ]]; then
                # Add the new URL to the list
                urls+=("$url")

                # Update the script with the new URL
                update_script "${url}"

                # Clone the selected project
                update_script "${url}"
            else
                # Display an error message and exit
                echo "Invalid URL: $url"
                exit 1
            fi
            ;;
        $(( ${#urls[@]} + 2 )))
            # Exit the script
            exit 0
            ;;
        *)
            # Display an error message and exit
            echo "Invalid choice: $choice"
            exit 1
            ;;
    esac
}

# Display the menu
display_menu
