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

# Allow user to manually set architecture for 30 seconds
echo -e "\nDetected architecture: '$arch'. You have 30 seconds to use architecture other than '$arch' (aarch64 or arm), or press ENTER to continue with detected architecture.\n"
while true; do
    read -t 30 -p "Enter architecture or press ENTER: " manual_arch

    if [[ -z "$manual_arch" ]]; then
        echo -e "\n\nNo architecture entered, continuing with detected architecture.\n"
        break
    elif [[ "$manual_arch" == "aarch64" || "$manual_arch" == "arm" ]]; then
        echo -e "\nWarning: Manually changing architecture can lead to compatibility issues."
        arch=$manual_arch
        echo -e "\nArchitecture manually set to $arch"
        break
    else
        echo -e "Invalid architecture entered, try again.\n"
    fi
done

# Define download URLs based on architecture
case "$arch" in
    aarch64)
        injector_url="https://github.com/mcbegamerxx954/draco-injector/releases/download/v0.1.4/injector-aarch64-linux-android.tar.gz"
        injector_file="injector-aarch64-linux-android.tar.gz"
        ;;
    armv7l | arm)
        injector_url="https://github.com/mcbegamerxx954/draco-injector/releases/download/v0.1.4/injector-armv7-linux-androideabi.tar.gz"
        injector_file="injector-armv7-linux-androideabi.tar.gz"
        ;;
    *)
        echo "Unsupported architecture: $arch"
        exit 1
        ;;
esac

# Function to ask user about architecture
ask_user_about_architecture() {
    while true; do
        read -p "Are you sure that the APK file you are going to patch supports '$arch'? (reply yes or no) " consent
        case "$consent" in
            [Yy][Ee][Ss]|[Yy])
                echo -e "Okay, continuing process...\n"
                break
                ;;
            [Nn][Oo]|[Nn])
                while true; do
                    read -p "Same architecture on device and in APK file gives best compatibility and performance. Are you sure you still wish to continue? (reply yes or no) " confirm
                    case "$confirm" in
                        [Yy][Ee][Ss]|[Yy])
                            echo -e "Okay, forcibly continuing process...\n"
                            break 2
                            ;;
                        [Nn][Oo]|[Nn])
                            echo -e "Abort.\n"
                            exit 1
                            ;;
                        * )
                            echo -e "\nPlease answer yes or no.\n"
                            ;;
                    esac
                done
                ;;
            * )
                echo -e "\nPlease answer yes or no.\n"
                ;;
        esac
    done
}

# Call the function to ask user about architecture
ask_user_about_architecture

# Update and upgrade packages
apt update -y && apt upgrade -y

echo -e "\nSearching for all Minecraft APK files in storage/emulated/0/Download, this may take some time...\n\nPlease enter the number of the desired file after you see a list!\n"

# Magical bash boogaloo to find all APK files having "Minecraft" (case insensitive) in file name, thanks @devendrn
files=()
while IFS= read -r filename; do
  files+=("$filename")
done < <(find /storage/emulated/0/Download -type f -iname '*minecraft*.apk')
if [ ${#files[@]} -eq 0 ]; then
    echo -e "No APK files with 'Minecraft' in the name found.\n"
elif [ ${#files[@]} -eq 1 ]; then
    selected_file="${files[0]}"
    echo -e "Found one APK file: $selected_file\n"
else
    echo -e "\nMultiple APK files found:"
    select selected_file in "${files[@]}"; do
        if [ -n "$selected_file" ]; then
            echo -e "\nSelected APK file: $selected_file\n"
            break
        else
            echo -e "Invalid selection. Please try again.\n"
        fi
    done
fi

# Get important patch info
echo -e "Please enter the following info about Patched Minecraft here...\n"
read -p "App Name: " app
read -p "Package Name (enter a valid name): " pack
read -p "Output File Name (include .apk): " out

package="wget"

# Check if wget package is installed
if dpkg -l | grep -q "^ii  $package "; then
    echo -e "Package '$package' is installed. Continuing process...\n"
else
    echo -e "Package '$package' is not installed. Installing '$package' before continuing.\n"
    if ! apt install wget -y; then
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
    wget "$injector_url"
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
echo -e "\nProcess completed successfully.\n"
exit 0
