#!/bin/bash

echo "🚀 Setting up Company Flutter CLI..."

# Step 1: Add Dart global bin to PATH (if not already added)
if ! grep -q '.pub-cache/bin' ~/.zshrc; then
  echo 'export PATH="$PATH:$HOME/.pub-cache/bin"' >> ~/.zshrc
  echo "✅ PATH updated in ~/.zshrc"
else
  echo "ℹ️ PATH already configured"
fi

# Reload zsh config
source ~/.zshrc

# Step 2: Activate CLI from Git
echo "📦 Installing Company CLI..."
dart pub global activate \
  --source git https://github.com/Hardik-Moweb/Flutter-Structure-CLI.git

# Step 3: Verify installation
echo "🔍 Verifying installation..."
if command -v company_app &> /dev/null; then
  echo "✅ CLI installed successfully"
else
  echo "⚠️ CLI command not found. Try restarting terminal."
fi

# Step 4: Done message
echo ""
echo "🎉 Setup Complete!"
echo ""
echo "👉 To create a new project, run:"
echo "   company_app create"
echo ""