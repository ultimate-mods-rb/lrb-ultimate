#!/bin/bash

# Set a variable to track whether the ARK build failed
FAILED_ARK_BUILD=0

# Set the path to wit and arkhelper and check if the script is running on macOS
if [[ $(uname -s) == "Darwin" ]]; then
    echo "Running on macOS"
    # macOS-specific path to wit/arkhelper executable
    WIT_PATH="$(pwd)/dependencies/wit/wit_macos"
    ARKHELPER_PATH="$(pwd)/dependencies/macos/arkhelper"
else
    echo "Not running on macOS"
    # Assume Linux or other Unix-like systems
    WIT_PATH="$(pwd)/dependencies/wit/wit"
    ARKHELPER_PATH="$(pwd)/dependencies/linux/arkhelper"
fi

# Extract ISO using wit
"$WIT_PATH" extract "$PWD/iso" "$PWD/_build/wii"

# Copy patched main.dol and setup.txt
cp -rf "$PWD/dependencies/patch/main.dol" "$PWD/_build/wii/sys"
cp -rf "$PWD/dependencies/patch/setup.txt" "$PWD/_build/wii"

# Copy original main_wii.hdr to appropriate directory
cp "$PWD/dependencies/wii_rebuild_file/main_wii.hdr" "$PWD/_build/wii/files/gen"

# Remove lrb ultimate ark part
rm "$PWD/_build/wii/files/gen/main_wii_2.ark" 2> /dev/null

# Move the folder "songs_wii" into "_ark" and rename it to "songs"
echo "Temporarily moving Wii songs folder into ark"
mv "$PWD/_songs/songs_wii" "$PWD/_ark/songs"

# Temporarily move Xbox and Wii files out of the ARK path to reduce final ARK size
#echo
#echo "Temporarily moving Xbox and PS3 files out of the ark path to reduce final ARK size"
#find "$PWD/_ark" \( -name "*.milo_xbox" -o -name "*.png_xbox" -o -name "*.bmp_xbox" -o -name "*.milo_ps3" -o -name "*.png_ps3" -o -name "*.bmp_ps3" \) -exec mv -t "$PWD/_temp/_ark" {} +

# Create patched files using arkhelper
"$ARKHELPER_PATH" patchcreator "$PWD/_build/wii/files/gen/main_wii.hdr" "$PWD/dependencies/patch/main.dol" -a "$PWD/_ark" -o "$PWD/_build/wii/files/gen/temp"
if [ $? -ne 0 ]; then
    FAILED_ARK_BUILD=1
fi

# Move/delete patchcreator files
mv "$PWD/_build/wii/files/gen/temp/gen/main_wii.hdr" "$PWD/_build/wii/files/gen/main_wii.hdr"
mv "$PWD/_build/wii/files/gen/temp/gen/main_wii_2.ark" "$PWD/_build/wii/files/gen/main_wii_2.ark"
rm -r "$PWD/_build/wii/files/gen/temp"

# Moving back Xbox files
#echo
#echo "Moving back Xbox files"
#find "$PWD/_temp/_ark" \( -name "*.milo_xbox" -o -name "*.png_xbox" -o -name "*.bmp_xbox" -o -name "*.milo_ps3" -o -name "*.png_ps3" -o -name "*.bmp_ps3" \) -exec mv -t "$PWD/_ark" {} + 2> /dev/null

# Move the folder "songs" back to the original directory and rename it to "songs_wii"
echo "Moving back Wii song folder"
mv "$PWD/_ark/songs" "$PWD/_songs/songs_wii"

# Check if the ARK build failed and provide appropriate message
echo
if [ "$FAILED_ARK_BUILD" -ne 1 ]; then
    echo "Successfully built LEGO Rock Band Ultimate ARK files. Make sure to add _build/wii as a game path in Dolphin and enable search subfolders so it will show up."
else
    echo "Error building ARK. Download the repo again or some dta file is bad p.s turn echo on to see what arkhelper says"
fi

# Pause to keep terminal open
read -p "Press Enter to continue..."
