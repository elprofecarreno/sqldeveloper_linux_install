#!/bin/bash
# LOAD CONFIGURATION
source ./config.env

# FIND CURL VERSION
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

            echo "START DOWNLOAD: JDK from $URL_JDK"
            curl -O -S $URL_JDK
            echo "FINISH DOWNLOAD JDK"

            jdk_file=$(basename $URL_JDK)

            if [ -f "$jdk_file" ]; then
                echo "DOWNLOAD OK: $jdk_file"
                echo "EXTRACT JDK"
                tar -xzf "$jdk_file"
                jdk_dir=$(tar -tf "$jdk_file" | head -1 | cut -f1 -d"/")

                if [ -d "$jdk_dir" ]; then
                    echo "MOVE JDK TO $HOME/sqldeveloper"
                    mv "$jdk_dir" "$HOME/sqldeveloper/"
                    echo "JDK COPIED"

                    # === MODIFICAR sqldeveloper.conf ===
                    conf_file="$HOME/sqldeveloper/sqldeveloper/bin/sqldeveloper.conf"
                    java_home_path="\$HOME/sqldeveloper/$jdk_dir/"
                    if [ -f "$conf_file" ]; then
                        echo "INSERT SetJavaHome IN CONFIG"
                        sed -i "1aSetJavaHome $java_home_path" "$conf_file"
                        echo "sqldeveloper.conf UPDATED"
                    else
                        echo "ERROR: sqldeveloper.conf NOT FOUND"
                    fi

                else
                    echo "ERROR EXTRACTING JDK"
                fi

                echo "CLEANING UP JDK TAR"
                rm -f "$jdk_file"
            else
                echo "ERROR DOWNLOADING JDK"
            fi
        fi
    fi
fi
