Func searchEventList()
	$currentSearch = GUICtrlRead($searchEventTF)

	If $currentlySearching = 0 Then
		$completeEventList = _GUIListViewEx_ReturnArray($eventListIndex)
	EndIf

	Local $completeEventListArray[UBound($completeEventList)][5]

	For $i = 0 to UBound($completeEventList) - 1
		$currentItem = StringSplit($completeEventList[$i], "|", 2)

		$completeEventListArray[$i][0] = $currentItem[0]
		$completeEventListArray[$i][1] = $currentItem[1]
		$completeEventListArray[$i][2] = $currentItem[2]
		$completeEventListArray[$i][3] = $currentItem[3]
		$completeEventListArray[$i][4] = $currentItem[4]
	Next

	$foundItems = _ArrayFindAll($completeEventListArray, $currentSearch, Default, Default, Default, 1, 1)

	If IsArray($foundItems) Then
		ReDim $searchResultsList[UBound($foundItems)] ; resize the results array to add the search results in

		For $i = 0 to UBound($foundItems) - 1
			$currentItem = StringSplit($completeEventList[$foundItems[$i]], "|", 2)
			$searchResultsList[$i] = $completeEventList[$foundItems[$i]] ; the current event from the main playlist
		Next

		GUICtrlSetBkColor($searchEventTF, 0xb8ebcd)
		GUICtrlSetBkColor($eventList, 0xe4ffef)
		GUICtrlSetFont($eventList, 9, 400, 2, "Segoe UI")

		$currentlySearching = 1 ; set this flag to true to let the program know we're in search mode
		clearEvents()

		_GUICtrlListView_BeginUpdate($eventList)

		For $i = 0 to UBound($searchResultsList) - 1
			GUICtrlCreateListViewItem($searchResultsList[$i], $eventList)
		Next

		_GUICtrlListView_EndUpdate($eventList)

		$eventListIndex = _GUIListViewEx_Init($eventList, $searchResultsList, 0, 0, True, 1) ; for Dragging and Dropping items
		_GUICtrlListView_SetItemSelected($eventList, -1, False, False) ; for Dragging and Dropping items
		GUICtrlSetState($searchClearButton, $GUI_ENABLE)
		GUICtrlSetState($listClearButton, $GUI_HIDE) ; hides the "Clear All" button
	Else
		MsgBox(0, "", 'No results were found for "' & $currentSearch & '" in the current events list')
	EndIf
EndFunc