#include .\ExternalLibraries\AHKHID.ahk
#include .\ExternalLibraries\Bin2Hex.ahk

; ======

HID_DEBUG := true

; ======

MSNaturalHID := { "HID_0100000000040000": "HID_Favorites1"
                , "HID_0100000000080000": "HID_Favorites2"
                , "HID_0100000000100000": "HID_Favorites3"
                , "HID_0100000000200000": "HID_Favorites4"
                , "HID_0100000000400000": "HID_Favorites5"
                , "HID_0182010000000000": "HID_MyFavorites"
                , "HID_012E020000000000": "HID_ZoomDown"
                , "HID_012D020000000000": "HID_ZoomUp"
                , "HID_0100006700000000": "HID_NumpadEqual"
                , "HID_010000B600000000": "HID_NumpadLeftBracket"
                , "HID_010000B700000000": "HID_NumpadRightBracket"
                , "HID_0195000000000000": "HID_F1"
                , "HID_011A020000000000": "HID_F2"
                , "HID_0179020000000000": "HID_F3"
                , "HID_0101020000000000": "HID_F4"
                , "HID_0102020000000000": "HID_F5"
                , "HID_0103020000000000": "HID_F6"
                , "HID_0189020000000000": "HID_F7"
                , "HID_018B020000000000": "HID_F8"
                , "HID_018C020000000000": "HID_F9"
                , "HID_01AB010000000000": "HID_F10"
                , "HID_0107020000000000": "HID_F11"
                , "HID_0108020000000000": "HID_F12"
                , "HID_0124020000000000": "HID_BrowserBack"
                , "HID_0125020000000000": "HID_BrowserForward"
                , "HID_0123020000000000": "HID_BrowserHome"
                , "HID_0121020000000000": "HID_BrowserSearch"
                , "HID_018A010000000000": "HID_LaunchMail"
                , "HID_01E2000000000000": "HID_VolumeMute"
                , "HID_01EA000000000000": "HID_VolumeDown"
                , "HID_01E9000000000000": "HID_VolumeUp"
                , "HID_01CD000000000000": "HID_MediaPlayPause"
                , "HID_0192010000000000": "HID_Calculator"
                , "HID_0100000000020000": "HID_FnLock"
                , "HID_0100000000000000": "HID_KeyUp"}

; ======

HID_Init() {
    global

    HID_State := {}
    HID_RawHID := ""
    HID_HID := ""
    HID_Key := ""

    A_ThisHID := ""
}

; ======

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
    ; we call a subroutine related to the pressed key code or name if this subroutine exists
    if (vendorId = 1118) and (productId = 219) {
        HID_RawHID := Bin2Hex(&uData, numberOfBytes)

        if IsLabel(HID_RawHID) {
            A_ThisHID := HID_RawHID
        } else {
            HID_HID := SeparateState(HID_RawHID)
            HID_Key := MSNaturalHID["HID_" . HID_HID]

            if HID_DEBUG {
                OutputDebug % "HID_RawHID: " . HID_RawHID
                OutputDebug % "HID_HID:    " . HID_HID
                OutputDebug % "HID_State:`n" . StateStr()
                OutputDebug % "HID_Key:    " . HID_Key
            }

            if not HID_Key {
                OutputDebug % "Unknown MS Natural Keyboard HID: " . %HID_RawHID% . ":" . HID_HID
                return
            } 

            if IsLabel(HID_Key) {
                A_ThisHID := HID_Key
            }
        }

        if A_ThisHID {
            Gosub, %A_ThisHID%
        }

        HID_Init()
    }
}

; ======

SeparateState(hex) {
    local tmp := "0x" hex
    local code := tmp + 0

    HID_State := {}
    
    HID_State["Fn"]     := (code & 0x10000) != 0

    HID_State["LCtrl"]  := (code & 0x01) != 0
    HID_State["LShift"] := (code & 0x02) != 0
    HID_State["LAlt"]   := (code & 0x04) != 0
    HID_State["LWin"]   := (code & 0x08) != 0

    HID_State["RCtrl"]  := (code & 0x10) != 0
    HID_State["RShift"] := (code & 0x20) != 0
    HID_State["RAlt"]   := (code & 0x40) != 0
    HID_State["RWin"]   := (code & 0x80) != 0
        
    HID_State["Ctrl"]   := HID_State["LCtrl"]  or HID_State["RCtrl"]
    HID_State["Shift" ] := HID_State["LShift"] or HID_State["RShift"]
    HID_State["Alt"]    := HID_State["LAlt"]   or HID_State["RAlt"]
    HID_State["Win"]    := HID_State["LWin"]   or HID_State["RWin"]
        
    ; clean up HID from State
    ;    AHK bitwise operations seems buggy
    code := code & 0x0FFFFFFFFFFEFF00
    hex := Format("{:016X}", code)

    return hex
}

; ======
; debug function

StateStr() {
    local s := ""

    s .= "`tLeft:`t"
    s .= (HID_State["LCtrl"]  ? "CTRL"  : "ctrl")  . " "
    s .= (HID_State["LShift"] ? "SHIFT" : "shift") . " "
    s .= (HID_State["LAlt"]   ? "ALT"   : "alt")   . " "
    s .= (HID_State["LWin"]   ? "WIN"   : "win")   . " "
    s .= "`n"

    s .= "`tRight:`t"
    s .= (HID_State["RCtrl"]  ? "CTRL"  : "ctrl")  . " "
    s .= (HID_State["RShift"] ? "SHIFT" : "shift") . " "
    s .= (HID_State["RAlt"]   ? "ALT"   : "alt")   . " "
    s .= (HID_State["RWin"]   ? "WIN"   : "win")   . " "
    s .= "`n"

    s .= "`tBoth:`t"
    s .= (HID_State["Ctrl"]  ? "CTRL"  : "ctrl")  . " "
    s .= (HID_State["Shift"] ? "SHIFT" : "shift") . " "
    s .= (HID_State["Alt"]   ? "ALT"   : "alt")   . " "
    s .= (HID_State["Win"]   ? "WIN"   : "win")   . " "
    s .= "`n"

    s .= "`tFn:`t`t"
    s .= (HID_State["Fn"]  ? "FN"  : "fn")  . " "
    s .= "`n"

    return s
}

; ======

HID_Init()
