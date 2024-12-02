#!/bin/bash
#-------------------------------library check part--------------------------
Distributor='lsb_release -i'
Distributor=${Distributor##*:}
Release='lsb_release -r'
Release=${Release##*:}

if [ ${Distributor} != "Ubuntu" ];
then
    printf "Sorry, this file can not support $Distributor now!"
    exit 0
fi
case $Release in
    "20.04")
        dependentPackage=("build-essential" "cmake"\
                            "python3-dev" "python3-tk"
                            "gfortran")
                ;;
    "22.04")
        dependentPackage=("build-essential" "cmake"\
                            "python3-dev" "python3-tk"
                            "gfortran")
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
while(($index<${#dependentPackage[*]}))
do
    printf "%s  " ${dependentPackage[$index]}
    p_check='dpkg -l | grep ${dependentPackage[$index]}'
    if [ "$p_check"x == ""x]
    then
        printf "\033[36;1m[uninstalled]\033[0m\n"
        uninstallIdx[${uninstallNumber}]=$index
        let "uninstallNumber++"
    else
        printf "\033[36;1m[installed]\033[0m\n"
    end
    let "index++"
done

set -e

idx=0
while(($idx<$uninstallNumber))
do
    printf "\033[36;1m==========install dependent package============\033[0m\n"
    #check which should be installed now
    printf "\033[45;5m%s\033[0m " ${dependentPackage[${uninstallIdx[idx]}]}
    #install
    if! sudo apt install -y ${dependentPackage[${uninstallIdx[idx]}]}; then
        printf "Error installing %s: %s\n" ${dependentPackage[${uninstallIdx[idx]}]} $?
    fi
    sleep 1
    clear
    let "idx++"
done

#----------------------file check part-----------------------------

# Define a function to download the file
download_and_process_file() {
    local url="$1"
    local file_name=$(basename "$url")

    echo "Downloading the file from the internet: $file_name"
    if! wget "$url"; then
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

    if [ "$suffix"x == "tar.gz"x ]; then
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
            clear
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
num_args=$#

if [ $num_args == 1 ]; then
    file=$1
    check_and_extract_file "$file"
else
    echo "Install tk/tcl from the internet"

     # Check if wget is already installed
    local wget_check=$(dpkg -l | grep 'wget')
    if [ "$wget_check"x == ""x ]; then
        echo "Installing the wget tool..."
        if! sudo apt install -y wget; then
            echo -e "\033[31;1mError: Failed to install wget. Please check the network connection or the software sources!\033[0m"
            exit 1
        fi
    fi

    # Download and process the tcl file
    local tcl_url="http://prdownloads.sourceforge.net/tcl/tcl9.0.0-src.tar.gz"
    download_and_process_file "$tcl_url"

    # Download and process the tk file
    local tk_url="http://prdownloads.sourceforge.net/tcl/tk9.0.0-src.tar.gz"
    download_and_process_file "$tk_url"
fi

#-----------------FLUKA Installation--------------------------
# Check FLUKA package
fluka_package="fluka2024.1-linux-gfor64bit-yy-glibczzAA.tar.gz"

if [ -f "$fluka_package" ]; then
    echo "The file $fluka_package exists, extracting..."
    echo -e "\033[36;1m===============Checking source file ended================\033[0m"

    mkdir /home/zxw/fluka
    export FLUPRO=/home/zxw/fluka
    export FLUFOR=gfortran

    cp "$fluka_package" $FLUPRO
    cd $FLUPRO

    tar -zxvf "$fluka_package"

    # Execute make command and check its result
    if! make; then
        echo -e "\033[31;1mError: The make command failed during FLUKA installation. Please check for errors in the source code or missing dependencies!\033[0m"
        exit 1
    fi

    # Edit.bashrc file to add environment variables
    if grep -q "FLUPRO=/home/zxw/fluka" ~/.bashrc && grep -q "FLUFOR=gfortran" ~/.bashrc; then
        echo -e "\033[33;1mWarning: The environment variables FLUPRO and FLUFOR are already set in.bashrc. Skipping addition.\033[0m"
    else
        echo -e "\033[32;1mAdding environment variables to.bashrc...\033[0m"
        echo "export FLUPRO=/home/zxw/fluka" >> ~/.bashrc
        echo "export FLUFOR=gfortran" >> ~/.bashrc

        # Save and close the.bashrc file using sed
        sed -i's/^$/exit\n/' ~/.bashrc
    end

    sleep 1
    clear
else
    echo -e "\033[31;1mError: The file $fluka_package does not exist. Please check the path or redownload it!\033[0m"
    exit 1
fi




#echo -e "\e[1;92mInstall Dependent Software Packages..."
#sudo apt update && sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
#sudo apt install -y python3-dev python3-tk
#echo -e "\e[1;92mIPoint the "python" command to python3."
#sudo ln -s /usr/bin/python3 /usr/bin/python
#echo -e "\e[1;92mIPoint the "python-config" command to python3-config."
#sudo ln -s /usr/bin/python3-config /usr/bin/python-config
#export DISPLAY=:0
#echo $DISPLAY
#echo -e "\e[1;92mInstall Dependent Software Packages for Geoviewer..."
#sudo apt-get install -y make gcc build-essential tcl-dev tk-dev 


