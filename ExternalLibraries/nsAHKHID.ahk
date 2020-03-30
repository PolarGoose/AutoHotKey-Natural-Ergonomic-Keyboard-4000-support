; encapsulate AHKHID global variables and functions to separate namespace
class nsAHKHID {
/*! TheGood
    AHKHID - An AHK implementation of the HID functions.
    Last updated: August 22nd, 2010
*/
    ;______________________________________
    ;Flags you can use in AHKHID_GetDevInfo
    ;http://msdn.microsoft.com/en-us/library/ms645581
    DI_DEVTYPE                  := 4    ;Type of the device. See RIM_ constants.

    DI_MSE_ID                   := 8    ;ID for the mouse device.
    DI_MSE_NUMBEROFBUTTONS      := 12   ;Number of buttons for the mouse.
    DI_MSE_SAMPLERATE           := 16   ;Number of data points per second. This information may not be applicable for every
                                        ;mouse device.
    DI_MSE_HASHORIZONTALWHEEL   := 20   ;Vista and later only: TRUE if the mouse has a wheel for horizontal scrolling;
                                        ;otherwise, FALSE.

    DI_KBD_TYPE                 := 8    ;Type of the keyboard. 
    DI_KBD_SUBTYPE              := 12   ;Subtype of the keyboard. 
    DI_KBD_KEYBOARDMODE         := 16   ;Scan code mode. 
    DI_KBD_NUMBEROFFUNCTIONKEYS := 20   ;Number of function keys on the keyboard.
    DI_KBD_NUMBEROFINDICATORS   := 24   ;Number of LED indicators on the keyboard.
    DI_KBD_NUMBEROFKEYSTOTAL    := 28   ;Total number of keys on the keyboard. 

    DI_HID_VENDORID             := 8    ;Vendor ID for the HID.
    DI_HID_PRODUCTID            := 12   ;Product ID for the HID. 
    DI_HID_VERSIONNUMBER        := 16   ;Version number for the HID. 
    DI_HID_USAGEPAGE            := 20 | 0x0100  ;Top-level collection Usage Page for the device.
    DI_HID_USAGE                := 22 | 0x0100  ;Top-level collection Usage for the device.
    ;________________________________________
    ;Flags you can use in AHKHID_GetInputInfo
    ;http://msdn.microsoft.com/en-us/library/ms645562
    II_DEVTYPE          := 0    ;Type of the device generating the raw input data. See RIM_ constants.
    II_DEVHANDLE        := 8    ;Handle to the device generating the raw input data.

    II_MSE_FLAGS        := (08+A_PtrSize*2) | 0x0100  ;Mouse state. This member can be any reasonable combination of the
                                        ;following values -> see MOUSE constants.
    II_MSE_BUTTONFLAGS  := (12+A_PtrSize*2) | 0x0100  ;Transition state of the mouse buttons. This member can be one or more of
                                        ;the following values -> see RI_MOUSE constants.
    II_MSE_BUTTONDATA   := (14+A_PtrSize*2) | 0x1100  ;If usButtonFlags is RI_MOUSE_WHEEL, this member is a signed value that
                                        ;specifies the wheel delta.
    II_MSE_RAWBUTTONS   := (16+A_PtrSize*2)           ;Raw state of the mouse buttons. 
    II_MSE_LASTX        := (20+A_PtrSize*2) | 0x1000  ;Motion in the X direction. This is signed relative motion or absolute
                                        ;motion, depending on the value of usFlags.
    II_MSE_LASTY        := (24+A_PtrSize*2) | 0x1000  ;Motion in the Y direction. This is signed relative motion or absolute
                                        ;motion, depending on the value of usFlags. 
    II_MSE_EXTRAINFO    := (28+A_PtrSize*2)           ;Device-specific additional information for the event. 

    II_KBD_MAKECODE     := (08+A_PtrSize*2) | 0x0100  ;Scan code from the key depression. The scan code for keyboard overrun is
                                        ;KEYBOARD_OVERRUN_MAKE_CODE.
    II_KBD_FLAGS        := (10+A_PtrSize*2) | 0x0100  ;Flags for scan code information. It can be one or more of the following
                                        ;values -> see RI_KEY constants.
    II_KBD_VKEY         := (14+A_PtrSize*2) | 0x0100  ;Microsoft Windows message compatible virtual-key code.
    II_KBD_MSG          := (16+A_PtrSize*2)           ;Corresponding window message, for example WM_KEYDOWN, WM_SYSKEYDOWN, and
                                                        ;so forth.
    II_KBD_EXTRAINFO    := (20+A_PtrSize*2)           ;Device-specific additional information for the event.

    II_HID_SIZE         := (08+A_PtrSize*2)           ;Size, in bytes, of each HID input in bRawData.
    II_HID_COUNT        := (12+A_PtrSize*2)           ;Number of HID inputs in bRawData.

    ;DO NOT USE WITH AHKHID_GetInputInfo. Use AHKHID_GetInputData instead to retrieve the raw data.
    II_HID_DATA         := (16+A_PtrSize*2)           ;Raw input data as an array of bytes.
    ;__________________________________________________________________________________
    ;Device type values returned by AHKHID_GetDevType as well as DI_DEVTYPE and II_DEVTYPE
    ;http://msdn.microsoft.com/en-us/library/ms645568
    RIM_TYPEMOUSE       := 0    ;The device is a mouse.
    RIM_TYPEKEYBOARD    := 1    ;The device is a keyboard.
    RIM_TYPEHID         := 2    ;The device is an Human Interface Device (HID) that is not a keyboard and not a mouse.
    ;_______________________________________________________________________________________________
    ;Different flags for RAWINPUTDEVICE structure (to be used with AHKHID_AddRegister and AHKHID_Register)
    ;http://msdn.microsoft.com/en-us/library/ms645565
    RIDEV_REMOVE        := 0x00000001   ;If set, this removes the top level collection from the inclusion list. This tells the
                                        ;operating system to stop reading from a device which matches the top level collection.
    RIDEV_EXCLUDE       := 0x00000010   ;If set, this specifies the top level collections to exclude when reading a complete
                                        ;usage page. This flag only affects a TLC whose usage page is already specified with
                                        ;RIDEV_PAGEONLY.
    RIDEV_PAGEONLY      := 0x00000020   ;If set, this specifies all devices whose top level collection is from the specified
                                        ;usUsagePage. Note that usUsage must be zero. To exclude a particular top level
                                        ;collection, use RIDEV_EXCLUDE.
    RIDEV_NOLEGACY      := 0x00000030   ;If set, this prevents any devices specified by usUsagePage or usUsage from generating
                                        ;legacy messages. This is only for the mouse and keyboard. See Remarks.
    RIDEV_INPUTSINK     := 0x00000100   ;If set, this enables the caller to receive the input even when the caller is not in
                                        ;the foreground. Note that hwndTarget must be specified.
    RIDEV_CAPTUREMOUSE  := 0x00000200   ;If set, the mouse button click does not activate the other window.
    RIDEV_NOHOTKEYS     := 0x00000200   ;If set, the application-defined keyboard device hotkeys are not handled. However, the
                                        ;system hotkeys; for example, ALT+TAB and CTRL+ALT+DEL, are still handled. By default,
                                        ;all keyboard hotkeys are handled. RIDEV_NOHOTKEYS can be specified even if
                                        ;RIDEV_NOLEGACY is not specified and hwndTarget is NULL.
    RIDEV_APPKEYS       := 0x00000400   ;Microsoft Windows XP Service Pack 1 (SP1): If set, the application command keys are
                                        ;handled. RIDEV_APPKEYS can be specified only if RIDEV_NOLEGACY is specified for a
                                        ;keyboard device.
    RIDEV_EXINPUTSINK   := 0x00001000   ;Vista and later only: If set, this enables the caller to receive input in the
                                        ;background only if the foreground application does not process it. In other words, if
                                        ;the foreground application is not registered for raw input, then the background
                                        ;application that is registered will receive the input.
    RIDEV_DEVNOTIFY     := 0x00002000   ;Vista and later only: If set, this enables the caller to receive WM_INPUT_DEVICE_CHANGE
                                        ;notifications for device arrival and device removal.
    ;__________________________________________________
    ;Different values of wParam in the WM_INPUT message
    ;http://msdn.microsoft.com/en-us/library/ms645590
    RIM_INPUT       := 0    ;Input occurred while the application was in the foreground. The application must call
                            ;DefWindowProc so the system can perform cleanup.
    RIM_INPUTSINK   := 1    ;Input occurred while the application was not in the foreground. The application must call
                            ;DefWindowProc so the system can perform the cleanup.
    ;__________________________________
    ;Flags for GetRawInputData API call
    ;http://msdn.microsoft.com/en-us/library/ms645596
    RID_INPUT    := 0x10000003    ;Get the raw data from the RAWINPUT structure.
    RID_HEADER   := 0x10000005    ;Get the header information from the RAWINPUT structure.
    ;_____________________________________
    ;Flags for RAWMOUSE (part of RAWINPUT)
    ;http://msdn.microsoft.com/en-us/library/ms645578

    ;Flags for the II_MSE_FLAGS member
    MOUSE_MOVE_RELATIVE         := 0     ;Mouse movement data is relative to the last mouse position.
    MOUSE_MOVE_ABSOLUTE         := 1     ;Mouse movement data is based on absolute position.
    MOUSE_VIRTUAL_DESKTOP       := 0x02  ;Mouse coordinates are mapped to the virtual desktop (for a multiple monitor system)
    MOUSE_ATTRIBUTES_CHANGED    := 0x04  ;Mouse attributes changed; application needs to query the mouse attributes.

    ;Flags for the II_MSE_BUTTONFLAGS member
    RI_MOUSE_LEFT_BUTTON_DOWN   := 0x0001   ;Self-explanatory
    RI_MOUSE_LEFT_BUTTON_UP     := 0x0002   ;Self-explanatory
    RI_MOUSE_RIGHT_BUTTON_DOWN  := 0x0004   ;Self-explanatory
    RI_MOUSE_RIGHT_BUTTON_UP    := 0x0008   ;Self-explanatory
    RI_MOUSE_MIDDLE_BUTTON_DOWN := 0x0010   ;Self-explanatory
    RI_MOUSE_MIDDLE_BUTTON_UP   := 0x0020   ;Self-explanatory
    RI_MOUSE_BUTTON_4_DOWN      := 0x0040   ;XBUTTON1 changed to down.
    RI_MOUSE_BUTTON_4_UP        := 0x0080   ;XBUTTON1 changed to up.
    RI_MOUSE_BUTTON_5_DOWN      := 0x0100   ;XBUTTON2 changed to down.
    RI_MOUSE_BUTTON_5_UP        := 0x0200   ;XBUTTON2 changed to up.
    RI_MOUSE_WHEEL              := 0x0400   ;Raw input comes from a mouse wheel. The wheel delta is stored in usButtonData.
    ;____________________________________________
    ;Flags for the RAWKEYBOARD (part of RAWINPUT)
    ;http://msdn.microsoft.com/en-us/library/ms645575

    ;Flag for the II_KBD_MAKECODE member in the event of a keyboard overrun
    KEYBOARD_OVERRUN_MAKE_CODE  := 0xFF

    ;Flags for the II_KBD_FLAGS member
    RI_KEY_MAKE             := 0
    RI_KEY_BREAK            := 1
    RI_KEY_E0               := 2
    RI_KEY_E1               := 4
    RI_KEY_TERMSRV_SET_LED  := 8
    RI_KEY_TERMSRV_SHADOW   := 0x10

    ;____________________________________
    ;AHKHID FUNCTIONS

    Initialize(bRefresh = False) {
        Static uHIDList, bInitialized := False
    
        If bInitialized And Not bRefresh
            Return &uHIDList
    
        ;Get the device count
        r := DllCall("GetRawInputDeviceList", "Ptr", 0, "UInt*", iCount, "UInt", A_PtrSize * 2)
    
        ;Check for error
        If (r = -1) Or ErrorLevel {
            ErrorLevel = GetRawInputDeviceList call failed.`nReturn value: %r%`nErrorLevel: %ErrorLevel%`nLine: %A_LineNumber%`nLast Error: %A_LastError%
            Return -1
        }
    
        ;Prep var
        VarSetCapacity(uHIDList, iCount * (A_PtrSize * 2))
        r := DllCall("GetRawInputDeviceList", "Ptr", &uHIDList, "UInt*", iCount, "UInt", A_PtrSize * 2)
        If (r = -1) Or ErrorLevel {
            ErrorLevel = GetRawInputDeviceList call failed.`nReturn value: %r%`nErrorLevel: %ErrorLevel%`nLine: %A_LineNumber%`nLast Error: %A_LastError%
            Return -1
        }
    
        bInitialized := True
        Return &uHIDList
    }

    GetDevCount() {
    
        ;Get the device count
        r := DllCall("GetRawInputDeviceList", "Ptr", 0, "UInt*", iCount, "UInt", A_PtrSize * 2)
    
        ;Check for error
        If (r = -1) Or ErrorLevel {
            ErrorLevel = GetRawInputDeviceList call failed.`nReturn value: %r%`nErrorLevel: %ErrorLevel%`nLine: %A_LineNumber%`nLast Error: %A_LastError%
            Return -1
        } Else Return iCount
    }

    GetDevHandle(i) {
        Return NumGet(this.Initialize(), (i - 1) * (A_PtrSize * 2))
    }

    GetDevIndex(Handle) {
        Loop % this.GetDevCount()
            If (NumGet(this.Initialize(), (A_Index - 1) * (A_PtrSize * 2)) = Handle)
                Return A_Index
        Return 0
    }

    GetDevType(i, IsHandle = False) {
        Return Not IsHandle ? NumGet(this.Initialize(), ((i - 1) * (A_PtrSize * 2)) + A_PtrSize, "UInt")
        : NumGet(this.Initialize(), ((this.GetDevIndex(i) - 1) * (A_PtrSize * 2)) + A_PtrSize, "UInt")
    }

    GetDevName(i, IsHandle = False) {
    
        ;Get index if i is handle
        h := IsHandle ? i : this.GetDevHandle(i)
    
        ;Get device name length.                                RIDI_DEVICENAME
        r := DllCall("GetRawInputDeviceInfo", "Ptr", h, "UInt", 0x20000007, "Ptr", 0, "UInt*", iLength)
        If (r = -1) Or ErrorLevel {
            ErrorLevel = GetRawInputDeviceInfo call failed.`nReturn value: %r%`nErrorLevel: %ErrorLevel%`nLine: %A_LineNumber%`nLast Error: %A_LastError%
            Return ""
        }
	
        ;Get device name.
        VarSetCapacity(s, (iLength + 1) * 2)                         ;RIDI_DEVICENAME
        r := DllCall("GetRawInputDeviceInfo", "Ptr", h, "UInt", 0x20000007, "Str", s, "UInt*", iLength)
        If (r = -1) Or ErrorLevel {
            ErrorLevel = GetRawInputDeviceInfo call failed.`nReturn value: %r%`nErrorLevel: %ErrorLevel%`nLine: %A_LineNumber%`nLast Error: %A_LastError%
            Return ""
        }
    
        Return s
    }

    GetDevInfo(i, Flag, IsHandle = False) {
        Static uInfo, iLastHandle := 0
    
        ;Get index if i is handle
        h := IsHandle ? i : this.GetDevHandle(i)
    
        ;Check if the handle changed
        If (h = iLastHandle) ;It's the same device. No need to call again
            Return NumGet(uInfo, Flag, this.NumIsShort(Flag) ? "UShort" : "UInt")
        Else {
        
            ;Get device info buffer size.                           RIDI_DEVICEINFO
            r := DllCall("GetRawInputDeviceInfo", "Ptr", h, "UInt", 0x2000000b, "Ptr", 0, "UInt*", iLength)
            If (r = -1) Or ErrorLevel {
                ErrorLevel = GetRawInputDeviceInfo call failed.`nReturn value: %r%`nErrorLevel: %ErrorLevel%`nLine: %A_LineNumber%`nLast Error: %A_LastError%
                Return -1
            }
        
            ;Get device info
            VarSetCapacity(uInfo, iLength)
            NumPut(iLength, uInfo, 0, "UInt") ;Put length in struct RIDI_DEVICEINFO
            r := DllCall("GetRawInputDeviceInfo", "Ptr", h, "UInt", 0x2000000b, "Ptr", &uInfo, "UInt*", iLength)
            If (r = -1) Or ErrorLevel {
                ErrorLevel = GetRawInputDeviceInfo call failed.`nReturn value: %r%`nErrorLevel: %ErrorLevel%`nLine: %A_LineNumber%`nLast Error: %A_LastError%
                Return -1
            }
        
            ;Successful. Keep handle.
            iLastHandle := h
        
            ;Retrieve data
            Return NumGet(uInfo, Flag, this.NumIsShort(Flag) ? "UShort" : "UInt")
        }
    
        Return 0
    }

    AddRegister(UsagePage = False, Usage = False, Handle = False, Flags = 0) {
        Static uDev, iIndex := 0, iCount := 0
    
        ;Check if we just want the address
        If Not (UsagePage Or Usage Or Handle Or Flags)
            Return &uDev
        ;Check if we just want the count
        Else If (UsagePage = "Count")
            Return iCount
        ;Check if we're dimensioning the struct
        Else If UsagePage And Not (Usage Or Handle Or Flags) {
            iCount := UsagePage
            iIndex := 0
            VarSetCapacity(uDev, iCount * (8 + A_PtrSize))
            Return &uDev
        }
    
        ;Check if there's space before adding data to struct
        If (iIndex = iCount)
            Return -1    ;Full capacity
    
        ;Check if hwnd needs to be null. RIDEV_REMOVE, RIDEV_EXCLUDE
        Handle := ((Flags & 0x00000001) Or (Flags & 0x00000010)) ? 0 : Handle

        ;Put in struct
        NumPut(UsagePage, uDev, (iIndex * (8 + A_PtrSize)) + 0, "UShort")
        NumPut(Usage,     uDev, (iIndex * (8 + A_PtrSize)) + 2, "UShort")
        NumPut(Flags,     uDev, (iIndex * (8 + A_PtrSize)) + 4, "UInt")
        NumPut(Handle,    uDev, (iIndex * (8 + A_PtrSize)) + 8, "Ptr")
    
        ;Move to next slot
        iIndex += 1
    
        Return &uDev
    }

    Register(UsagePage = False, Usage = False, Handle = False, Flags = 0) {
    
        ;Check if we're using the AddRegister array or only a single struct
        If Not (UsagePage Or Usage Or Handle Or Flags) {
        
            ;Call
            r := DllCall("RegisterRawInputDevices", "Ptr", this.AddRegister(), "UInt", this.AddRegister("Count"), "UInt", 8 + A_PtrSize)
        
            ;Check for error
            If Not r {
                ErrorLevel = RegisterRawInputDevices call failed.`nReturn value: %r%`nErrorLevel: %ErrorLevel%`nLine: %A_LineNumber%`nLast Error: %A_LastError%
                Return -1
            }
        
        ;Build struct and call
        } Else {
        
            ;Prep var
            VarSetCapacity(uDev, (8 + A_PtrSize), 0)
        
            ;Check if hwnd needs to be null. RIDEV_REMOVE, RIDEV_EXCLUDE
            Handle := ((Flags & 0x00000001) Or (Flags & 0x00000010)) ? 0 : Handle
        
            NumPut(UsagePage, uDev, 0, "UShort")
            NumPut(Usage,     uDev, 2, "UShort")
            NumPut(Flags,     uDev, 4, "UInt")
            NumPut(Handle,    uDev, 8, "Ptr")
        
            ;Call
            r := DllCall("RegisterRawInputDevices", "Ptr", &uDev, "UInt", 1, "UInt", 8 + A_PtrSize)
        
            ;Check for error
            If Not r Or ErrorLevel {
                ErrorLevel = RegisterRawInputDevices call failed.`nReturn value: %r%`nErrorLevel: %ErrorLevel%`nLine: %A_LineNumber%`nLast Error: %A_LastError%
                Return -1
            }
        }
    
        Return 0
    }

    GetRegisteredDevs(ByRef uDev) {
    
        ;Get length
        VarSetCapacity(iCount, 4, 0)
        r := DllCall("GetRegisteredRawInputDevices", "Ptr", 0, "UInt*", iCount, "UInt", 8 + A_PtrSize)
        If ErrorLevel {
            ErrorLevel = GetRegisteredRawInputDevices call failed.`nReturn value: %r%`nErrorLevel: %ErrorLevel%`nLine: %A_LineNumber%`nLast Error: %A_LastError%
            Return -1
        }
    
        If (iCount > 0) {
        
            ;Prep var
            VarSetCapacity(uDev, iCount * (8 + A_PtrSize))
        
            ;Call
            r := DllCall("GetRegisteredRawInputDevices", "Ptr", &uDev, "UInt*", iCount, "UInt", 8 + A_PtrSize)
            If (r = -1) Or ErrorLevel {
                ErrorLevel = GetRegisteredRawInputDevices call failed.`nReturn value: %r%`nErrorLevel: %ErrorLevel%`nLine: %A_LineNumber%`nLast Error: %A_LastError%
                Return -1
            }
        }
    
        Return iCount
    }

    GetInputInfo(InputHandle, Flag) {
        Static uRawInput, iLastHandle := 0
    
        ;Check if it's the same handle
        If (InputHandle = iLastHandle) ;We can retrieve the data without having to call again
            Return NumGet(uRawInput, Flag, this.NumIsShort(Flag) ? (this.NumIsSigned(Flag) ? "Short" : "UShort") : (this.NumIsSigned(Flag) ? "Int" : (Flag = 8 ? "Ptr" : "UInt")))
        Else {    ;We need to get a fresh copy
        
            ;Get raw data size                                           RID_INPUT
            r := DllCall("GetRawInputData", "UInt", InputHandle, "UInt", 0x10000003, "Ptr", 0, "UInt*", iSize, "UInt", 8 + A_PtrSize * 2)
            If (r = -1) Or ErrorLevel {
                ErrorLevel = GetRawInputData call failed.`nReturn value: %r%`nErrorLevel: %ErrorLevel%`nLine: %A_LineNumber%`nLast Error: %A_LastError%
                Return -1
            }
        
            ;Prep var
            VarSetCapacity(uRawInput, iSize)
        
            ;Get raw data                                                RID_INPUT
            r := DllCall("GetRawInputData", "UInt", InputHandle, "UInt", 0x10000003, "Ptr", &uRawInput, "UInt*", iSize, "UInt", 8 + A_PtrSize * 2)
            If (r = -1) Or ErrorLevel {
                ErrorLevel = GetRawInputData call failed.`nReturn value: %r%`nErrorLevel: %ErrorLevel%`nLine: %A_LineNumber%`nLast Error: %A_LastError%
                Return -1
            } Else If (r <> iSize) {
                ErrorLevel = GetRawInputData did not return the correct size.`nSize returned: %r%`nSize allocated: %iSize%
                Return -1
            }
        
            ;Keep handle reference of current uRawInput
            iLastHandle := InputHandle
        
            ;Retrieve data
            Return NumGet(uRawInput, Flag, this.NumIsShort(Flag) ? (this.NumIsSigned(Flag) ? "Short" : "UShort") : (this.NumIsSigned(Flag) ? "Int" : (Flag = 8 ? "Ptr" : "UInt")))
        }
    
        Return 0
    }

    GetInputData(InputHandle, ByRef uData) {
    
        ;Get raw data size                                           RID_INPUT
        r := DllCall("GetRawInputData", "UInt", InputHandle, "UInt", 0x10000003, "Ptr", 0, "UInt*", iSize, "UInt", 8 + A_PtrSize * 2)
        If (r = -1) Or ErrorLevel {
            ErrorLevel = GetRawInputData call failed.`nReturn value: %r%`nErrorLevel: %ErrorLevel%`nLine: %A_LineNumber%`nLast Error: %A_LastError%
            Return -1
        }
    
        ;Prep var
        VarSetCapacity(uRawInput, iSize)
    
        ;Get raw data                                                RID_INPUT
        r := DllCall("GetRawInputData", "UInt", InputHandle, "UInt", 0x10000003, "Ptr", &uRawInput, "UInt*", iSize, "UInt", 8 + A_PtrSize * 2)
        If (r = -1) Or ErrorLevel {
            ErrorLevel = GetRawInputData call failed.`nReturn value: %r%`nErrorLevel: %ErrorLevel%`nLine: %A_LineNumber%`nLast Error: %A_LastError%
            Return -1
        } Else If (r <> iSize) {
            ErrorLevel = GetRawInputData did not return the correct size.`nSize returned: %r%`nSize allocated: %iSize%
            Return -1
        }
    
        ;Get the size of each HID input and the number of them
        iSize   := NumGet(uRawInput, 8 + A_PtrSize * 2 + 0, "UInt") ;ID_HID_SIZE
        iCount  := NumGet(uRawInput, 8 + A_PtrSize * 2 + 4, "UInt") ;ID_HID_COUNT
    
        ;Allocate memory
        VarSetCapacity(uData, iSize * iCount)
    
        ;Copy bytes
        DllCall("RtlMoveMemory", UInt, &uData, UInt, &uRawInput + 8 + A_PtrSize * 2 + 8, UInt, iSize * iCount)
    
        Return (iSize * iCount)
    }

    ;Internal use only
    NumIsShort(ByRef Flag) {
        If (Flag & 0x0100) {
            Flag ^= 0x0100    ;Remove it
            Return True
        } Return False
    }

    ;Internal use only
    NumIsSigned(ByRef Flag) {
        If (Flag & 0x1000) {
            Flag ^= 0x1000    ;Remove it
            Return True
        } Return False
    }
}

; publish namespace
AHKHID := new nsAHKHID()
