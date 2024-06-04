#!/bin/bash

# Setup storage permission for Termux if necessary
directory="$HOME/storage"
if [ -d "$directory" ]; then
    echo -e "\nTermux's storage is already setup, skipping storage setup."
else
    termux-setup-storage
fi

# Determine screen width
width=$(stty size | awk '{print $2}')

# Determine device architecture
arch=$(uname -m)

# Define download URLs based on architecture
case "$arch" in
    aarch64)
        injector_url="https://github.com/mcbegamerxx954/draco-injector/releases/download/v0.1.5/injector-aarch64-linux-android.tar.gz"
        injector_file="v0.1.5_injector-aarch64-linux-android.tar.gz"
        ;;
    armv7l | arm)
        injector_url="https://github.com/mcbegamerxx954/draco-injector/releases/download/v0.1.5/injector-armv7-linux-androideabi.tar.gz"
        injector_file="v0.1.5_injector-armv7-linux-androideabi.tar.gz"
        ;;
    x86_64)
        injector_url="https://github.com/mcbegamerxx954/draco-injector/releases/download/v0.1.5/injector-x86_64-unknown-linux-gnu.tar.gz"
        injector_file="v0.1.5_injector-x86_64-unknown-linux-gnu.tar.gz"
        ;;
    *)
        echo "Unsupported architecture: $arch"
        printf '%*s\n' "$width" '' | tr ' ' '-'
        exit 1
        ;;
esac

printf '%*s\n' "$width" '' | tr ' ' '-'

# Get important patch info
echo -e "Please enter the following info about Patched Minecraft here...\n"
read -p "App Name: " app
read -p "Package Name (enter a valid name): " pack
read -p "Output File Name (include .apk): " out

printf '%*s\n' "$width" '' | tr ' ' '-'

echo -e "Searching for all Minecraft APK files in storage/emulated/0/Download, this may take some time...\n"

# Magical bash boogaloo to find all APK files having "Minecraft" (case insensitive) in file name, thanks @devendrn
files=()
while IFS= read -r filename; do
  files+=("$filename")
done < <(find /storage/emulated/0/Download -type f -iname '*minecraft*.apk')
if [ ${#files[@]} -eq 0 ]; then
    echo -e "No APK files with 'Minecraft' in the name found.\n\nMake sure you have an APK in /storage/emulated/0/Download that has the word 'Minecraft' in filename.\n\nError found, stopping patching process...\n"
    printf '%*s\n' "$width" '' | tr ' ' '-'
    exit 1
elif [ ${#files[@]} -eq 1 ]; then
    selected_file="${files[0]}"
    echo -e "Found only one APK file: $selected_file\n\nUsing the only auto-detected file for patching..."
else
    echo -e "\nMultiple APK files found!\nPlease enter the number beside the APK file you want to use:"
    select selected_file in "${files[@]}"; do
        if [ -n "$selected_file" ]; then
            echo -e "\nSelected APK file: $selected_file\n\nUsing chosen file for patching..."
            break
        else
            echo -e "Invalid selection. Please try again.\n"
        fi
    done
fi

printf '%*s\n' "$width" '' | tr ' ' '-'

# Check if the injector file already exists then download
if [ -f "$injector_file" ]; then
    echo -e "Injector file already exists, skipping download.\n"
else
    echo -e "Downloading injector for $arch...\n"
    curl -L -o "$injector_file" "$injector_url"
fi

# Extract the injector
echo -e "\nExtracting the injector..."
tar xvzf "$injector_file"
printf '%*s\n' "$width" '' | tr ' ' '-'

# Run the injector
if ! ./injector "$selected_file" -a "$app" -p "$pack" -o "$out"; then
    echo -e "Patching process failed!\n"
    exit 1
fi

# Move the output file to downloads
mv "$out" /storage/emulated/0/Download

# Done, exit
printf '%*s\n' "$width" '' | tr ' ' '-'
echo -e "Patched Minecraft APK created successfully in Download folder."
printf '%*s\n' "$width" '' | tr ' ' '-'
exit 0
