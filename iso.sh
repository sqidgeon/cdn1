#!/bin/bash

# Simple Debian ISO Downloader

clear

echo "==============================="
echo "     Linux ISO Downloader"
echo "==============================="
echo
echo "1) Debian"
echo "2) Exit"
echo

read -p "Select an option: " main_choice

case $main_choice in
    1)
        clear
        echo "==============================="
        echo "          Debian Menu"
        echo "==============================="
        echo
        echo "1) Debian 13"
        echo "2) Back/Exit"
        echo

        read -p "Select a Debian version: " debian_choice

        case $debian_choice in
            1)
                echo
                echo "Installing wget..."
                sudo apt install -y wget

                echo
                echo "Downloading Debian 13 ISO..."
                wget https://saimei.ftp.acc.umu.se/debian-cd/current/amd64/iso-cd/debian-13.4.0-amd64-netinst.iso

                echo
                echo "Download complete!"
                ;;
            2)
                echo "Exiting..."
                ;;
            *)
                echo "Invalid option."
                ;;
        esac
        ;;
    2)
        echo "Goodbye!"
        ;;
    *)
        echo "Invalid option."
        ;;
esac