#!/bin/bash

# Makes a sample.txt that contains all the locations of the files in the G-bucket
# Finds the read pairs (SAMPLE123_r1.fq.gz and SAMPLE123_r2.fq.gz)
# Pushes these pairs onto BRVRC assembly 

# INPUTS:
# G Bucket location of reads
# Location where the raw reads will be loaded on BVBRC
# Location where the output assembly will be placed in BVBRC

if [ -e "samples.txt" ]; then
  # If it exists, remove it
  rm "samples.txt"
  echo "samples.txt has been removed."
else
  echo "samples.txt does not exist in the current working directory."
fi

# User input 
read -p "Google Bucket Location: " gbucket
read -p "BVBRC Location: " bvbrc_location
read -p "BVBRC raw reads location: " raw_location

if gsutil -q ls "$gbucket" > samples.txt; then
  echo "File exists."
else
  echo "File does not exist."
  exit 1
fi


count_this = 0
prev_line="" 

# Read the list of file locations from the input file and find pairs
while IFS= read -r current_line; do
  # Extract the file name by removing the path
  current_basename=$(basename "$current_line")

  # Extract the common prefix by removing the last portion of the file name
  # Use this as BVBRC file name
  current_prefix="${current_basename%_R*}"

  # Check if the current line has the same common prefix as the previous line
  if [ "$current_prefix" = "$prev_prefix" ]; then
    file_1=$(basename "$prev_line")
    file_2=$(basename "$current_line")

    echo "$file_1"
    echo "$file_2"

    temp_file1=$(mktemp "/tmp/$file_1")
    temp_file2=$(mktemp "/tmp/$file_2")
    
    gsutil cp $prev_line $temp_file1
    gsutil cp $current_line $temp_file2

    # submits a job into BVBRC
    p3-submit-genome-assembly --workspace-upload-path $raw_location --recipe unicycler --paired-end-lib $temp_file1 $temp_file2 $bvbrc_location $current_prefix && echo " ## ASSEMBLY!"
    count_this=$((count_this + 1))
  fi

  # Set the current prefix as the previous prefix for the next iteration
  prev_prefix="$current_prefix"
  prev_line="$current_line"
  
done < samples.txt