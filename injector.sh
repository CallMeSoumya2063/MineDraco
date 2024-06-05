#!/bin/bash

# Setup storage permission for Termux if necessary
directory="$HOME/storage"
if [ -d "$directory" ]; then
    echo -e "\n${BLUE}Termux's storage is already setup, skipping storage setup.${RESET}"
else
    termux-setup-storage
fi

# Define color variables
RED='\e[31m'
BLUE='\e[34m'
GREEN='\e[32m'
YELLOW='\e[33m'
MAGENTA='\e[35m'
RESET='\e[0m'

# Determine screen width
width=$(stty size | awk '{print $2}')

# Determine device architecture
arch=$(uname -m)

# Define download URLs based on architecture
case "$arch" in
    aarch64)
        injector_url="https://github.com/mcbegamerxx954/draco-injector/releases/download/v0.1.6/injector-aarch64-linux-android.tar.gz"
        injector_file="v0.1.6_injector-aarch64-linux-android.tar.gz"
        ;;
    armv7l | arm)
        injector_url="https://github.com/mcbegamerxx954/draco-injector/releases/download/v0.1.6/injector-armv7-linux-androideabi.tar.gz"
        injector_file="v0.1.6_injector-armv7-linux-androideabi.tar.gz"
        ;;
    x86_64)
        injector_url="https://github.com/mcbegamerxx954/draco-injector/releases/download/v0.1.6/injector-x86_64-unknown-linux-gnu.tar.gz"
        injector_file="v0.1.6_injector-x86_64-unknown-linux-gnu.tar.gz"
        ;;
    *)
        echo "${RED}Unsupported architecture:${RESET} ${MAGENTA}$arch${RESET}"
        printf '%*s\n' "$width" '' | tr ' ' '-'
        exit 1
        ;;
esac

printf '%*s\n' "$width" '' | tr ' ' '-'

# Get important patch info
echo -e "${YELLOW}Please enter the following info about Patched Minecraft here...${RESET}\n"
read -p "App Name: " app
read -p "Package Name (enter a valid name): " pack
read -p "Output File Name (include .apk): " out

printf '%*s\n' "$width" '' | tr ' ' '-'

echo -e "${BLUE}Searching for all Minecraft APK files in storage/emulated/0/Download, this may take some time...${RESET}"

# Magical bash boogaloo to find all APK files having "Minecraft" (case insensitive) in file name, thanks @devendrn
files=()
while IFS= read -r filename; do
  files+=("$filename")
done < <(find /storage/emulated/0/Download -type f -iname '*minecraft*.apk')
if [ ${#files[@]} -eq 0 ]; then
    echo -e "${RED}No APK files with 'Minecraft' in the name found.${RESET}\n\nMake sure you have an APK in /storage/emulated/0/Download that has the word 'Minecraft' in filename.\n\n${RED}Error found, stopping patching process...${RESET}\n"
    printf '%*s\n' "$width" '' | tr ' ' '-'
    exit 1
elif [ ${#files[@]} -eq 1 ]; then
    selected_file="${files[0]}"
    echo -e "${YELLOW}Found only one APK file:${RESET} ${MAGENTA}$selected_file${RESET}\n\nUsing the only auto-detected file for patching..."
else
    echo -e "\n${YELLOW}Multiple APK files found!${RESET}\n${YELLOW}Please enter the number beside the APK file you want to use:${RESET}"
    select selected_file in "${files[@]}"; do
        if [ -n "$selected_file" ]; then
            echo -e "\n${BLUE}Selected APK file:${RESET} ${MAGENTA}$selected_file${RESET}\n\nUsing chosen file for patching..."
            break
        else
            echo -e "${RED}Invalid selection. Please try again.${RESET}\n"
        fi
    done
fi

printf '%*s\n' "$width" '' | tr ' ' '-'

# Check if the injector file already exists then download
if [ -f "$injector_file" ]; then
    echo -e "${GREEN}Injector file already exists, skipping download.${RESET}\n"
else
    echo -e "${BLUE}Downloading injector for ${RESET}${MAGENTA}$arch${RESET}${BLUE}...${RESET}\n"
    curl -L -o "$injector_file" "$injector_url"
fi

# Extract the injector
echo -e "\n${BLUE}Extracting the injector...${RESET}"
tar xvzf "$injector_file"
printf '%*s\n' "$width" '' | tr ' ' '-'

# Run the injector
if ! ./injector "$selected_file" -a "$app" -p "$pack" -o "$out"; then
    echo -e "${RED}Patching process failed!${RESET}\n"
    exit 1
fi

# Move the output file to downloads
mv "$out" /storage/emulated/0/Download

# Done, exit
printf '%*s\n' "$width" '' | tr ' ' '-'
echo -e "${GREEN}Patched Minecraft APK created successfully in Download folder.${RESET}"
printf '%*s\n' "$width" '' | tr ' ' '-'
exit 0
