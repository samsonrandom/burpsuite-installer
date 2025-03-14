#!/bin/bash

BURP_VERSION="latest"
INSTALL_DIR="$HOME/burpsuite"
BURP_JAR_URL="https://portswigger.net/burp/releases/download?product=community&version=$BURP_VERSION&type=Jar"
BURP_JAR_PATH="$INSTALL_DIR/burpsuite.jar"


# Check if Java is installed
if ! command -v java &> /dev/null; then
	echo "Java is not installed. Installing OpenJDK..."
	sudo apt update && sudo apt install -y default-jre
fi


# Ensure Java is istalled after the attempt
if ! command -v java &> /dev/null; then
	echo "Java installation failed. Please install Java manually and rerun the script."
	echo "script: sudo apt update && sudo apt install -y default-jre"
	exit 1
fi


# Then install the burpsuite

mkdir -p "$INSTALL_DIR"

echo "Downloading Burp Suite..."
curl -L "$BURP_JAR_URL" -o "$BURP_JAR_PATH"

chmod +x "$BURP_JAR_PATH"

echo "Burp Suite installed in $INSTALL_DIR. Run 'burpsuite' to start it."

