#!/bin/bash
# This script can be used to create spring boot properties based on the given user input.
# To configure the prompts look into the CONFIGURATION section below.
# To adjust the property generation logic, adjust the generate_properties() method in the PROPERTY GENERATION LOGIC section below.
# No matter how complex the generate_properties() logic is, the result needs to be saved in a global generated_properties variable for later use.

##############################################
#              CONFIGURATION                 #
##############################################

# Variables to customize each prompt (name, prompt text, help message)
# If you want to add more prompts, append the variable list with pX_var and pX_help and add the pX_var to the prompt_collection
# If you want to remove a prompt, remove the corresponding pX_var and pX_help variables and also remove pX_var from the prompt_collection
p1_var="host"
p1_help="$(tput bold)MongoDB Host$(tput sgr0) This is the host your mongodb application is running on"

p2_var="port"
p2_help="$(tput bold)MongoDB Port:$(tput sgr0) This is the port of your mongodb running on the given host"

p3_var="database"
p3_help="$(tput bold)MongoDB DB Name:$(tput sgr0) This is the name of the database the application should connect to"

p4_var="username"
p4_help="$(tput bold)MongoDB DB Username:$(tput sgr0) This is the username used to connect to your database."

p5_var="password"
p5_help="$(tput bold)MongoDB DB Password:$(tput sgr0) This is the password used to connect to your database."

prompt_collection="$p1_var $p2_var $p3_var $p4_var $p5_var"





##############################################
#         PROPERTY GENERATION LOGIC          #
##############################################
generate_properties() {
declare -g generated_properties="
spring.application.name=$host
spring.profiles.active=$port
spring.datasource.url=$database
spring.datasource.username=$username
spring.datasource.password=$password
"
}





##############################################
#              IMPLEMENTATION                #
##############################################

# Function to prompt the user for input with formatting
prompt() {
    read -p "$(tput bold)$(tput setaf 4)$1$(tput sgr0): " "$2"
}

# Function to print errors with formatting
print_err() {
    echo "$(tput bold)$(tput setaf 1)$1$(tput sgr0)"
}

# Help function to provide information about input prompts
help_message() {
    case "$1" in
        "$p1_var")
            echo $p1_help
            ;;
        "$p2_var")
            echo $p2_help
            ;;
        "$p3_var")
            echo $p3_help
            ;;
        "$p4_var")
            echo $p4_help
            ;;
        "$p5_var")
            echo $p5_help
            ;;
        *)  # Default case
            echo "No help available for this input."
            ;;
    esac
}

# Function to get user input and handle help requests
get_input() {
    local prompt="$1"
    local var_name="$2"
    while true; do
        prompt "$prompt" input
        if [[ "$input" == "!help" ]]; then
            help_message "$var_name"
        else
            eval "$var_name=\$input"
            break
        fi
    done
}

# Function to copy properties to clipboard if possible
copy_to_clipboard() {
    local generated_properties="$1"

    if command -v xclip &>/dev/null; then
        echo "$generated_properties" | xclip -selection clipboard
        echo "Properties copied to clipboard!"
    elif command -v pbcopy &>/dev/null; then
        echo "$generated_properties" | pbcopy
        echo "Properties copied to clipboard!"
    elif command -v xsel &>/dev/null; then
        echo "$generated_properties" | xsel --clipboard
        echo "Properties copied to clipboard!"
    else
        print_err "Unable to copy properties to clipboard. Please install xclip, pbcopy, or xsel or copy the values manually from the previous console output"
    fi
}

# Function to save properties to a file
save_to_file() {
    echo "$1" > "$2"
    echo "Properties saved to file: $2"
}





##############################################
#                 EXECUTION                  #
##############################################

# Welcome message
echo "$(tput bold)$(tput setaf 2)Welcome to the Spring Boot Properties Generator!$(tput sgr0)"
echo "$(tput bold)$(tput setaf 2)Let's start by creating your application properties.$(tput sgr0)"
echo "$(tput bold)$(tput setaf 2)If you have problems with any prompt use !help to get some further information$(tput sgr0)"

# Gather inputs
for prompt_var in $prompt_collection; do
    get_input "Enter your ${prompt_var//_/' '}" "$prompt_var"
done

# Generate properties
generate_properties

# Print generated properties
echo ""
echo "$(tput bold)$(tput setaf 3)Generated Spring Boot Properties:$(tput sgr0)"
echo "$generated_properties"

# Offer options to the user of what he wants to do with the generated properties
while true; do
	prompt "Do you want to (0) copy the generated properties to clipboard, (1) save them to a file or (2) end the script without any further actions? (0/1/2): " option
    case $option in
        0)
            copy_to_clipboard "$generated_properties"
            break
            ;;
        1)
            prompt "Enter the filename to save the properties: " filename
            save_to_file "$generated_properties" "$filename"
            break
            ;;
	2)
            break;
	    ;;
        *)
            print_err "Invalid option. Please choose 1 or 2."
            ;;
    esac
done
