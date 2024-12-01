#!/bin/bash

# Navigate to the iOS project directory
cd ios || exit 1

yes | fastlane spaceauth -u o.nasser@eltgcc.com
export FASTLANE_PASSWORD="kvlk-lpbs-nuaf-xsyq"

## Run fastlane produce with the necessary options
fastlane produce -a com.elt.productt.widgett -q "Product widget" -b com.elt.productt.widgett <<EOF
1
EOF



