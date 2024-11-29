#!/bin/bash

# Clear the terminal screen for a clean start
clear

# Display the current Flutter version
echo "🚀 Checking Flutter version..."
flutter --version

# Clean the Flutter build artifacts
echo "🧹 Cleaning Flutter project..."
flutter clean

# Remove iOS Pods and Podfile.lock to ensure a clean pod installation
echo "🗑️ Removing old iOS Pods and Podfile.lock..."
rm -rf ios/Pods ios/Podfile.lock

# Fetch Flutter package dependencies
echo "📦 Getting Flutter dependencies..."
flutter pub get

# Navigate to the iOS directory
cd ios || exit

# Update and install CocoaPods
echo "🔄 Updating and installing CocoaPods..."
pod update
pod install

# Return to the root directory
cd ..

# Build the iOS app (debug mode)
echo "🔧 Building the iOS app in debug mode..."
flutter build ios

# Build the iOS app for release
echo "🎯 Building the iOS app in release mode..."
flutter build ios --release

# Navigate back to the iOS directory
cd ios || exit

# Run Fastlane for releasing the app
echo "🚢 Running Fastlane for iOS release..."
# Uncomment and configure the following lines as needed for Fastlane commands:
fastlane spaceauth -u omar.nasser@ybservice.iq
export FASTLANE_PASSWORD="iofb-mzny-xleu-ppkj"
yes | fastlane ios release

# Print completion message
echo "✅ Script execution completed! 🎉"
echo "***********************************************"
echo "*                                             *"
echo "*          🚀 Flutter Build Complete! 🚀         *"
echo "*                                             *"
echo "***********************************************"




#fastlane deliver init
#fastlane init
#fastlane spaceauth -u omar.nasser@ybservice.iq
#export FASTLANE_PASSWORD="iofb-mzny-xleu-ppkj"
