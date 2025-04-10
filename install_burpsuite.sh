#!/bin/bash
# Install Burp Suite Community Edition (Linux)

BURP_VERSION="2025.1.5"
BURP_URL="https://portswigger-cdn.net/burp/releases/download?product=community&version=${BURP_VERSION}&type=Linux"
OUTPUT_FILE="burpsuite_community_linux_v${BURP_VERSION}.sh"

echo "Downloading Burp Suite Community Edition v${BURP_VERSION}..."

if ! curl -L "$BURP_URL" -o "$OUTPUT_FILE"; then
    echo "❗ Failed to download Burp Suite. Please check your internet connection and try again."
    exit 1
fi

# Make installer executable
chmod +x "$OUTPUT_FILE"

echo "Running the Burp Suite installer..."

if ! ./"$OUTPUT_FILE"; then
    echo "❗ Installation failed. Please check the installer output for more details."
    exit 1
fi

# Set up alias
INSTALL_DIR="$HOME/.local/bin"
ALIAS_NAME="burpsuite"

# Create .local/bin if it doesn't exist
mkdir -p "$INSTALL_DIR"

# Try to locate installed Burp Suite executable
BURP_EXEC="$HOME/BurpSuiteCommunity/BurpSuiteCommunity"

if [[ -f "$BURP_EXEC" ]]; then
    # Use the provided alias command
    alias burpsuite="$BURP_EXEC"
    
    # Ensure ~/.local/bin is in PATH
    SHELL_RC="$HOME/.bashrc"
    [[ "$SHELL" == */zsh ]] && SHELL_RC="$HOME/.zshrc"

    if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$SHELL_RC"; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_RC"
    fi

    echo "Alias 'burpsuite' added. Restart your terminal or run:"
    echo "source $SHELL_RC"
else
    echo "❗ Burp executable not found. You may need to manually set up the alias."
    exit 1
fi
