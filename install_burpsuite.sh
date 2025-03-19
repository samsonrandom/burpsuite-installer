#!/bin/bash

BURP_VERSION="2023.1"
INSTALL_DIR="$HOME/burpsuite"
BURP_JAR_URL="https://portswigger.net/burp/releases/download?product=community&version=$BURP_VERSION&type=Jar"
BURP_JAR_PATH="$INSTALL_DIR/burpsuite.jar"


#Function to install Java 17
install_java17(){
	echo "Installing Java 17..."
	sudo apt update && sudo apt install -y openjdk-17-jre

	# Set Java 17 as the default version
	echo "Setting Java 17 as the default..."
	sudo update-alternatives --set java $(update-alternatives --list java | grep "java-17")
}

#Check of Java is install and its version
if ! command -v java &> /dev/null; then
    echo "Java is not installed. Installing Java 17..."
    install_java17
else
    JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
    if [[ ! $JAVA_VERSION =~ ^17 ]]; then
        echo "Detected Java version: $JAVA_VERSION"
        echo "Burp Suite 2023.1 requires Java 17. Switching to Java 17..."
        install_java17
    else
        echo "Java 17 is already set as default."
    fi
fi


# Verify Java installation
if ! command -v java &> /dev/null; then
	echo "Java installation failed. Please install Java manually and rerun the script."
	echo "script: sudo apt update && sudo apt install -y openjdk-17-jre"
	exit1
fi


# Downloading and installing Burp Suite..

mkdir -p "$INSTALL_DIR"

echo "Downloading Burp Suite..."
curl -L "$BURP_JAR_URL" -o "$BURP_JAR_PATH"

if [ ! -f "$BURP_JAR_PATH"]; then
	echo "Download failed. Please check the URL or your internet connection."
	exit 1
fi

# Set execute permissions
chmod +x "$BURP_JAR_PATH"

echo "Burp Suite installed in $INSTALL_DIR."

# Create an alias for running Burp Suite
echo "alias burpsuitejar='java -jar $BURP_JAR_PATH'" >> ~/.bashrc
source ~/.bashrc


echo "To run it, use: java -jar $BURP_JAR_PATH"
echo "You may also use this alias to run it: burpsuitejar"
