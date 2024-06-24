#!/bin/bash

# Directory containing images passed as the first command-line argument
DIR_PATH="$1"

# E-book name extracted from the directory name
EBOOK_NAME=$(basename "$DIR_PATH")

# Output markdown file name
MD_FILE="${EBOOK_NAME}.md"

# Clear existing markdown file
echo "" > "$MD_FILE"

# Default sorting order is ascending
MAIN_SORT_ORDER="ascending"
COVER_SORT_ORDER="ascending"

# Check if the second argument is provided and set the sorting order accordingly
if [ "$#" -gt 1 ] && [ "$2" == "-d" ]; then
    MAIN_SORT_ORDER="descending"
elif [ "$#" -gt 1 ] && [ "$2"!= "-d" ]; then
    echo "Invalid sorting option for main images. Use '-d' for descending."
    exit 1
fi

# Check if the third argument is provided and set the cover sorting order accordingly
if [ "$#" -gt 2 ] && [ "$3" == "-d" ]; then
    COVER_SORT_ORDER="descending"
elif [ "$#" -gt 2 ] && [ "$3"!= "-d" ]; then
    echo "Invalid sorting option for cover image. Use '-d' for descending."
    exit 1
fi

# Generate markdown content for each image wrapped in divs, sorted by filename
if [ "$MAIN_SORT_ORDER" == "ascending" ]; then
    ls -v "$DIR_PATH"/*.jpg | tail -n +2 | while read -r img; do
        BASENAME=$(basename "$img")
        ALT_TEXT="${BASENAME%.*}" # Extracts the base name excluding the extension
        echo "<div><img src=\"$img\" alt=\"$ALT_TEXT\"></div>" >> "$MD_FILE"
    done
else
    ls -vr "$DIR_PATH"/*.jpg | tail -n +2 | while read -r img; do
        BASENAME=$(basename "$img")
        ALT_TEXT="${BASENAME%.*}" # Extracts the base name excluding the extension
        echo "<div><img src=\"$img\" alt=\"$ALT_TEXT\"></div>" >> "$MD_FILE"
    done
fi

# Find the image with the smallest numeric value in its name for the cover
if [ "$COVER_SORT_ORDER" == "ascending" ]; then
    # Using ls -v for natural sorting
    COVER_IMAGE=$(ls -v "$DIR_PATH"/*.jpg | sort -n | head -n 1)
else
    # Reverse the order for descending sort
    COVER_IMAGE=$(ls -vr "$DIR_PATH"/*.jpg | sort -n | head -n 1)
fi

if [ -z "$COVER_IMAGE" ]; then
    echo "No suitable image found in $DIR_PATH."
else
    # Convert markdown to epub
    ebook-convert "$MD_FILE" "${EBOOK_NAME}.epub" --formatting-type markdown --cover "$COVER_IMAGE" --title "$EBOOK_NAME"
fi

# Remove the temporary markdown file
rm "$MD_FILE"
