#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#Persistent ; script will stay running after the auto-execute section (top part of the script) completes
#SingleInstance Force ; Replaces the old instance of this script automatically
SendMode Input ; Recommended for new scripts due to its superior speed and reliability

#Include %A_ScriptDir%
#Include Natural_keyboard_4000_support.ahk

return ; nothing to do in the main part of the script

; === Use the zoom button to scroll ===
DoScroll:
    if (ScrollDir = 1)
        SendInput, {WheelUp}
    else
        SendInput, {WheelDown}
    return

; Zoom Down
HID_ZoomDown:
    ScrollDir := 2
    GoSub, DoScroll
    SetTimer, DoScroll, 80
    return

; Zoom Up
HID_ZoomUp:
    ScrollDir := 1
    GoSub, DoScroll
    SetTimer, DoScroll, 80
    return

; All up
HID_KeyUp:
    ScrollDir := 0
    SetTimer, DoScroll, Off
    return
; ======

; === Map extra numpad's keys to their ordinary functionality ===
; numpad "="
HID_NumpadEqual:
    Send {=}
    return

; numpad "("
HID_NumpadLeftBracket:
    Send {(}
    return

; numpad ")"
HID_NumpadRightBracket:
    Send {)}
    return
; ======

; === Use favorites buttons ===
; My Favorites
HID_MyFavorites:

    if HID_State.Shift {
        MsgBox Shift and MyFavorites button
        return
    }

    if HID_State.LCtrl and HID_State.RCtrl {
        MsgBox LeftCtrl+RightCtrl and MyFavorites button
        return
    }

    MsgBox % ("My Favorites Button while Fn-lock is " . (HID_State.Fn ? "Enabled" : "Disabled"))

    return

; Favorites 1
HID_Favorites1:
    MsgBox Favorites 1
    return

; Favorites 2
HID_Favorites2:
    MsgBox Favorites 2
    return

; Favorites 3
HID_Favorites3:
    MsgBox Favorites 3
    return

; Favorites 4
HID_Favorites4:
    MsgBox Favorites 4
    return

; Favorites 5
HID_Favorites5:
    MsgBox Favorites 5
    return
; ======


; === Map F-keys then Fn-Lock is Disabled to their ordinary functionality ===
HID_F1:
HID_F2:
HID_F3:
HID_F4:
HID_F5:
HID_F6:
HID_F7:
HID_F8:
HID_F9:
HID_F10:
HID_F11:
HID_F12:
    fkey := StrReplace(A_ThisHID, "HID_")
    Send {%fkey%}
    return
; ======

; === Map Fn-Lock key to F12 ===
HID_FnLock:
    Send {F12}
    return
; ======


HID_BrowserBack:
    return
HID_BrowserForward:
    return

HID_BrowserHome:
    return
HID_BrowserSearch:
    return
HID_LaunchMail:
    return

HID_VolumeMute:
    return
HID_VolumeDown:
    return
HID_VolumeUp:
    return
HID_MediaPlayPause:
    return

HID_Calculator:
    return

