#!/bin/bash
# Script to create a GitHub repository for BookBridge

# Variables
REPO_NAME="book-bridge"
DESCRIPTION="A peer-to-peer marketplace for Cameroonian students to buy and sell used physical books"
PRIVATE=false  # Set to true if you want a private repository

echo "Creating GitHub repository: $REPO_NAME"

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    echo "GitHub CLI (gh) is not installed. Please install it first:"
    echo "On Ubuntu/Debian: curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg && echo \"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main\" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null && sudo apt update && sudo apt install gh"
    echo "On macOS: brew install gh"
    echo "On Windows: Download from https://github.com/cli/cli/releases"
    exit 1
fi

# Check if logged in to GitHub
if ! gh auth status &> /dev/null; then
    echo "You are not logged in to GitHub. Running gh auth login..."
    gh auth login
fi

# Create the repository
gh repo create $REPO_NAME \
    --description "$DESCRIPTION" \
    $(if [ "$PRIVATE" = true ]; then echo "--private"; else echo "--public"; fi) \
    --remote=origin \
    --push

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Repository created successfully!"
    echo "Repository URL: https://github.com/$(gh api user --jq '.login')/$REPO_NAME"
    echo ""
    echo "The repository has been initialized with the current directory content."
    echo "All your files including the updated README.md are now pushed to GitHub."
else
    echo "❌ Failed to create repository"
    exit 1
fi