#!/bin/bash

# Set FAILED_ARK_BUILD variable to 0
FAILED_ARK_BUILD=0

# Set the path to arkhelper and check if the script is running on macOS
if [[ $(uname -s) == "Darwin" ]]; then
    echo "Running on macOS"
    # macOS-specific path to arkhelper executable
    ARKHELPER_PATH="$(pwd)/dependencies/macos/arkhelper"
else
    echo "Not running on macOS"
    # Assume Linux or other Unix-like systems
    ARKHELPER_PATH="$(pwd)/dependencies/linux/arkhelper"
fi

#echo
#echo "Temporarily moving PS3 files out of the ark path to reduce final ARK size"
#find "$PWD/_ark" -type f \( -name "*.milo_ps3" -o -name "*.png_ps3" -o -name "*.bmp_ps3" \) -exec mv {} "$PWD/_temp/_ark" \;

# Move the folder "songs_xbox" into "_ark" and rename it to "songs"
echo "Temporarily moving Xbox songs folder into ark"
mv "$PWD/_songs/songs_xbox" "$PWD/_ark/songs"

echo
echo "Building Xbox ARK"
"$ARKHELPER_PATH" dir2ark "$PWD/_ark" "$PWD/_build/xbox/gen" -n "patch_xbox" -e -v 5 -s 4073741823
if [ $? -ne 0 ]; then
    FAILED_ARK_BUILD=1
fi

#echo
#echo "Moving back PS3 files"
#find "$PWD/_temp/_ark" -type f \( -name "*.milo_ps3" -o -name "*.png_ps3" -o -name "*.bmp_ps3" \) -exec mv {} "$PWD/_ark" \;
#rm -rf "$PWD/_temp"

# Move the folder "songs" back to the original directory and rename it to "songs_xbox"
echo "Moving back Xbox song folder"
mv "$PWD/_ark/songs" "$PWD/_songs/songs_xbox"

echo
if [ $FAILED_ARK_BUILD -ne 1 ]; then
    echo "Successfully built LEGO Rock Band Ultimate ARK. You may find the files needed to place on your Xbox 360 in /_build/xbox/"
else
    echo "Error building ARK. Check your modifications."
fi

echo
read -p "Press Enter to continue..."
