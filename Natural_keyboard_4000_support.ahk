#include .\ExternalLibraries\AHKHID.ahk

class TMsNatural4000
{
    static vendorId = 1118
    static productId = 219

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

    __New(){
        OnMessage(0x00FF, ObjBindMethod(this, "InputMessage")) ; subscrube for WM_INPUT
        global RIDEV_INPUTSINK
        AHKHID_Register(12, 1, A_ScriptHwnd, RIDEV_INPUTSINK) ; the keyboard has UsagePage=12 and Usage=1
    }

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
        if (vendorId = this.vendorId) and (productId = this.productId) {
            local hexString := "0x" . this.BinaryDataToHexDecimalString(uData, numberOfBytes)
            local keyCode := this.SeparateKeyModifiers(hexString)
            local keyName := this.keyCodeToNameMapping[keyCode]

            this.OnKey(keyName, keyCode, hexString)
        }
    }

    OnKey(keyName, keyCode, hexString) {
        if IsLabel(keyName) 
            Gosub, %keyName%
    }

    SeparateKeyModifiers(hexString) {
        ; convert hexdecimal string representation to value
        local code := hexString + 0

        local modifiers := {}
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

        ; store modifiers in a global variable
        this.keyModifiers := modifiers

        local codeWithoutModifiers := code & 0x0FFFFFFFFFFEFF00
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
