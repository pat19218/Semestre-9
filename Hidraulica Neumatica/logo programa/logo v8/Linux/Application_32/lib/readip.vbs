strComputer = "." 
argsCount = Wscript.Arguments.Count
Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\CIMV2") 
queryStr = "SELECT * FROM Win32_NetworkAdapterConfiguration Where IPEnabled=TRUE"
If argsCount=1 Then
	queryStr = queryStr & " And Description='" & Wscript.Arguments.item(0) & "'"
End If
Set colItems = objWMIService.ExecQuery(queryStr)
If colItems.Count=0 Then
	Wscript.Echo "no record"
Else
	For Each objItem in colItems
		Wscript.Echo "beginrow---"
		Wscript.Echo "Index:" & objItem.Index
		Wscript.Echo "Description:" & objItem.Description
		Wscript.Echo "DHCPEnabled:" & objItem.DHCPEnabled
		
		If Not IsNull(objItem.IPAddress) Then
			Wscript.Echo "IPAddress:" & Join(objItem.IPAddress, ",")
		Else
			Wscript.Echo "IPAddress:"
		End if
		If Not IsNull(objItem.IPSubnet) Then
			Wscript.Echo "IPSubnet:" & Join(objItem.IPSubnet, ",")
		Else
			Wscript.Echo "IPSubnet:"
		End if
		If Not IsNull(objItem.DefaultIPGateway) Then
			Wscript.Echo "DefaultIPGateway:" & Join(objItem.DefaultIPGateway, ",")
		Else
			Wscript.Echo "DefaultIPGateway:"
		End if
		Wscript.Echo "endrow---"
	Next
End If