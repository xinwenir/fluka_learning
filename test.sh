#!/bin/bash

# Get the current working directory
Work_Path=$(pwd)/..
echo "Working path: $Work_Path"

#-----------------FLUKA Installation--------------------------

cd "$Work_Path"

# Correcting the syntax for variable assignment
fluka_install_path="$Work_Path/fluka"

# Create the fluka installation path if it doesn't exist
if [ ! -d "$fluka_install_path" ]; then
    mkdir -p "$fluka_install_path"
fi

# Check FLUKA package
fluka_package=$(find "$Work_Path" -type f -name "fluka2024*.tar.gz" | head -n 1)

if [ -f "$fluka_package" ]; then
    echo "The file $fluka_package exists, extracting..."
    echo -e "\033[36;1m===============Checking source file ended================\033[0m"

    # Set FLUPRO and FLUFOR environment variables
    export FLUPRO="$fluka_install_path"
    export FLUFOR=gfortran

    # Copy the FLUKA package to the installation directory
    cp "$fluka_package" "$FLUPRO"

    cd "$FLUPRO"

    # Extract the FLUKA package
    tar -zxvf "$fluka_package"

    # Execute make and check its result
    if ! make; then
        echo -e "\033[31;1mError: The make command failed during FLUKA installation. Please check for errors in the source code or missing dependencies!\033[0m"
        exit 1
    fi

    # Check if environment variables are already set in .bashrc
    if grep -q "FLUPRO=$FLUPRO" ~/.bashrc && grep -q "FLUFOR=gfortran" ~/.bashrc; then
        echo -e "\033[33;1mWarning: The environment variables FLUPRO and FLUFOR are already set in .bashrc. Skipping addition.\033[0m"
    else
        echo -e "\033[32;1mAdding environment variables to .bashrc...\033[0m"
        echo "export FLUPRO=$FLUPRO" >> ~/.bashrc
        echo "export FLUFOR=gfortran" >> ~/.bashrc
    fi

    # Wait before finishing
    sleep 1
else
    echo -e "\033[31;1mError: The file $fluka_package does not exist. Please check the path or redownload it!\033[0m"
    exit 1
fi
