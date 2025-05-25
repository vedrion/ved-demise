# End-of-Life (Demise)

An easy-to-use script for QBCore/ESX/QBox servers in FiveM that lets players end their character's life under safe conditions using a pistol.

## Preview

![Preview](https://imgur.com/U9JNFEy.png)

## Installation

### 1. 📥 Download the Script

Clone or download this repository to your computer.

### 2. 📂 Add to Server Resources

Move the downloaded folder to the `resources` directory of your FiveM server.

### 3. 🛠️ Update `server.cfg`

- Open your `server.cfg` file, located in your server's main directory.
- Add `ensure ved-demise` to ensure the script starts with your server.

### ⚠️ Note for ESX Users

If you're using the **default ESX progress bar**, you must add the following export to support progress bar state checks:

Add this code to the end of **`Progress.lua`**:
```lua
exports("IsProgressActive", function()
    return CurrentProgress ~= nil
end)
```
If you're not using the default ESX progress bar, ensure your custom progress bar includes:

- An export to check if the progress bar is active.

- An export to cancel the progress bar if needed.

## Changelog

**Version 1.1.0**

- Added support for ESX framework.

- Integrated support for Ox Lib.

- Synchronized gunshot sound across players.

- Updated UI for confirmation and time left display.

**Version 1.0.0**

#### **[ Initial Release ]**

## Features

- ✅ Confirmation before dying (no accidental deaths).

- ✅ Pistol-only requirement for realistic action.

- ✅ Many safety checks to prevent abuse or misuse.

- ✅ Progressbar countdown while thinking before action.

- ✅ Includes realistic animations, sounds, and camera shake effects.

- ✅ 100% configurable through the config file (no coding needed).

- ✅ Realistic Restrictions: Players cannot perform the action if they are:

  - Dead or unconscious

  - Dying or in a ragdoll state

  - Cuffed or hands-up

  - In a vehicle, falling, swimming, or parachuting

  - In combat (melee, shooting, drive-by, etc.)

  - Busy with other actions (reloading, diving, eating, drinking, etc.)

## Configurations

Everything in this script is fully customizable through the `config.lua` file. I’ve added clear and detailed comments for every setting to make customization easy, even if you have no coding experience. Make sure to check the [config.lua](https://github.com/vedrion/ved-demise/blob/main/config.lua) file to explore all available options and adjust the script exactly how you want.

## Disclaimer

If you or someone you know is struggling, please reach out to a mental health professional or trusted individual. This script is made purely for roleplay purposes and is not intended to trivialize serious mental health issues.

## Contributing

Feel free to fork this repository and create a pull request for any improvements or features!

## License

This project is licensed under the MIT License.
