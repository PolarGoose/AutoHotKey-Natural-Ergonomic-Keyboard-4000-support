;!roy
#include .\ExternalLibraries\AHKHID.ahk
#include .\ExternalLibraries\Bin2Hex.ahk

A_ThisHID := ""

OnMessage(0x00FF, "InputMessage") ; subscrube for WM_INPUT
AHKHID_Register(12, 1, A_ScriptHwnd, RIDEV_INPUTSINK) ; the keyboard has UsagePage=12 and Usage=1

InputMessage(wParam, lParam) {
    global ; we need to have access to global variables
    Critical ; otherwise you can get ERROR_INVALID_HANDLE

    ; if the event came from not a HID device we don't need to handle it
    local devType := AHKHID_GetInputInfo(lParam, II_DEVTYPE)
    if (devType != RIM_TYPEHID) {
        return
    }

    local inputInfo := AHKHID_GetInputInfo(lParam, II_DEVHANDLE)
    local numberOfBytes := AHKHID_GetInputData(lParam, uData)
    local vendorId := AHKHID_GetDevInfo(inputInfo, DI_HID_VENDORID, True)
    local productId := AHKHID_GetDevInfo(inputInfo, DI_HID_PRODUCTID, True)

    ; if the event came from our keyboard (vendor and product ids match),
    ; we call a subroutine related to the pressed key code if this subroutine exists
    if (vendorId = 1118) and (productId = 219) {
        local hex := Bin2Hex(&uData, numberOfBytes)
        if IsLabel(hex) {
            A_ThisHID := hex
            Gosub, %hex%
            A_ThisHID := ""
        }
    }
}

; === Key codes ===
; ; Zoom down
; 012E020000000000:
; 012E020000010000:
;    return
;
; ; Zoom up
; 012D020000000000:
; 012D020000010000:
;    return
;
; ; All up
; 0100000000000000:
; 0100000000010000:
;    return
;
; ;numpad=
; 0100006700000000:
; 0100006700010000:
;    return
;
; ;numpad(
; 010000B600000000:
; 010000B600010000:
;    return
;
; ;numpad)
; 010000B700000000:
; 010000B700010000:
;    return
;
; ; My Favorites
; 0182010000000000:
; 0182010000010000:
;    return
;
; ; Favorites 1
; 0100000000040000:
; 0100000000050000:
;    return
;
; ; Favorites 2
; 0100000000080000:
; 0100000000090000:
;    return
;
; ; Favorites 3
; 0100000000100000:
; 0100000000110000:
;    return
;
; ; Favorites 4
; 0100000000200000:
; 0100000000210000:
;    return
;
; ; Favorites 5
; 0100000000400000:
; 0100000000410000:
;    return
;
; ; F-lock - message alternates with each press (shifted / not shifted)
; 0100000000020000:
; 0100000000030000:
;    return
;
; ; F-keys when F-lock enabled
;
; ; F1
; 0195000000000000:
;    return
;
; ;F2
; 011A020000000000:
;    return
;
; ;F3
; 0179020000000000:
;    return
;
; ;F4
; 0101020000000000:
;    return
;
; ;F5
; 0102020000000000:
;    return
;
; ;F6
; 0103020000000000:
;    return
;
; ;F7
; 0189020000000000:
;    return
;
; ;F8
; 018B020000000000:
;    return
;
; ;F9
; 018C020000000000:
;    return
;
; ;F10
; 01AB010000000000:
;    return
;
; ;F11
; 0107020000000000:
;    return
;
; ;F12
; 0108020000000000:
;    return
; ======
