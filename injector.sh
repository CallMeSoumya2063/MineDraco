#!/bin/bash

# Setup storage permission for Termux if necessary
directory="$HOME/storage"
if [ -d "$directory" ]; then
    echo -e "\nTermux's storage is already setup, skipping storage setup.\n"
else
    termux-setup-storage
fi

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
        exit 1
        ;;
esac

# Get important patch info
echo -e "Please enter the following info about Patched Minecraft here...\n"
read -p "App Name: " app
read -p "Package Name (enter a valid name): " pack
read -p "Output File Name (include .apk): " out

echo -e "\nSearching for all Minecraft APK files in storage/emulated/0/Download, this may take some time...\n\n"

# Magical bash boogaloo to find all APK files having "Minecraft" (case insensitive) in file name, thanks @devendrn
files=()
while IFS= read -r filename; do
  files+=("$filename")
done < <(find /storage/emulated/0/Download -type f -iname '*minecraft*.apk')
if [ ${#files[@]} -eq 0 ]; then
    echo -e "No APK files with 'Minecraft' in the name found.\nMake sure you have an APK in /storage/emulated/0/Download that has the word 'Minecraft' in filename.\nError found, stopping process...\n"
    exit 1
elif [ ${#files[@]} -eq 1 ]; then
    selected_file="${files[0]}"
    echo -e "Found only one APK file: $selected_file\nUsing the only auto-detected file for patching...\n"
else
    echo -e "\nMultiple APK files found!\nPlease enter the number beside the APK file you want to use:"
    select selected_file in "${files[@]}"; do
        if [ -n "$selected_file" ]; then
            echo -e "\nSelected APK file: $selected_file\nUsing chosen file for patching...\n"
            break
        else
            echo -e "Invalid selection. Please try again.\n"
        fi
    done
fi

package="curl"

# Check if curl is installed, install if necessary
if dpkg -l | grep -q "^ii  $package "; then
    echo -e "Package '$package' is installed. Continuing process...\n"
else
    echo -e "Package '$package' is not installed. Installing '$package' before continuing.\n"
    if ! apt install curl -y; then
        echo -e "Failed to install package '$package'\n"
        exit 1
    fi
    echo -e "Package '$package' has been installed successfully. Continuing process...\n"
fi

# Check if the injector file already exists then download
if [ -f "$injector_file" ]; then
    echo -e "Injector file already exists, skipping download.\n"
else
    echo -e "Downloading injector for '$arch...'\n"
    curl -L -o "$injector_file" "$injector_url"
fi

# Extract the injector
echo -e "Extracting the injector...\n"
tar xvzf "$injector_file"

# Run the injector
if ! ./injector "$selected_file" -a "$app" -p "$pack" -o "$out"; then
    echo -e "Injector failed\n"
    exit 1
fi

# Move the output file to downloads
mv "$out" /storage/emulated/0/Download

# Done, exit
echo -e "\nPatched Minecraft APK created successfully in Download folder.\n"
exit 0
