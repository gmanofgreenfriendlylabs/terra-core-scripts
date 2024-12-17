#!/bin/bash

# Target block height
TARGET_BLOCK_HEIGHT=21163600
# Get the current block height
CURRENT_BLOCK_HEIGHT=$(terrad status | grep "Sync Info" | awk '{print $6}' | cut -d':' -f2)

# Loop that checks the block height until the target height is reached
while [ "$CURRENT_BLOCK_HEIGHT" -lt "$TARGET_BLOCK_HEIGHT" ]
do
    echo "Current block height: $CURRENT_BLOCK_HEIGHT. Waiting for target height $TARGET_BLOCK_HEIGHT."
    sleep 30 # Wait 30 seconds before checking again
    CURRENT_BLOCK_HEIGHT=$(terrad status | grep "Sync Info" | awk '{print $6}' | cut -d':' -f2)
done

echo "Target block height reached ($TARGET_BLOCK_HEIGHT). Performing upgrade."

# Execute upgrade commands
git clone https://github.com/classic-terra/core core-v3.3.0
cd core-v3.3.0
git checkout v3.3.0
make build && make install

# Verify version
terrad version
