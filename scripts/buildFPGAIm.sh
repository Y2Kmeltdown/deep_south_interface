#!/bin/bash

# Check if at least one argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <filename>"
  exit 1
fi

# Store the first argument in a variable for clarity
filename="$1"

# Check if the file exists and is a regular file
if [ -f "$filename" ]; then
  projectName="${filename%.*}"
  quartus_sh --flow compile $projectName
  if [ $? -eq 0 ]; then
    echo "Quartus compilation successful!"
  else
    echo "Quartus compilation failed. Exit code: $?"
    exit 1 # Exit the script with a failure code
  fi
else
  echo "'$filename' does not exist or is not a regular file."
  exit 1 # Exit the script with a failure code
fi
exit 0
