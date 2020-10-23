#include %A_LineFile%\..\nsAHKHID.ahk

; the script relies on CRYPT_STRING_NOCRLF Win32Api flag which is supported only since Vista
if A_OSVersion in WIN_2003,WIN_XP,WIN_2000
{
    MsgBox This script requires Windows Vista or later.
    ExitApp
}

if (A_PtrSize != 8) {
    MsgBox This script needs to be run using 64 bit version of Autohotkey like "AutoHotkeyU64.exe"
    ExitApp
}

class TMsNatural4000
{
    ; Microsoft Natural 4000 keyboard vendor and product ids
    static vendorId = 0x045E
    static productId = 0x00DB

    static keyCodeToNameMapping := { 0x0100000000040000: "MsNatural4000_Favorites1"
                                   , 0x0100000000080000: "MsNatural4000_Favorites2"
                                   , 0x0100000000100000: "MsNatural4000_Favorites3"
                                   , 0x0100000000200000: "MsNatural4000_Favorites4"
                                   , 0x0100000000400000: "MsNatural4000_Favorites5"
                                   , 0x0182010000000000: "MsNatural4000_MyFavorites"
                                   , 0x012E020000000000: "MsNatural4000_ZoomDown"
                                   , 0x012D020000000000: "MsNatural4000_ZoomUp"
                                   , 0x0100006700000000: "MsNatural4000_NumpadEqual"
                                   , 0x010000B600000000: "MsNatural4000_NumpadLeftBracket"
                                   , 0x010000B700000000: "MsNatural4000_NumpadRightBracket"
                                   , 0x0195000000000000: "MsNatural4000_F1_Flock_disabled"
                                   , 0x011A020000000000: "MsNatural4000_F2_Flock_disabled"
                                   , 0x0179020000000000: "MsNatural4000_F3_Flock_disabled"
                                   , 0x0101020000000000: "MsNatural4000_F4_Flock_disabled"
                                   , 0x0102020000000000: "MsNatural4000_F5_Flock_disabled"
                                   , 0x0103020000000000: "MsNatural4000_F6_Flock_disabled"
                                   , 0x0189020000000000: "MsNatural4000_F7_Flock_disabled"
                                   , 0x018B020000000000: "MsNatural4000_F8_Flock_disabled"
                                   , 0x018C020000000000: "MsNatural4000_F9_Flock_disabled"
                                   , 0x01AB010000000000: "MsNatural4000_F10_Flock_disabled"
                                   , 0x0107020000000000: "MsNatural4000_F11_Flock_disabled"
                                   , 0x0108020000000000: "MsNatural4000_F12_Flock_disabled"
                                   , 0x0124020000000000: "MsNatural4000_BrowserBack"
                                   , 0x0125020000000000: "MsNatural4000_BrowserForward"
                                   , 0x0123020000000000: "MsNatural4000_BrowserHome"
                                   , 0x0121020000000000: "MsNatural4000_BrowserSearch"
                                   , 0x018A010000000000: "MsNatural4000_LaunchMail"
                                   , 0x01E2000000000000: "MsNatural4000_VolumeMute"
                                   , 0x01EA000000000000: "MsNatural4000_VolumeDown"
                                   , 0x01E9000000000000: "MsNatural4000_VolumeUp"
                                   , 0x01CD000000000000: "MsNatural4000_MediaPlayPause"
                                   , 0x0192010000000000: "MsNatural4000_Calculator"
                                   , 0x0100000000020000: "MsNatural4000_FnLock"
                                   , 0x0100000000000000: "MsNatural4000_KeyUp" }

    __New() {
        global AHKHID
        OnMessage(0x00FF, ObjBindMethod(this, "HandleInputMessage")) ; subscrube for WM_INPUT
        AHKHID.Register(12, 1, A_ScriptHwnd, AHKHID.RIDEV_INPUTSINK) ; the keyboard has UsagePage=12 and Usage=1
    }

    HandleInputMessage(wParam, lParam) {
        Critical ; otherwise you can get ERROR_INVALID_HANDLE

        global AHKHID

        ; if the event came from not a HID device we don't need to handle it
        devType := AHKHID.GetInputInfo(lParam, AHKHID.II_DEVTYPE)
        if (devType != AHKHID.RIM_TYPEHID) {
            return
        }

        inputInfo := AHKHID.GetInputInfo(lParam, AHKHID.II_DEVHANDLE)
        numberOfBytes := AHKHID.GetInputData(lParam, uData)
        vendorId := AHKHID.GetDevInfo(inputInfo, AHKHID.DI_HID_VENDORID, True)
        productId := AHKHID.GetDevInfo(inputInfo, AHKHID.DI_HID_PRODUCTID, True)

        ; if "vendorId" and "deviceId" don't much, the event came from a different device
        if (vendorId != this.vendorId) or (productId != this.productId) {
            return
        }

        ; keycode must be 8 bytes long
        if (numberOfBytes != 8) {
            MsgBox Fatal error, wrong number of bytes: %numberOfBytes%
        }

        hexString := "0x" . this.BinaryDataToHexDecimalString(uData, numberOfBytes)
        keyCode := this.SeparateKeyModifiers(hexString)
        keyName := this.keyCodeToNameMapping[keyCode]
        this.OnKey(keyName, keyCode, hexString)
    }

    ; event function, you can override it for some reason
    OnKey(keyName, keyCode, hexString) {
        ; call a subroutine related to the pressed key name if this subroutine exists
        if IsLabel(keyName) {
            Gosub, %keyName%
        }
    }

    SeparateKeyModifiers(hexString) {
        ; convert hexdecimal string representation to value
        code := hexString + 0

        modifiers := {}
        modifiers["Fn"] := (code & 0x10000) != 0
        modifiers["LCtrl"] := (code & 0x01) != 0
        modifiers["LShift"] := (code & 0x02) != 0
        modifiers["LAlt"] := (code & 0x04) != 0
        modifiers["LWin"] := (code & 0x08) != 0
        modifiers["RCtrl"] := (code & 0x10) != 0
        modifiers["RShift"] := (code & 0x20) != 0
        modifiers["RAlt"] := (code & 0x40) != 0
        modifiers["RWin"] := (code & 0x80) != 0
        modifiers["Ctrl"] := modifiers["LCtrl"] or modifiers["RCtrl"]
        modifiers["Shift" ] := modifiers["LShift"] or modifiers["RShift"]
        modifiers["Alt"] := modifiers["LAlt"] or modifiers["RAlt"]
        modifiers["Win"] := modifiers["LWin"] or modifiers["RWin"]

        ; store modifiers in a object variable
        this.keyModifiers := modifiers

        codeWithoutModifiers := code & 0x0FFFFFFFFFFEFF00
        return codeWithoutModifiers
    }

    BinaryDataToHexDecimalString(ByRef binaryVar, binaryVarSize)
    {
        ; https://docs.microsoft.com/en-us/windows/win32/api/wincrypt/nf-wincrypt-cryptbinarytostringa
        ; 0x4000000c = CRYPT_STRING_NOCRLF & CRYPT_STRING_HEX

        ; calculate output string size
        DllCall("crypt32.dll\CryptBinaryToString", "Ptr", &binaryVar, "UInt", binaryVarSize, "UInt", 0x4000000c, "Ptr", 0, "UInt*", outputSize)

        ; allocate buffer for storing resulting string
        VarSetCapacity(hexVar, outputSize * ( A_Isunicode ? 2 : 1 ), 1)

        ; convert binary data to the string
        DllCall("crypt32.dll\CryptBinaryToString", "Ptr", &binaryVar, "UInt", binaryVarSize, "UInt", 0x4000000c, "Ptr", &hexVar, "UInt*", outputSize)

        return StrGet(&hexVar)
    }
}

MsNatural4000 := new TMsNatural4000()
