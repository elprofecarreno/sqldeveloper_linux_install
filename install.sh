#!/bin/bash
# LOAD CONFIGURATION
source ./config.env

# FIN CURL VERSION
version=$(curl --version | grep -oP '^curl \K[0-9]+\.[0-9]+\.[0-9]+')#
# VALIDATE CURL 
if [ -z "$version" ]; then
    echo "NOT INSTALLING CURL"
else
    echo "CURL OK : $version"
    echo "DELETE ZIP + SQLDEVELOPER"
    rm -rf *.zip
    rm -rf sqldeveloper
    rm -rf "$HOME/sqldeveloper"
    echo "START DOWNLOAD: $URL_SQLDEVELOPER"  
    curl -O -S $URL_SQLDEVELOPER
    echo "FINISH DOWNLOAD"
    
    file=$(ls | grep zip)
    
    if [ -z "$file" ]; then
        echo "ERROR DOWNLOAD SQLDEVELOPER"
    else
    	echo "DOWNLOAD OK : $file"
    	echo "UNZIP FILE"
    	unzip -q *.zip
    	file=$(ls | grep -x "sqldeveloper")
    	
    	if [ -z "$file" ]; then
        	echo "ERROR UNZIP FILE"
    	else
    		echo "UNZIP FILE: OK"
    		echo "MOVE sqldeveloper TO $HOME/sqldeveloper"
    		mv sqldeveloper "$HOME/sqldeveloper"
    		echo "CREATE ICON"
            cp sqldeveloper.desktop.template sqldeveloper.desktop
            sed -i "s|\$HOME|$HOME|g" sqldeveloper.desktop
            mv sqldeveloper.desktop "$HOME/.local/share/applications/sqldeveloper.desktop"
    		echo "PERMISSION ICON"
    		chmod +x "$HOME/.local/share/applications/sqldeveloper.desktop"
    		echo "UPDATE DESKTOP ICON"
    		update-desktop-database "$HOME/.local/share/applications/sqldeveloper.desktop"
            rm -rf *.zip
            echo "DELETE FOLDER sqldeveloper_install"
    	fi
    fi
fi
