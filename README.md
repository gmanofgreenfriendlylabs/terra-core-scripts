# Terra Validator upgrade script (not tested)
In order to automate the process where the script is executed based on the block height, you can write a Bash script or a Python script that monitors the block height and runs the appropriate upgrade commands once the specified block height is reached. Below are the steps you can take:

## 1. Monitor Block Height and Time Control
First, we need to monitor the block height. The terrad CLI can be used to query the current block height. Once the target block height is reached (in this case, 21163600), the upgrade script will be executed.

## 2. Automation with a Bash Script
A simple Bash script can periodically check the block height and then execute the upgrade commands when the target height is reached. Here's how you can implement it:

```sh
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
```

## 3. Running the Script in the Background
To run the script periodically in the background, you can use nohup or set it up as a Cron job on a Linux server. Example using nohup:

```sh
nohup ./upgrade_script.sh &
Or as a Cron job, which checks every 30 seconds:
```
```sh
*/30 * * * * /path/to/your/script.sh
```
## 4. Explanation of the Bash Script:
Monitoring Block Height: The script uses the terrad status command to fetch the current block height and compares it with the target height. It repeats this every 30 seconds.
Upgrade Execution: Once the target block height is reached, the repository is cloned, the v3.3.0 version is checked out, and the build and install process is executed.
Version Check: After installation, the terrad version command is used to verify that the correct version has been installed.
