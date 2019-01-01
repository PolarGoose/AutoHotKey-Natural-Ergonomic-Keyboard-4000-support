#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#Persistent ; script will stay running after the auto-execute section (top part of the script) completes
#SingleInstance Force ; Replaces the old instance of this script automatically
SendMode Input ; Recommended for new scripts due to its superior speed and reliability

#Include %A_ScriptDir%\Natural_keyboard_4000_support.ahk

return ; nothing to do in the main part of the script

; === Use the zoom button to scroll ===
DoScroll:
    if (ScrollDir = 1)
        SendInput, {WheelUp}
    else
        SendInput, {WheelDown}
    return

; Zoom Down
012E020000000000:
012E020000010000:
    ScrollDir := 2
    GoSub, DoScroll
    SetTimer, DoScroll, 80
    return

; Zoom Up
012D020000000000:
012D020000010000:
    ScrollDir := 1
    GoSub, DoScroll
    SetTimer, DoScroll, 80
    return

; All up
0100000000000000:
0100000000010000:
    ScrollDir := 0
    SetTimer, DoScroll, Off
    return
; ======

; === Map extra numpad's keys to their ordinary functionality ===
; numpad "="
0100006700000000:
0100006700010000:
    Send {=}
    return

; numpad "("
010000B600000000:
010000B600010000:
    Send {(}
    return

; numpad ")"
010000B700000000:
010000B700010000:
    Send {)}
    return
; ======

; === Use favorites buttons ===
; My Favorites
0182010000000000:
0182010000010000:
    MsgBox My Favorites Button
    return

; Favorites 1
0100000000040000:
0100000000050000:
    MsgBox Favorites 1
    return

; Favorites 2
0100000000080000:
0100000000090000:
    MsgBox Favorites 2
    return

; Favorites 3
0100000000100000:
0100000000110000:
    MsgBox Favorites 3
    return

; Favorites 4
0100000000200000:
0100000000210000:
    MsgBox Favorites 4
    return

; Favorites 5
0100000000400000:
0100000000410000:
    MsgBox Favorites 5
    return
; ======
