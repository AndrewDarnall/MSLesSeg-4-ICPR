#!/bin/bash

# Provides a SegFormer3D-compliant preprocessing of the MSLesSeg dataset

# Check if a path is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <PATH-to-train-set-ONLY>"
    exit 1
fi

input_path="$1"
counter=0  # Initialize the counter

echo "Step 1: Renaming files and incrementing counter for each subdirectory..."

# Iterate over all P* directories
for patient_dir in "$input_path"/P*/; do
    if [ -d "$patient_dir" ]; then
        echo "Processing patient directory: $patient_dir"

        # Iterate over each T* subdirectory inside P*
        for scan_dir in "$patient_dir"*/; do
            if [ -d "$scan_dir" ]; then
                echo "  Processing scan directory: $scan_dir"

                # Format counter with "%03d"
                formatted_counter=$(printf "%03d" $counter)

                # Define renaming patterns
                declare -A patterns
                patterns=(
                    ["T1"]="*_T*_T1.nii.gz"
                    ["T2"]="*_T*_T2.nii.gz"
                    ["FLAIR"]="*_T*_FLAIR.nii.gz"
                    ["MASK"]="*_T*_MASK.nii.gz"
                )

                # Rename files
                for key in "${!patterns[@]}"; do
                    for file in "$scan_dir"/${patterns[$key]}; do
                        if [ -f "$file" ]; then
                            new_name="$scan_dir/MSLS_${formatted_counter}_${key}.nii.gz"
                            echo "    Renaming: $file -> $new_name"
                            mv "$file" "$new_name"
                        fi
                    done
                done

                # Increment counter for every new T* subdirectory
                ((counter++))
            fi
        done
    fi
done

echo "Step 2: Moving renamed files to the input path and deleting subdirectories..."

# Move all renamed files to the input directory
find "$input_path" -type f -name "MSLS_*.nii.gz" -exec mv {} "$input_path" \;

# Remove all original directories (P* and subdirectories)
find "$input_path" -mindepth 1 -type d -exec rm -rf {} +

echo "Step 3: Organizing files into MSLS directories..."

# Reset counter for grouping
counter=0  

while true; do
    formatted_counter=$(printf "%03d" $counter)
    
    # Find all files matching MSLS_$counter_*.nii.gz
    matching_files=("$input_path"/MSLS_"$formatted_counter"_*.nii.gz)

    # If no files are found, break the loop
    if [ ! -e "${matching_files[0]}" ]; then
        break
    fi

    target_dir="$input_path/MSLS_${formatted_counter}"

    # Create directory if it doesn't exist
    mkdir -p "$target_dir"

    # Move all matched files into the corresponding directory
    mv "${matching_files[@]}" "$target_dir/"

    echo "  Moved ${#matching_files[@]} files to $target_dir/"

    # Increment counter
    ((counter++))
done

echo "Step 4: Final renaming (lowercase T1, T2, FLAIR; MASK to seg)..."

# Iterate through each MSLS directory and rename files accordingly
for dir in "$input_path"/MSLS_*/; do
    if [ -d "$dir" ]; then
        for file in "$dir"/MSLS_*.nii.gz; do
            if [ -f "$file" ]; then
                new_file=$(echo "$file" | sed -E 's/_T1\.nii\.gz$/_t1.nii.gz/; 
                                                 s/_T2\.nii\.gz$/_t2.nii.gz/; 
                                                 s/_FLAIR\.nii\.gz$/_flair.nii.gz/;
                                                 s/_MASK\.nii\.gz$/_seg.nii.gz/')
                if [ "$file" != "$new_file" ]; then
                    echo "    Renaming: $file -> $new_file"
                    mv "$file" "$new_file"
                fi
            fi
        done
    fi
done

echo "Processing complete!"
