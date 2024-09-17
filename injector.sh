#!/bin/bash

# Define injector version to use during patching
injector_ver="v0.1.7"

# Define color variables
RED='\e[31m'
BLUE='\e[34m'
GREEN='\e[32m'
YELLOW='\e[33m'
MAGENTA='\e[35m'
RESET='\e[0m'

# Define a function to draw dashes across screen width as separation line
width=$(stty size | awk '{print $2}')
separate() { printf '%*s\n' "$width" '' | tr ' ' '-'; }

# Determine device architecture
arch=$(uname -m)

# Define download URLs based on device architecture
url_const="https://github.com/mcbegamerxx954/draco-injector/releases/download"
case "$arch" in
    aarch64 | arm64)
        injector_url="$url_const/$injector_ver/injector-aarch64-linux-android.tar.gz"
        injector_file="$injector_ver-injector-aarch64-linux-android.tar.gz"
        ;;
    armv7l | arm | armv8l | arm32)
        injector_url="$url_const/$injector_ver/injector-armv7-linux-androideabi.tar.gz"
        injector_file="$injector_ver-injector-armv7-linux-androideabi.tar.gz"
        ;;
    x86_64)
        injector_url="$url_const/$injector_ver/injector-x86_64-unknown-linux-gnu.tar.gz"
        injector_file="$injector_ver-injector-x86_64-unknown-linux-gnu.tar.gz"
        ;;
    *)
        echo "${RED}Unsupported architecture:${RESET} ${MAGENTA}$arch${RESET}"
        separate
        exit 1
        ;;
esac
separate

# Setup storage permission for Termux if necessary
directory="$HOME/storage"
if [ -d "$directory" ]; then
    echo -e "${BLUE}Termux's storage is already setup, skipping storage setup.${RESET}"
else
    termux-setup-storage
fi
separate

# Get important patch info
echo -e "${YELLOW}Please enter the following info about Patched Minecraft here...${RESET}\n"
read -p "App Name: " app
read -p "Package Name (enter a valid name): " pack
read -p "Output File Name (include .apk): " out
separate

echo -e "${BLUE}Searching for all Minecraft APK files in storage/emulated/0/Download, this may take some time...${RESET}"

# Magical bash boogaloo to find all APK files having "Minecraft" (case insensitive) in file name, thanks @devendrn
files=()
while IFS= read -r filename; do
  files+=("$filename")
done < <(find /storage/emulated/0/Download -type f -iname '*minecraft*.apk')
if [ ${#files[@]} -eq 0 ]; then
    echo -e "${RED}No APK files with 'Minecraft' in the name found.${RESET}\n\n${YELLOW}TIP${RESET}: Make sure you have an APK in /storage/emulated/0/Download that has the word 'Minecraft' in filename.\n\n${RED}Error found, stopping patching process...${RESET}"
    separate
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
separate

# Check if the injector file already exists, download if necessary
if [ -f "$injector_file" ]; then
    echo -e "${GREEN}Injector file for${RESET} ${MAGENTA}$injector_ver${RESET} ${GREEN}already exists, skipping download.${RESET}\n"
else
    echo -e "${BLUE}Downloading injector file${RESET} ${MAGENTA}$injector_ver${RESET} ${BLUE}for${RESET} ${MAGENTA}$arch${RESET}${BLUE}...${RESET}\n"
    if curl -L -o "$injector_file" "$injector_url"; then
        echo -e "${GREEN}Downloaded injector file successfully!${RESET}"
    else
        echo -e "${RED}Could not download injector file...${RESET}\n\n${YELLOW}TIP${RESET}: Make sure you are connected to the internet, then try again!"
        separate
        exit 1
    fi
fi

# Extract the injector
echo -e "\n${BLUE}Extracting the injector file...${RESET}"
if tar xzf "$injector_file"; then
    echo -e "${GREEN}Injector file extracted successfully!${RESET}"
    separate
else
    echo -e "${RED}Could not extract injector file...${RESET}"
    separate
    exit 1
fi

# Run the injector
if ./injector "$selected_file" -a "$app" -p "$pack" -o "$out"; then
    mv "$out" /storage/emulated/0/Download
    separate
    echo -e "${GREEN}Patched Minecraft APK created successfully in Download folder.${RESET}"
    separate
else
    separate
    rm "$out"
    echo -e "${RED}Patching process failed!${RESET}\n\n${YELLOW}TIP${RESET}: Try running the script again!\n\nIf it failed due to ${MAGENTA}'os error 17'${RESET} then it should work the next time.\nIf it failed due to ${MAGENTA}'Unaligned sh_offset value'${RESET} then report the issue in Draco Injector GitHub repo by mcbegamerxx954.\n\n${RED}Error found, stopping patching process...${RESET}"
    separate
    exit 1
fi

# Exit
exit 0
