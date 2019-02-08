Func modifyEventPrompt() ; modify an event in the event list
	If GUICtrlRead($listModifyButton) = "Modify Event" Then
		If $currentlySearching = 2 Then
			$currentItem = $searchResultsList[$currentPlayingEvent]
			$currentPlayingEvent = Int(StringLeft($currentItem, StringInStr($currentItem, "|"))) - 1
		EndIf

		searchEventListRestore()
		initializeEventChange($GUI_DISABLE)

		$currentEvent = _GUICtrlListView_GetItemText($eventList, $currentPlayingEvent, 0) ; the current position of this event in the list
		$currentName = _GUICtrlListView_GetItemText($eventList, $currentPlayingEvent, 1) ; the current name of this event in the list
		$currentName = eventNamePrompt($currentName)

		If $currentName <> "" Then
			$inPoint = GUICtrlRead($inTF)
			$outPoint = GUICtrlRead($outTF)

			refreshMPCInfo()
			$currentFile = $nowPlayingInfo[4]

			modifyEvent($currentPlayingEvent, $currentEvent, $currentName, $inPoint, $outPoint, $currentFile, $currentPlayingEvent, $currentPlayingEvent)
		EndIf

		initializeEventChange($GUI_ENABLE)
	Else
		$currentlySelected = _GUICtrlListView_GetSelectedIndices($eventList, 1)

		If $currentlySelected[0] <> 0 Then
			$newName = "[Events " & _GUICtrlListView_GetItemText($eventList, $currentlySelected[1], 0) & "-" & _GUICtrlListView_GetItemText($eventList, $currentlySelected[UBound($currentlySelected) - 1], 0) &"]"
			$newINPoint =  _GUICtrlListView_GetItemText($eventList, $currentlySelected[1], 2)
			$newOUTPoint = _GUICtrlListView_GetItemText($eventList, $currentlySelected[UBound($currentlySelected) - 1], 3)
			$newDur = NumberToTimeString(getEventDur($newINPoint, $newOUTPoint))
			$currentFile = _GUICtrlListView_GetItemText($eventList, $currentlySelected[1], 5)

			$combineEvents = MsgBox(4, "Combine events?", "Are you sure you want to combine these " & $currentlySelected[0] & " events into one event?" & @CRLF & @CRLF & _
			"New Name: " & $newName & @CRLF & @CRLF & _
			"New IN Point: " & $newINPoint & @CRLF & _
			"New OUT Point: " & $newOUTPoint & @CRLF & @CRLF & _
			"New Duration: " & $newDur)

			If $combineEvents = 6 Then ; you clicked on "Yes" to combining files
				;          The current event's ID  The event's proper order in the event list (the leftmost column)    Name      IN Point     Out Point     Filename      Event to start delete  Event to stop delete (the last item of the array)
				modifyEvent($currentlySelected[1], _GUICtrlListView_GetItemText($eventList, $currentlySelected[1], 0), $newName, $newINPoint, $newOUTPoint, $currentFile, $currentlySelected[1], $currentlySelected[UBound($currentlySelected) -1])
			EndIf
		EndIf
	EndIf
EndFunc