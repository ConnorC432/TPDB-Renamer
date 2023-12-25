#!/bin/bash

# Function to rename files
rename_to_poster() {
  for file in "$1"/*.{png,jpg,jpeg}; do
    if [[ -f $file ]]; then
      base_name=$(basename "$file")

      # Exclude renamed files
      if [[ $base_name =~ ^poster\.(png|jpg|jpeg)$ ]]; then
          continue
      fi


      new_name="poster.${base_name##*.}"

      # Rename the file
      mv "$file" "$1/$new_name"
    fi
  done
}

# Check if a base directory is provided as a command-line argument
if [ -z "$1" ]; then
  base_dir="."
else
  base_dir="$1"
fi

# Loop through each directory in the base directory and call the function
for dir in "$base_dir"/*/; do
  rename_to_poster "$dir"
done
