Func stripInfoFromName($eventName)
	$speedOffset = StringInStr($eventName, "<S:")

	If $speedOffset <> 0 Then ; if we have a speed setting on the event name (<S:30>), then take it off for the dialog
		$eventName = StringTrimLeft($eventName, $speedOffset)
		$endBracketOffset = StringInStr($eventName, ">")
		$eventName = StringTrimLeft($eventName, $endBracketOffset)
	EndIf

	$repeatOffset = StringInStr($eventName, "<L:")

	If $repeatOffset <> 0 Then ; if we have a repeat setting on the event name (<L:5>), then take it off for the dialog
		$eventName = StringTrimLeft($eventName, $repeatOffset)
		$endBracketOffset = StringInStr($eventName, ">")
		$eventName = StringTrimLeft($eventName, $endBracketOffset)
	EndIf

	Return $eventName
EndFunc



Func eventNamePrompt($textToInsert = "")
	Opt("GUIOnEventMode",0)

	$eventDialogWindow = GUICreate("Loop event name", 315, 149, -1, -1)
	$eventHappenedLabel = GUICtrlCreateLabel("", 8, 4, 300, 21, $SS_LEFT)

	$eventNameTF = GUICtrlCreateEdit("", 8, 26, 297, 22, $ES_AUTOVSCROLL)

	$speedLabel = GUICtrlCreateLabel("What Speed?", 8, 52, 81, 21, $SS_CENTER)
	$speedTF = GUICtrlCreateEdit("---", 8, 74, 81, 22, $ES_AUTOVSCROLL)

	$repeatLabel = GUICtrlCreateLabel("How many times to play this loop?", 104, 52, 205, 21, $SS_CENTER)
	$repeatTF = GUICtrlCreateEdit("---", 104, 74, 201, 22, $ES_AUTOVSCROLL)

	$eventDialogOKButton = GUICtrlCreateButton("OK", 8, 112, 142, 25)
	$eventDialogCancelButton = GUICtrlCreateButton("Cancel", 156, 112, 150, 25)

	GUICtrlSetFont($eventHappenedLabel, 10, 400, 0, "Segoe UI")
	GUICtrlSetFont($eventNameTF, 10, 400, 0, "Segoe UI")

	GUICtrlSetFont($speedLabel, 10, 400, 0, "Segoe UI")
	GUICtrlSetFont($speedTF, 10, 400, 0, "Segoe UI")

	GUICtrlSetFont($repeatLabel, 10, 400, 0, "Segoe UI")
	GUICtrlSetFont($repeatTF, 10, 400, 0, "Segoe UI")

	GUICtrlSetFont($eventDialogOKButton, 10, 800, 0, "Segoe UI")
	GUICtrlSetFont($eventDialogCancelButton, 10, 400, 0, "Segoe UI")

	If $textToInsert = "" Then
		GUICtrlSetData($eventHappenedLabel, "What do you want to name this event?")
		GUICtrlSetData($speedTF, $currentSpeed)
	Else
		GUICtrlSetData($eventHappenedLabel, "What do you want to re-name this event?")
		GUICtrlSetData($eventNameTF, stripInfoFromName($textToInsert))
		GUICtrlSetData($speedTF, checkNameSpeedSetting($textToInsert))
		GUICtrlSetData($repeatTF, checkNameRepeatSetting($textToInsert))
	EndIf

	Dim $eventDialogWindow_AccelTable[2][2] = [["{ENTER}", $eventDialogOKButton],["{ESC}", $eventDialogCancelButton]]
	GUISetAccelerators($eventDialogWindow_AccelTable)

	GUISetState(@SW_SHOW)

	_WinAPI_SetFocus(ControlGetHandle($eventDialogWindow, "", $eventNameTF))
	WinSetOnTop($eventDialogWindow, "", 1)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE, $eventDialogCancelButton
				$textReturned = ""
				GUIDelete($eventDialogWindow)
				ExitLoop
			Case $eventDialogOKButton
				$textReturned = ""

				If GUICtrlRead($speedTF) <> "100" Then
					$textReturned = $textReturned & "<S:" & GUICtrlRead($speedTF) & ">"
				EndIf

				If GUICtrlRead($repeatTF) <> "---" Then
					$textReturned = $textReturned & "<L:" & GUICtrlRead($repeatTF) & ">"
				EndIf

				If GUICtrlRead($eventNameTF) = "" Then
					$textReturned = $textReturned & "New Loop Event"
				Else
					$textReturned = $textReturned & GUICtrlRead($eventNameTF)
				EndIf

				GUIDelete($eventDialogWindow)
				ExitLoop
		EndSwitch
	WEnd

	Opt("GUIOnEventMode",1)
	Return $textReturned
EndFunc