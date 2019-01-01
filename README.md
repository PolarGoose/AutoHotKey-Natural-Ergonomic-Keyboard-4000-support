### Desription
 
The “Natural_keyboard_4000_support.ahk” module adds support for customizing extra keys
from "Microsoft Natural Ergonomic Keyboard 4000" like:
- favorites buttons
-  zoom slider
- ‘=’ ‘(‘ ‘)’ keys on top of the numpad.

This module connects to the USB HID device which is registered by the keyboard and handles events
which come from these extra buttons converting them to AutoHotKey subroutine labels, giving the ability to customize their behavior.

### How to use

- Simply copy the files including "ExternalLibraries" folder to the folder with your script.
- Look at the "example.ahk" file, which shows how you can use this module in your AHK script.
- The full list of keys with their labels is located inside the “Natural_keyboard_4000_support.ahk” file.


### References

The implementation is based on ideas formulated in the following forum discussion:<br/>
https://autohotkey.com/board/topic/36304-hidextended-input-devices-ms-natural-keyboard-4000-etc/

"AHKHID.ahk" and the implementation for "Bin2Hex.ahk" are taken from the following repository:<br/>
https://github.com/jleb/AHKHID

