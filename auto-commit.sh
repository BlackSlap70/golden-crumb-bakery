#!/bin/bash

# Auto-commit script for Golden Crumb Bakery
# This script automatically generates commit messages based on file changes

echo "🍪 Golden Crumb Bakery - Auto Commit Helper"
echo "============================================"

# Check if there are changes to commit
if [[ -z $(git status --porcelain) ]]; then
    echo "✅ No changes to commit!"
    exit 0
fi

# Show current status
echo "📋 Current changes:"
git status --short

echo ""
echo "🤖 Generating automatic commit message..."

# Detect change types
HAS_NEW_IMAGES=$(git status --porcelain | grep -E "\.(jpg|png|gif|svg)$" | grep "^A" | wc -l)
HAS_MODIFIED_HTML=$(git status --porcelain | grep "index.html" | grep "^M" | wc -l)
HAS_NEW_JS=$(git status --porcelain | grep -E "\.(js)$" | grep "^A" | wc -l)
HAS_MODIFIED_CSS=$(git status --porcelain | grep -E "\.(css)$" | grep "^M" | wc -l)

# Generate message based on changes
MESSAGE=""

if [ $HAS_NEW_IMAGES -gt 0 ]; then
    MESSAGE="🍪 content: add new cookie images and update display"
elif [ $HAS_MODIFIED_HTML -gt 0 ] && [ $HAS_MODIFIED_CSS -gt 0 ]; then
    MESSAGE="🎨 style: update website design and layout"
elif [ $HAS_MODIFIED_HTML -gt 0 ]; then
    MESSAGE="✨ feat: update website content and functionality"
elif [ $HAS_NEW_JS -gt 0 ]; then
    MESSAGE="🚀 perf: add new JavaScript functionality"
elif [ $HAS_MODIFIED_CSS -gt 0 ]; then
    MESSAGE="🎨 style: improve website styling"
else
    MESSAGE="🔧 chore: update project files"
fi

echo "📝 Suggested commit message: $MESSAGE"
echo ""

# Ask for confirmation
read -p "📤 Use this message? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git add .
    git commit -m "$MESSAGE"
    echo "✅ Changes committed successfully!"
    
    read -p "🚀 Push to GitHub? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git push origin main
        echo "🎉 Changes pushed to GitHub!"
    fi
else
    echo "❌ Commit cancelled. You can commit manually with:"
    echo "   git add ."
    echo "   git commit -m \"Your custom message\""
fi