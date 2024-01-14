#!/bin/bash

# Function to rename files
rename_files() {
  for file in "$1"/*.{png,jpg,jpeg}; do
    if [[ -f $file ]]; then
      base_name=$(basename "$file")
      
      # Exclude previously renamed files
      if [[ $base_name =~ ^((season-specials-poster|show|Season.*|.*S.*E.*)\.(png|jpg|jpeg))$ ]]; then
          continue
      fi

      # Check for * - Season *
      if [[ $base_name =~ (.*)\ -\ Season\ ([0-9]+)\.(png|jpg|jpeg) ]]; then
        new_name="Season ${BASH_REMATCH[2]}.${BASH_REMATCH[3]}"
      # Check for * - Specials
      elif [[ $base_name =~ (.*)\ -\ Specials\.(png|jpg|jpeg) ]]; then
        new_name="season-specials-poster.${BASH_REMATCH[2]}"
      # Default to show for other files
      else
        new_name="show.${base_name##*.}"
      fi
      
      # Rename the file
      mv "$file" "$1/$new_name"
    fi
  done
}

# Check if a directory is provided as a command-line argument
if [ -z "$1" ]; then
  base_dir="."
else
  base_dir="$1"
fi

# Loop through each subdirectory in the base directory and call the function
for dir in "$base_dir"/*/; do
  rename_files "$dir"
done
