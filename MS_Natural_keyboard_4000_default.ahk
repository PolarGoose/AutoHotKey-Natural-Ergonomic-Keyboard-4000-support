; Microsoft Natural Ergonomic Keyboard 4000
;
; ### References
; 
; The implementation is based on ideas formulated in the following forum discussion:<br/>
; https://autohotkey.com/board/topic/36304-hidextended-input-devices-ms-natural-keyboard-4000-etc/
; 
; "AHKHID.ahk" and the implementation for "Bin2Hex.ahk" are taken from the following repository:<br/>
; https://github.com/jleb/AHKHID

#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#Persistent ; script will stay running after the auto-execute section (top part of the script) completes
#SingleInstance Force ; Replaces the old instance of this script automatically
SendMode Input ; Recommended for new scripts due to its superior speed and reliability

#Include %A_ScriptDir%\Natural_keyboard_4000_support.ahk

return ; nothing to do in the main part of the script

; To use Buttons with Raw-Input instead of as the default Extra-Keys you have to disable the Extra-Keys globally:
;Browser_Home::return
;Browser_Search::return
;Launch_Mail::return
;Launch_App2::return ; Calculator-Button
;Browser_Back::return
;Browser_Forward::return

; ====================== Extra Keys =============================
; Home (Default: Extra-Key: Browser_Home)
0123020000000000:
0123020000010000:
	Send {Browser_Home}
return

; Search (Default: Extra-Key: Browser_Search)
0121020000000000:
0121020000010000:
	Send {Browser_Search}
return

; Mail (Default: Extra-Key: Launch_Mail)
018A010000000000:
018A010000010000:
	Send {Launch_Mail}
return
; ===============================================================


; ==================== Favorite Buttons ========================
; My Favorites
0182010000000000:
0182010000010000:
    MsgBox, 0, AutoHotKey | Microsoft Natural Ergonomic Keyboard 4000, Button not assigned
    return

; Favorites 1
0100000000040000:
0100000000050000:
    MsgBox, 0, AutoHotKey | Microsoft Natural Ergonomic Keyboard 4000, Button not assigned
    return

; Favorites 2
0100000000080000:
0100000000090000:
    MsgBox, 0, AutoHotKey | Microsoft Natural Ergonomic Keyboard 4000, Button not assigned
    return

; Favorites 3
0100000000100000:
0100000000110000:
    MsgBox, 0, AutoHotKey | Microsoft Natural Ergonomic Keyboard 4000, Button not assigned
    return

; Favorites 4
0100000000200000:
0100000000210000:
    MsgBox, 0, AutoHotKey | Microsoft Natural Ergonomic Keyboard 4000, Button not assigned
    return

; Favorites 5
0100000000400000:
0100000000410000:
    MsgBox, 0, AutoHotKey | Microsoft Natural Ergonomic Keyboard 4000, Button not assigned
    return
; ===============================================================


; ================== Functional F-Keys ==========================
; F-lock - message alternates with each press (shifted / not shifted)
0100000000020000:
0100000000030000:
;	MsgBox F-lock
	TrayTip, AutoHotkey, F-Lock changed
return

; F-keys when F-lock enabled

; F1
0195000000000000:
0195000000010000:
	SendInput, {f1}
return

;F2
011A020000000000:
011A020000010000:
	Send ^z
return

;F3
0179020000000000:
0179020000010000:
	Send ^y
return

;F4
0101020000000000:
0101020000010000:
	Send ^n
return

;F5
0102020000000000:
0102020000010000:
	Send ^o
return

;F6
0103020000000000:
0103020000010000:
	Send !{F4}
return

;F7
0189020000000000:
0189020000010000:
	Send ^r
return

;F8
018B020000000000:
018B020000010000:
	Send ^e
return

;F9
018C020000000000:
018C020000010000:
	Send !s
return

;F10
01AB010000000000:
01AB010000010000:
	SendInput, {F7}
return

;F11
0107020000000000:
0107020000010000:
	SendInput, {f11}
return

;F12
0108020000000000:
0108020000010000:
	Send ^p
return
; ===============================================================


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
; ===============================================================


; ===================== Zoom-Stick ==============================
ZoomIn:
	Send ^{+}
return
ZoomOut:
	Send ^-
return

; Zoom Up
012D020000000000:
012D020000010000:
    SetTimer, ZoomIn, 10
return

; Zoom Down
012E020000000000:
012E020000010000:
    SetTimer, ZoomOut, 10
return

; All up
0100000000000000:
0100000000010000:
	SetTimer, ZoomIn, off
	SetTimer, ZoomOut, off
return
; ===============================================================


; ================== Direction-Keys below =======================
;Back-Button (Default: Extra-Key: Browser_Back)
0124020000000000:
0124020000010000:
    Send {Browser_Back}
return
; ======

;Forward-button (Default: Extra-Key: Browser_Forward)
0125020000000000:
0125020000010000:
	Send {Browser_Forward}
; ===============================================================
