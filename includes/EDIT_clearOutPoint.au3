Func clearOutPoint() ; clear the OUT point
	GUICtrlSetBkColor($clearOutButton, 0xb9b9b9)

	If IsArray($nowPlayingInfo) Then
		GUICtrlSetData($outTF, NumberToTimeString($nowPlayingInfo[5] + 0.5 - 0.057))
	EndIf

	clearOSDInfo()
	Sleep(30)
	GUICtrlSetBkColor($clearOutButton, 0xFF000000)
EndFunc