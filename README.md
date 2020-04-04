## Description
The “Natural_keyboard_4000_support.ahk” module adds support for customizing extra keys
from "Microsoft Natural Ergonomic Keyboard 4000" like:
- favorites buttons
-  zoom slider
- ‘=’ ‘(‘ ‘)’ keys on top of the numpad.
- F-lock button and F1-F12 keys when F-lock is disabled

The library also detects key modifiers like Ctrl and Alt if they are pressed together with the abovementioned buttons.

For the list of supported buttons and modifiers, please look at the `keyCodeToNameMapping` variable and the `SeparateKeyModifiers` function in the `Natural_keyboard_4000_support.ahk`.

## How it works
The "Microsoft Natural Ergonomic Keyboard 4000" is registered by the system as two USB devices:
- a normal keyboard device which handles all default buttons on the keyboard
- USB HID device which handles the extra buttons

The AHK module from this repository connects to the USB HID device and handles events which come from the extra buttons and convert them to AutoHotKey subroutine labels, providing the ability to customize their behavior.

## How to use
- System requirements: Windows Vista 64 bit or later
- Uninstall "Microsoft Mouse and Keyboard Center" if installed
- Simply copy the files including "ExternalLibraries" folder to the folder with your script.
- Look at the "example.ahk" file, which shows how you can use this library.
- The full list of keys with their labels is located inside the “Natural_keyboard_4000_support.ahk” file.
- Use `AutoHotkeyU64` to run the scripts.

## References
The implementation is based on ideas formulated in the following forum discussion:<br/>
https://autohotkey.com/board/topic/36304-hidextended-input-devices-ms-natural-keyboard-4000-etc/

`nsAHKHID.ahk` implementation is based on the `AHKHID.ahk` from the following repository:<br/>
https://github.com/jleb/AHKHID

## Contributors
[LazyRoy](https://github.com/LazyRoy)
