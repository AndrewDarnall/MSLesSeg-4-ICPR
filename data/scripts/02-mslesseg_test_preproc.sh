#!/bin/bash

# This script provides preprocessing for the Test set of MSLesSeg into BraTs 2021 format

# Check if path and counter value are provided
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <PATH-to-directory> <starting-counter>"
    exit 1
fi

input_path="$1"
original_counter="$2"
counter="$original_counter"  # Initialize the counter with the given value

echo "Step 1: Moving all files from subdirectories to the input directory..."

# Find and move all .nii.gz files to the input directory
find "$input_path" -mindepth 2 -type f -name "*.nii.gz" -exec mv {} "$input_path" \;

# Remove all subdirectories after moving the files
echo "Step 2: Removing empty directories..."
find "$input_path" -mindepth 1 -type d -exec rm -rf {} +

echo "Step 3: Grouping files with the same prefix into MSLS directories..."

# Extract unique prefixes from filenames (P* part before the first underscore)
prefixes=($(ls "$input_path"/P*_*.nii.gz 2>/dev/null | sed -E 's|.*/([^_]*)_.*|\1|' | sort -u))

# Check if no files are found
if [ ${#prefixes[@]} -eq 0 ]; then
    echo "No files found for grouping. Exiting."
    exit 1
fi

# Process each unique prefix
for prefix in "${prefixes[@]}"; do
    formatted_counter=$(printf "%03d" $counter)
    target_dir="$input_path/MSLS_${formatted_counter}"
    
    # Create directory if it doesn't exist
    mkdir -p "$target_dir"

    # Move all files with the same prefix into the directory
    mv "$input_path"/${prefix}_*.nii.gz "$target_dir/"
    echo "  Moved files with prefix $prefix to $target_dir"

    # Increment counter for the next prefix
    ((counter++))
done

# Reset counter to the original value
counter="$original_counter"

echo "Step 4: Renaming files inside MSLS directories (P*_ -> MSLS_$counter_*)..."

# Iterate through each MSLS directory and rename files
for dir in "$input_path"/MSLS_*/; do
    if [ -d "$dir" ]; then
        formatted_counter=$(printf "%03d" $counter)
        
        for file in "$dir"/P*_*.nii.gz; do
            if [ -f "$file" ]; then
                new_file=$(echo "$file" | sed -E "s|/P[0-9]+_|/MSLS_${formatted_counter}_|")
                echo "  Renaming: $file -> $new_file"
                mv "$file" "$new_file"
            fi
        done

        # Increment counter for the next directory
        ((counter++))
    fi
done

echo "Step 5: Final renaming (_T1, _T2, _FLAIR, _MASK changes)..."

# Iterate through MSLS directories and rename file suffixes
for dir in "$input_path"/MSLS_*/; do
    if [ -d "$dir" ]; then
        for file in "$dir"/MSLS_*.nii.gz; do
            if [ -f "$file" ]; then
                new_file=$(echo "$file" | sed -E 's/_T1\.nii\.gz$/_t1.nii.gz/;
                                                 s/_T2\.nii\.gz$/_t2.nii.gz/;
                                                 s/_FLAIR\.nii\.gz$/_flair.nii.gz/;
                                                 s/_MASK\.nii\.gz$/_seg.nii.gz/')
                if [ "$file" != "$new_file" ]; then
                    echo "  Renaming: $file -> $new_file"
                    mv "$file" "$new_file"
                fi
            fi
        done
    fi
done

echo "Processing complete!"
