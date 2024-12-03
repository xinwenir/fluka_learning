#!/bin/bash
# Get the current working directory
Work_Path=$(pwd)/.. 
echo "Working path: $Work_Path"
cd "$Work_Path"

#-------------------------------library check part--------------------------
Distributor=$(lsb_release -i)
Distributor=${Distributor##*:}
# 使用tr命令删除开头和结尾的空格
Distributor=$(tr -d '[:space:]' <<< $Distributor)
echo "DEBUG: Distributor value is: [${Distributor}]"

Release=$(lsb_release -r)
Release=${Release##*:}
# 使用tr命令删除开头和结尾的空格
Release=$(tr -d '[:space:]' <<< $Release)
echo "DEBUG: Release value is: [${Release}]"

if [ "${Distributor}" != "Ubuntu" ]; then
    printf "Sorry, this file can not support $Distributor now!\n"
    exit 0
fi

case ${Release} in
    "20.04")
        dependentPackage=("build-essential" "cmake" \
                            "python3-dev" "python3-tk" \
                            "gfortran" "libx11-dev" "wget")
                ;;
    "22.04")
        dependentPackage=("build-essential" "cmake" \
                            "python3-dev" "python3-tk" \
                            "gfortran" "libx11-dev" "wget")
                ;;
    *)
        printf "Sorry, this file only supports Ubuntu 20.04 and 22.04 currently!\n"
        exit 0
        ;;
esac

printf "\033[36;1m==========check dependent package============\033[0m\n"

uninstallNumber=0
uninstallIdx=()

index=0
while [ "${index}" -lt "${#dependentPackage[*]}" ]; do
    printf "%s  " ${dependentPackage[$index]}
    p_check=$(dpkg -l | grep ${dependentPackage[$index]})
    if [ -z "$p_check" ]; then
        printf "\033[36;1m[uninstalled]\033[0m\n"
        uninstallIdx[${uninstallNumber}]=$index
        let "uninstallNumber++"
    else
        printf "\033[36;1m[installed]\033[0m\n"
    fi
    let "index++"
done

set -e

idx=0
while [ $idx -lt $uninstallNumber ]; do
    printf "\033[36;1m==========install dependent package============\033[0m\n"
    #check which should be installed now
    printf "\033[45;5m%s\033[0m " ${dependentPackage[${uninstallIdx[$idx]}]}
    #install
    if ! echo "1" | sudo -S apt install -y ${dependentPackage[${uninstallIdx[$idx]}]}; then
        printf "Error installing %s: %s\n" ${dependentPackage[${uninstallIdx[$idx]}]} $?
    fi

    sleep 1
    let "idx++"
done

#----------------------file check part-----------------------------

# Define a function to download the file
download_and_process_file() {
    local url="$1"
    local file_name=$(basename "$url")

    echo "Downloading the file from the internet: $file_name"
    if ! wget "$url"; then
        echo -e "\033[31;1mError: Failed to download the file $file_name. Please check the network connection or if the URL is correct!\033[0m"
        exit 1
    fi

    check_and_extract_file "$file_name"
}

# Define a function to check, extract the file and perform subsequent operations
check_and_extract_file() {
    local file="$1"
    local suffix=${file: -6}
    local file_base_name=$(basename "$file" ".tar.gz")

    if [ "$suffix" == "tar.gz" ]; then
        if [ -f "$file" ]; then
            echo "The file $file exists, extracting..."
            tar -xzvf "$file"
            echo -e "\033[36;1m===============Checking source file ended================\033[0m"

            mkdir "./$file_base_name"
            tar -vzxf "$file" -C "./$file_base_name" --strip-components 1

            cd "./$file_base_name/unix"
            ./configure
            make
            sudo make install
            sleep 1
        else
            echo -e "\033[31;1mError: The file $file does not exist. Please check the path or redownload it!\033[0m"
            exit 1
        fi
    else
        echo -e "\033[31;1mError: Incorrect file suffix. Expected 'tar.gz', but got $suffix. Please check the file!\033[0m"
        exit 1
    fi
}

# Output the prompt message for starting to check the source file
echo -e "\033[36;1m=================Checking source file=================\033[0m"

# Get the number of arguments passed to the script
# num_args=$#
tcl_package=$(find "$Work_Path" -type f -name "tcl*.tar.gz" | head -n 1)
tk_package=$(find "$Work_Path" -type f -name "tk*.tar.gz" | head -n 1)
cd "$Work_Path"
if [ -f "$tcl_package" ]; then
    check_and_extract_file "$tcl_package"
else
    echo "Install tk/tcl from the internet"

    cd "$Work_Path"
    # Download and process the tcl file
    tcl_url="http://prdownloads.sourceforge.net/tcl/tcl9.0.0-src.tar.gz"
    download_and_process_file "$tcl_url"
fi

cd "$Work_Path"
if [ -f "$tk_package" ]; then
    check_and_extract_file "$tk_package"
else
    echo "Install tk/tcl from the internet"

    cd "$Work_Path"
    # Download and process the tk file
    tk_url="http://prdownloads.sourceforge.net/tcl/tk9.0.0-src.tar.gz"
    download_and_process_file "$tk_url"
fi
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
