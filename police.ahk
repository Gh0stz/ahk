#IfWinActive GTA:SA:MP
#include SAMP.ahk

sbros:=1
funcIndex:=0
suspectids:=-1
step:=-1
grID:=-1
tagstring:=""
start_time:=0
start_time1:=0
start_time2:=0
start_time3:=0
arrestidone:=-1
arrestidtwo:=-1
followidone:=-1
followidtwo:=-1
cputidone:=-1
cputidtwo:=-1
cejectidone:=-1
cejectidtwo:=-1

Version := 15
sVersion := "0.4"
UserCount := 0

MainMenuString:="{FFD700} [ - ] ��������� �������: Norman Reed � Fernando Barrowman. [ - ]`n{FFFFFF} {008080}�{FFFFFF} ���� ������ ������� (3 ��.) � �������� {FF0000}� {FFFFFF}�� ����������� �������. `t`t`t`t ���������: {00FF11}Alt+1.`n{FFFFFF} {008080}�{FFFFFF} ���� ������ ������� (3 ��.) � �������� {FF8D00}B {FFFFFF}�� ����������� �������. `t`t`t`t ���������: {00FF11}Alt+2.`n{FFFFFF} {008080}�{FFFFFF} �������������� ���������� ������� ������ � �� ����������. `t`t`t`t ���������: {00FF11}Alt+3.`n{FFFFFF} {008080}�{FFFFFF} �������������� ������� � ����� (������� ���� ������ ��������). `t`t`t`t ���������: {00FF11}Alt+4.`n{FFFFFF} {008080}�{FFFFFF} �������������� ��������� (��������� ������ �������� �������). `t`t`t`t ���������: {00FF11}Alt+5.`n{FFFFFF} {008080}�{FFFFFF} �������������� ����� �������������� � ������ RP ����������. `t`t`t`t ���������: {00FF11}Alt+6.`n{FFFFFF} {008080}�{FFFFFF} �������������� ������������� ���. ������������� � ������ RP ����������. `t`t ���������: {00FF11}Alt+7.`n{FFFFFF} {008080}�{FFFFFF} �������������� ������ � ����� � ������ � ��������� ������� �������. `t`t`t ���������: {00FF11}Alt+9.`n{FFFFFF} {008080}�{FFFFFF} �������������� ����������� ������ � ������ RP ����������. `t`t`t`t ���������: {00FF11}Alt+0.`n {008080}�{FFFFFF} ������������� /mdc �� ������� � ����� (����� ���� � ��������� ������).  `t`t ���������: {00FF11}Numpad Dot.`n {008080}�{FFFFFF} ������� ��������� � /m (����� 3-� ��������� ���������� �������� ����).  `t`t ���������: {00FF11}Numpad 8.`n {008080}�{FFFFFF} ����� �������� ���� ��� ������� ������� ���������� � ����������� ��������. `t`t ���������: {00FF11}Numpad [4/5/6/7].`n {008080}�{FFFFFF} ����� ���� ���������� ������� �� �������� �� ��������� (����� ���� ��� �����).  `t ���������: {00FF11}Numpad 9.`n{FFFFFF} {008080}�{FFFFFF} ������� ���� ������ ��� ���������� ��������������� ������. `t`t`t`t ���������: {00FF11}Numpad 9."

Loop %0%
ComParam%A_Index% := %A_Index%
If ComParam1 = /Update
	Update(ComParam2, ComParam3)
Else If ComParam1 = /TempDelete
	TempDelete(ComParam2, ComParam3)
Else
	CheckUpdate(Version)

If ComParam1 = /Update
	Goto, StartScript
Else
	Goto, FirstMenu
Return

CheckUpdate(Version)
{
	IfExist, %A_scriptdir%\config.ini
		FileDelete, %A_scriptdir%\config.ini
	
	IfNotExist, %A_scriptdir%\files
		FileCreateDir, files

	FileInstall, 37945-200.png, %A_scriptdir%\files\Icon.png, 0
	file=%A_scriptdir%\files\config.ini
	global File_Update
	IfExist, %file%
	{
		IniRead, File_Update, %file%, Main, AutoUpdate
	}
	Http := ComObjCreate("WinHttp.WinHttpRequest.5.1"), Http.Option(6) := 0
	Http.Open("GET", "https://raw.githubusercontent.com/NReedz/ahk/master/README.md")
	Http.Send(), Text := Http.ResponseText
	Http.Open("GET", "https://raw.githubusercontent.com/NReedz/ahk/master/CHANGELOG.md")
	Http.Send(), Text1 := Http.ResponseText
	if(RegExMatch(Text, "i).*?Version\s*(\d+)\s!"))
		MustUpd:=1
	New := RegExReplace(Text, "i).*?Version\s*(\d+)\s*", "$1")
	If (New <= Version)
		Return
	
	if(MustUpd == 1 or File_Update == 1 or File_Update = "Yes")
	{
		if(MustUpd != 1)
			MsgBox, % 0+64,  �������������� ����������, ����� ������ ������� ����� ����������� �������������.`n `n [ ������ ���������: ] `n%Text1%
		URLDownloadToFile, https://github.com/NReedz/ahk/blob/master/police.exe?raw=true, %A_Temp%\Update.exe
		PID := DllCall("GetCurrentProcessId")
		Run %A_Temp%\Update.exe "/Update" "%PID%" "%A_ScriptFullPath%"
		ExitApp
	}
}
Update(PID, Path)
{
	Process, Close, %PID%
	Process, WaitClose, %PID%, 3
	If ErrorLevel
	{
		MsgBox, % 16, �������������� ����������, �� ������ ������� �������
		ExitApp
	}
	FileCopy, %A_ScriptFullPath%, %Path%, 1
	If ErrorLevel
	{
		MsgBox, % 16,  �������������� ����������, �� ������� �����������, �������� ���� �������� ��������� ����������� ���������
		ExitApp
	}
	PID := DllCall("GetCurrentProcessId")
	Run %Path% "/TempDelete" "%PID%" "%A_ScriptFullPath%"
	ExitApp
}
TempDelete(PID, Path) 
{
	Process, Close, %PID%
	Process, WaitClose, %PID%, 2
	FileDelete, %Path%
}

CheckFile()
{
	file=%A_scriptdir%\files\config.ini
	global File_Tag, File_Nick, File_Rand, File_Police, File_Chatlog, FullChatLogPath, HotKey1, HotKey2, HotKey3, HotKey4, HotKey5, HotKey6, HotKey7, HotKey8, HotKey9, HotKey10, HotKey11, HotKey12
	IfExist,  %file%
	{
		IniRead, File_Nick, %file%, Main, Name
		IniRead, File_Tag, %file%, Main, GameTag
		IniRead, File_Update, %file%, Main, AutoUpdate
		IniRead, File_Rand, %file%, Main, UseRandom
		IniRead, File_Police, %file%, Main, PoliceName
		IniRead, File_Chatlog, %file%, Main, ChatLog
		if(File_Chatlog = "�����������")
			FullChatLogPath =%A_MyDocuments%\GTA San Andreas User Files\SAMP\chatlog.txt
		else
			FullChatLogPath =%File_Chatlog%
			
		IniRead, TestKey, %file%, Keys, Key7
		if(TestKey == "ERROR")
		{
			IniWrite, !6, %file%, Keys, Key7
			IniWrite, !0, %file%, Keys, Key8
			IniWrite, Numpad8, %file%, Keys, Key9
			IniWrite, NumpadDot, %file%, Keys, Key10
			IniWrite, !9, %file%, Keys, Key11
			IniWrite, !7, %file%, Keys, Key12
		}
		
		s_Index = 1
		Loop 12
		{
			IniRead, Key%s_Index%, %file%, Keys, Key%s_Index%
			s_Index++
		}
		Return
	}
	IniWrite, No, %file%, Main, Name
	IniWrite, No, %file%, Main, GameTag
	IniWrite, No, %file%, Main, UseRandom
	IniWrite, No, %file%, Main, AutoUpdate
	IniWrite, LSPD, %file%, Main, PoliceName
	IniWrite, �����������, %file%, Main, ChatLog

	IniWrite, !F2, %file%, Keys, Key1
	IniWrite, !3, %file%, Keys, Key2
	IniWrite, !4, %file%, Keys, Key3
	IniWrite, !5, %file%, Keys, Key4
	IniWrite, NumpadSub, %file%, Keys, Key5
	IniWrite, Numpad9, %file%, Keys, Key6
	IniWrite, !6, %file%, Keys, Key7
	IniWrite, !0, %file%, Keys, Key8
	IniWrite, Numpad8, %file%, Keys, Key9
	IniWrite, NumpadDot, %file%, Keys, Key10
	IniWrite, !9, %file%, Keys, Key11
	IniWrite, !7, %file%, Keys, Key12
	
	FileAppend, `n`n# ��������:`n# Name - ��� � ����`n# GameTag - ��� ��� �����`n# UseRandom - ���. ��������� ���������`n# AutoUpdate - �������������� ����������`n# PoliceName - ����������� �������� �������, %A_scriptdir%\files\config.ini
	
	IniRead, File_Nick, %file%, Main, Name
	IniRead, File_Tag, %file%, Main, GameTag
	IniRead, File_Rand, %file%, Main, UseRandom
	IniRead, File_Update, %file%, Main, AutoUpdate
	IniRead, File_Police, %file%, Main, PoliceName
	IniRead, File_Chatlog, %file%, Main, ChatLog
	
	s_Index = 1
	Loop 12
	{
		IniRead, Key%s_Index%, %file%, Keys, Key%s_Index%
		s_Index++
	}
	Return
}

Authorization:
{	
	if(File_Nick == "No" or File_Nick == "")
	{
		Msgbox, 48, ������, �� �� ����� ���� ������� ���!
		Return
	}
	if(!RegExMatch(File_Nick, "(.*)_(.*)"))
	{
		Msgbox, 48, ������, �� ����� ������������ ������� ���!
		Return
	}
	if(File_Police != "LSPD" and File_Police != "SFPD" and File_Police != "LVPD" and File_Police != "FBI")
	{
		Msgbox, 48, ������, ������� ���������� �������� ������� (LSPD | SFPD | LVPD | FBI).
		Return
	}

	Indexator := 0
	IndexatorTwo := 0
	Loop
	{
		IndexatorTwo++
		Loop
		{
			Indexator++
			if(IndexatorTwo != Indexator)
			{
				if(Key%IndexatorTwo% == Key%Indexator%)
				{
					Msgbox, 48, ������, ��������� ������ ������� ��� ������������� �������!
					Return
				}
			}
			if(Indexator > 11)
			{
				Indexator := 0
				break
			}
		}
		if(IndexatorTwo > 11)
			break
	}
	
	Goto, EnterScript
}
Return

FirstMenu:
{
	#SingleInstance Ignore
	SetBatchLines, -1
	Menu, Tray, NoStandard
	Menu, Tray, Add, ���������� VK, GoVKGroup
	Menu, Tray, Add
	Menu, Tray, Add, ������ ������, GoASK
	Menu, Tray, Add, �������� � ����, GoBugFix
	Menu, Tray, Add, ���� � ���������, GoOffer
	Menu, Tray, Add
	Menu, Tray, Add, ���������� �������, GuiClose
	Menu, Tray, Default, ���������� VK

	Http := ComObjCreate("WinHttp.WinHttpRequest.5.1"), Http.Option(6) := 0
	Http.Open("GET", "https://n0rmreedz.000webhostapp.com/counter.php")
	Http.Send(), Text2 := Http.ResponseText
	UserCount := RegExReplace(Text2, "i).*?����� ������������� �������:\s*(\d+)\s*", "$1")
	if(RegExMatch(UserCount, "HTML"))
		UserCount:="25"

	Gui 1:Add, GroupBox, x3 y-1 w430 h70 , 
	Gui 1:Font, S12 CDefault, Arial
	Gui 1:Add, Text, x82 y14 w280 h20 , AutoHotKey ��� ����������� Samp-RP
	Gui 1:Font, S10 CDefault, Arial
	Gui 1:Add, Text, x16 y46 w130 h20 , ������ �������: %sVersion%
	Gui 1:Add, Text, x310 y46 w110 h20 , ����� �����: #%Version%
	Gui 1:Add, Text, x158 y46 w145 h20 , |   �������������: %UserCount%   |
	Gui 1:Add, GroupBox, x3 y-1 w430 h42 , 
	Gui 1:Add, Progress, vMyProgress x13 y79 w410 h10 , 100
	Gui 1:Add, GroupBox, x2 y99 w210 h120 , �������������� �������
	Gui 1:Add, GroupBox, x222 y99 w210 h120 , INI-���� ��������
	Gui 1:Font, S9 CDefault, Arial
	Gui 1:Add, Text, x232 y119 w190 h90 , ������ ������ ����� ������� �������� ���� ����� ������ �������� � ����������� INI �����. ��� ��������� � ������ ��������� ������ ������� ��������� � ������ ��������.
	Gui, Add, Text, x12 y119 w190 h90 , ��� �������� ������������� � ������ ������� ����������� ����������� ��������������� ����������. ��� ��������� ��� ����� ����� ���� �������� ��� ����� � ���������� �������.
	Gui 1:Add, Button, x22 y234 w110 h30 vSettings, ���������
	Gui 1:Add, Button, Default x162 y229 w100 h40 +Disabled vStart, �����
	Gui 1:Add, Button, x292 y234 w120 h30 , �����
	Gui 1:-SysMenu
	Gui 1:Show, x462 y196 h280 w435, Police Helper ��� Samp-RP
	StringCheck(MainMenuString)
	Goto, FillProgressBar
}

SecondMenu:
	enabled := 0
	ImgCreated := 0
	CheckFile()
	Gui 2:Destroy
	Gui 2:Font, S18 CDefault, Constantia
	Gui 2:Add, Text, x99 y2 w160 h30 +BackgroundTrans, ���������
	Gui 2:Font, S12 CDefault, Constantia
	Gui 2:Add, Button, x42 y300 w100 h30 Default gSaving, ���������
	Gui 2:Add, Button, x185 y300 w100 h30 Default gStandart, ��������
	Gui 2:Font, S10 CDefault, Arial
	Gui 2:Add, Tab, x2 y39 w330 h250 , �������� ���������|������� #1|������� #2
	Gui 2:Tab, �������� ���������
	Gui 2:Add, Text, x22 y79 w110 h20 , ������� ���
	Gui 2:Add, Text, x22 y139 w110 h20 , ���� �������
	Gui 2:Add, Text, x22 y109 w110 h20 , ��� ��� �����
	Gui 2:Add, Text, x22 y169 w100 h20 , ���� � �������
	Gui 2:Add, Edit, x142 y79 w170 h20 vNick , %File_Nick%
	Gui 2:Add, Edit, x142 y109 w170 h20 vTag , %File_Tag%
	Gui 2:Add, Edit, x142 y139 w170 h20 vPolice , %File_Police%
	if(File_Update = "Yes")
		Gui 2:Add, CheckBox, x22 y199 w290 h20 vUpdate Checked, �������� �������������� ����������
	else
		Gui 2:Add, CheckBox, x22 y199 w290 h20 vUpdate, �������� �������������� ����������
	if(File_Rand = "Yes")
		Gui 2:Add, CheckBox, x22 y229 w290 h20 vRandom Checked, ������������� ��������� ���������
	else
		Gui 2:Add, CheckBox, x22 y229 w290 h20 vRandom , ������������� ��������� ���������
	if(File_Chatlog != "�����������")
	{
		ImgCreated = 1
		Gui 2:Add, Picture, gClickImage vImage x122 y169 w20 h20 , %A_scriptdir%\files\Icon.png
		Gui 2:Add, Edit, x142 y169 w170 h20 vChatlogPath, %File_Chatlog%
		Gui 2:Add, CheckBox, x22 y259 w290 h20 vChatlog gEnableOwnPath Checked, ������������ ������ ���� � �������
	}
	else
	{
		Gui 2:Add, CheckBox, x22 y259 w290 h20 vChatlog gEnableOwnPath, ������������ ������ ���� � �������
		Gui 2:Add, Edit, x142 y169 w170 h20 +Disabled vChatlogPath, %File_Chatlog%
	}
	Gui 2:Tab, ������� #1
	Gui 2:Add, Hotkey, vKey1 x22 y79 w70 h20 , %Key1%
	Gui 2:Add, Hotkey, vKey2 x22 y113 w70 h20 , %Key2%
	Gui 2:Add, Hotkey, vKey3 x22 y147 w70 h20 , %Key3%
	Gui 2:Add, Hotkey, vKey4 x22 y181 w70 h20 , %Key4%
	Gui 2:Add, Hotkey, vKey5 x22 y215 w70 h20 , %Key5%
	Gui 2:Add, Hotkey, vKey6 x22 y249 w70 h20 , %Key6%
	Gui 2:Add, Text, x122 y79 w210 h20 , ��������� �������� ����
	Gui 2:Add, Text, x122 y113 w210 h20 , ������ ���������� ������
	Gui 2:Add, Text, x122 y147 w210 h20 , �������������� ������
	Gui 2:Add, Text, x122 y181 w210 h20 , ��������� �����������
	Gui 2:Add, Text, x122 y215 w210 h20 , ������ ���� � ����������
	Gui 2:Add, Text, x122 y249 w210 h20 , ������� ���������� �������
	Gui 2:Tab, ������� #2
	Gui 2:Add, Hotkey, vKey7 x22 y79 w70 h20 , %Key7%
	Gui 2:Add, Hotkey, vKey8 x22 y113 w70 h20 , %Key8%
	Gui 2:Add, Hotkey, vKey9 x22 y147 w70 h20 , %Key9%
	Gui 2:Add, Hotkey, vKey10 x22 y181 w70 h20 , %Key10%
	Gui 2:Add, Hotkey, vKey11 x22 y215 w70 h20 , %Key11%
	Gui 2:Add, Hotkey, vKey12 x22 y249 w70 h20 , %Key12%
	Gui 2:Add, Text, x122 y79 w210 h20 , �������������� �����
	Gui 2:Add, Text, x122 y113 w210 h20 , �������������� �����
	Gui 2:Add, Text, x122 y147 w210 h20 , ��������� � �������
	Gui 2:Add, Text, x122 y181 w210 h20 , ������� /mdc �� �������
	Gui 2:Add, Text, x122 y215 w210 h20 , ���� ������ � ������
	Gui 2:Add, Text, x122 y249 w210 h20 , ���� ������� ���. ����
	Gui 2:-SysMenu
	Gui 2:Show, x899 y196 h341 w329, Police Helper ��� Samp-RP
	GuiControl, Focus, Nick
return

FillProgressBar:
	Loop
	{
		if A_Index > 100
			break
		GuiControl,, MyProgress, %A_Index%
		Sleep 20
	}
	CheckFile()
	GuiControl, Enable, Start
Return

ClickImage:
	FileSelectFile, Fav, 3, FileName, ������� ���� � chatlog.txt, ��������� ����� (*.txt)
	if(Fav = "")
		Fav := "�����������"
	GuiControl,, ChatlogPath, %Fav%
Return

EnableOwnPath:
	if(File_Chatlog = "�����������")
	{
		if(enabled = 0)
		{
			GuiControl, Enable, ChatlogPath
			if(ImgCreated = 0)
			{
				Gui 2:Tab, �������� ���������
				Gui 2:Add, Picture, gClickImage vImage x122 y169 w20 h20 , %A_scriptdir%\files\Icon.png
				GuiControl, Move, Image, w0
				GuiControl, Move, Image, w20
				ImgCreated = 1
			}
			else
			{
				GuiControl, Move, Image, w20
			}
			enabled := 1
			Return
		}
		else
		{
			GuiControl, Disable, ChatlogPath
			GuiControl,, ChatlogPath, �����������
			GuiControl, Move, Image, w0
			enabled := 0
		}
	}
	else
	{
		if(enabled = 0)
		{
			GuiControl, Disable, ChatlogPath
			GuiControl,, ChatlogPath, �����������
			GuiControl, Move, Image, w0
			enabled := 1
			Return
		}
		else
		{
			GuiControl, Enable, ChatlogPath
			if(ImgCreated = 1)
				GuiControl, Move, Image, w20
			else
			{
				Gui 2:Tab, �������� ���������
				Gui 2:Add, Picture, gClickImage vImage x122 y169 w20 h20 , %A_scriptdir%\files\Icon.png
				ImgCreated = 1
			}
			enabled := 0
		}
	}
Return

Button���������:
	Goto, SecondMenu
Return
	
Button�����:
	Goto, GuiClose
Return
	
Button�����:
	CheckFile()
	Goto, Authorization
Return

GuiClose:
	ExitApp

Saving:
	Gui, Submit
	if(Update = 1)
		File_Update := "Yes"
	else
		File_Update := "No"
	if(Random = 1)
		File_Rand := "Yes"
	else
		File_Rand := "No"
	if(Chatlog = 0)
		ChatlogPath := "�����������"

	file=%A_scriptdir%\files\config.ini
	IniWrite, %Nick%, %file%, Main, Name
	IniWrite, %Tag%, %file%, Main, GameTag
	IniWrite, %Police%, %file%, Main, PoliceName
	IniWrite, %File_Rand%, %file%, Main, UseRandom
	IniWrite, %File_Update%, %file%, Main, AutoUpdate
	IniWrite, %ChatlogPath%, %file%, Main, ChatLog
	
	s_Index = 1
	Loop 12
	{
		IniWrite, % Key%s_Index%, %file%, Keys, Key%s_Index%
		s_Index++
	}
Return

Standart:
	MsgBox, % 4+32, ������������� ������, �� �������, ��� ������ ���������� ����������� �������?
	IfMsgBox No
		Return

	IniWrite, !F2, %file%, Keys, Key1
	IniWrite, !3, %file%, Keys, Key2
	IniWrite, !4, %file%, Keys, Key3
	IniWrite, !5, %file%, Keys, Key4
	IniWrite, NumpadSub, %file%, Keys, Key5
	IniWrite, Numpad9, %file%, Keys, Key6
	IniWrite, !6, %file%, Keys, Key7
	IniWrite, !0, %file%, Keys, Key8
	IniWrite, Numpad8, %file%, Keys, Key9
	IniWrite, NumpadDot, %file%, Keys, Key10
	IniWrite, !9, %file%, Keys, Key11
	IniWrite, !7, %file%, Keys, Key12
	Gui 2: Destroy
	Goto, SecondMenu
Return

GoVKGroup:
	Run https://vk.com/pdhelper
Return

GoASK:
	Run https://vk.com/topic-143202034_35193847
Return

GoOffer:
	Run https://vk.com/topic-143202034_35193854
Return

GoBugFix:
	Run https://vk.com/topic-143202034_35193859
Return

EnterScript:
{
	Gui 1:Cancel
	Gui 2:Cancel
	TrayTip, Police AHK for Samp-RP, ������ ������� �������!
	
	s_Index = 1
	loop 12
	{
		HotKey, % Key%s_Index%, ActiveKey%s_Index%, On, UseErrorLevel
		s_Index++
	}
	URLDownloadToFile, http://n0rmreedz.000webhostapp.com/?text=%File_Nick%, %a_temp%\index.php
	if(File_Update = "Yes" or File_Update = "1")
		URLDownloadToFile, http://n0rmreedz.000webhostapp.com/autoupdate.php?text=%File_Nick%, %a_temp%\index.php

	StringCheck(MainMenuString)
}
Return

StartScript:


ActiveKey2:
{
	StringCheck(MainMenuString)
	IdTarget:=getIdByPed(getTargetPed())
	if (IdTarget == "-1")
	{
		IdTarget:=getClosestPlayerId()
		if (IdTarget == "-1")
		{
			addchatmessage("[AHK] ���� �� �������.")
			Return
		}
	}
	if(HasPlayerCopSkin(IdTarget))
	{
		addchatmessage("[AHK] ���������� ��������� � ���. ����������.")
		Return
	}
	name:=getPlayerNameById(IdTarget)
	if (arrestidone == IdTarget or arrestidtwo == IdTarget)
	{
		SendChat("/me ���������� "name " ����������� � ����")
		sleep 1200
		SendChat("/follow "IdTarget)
		if (followidone != -1 and followidtwo != -1)
		{
			addchatmessage("[AHK] ����� ��� ����� ������, �������� ����.")
			Return
		}
		if (arrestidone == IdTarget)
			arrestidone:=-1
		if (arrestidtwo == IdTarget)
			arrestidtwo:=-1
		if (followidone == -1)
		{
			followidone:=IdTarget
			Return
		}
		if (followidtwo == -1)
			followidtwo:=IdTarget
		Return
	}
	else if (followidone == IdTarget or followidtwo == IdTarget)
	{
		if(IsPlayerInRangeOfPoint(268.2251,80.3467,1001.0391, 15.0) or IsPlayerInRangeOfPoint(218.3700,114.7315,999.0156, 15.0) or IsPlayerInRangeOfPoint(195.9883,158.9503,1003.0234, 15.0))
		{
			addchatmessage("[AHK] ���� ��������� � ���, ���������� ���..")
			if (cejectidone != -1 and cejectidtwo != -1)
			{
				addchatmessage("[AHK] ����� ��� ����� ������, �������� ����.")
				Return
			}
			if (followidone == IdTarget)
				followidone:=-1
			if (followidtwo == IdTarget)
				followidtwo:=-1
			if (cejectidone == -1)
			{
				cejectidone:=IdTarget
				Return
			}
			if (cejectidtwo == -1)
				cejectidtwo:=IdTarget
			Return
		}
		SendChat("/cput "IdTarget)
		sleep 1200
		if(isPlayerInAnyVehicle())
		{
			if(File_Rand == "Yes" or File_Rand == 1)
			{
				if(getVehicleModelName() != "HPV1000")
				{
					Random, rand, 1, 3
					if (rand == 1)
						SendChat("/me ����� ������ ����� � ��������� "name " � ������")
					else if (rand == 2)
						SendChat("/me ������� �������������� "name " � ������")
					else if (rand == 3)
						SendChat("/me ������ ����� � ������� "name " � ���������� ������")
				}
				else
					SendChat("/me ������ �������������� "name " �� ��������")
			}
			else
				SendChat("/me ������ �������������� "name " � ���������")
		}
		else
			SendChat("/me ������ �������������� "name " � ���������")
		if (cputidone != -1 and cputidtwo != -1)
		{
			addchatmessage("[AHK] ����� ��� ����� ������, �������� ����.")
			Return
		}
		if (followidone == IdTarget)
			followidone:=-1
		if (followidtwo == IdTarget)
			followidtwo:=-1
		if (cputidone == -1)
		{
			cputidone:=IdTarget
			Return
		}
		if (cputidtwo == -1)
			cputidtwo:=IdTarget
		Return
	}
	else if (cputidone == IdTarget or cputidtwo == IdTarget)
	{
		if(!isTargetInAnyVehicleById(IdTarget))
		{
			addchatmessage("[AHK] ��������� ���� �� ��������� � ����������, ���������� ���..")
			if (cejectidone != -1 and cejectidtwo != -1)
			{
				addchatmessage("[AHK] ����� ��� ����� ������, �������� ����.")
				Return
			}
			if (cputidone == IdTarget)
				cputidone:=-1
			if (cputidtwo == IdTarget)
				cputidtwo:=-1
			if (cejectidone == -1)
			{
				cejectidone:=IdTarget
				Return
			}
			if (cejectidtwo == -1)
				cejectidtwo:=IdTarget
			Return
		}
		SendChat("/ceject "IdTarget)
		sleep 1200
		if(isPlayerInAnyVehicle())
		{
			if(File_Rand == "Yes" or File_Rand == 1)
			{
				if(getVehicleModelName() != "HPV1000")
				{
					Random, rand, 1, 3
					if (rand == 1)
						SendChat("/me ����� ������ ����� � ��������� "name " �� ������")
					else if (rand == 2)
						SendChat("/me ������� �������������� "name " �� ������")
					else if (rand == 3)
						SendChat("/me ������ ����� � ������� "name " �� ���������� ������")
				}
				else
					SendChat("/me ������� �������������� "name " � ���������")
			}
			else
				SendChat("/me ������� "name " �� ����������")
		}
		else
			SendChat("/me ������� "name " �� ����������")

		if (cejectidone != -1 and cejectidtwo != -1)
		{
			addchatmessage("[AHK] ����� ��� ����� ������, �������� ����.")
			Return
		}
		if (cputidone == IdTarget)
			cputidone:=-1
		if (cputidtwo == IdTarget)
			cputidtwo:=-1
		if (cejectidone == -1)
		{
			cejectidone:=IdTarget
			Return
		}
		if (cejectidtwo == -1)
			cejectidtwo:=IdTarget
		Return
	}
	else if (cejectidone == IdTarget or cejectidtwo == IdTarget)
	{
		if(!IsPlayerInRangeOfPoint(268.2251,80.3467,1001.0391, 30.0) and !IsPlayerInRangeOfPoint(218.3700,114.7315,999.0156, 20.0) and !IsPlayerInRangeOfPoint(195.9883,158.9503,1003.0234, 20.0))
		{
			addchatmessage("[AHK] �� ���������� ������� ������ �� ���.")
			Return
		}
		SendChat("/me ������ ������ � ������ "name " � ���")
		sleep 1200
		SendChat("/arrest "IdTarget)
		sleep 1200
		SendChat("/me ������ ������")
		if (cejectidone == IdTarget)
			cejectidone:=-1
		if (cejectidtwo == IdTarget)
			cejectidtwo:=-1
		Return
	}
	else
	{
		if(isPlayerInAnyVehicle())
		{
			addchatmessage("[AHK] �������� ����������, �� ���������� � ����������.")
			Return
		}
		if(File_Rand == "Yes" or File_Rand == 1)
		{
			Random, rand, 1, 4
			if(rand == 1)
			SendChat("/me ������� "name " ���� � ������� ��� �� �����")
			else if(rand == 2)
			SendChat("/me ������� "name " �� ���� � ������� ��� �� �����")
			else if(rand == 3)
			SendChat("/me ������� "name " ���� � ������ ������ ���������")
			else if(rand == 4)
			SendChat("/me ������� �� ����� "name " � ���������� ���")
		}
		else
		{
			SendChat("/me ������� "name " ���� � ������� ��� �� �����")
		}
		sleep 1100
		SendChat("/cuff "IdTarget)
		if (arrestidone == -1)
		{
			arrestidone:=IdTarget
			Return
		}
		if (arrestidtwo == -1)
		{
			arrestidtwo:=IdTarget
			Return
		}
	}
	Return
}
ActiveKey3:
{
	IfWinActive, GTA:SA:MP
	{
		dwNaparnik:="���������:"
		dwPlacePoint := [0x460, 0x464, 0x468, 0x46C]
		dwVehPtr := readDWORD(hGTA, 0xBA18FC)
		NaparnikKolvo:=0
		Loop, 4
		{
			dwPlaceAdr := dwPlacePoint[A_Index]
			dwPED := readDWORD(hGTA, dwVehPtr+dwPlaceAdr)
			dwID := getIdByPed(dwPED)
			if(HasPlayerCopSkin(dwID))
			{
				NaparnikKolvo:=NaparnikKolvo +1
				dwName := getPlayerNameById(dwID)
				if RegExMatch(dwName, "([A-Z])[a-z]*_([A-Z][a-z]*?)$", pod)
				if (dwNaparnik!="���������:")
					dwNaparnik:=dwNaparnik ", " pod1 ". " pod2
				else
					dwNaparnik:=dwNaparnik " " pod1 ". " pod2
			}
		}
		if(dwNaparnik=="���������:")
		{
			dwNaparnik:="���������: ��������."
		}
		if(NaparnikKolvo == 1)
			dwNaparnik:=RegExReplace(dwNaparnik, "���������", "��������")

		if(isPlayerInRangeOfPoint(2714.0129,-2412.7183,13.3512, 120))
		{
			if(File_Tag != "No" and File_Tag != "")
				SendChat("/r "File_Tag " �������� � ����� LS. "dwNaparnik " ")
			else
				SendChat("/r "tagstring "�������� � ����� LS. "dwNaparnik " ")
			return
		}
		else if(isPlayerInRangeOfPoint(2201.6797,-2244.8928,13.1117, 35))
		{
			if(File_Tag != "No" and File_Tag != "")
				SendChat("/r "File_Tag " ����: ��������. "dwNaparnik " ")
			else
				SendChat("/r "tagstring "����: ��������. "dwNaparnik " ")
			return
		}
		else if(isPlayerInRangeOfPoint(1149.2653,-1725.3298,13.4598, 35))
		{
			if(File_Tag != "No" and File_Tag != "")
				SendChat("/r "File_Tag " ����: ���������� ��. "dwNaparnik " ")
			else
				SendChat("/r "tagstring "����: ���������� ��. "dwNaparnik " ")
			return
		}
		else if(isPlayerInRangeOfPoint(435.9747,-1503.2104,30.7054, 35))
		{
			if(File_Tag != "No" and File_Tag != "")
				SendChat("/r "File_Tag " �������� � �������� ������. "dwNaparnik " ")
			else
				SendChat("/r "tagstring "�������� � �������� ������. "dwNaparnik " ")
			return
		}
		else if(isPlayerInRangeOfPoint(329.5885,-1798.6801,4.4167, 25))
		{
			if(File_Tag != "No" and File_Tag != "")
				SendChat("/r "File_Tag " �������� �� �����������. "dwNaparnik " ")
			else
				SendChat("/r "tagstring "�������� �� �����������. "dwNaparnik " ")
			return
		}
		else if(isPlayerInRangeOfPoint(2039.2167,1009.7871,10.2432, 30))
		{
			if(File_Tag != "No" and File_Tag != "")
				SendChat("/r "File_Tag " ����: Four Dragon. "dwNaparnik " ")
			else
				SendChat("/r "tagstring "����: Four Dragon. "dwNaparnik " ")
			return
		}
		else if(isPlayerInRangeOfPoint(2824.6538,1290.9299,10.4915, 30))
		{
			if(File_Tag != "No" and File_Tag != "")
				SendChat("/r "File_Tag " ����: ���������� ��. "dwNaparnik " ")
			else
				SendChat("/r "tagstring "����: ���������� ��. "dwNaparnik " ")
			return
		}
		else if(isPlayerInRangeOfPoint(2178.3511,1674.0022,10.6603, 30))
		{
			if(File_Tag != "No" and File_Tag != "")
				SendChat("/r "File_Tag " ����: Caligula. "dwNaparnik " ")
			else
				SendChat("/r "tagstring "����: Caligula. "dwNaparnik " ")
			return
		}
		else if(isPlayerInRangeOfPoint(1823.6051,808.3889,10.5474, 30))
		{
			if(File_Tag != "No" and File_Tag != "")
				SendChat("/r "File_Tag " ����: ����������. "dwNaparnik " ")
			else
				SendChat("/r "tagstring "����: ����������. "dwNaparnik " ")
			return
		}
		else if(isPlayerInRangeOfPoint(-2034.6049,476.4055,34.8989, 20))
		{
			if(File_Tag != "No" and File_Tag != "")
				SendChat("/r "File_Tag " ����: SFN. "dwNaparnik " ")
			else
				SendChat("/r "tagstring "����: SFN. "dwNaparnik " ")
			return
		}
		else if(isPlayerInRangeOfPoint(-1987.5195,129.1644,27.3380, 20))
		{
			if(File_Tag != "No" and File_Tag != "")
				SendChat("/r "File_Tag " ����: ���������� ��. "dwNaparnik " ")
			else
				SendChat("/r "tagstring "����: ���������� ��. "dwNaparnik " ")
			return
		}
		else if(isPlayerInRangeOfPoint(-2054.8101,-84.4596,35.0474, 30))
		{
			if(File_Tag != "No" and File_Tag != "")
				SendChat("/r "File_Tag " ����: ���������. "dwNaparnik " ")
			else
				SendChat("/r "tagstring "����: ���������. "dwNaparnik " ")
			return
		}
		else if(isPlayerInRangeOfPoint(1476.8179,-1705.5459,13.3590, 35))
		{
			if(File_Tag != "No" and File_Tag != "")
				SendChat("/r "File_Tag " �������� �� ������� �����. "dwNaparnik " ")
			else
				SendChat("/r "tagstring "�������� �� ������� �����. "dwNaparnik " ")
			return
		}
		else if(File_Police = "LSPD")
		{
			if(File_Tag != "No" and File_Tag != "")
				SendChat("/r "File_Tag " ���� ������� ������ LS. "dwNaparnik " ")
			else
				SendChat("/r "tagstring "���� ������� ������ LS. "dwNaparnik " ")
			Return
		}
		else if(File_Police = "SFPD")
		{
			if(File_Tag != "No" and File_Tag != "")
				SendChat("/r "File_Tag " ���� ������� ������ SF. "dwNaparnik " ")
			else
				SendChat("/r "tagstring "���� ������� ������ SF. "dwNaparnik " ")
			Return
		}
		else if(File_Police = "LVPD")
		{
			if(File_Tag != "No" and File_Tag != "")
				SendChat("/r "File_Tag " ���� ������� ������ LV. "dwNaparnik " ")
			else
				SendChat("/r "tagstring "���� ������� ������ LV. "dwNaparnik " ")
			Return
		}
		else 
			addchatmessage("[AHK] ��� �������� ��� �����������.")
			
	}
	Return
}
ActiveKey4:
{
	if(grID=="-1")
	{
		IdTarget:=getIdByPed(getTargetPed())
		if (IdTarget == "-1")
		{
			addchatmessage("[AHK] �������: /gr [ID], ���� �������� ���� � ������� Alt+5.")
		}
	}
	else
		IdTarget:=grID
		
	if(IdTarget > -1 and IdTarget < 1001)
	{
		if(!HasPlayerCopSkin(IdTarget))
		{
			addchatmessage("[AHK] �������������� ��������� �������� ������ ��� ���. �����������.")
			Return
		}
		RankName1:="�����"
		RankName2:="������"
		RankName3:="��.�������"
		RankName4:="�������"
		RankName5:="���������"
		RankName6:="��.���������"
		RankName7:="��.���������"
		RankName8:="���������"
		RankName9:="��.���������"
		RankName10:="�������"
		RankName11:="�����"
		RankName12:="������������"
		RankName13:="���������"
		CurrentRank := 0
		name:=getPlayerNameById(IdTarget)
		Loop, read, %FullChatLogPath%
		{
			FoundPos1 := RegExMatch(A_LoopReadLine, ".*���: (.*)")
			if(FoundPos1==1)
			Find_Line1:=A_LoopReadLine
		}
		RegExMatch(Find_Line1, "���: (.*)", _name)
		if(name != _name1)
		{
			addChatMessage("[AHK] ��� ������ �� ��������� � ������ ����, ��� ������� ��� �������.")
			Return
		}
		Loop, read, %FullChatLogPath%
		{
			FoundPos2 := RegExMatch(A_LoopReadLine, ".*���������: (.*)")
			if(FoundPos2==1)
			Find_Line2:=A_LoopReadLine
		}
		RegExMatch(Find_Line2, "���������: (.*)", givenrank)
		if (givenrank1 == RankName1)
		{
			sleep 700
			sendchat("/giverank "IdTarget " 2")
			sleep 1100
			sendchat("/me ������� ������ �������")
			CurrentRank = 1
		}
		else if (givenrank1 == RankName2)
		{
			sleep 700
			sendchat("/giverank "IdTarget " 3")
			sleep 1100
			sendchat("/me ������� ������ ��.��������")
			CurrentRank = 2
		}
		else if (givenrank1 == RankName3)
		{
			sleep 700
			sendchat("/giverank "IdTarget " 4")
			sleep 1100
			sendchat("/me ������� ������ ��������")
			CurrentRank = 3
		}
		else if (givenrank1 == RankName4)
		{
			sleep 700
			sendchat("/giverank "IdTarget " 5")
			sleep 1100
			sendchat("/me ������� ������ ����������")
			CurrentRank = 4
		}
		else if (givenrank1 == RankName5)
		{
			sleep 700
			sendchat("/giverank "IdTarget " 6")
			sleep 1100
			sendchat("/me ������� ������ ��.����������")
			CurrentRank = 5
		}
		else if (givenrank1 == RankName6)
		{
			sleep 700
			sendchat("/giverank "IdTarget " 7")
			sleep 1100
			sendchat("/me ������� ������ ��.����������")
			CurrentRank = 6
		}
		else if (givenrank1 == RankName7)
		{
			sleep 700
			sendchat("/giverank "IdTarget " 8")
			sleep 1100
			sendchat("/me ������� ������ ����������")
			CurrentRank = 7
		}
		else if (givenrank1 == RankName8)
		{
			sleep 700
			sendchat("/giverank "IdTarget " 9")
			sleep 1100
			sendchat("/me ������� ������ ��.����������")
			CurrentRank = 8
		}
		else if (givenrank1 == RankName9)
		{
			sleep 700
			sendchat("/giverank "IdTarget " 10")
			sleep 1100
			sendchat("/me ������� ������ ��������")
			CurrentRank = 9
		}
		else if (givenrank1 == RankName10)
		{
			sleep 700
			sendchat("/giverank "IdTarget " 11")
			sleep 1100
			sendchat("/me ������� ������ ������")
			CurrentRank = 10
		}
		else if (givenrank1 == RankName11)
		{
			sleep 700
			sendchat("/giverank "IdTarget " 12")
			sleep 1100
			sendchat("/me ������� ������ �������������")
			CurrentRank = 11
		}
		else if (givenrank1 == RankName12)
		{
			sleep 700
			sendchat("/giverank "IdTarget " 13")
			sleep 1100
			sendchat("/me ������� ������ ����������")
			CurrentRank = 12
		}
		FormatTime, CurrentDateTime,, dd.MM.yy
		NewRank := CurrentRank+1
		name:=RegExReplace(name, "_", " ")
		FileAppend, %CurrentDateTime% | %name% | ������� � "%CurrentRank%" �� "%NewRank%". �������: ����� ���������.`n, %A_scriptdir%\files\giverank.txt
		sleep 1100
		sendchat("/time")
		sleep 500
		sendinput, {F8}
	}
}
return

ActiveKey5:
	o1:=Object()
	o1:=GetCoordinates()
	funcIndex:=-1
	kid := Object("0", "1", "2", "3")
	kid[0]:=-1
	kid[1]:=-1
	kid[2]:=-1
	kid[3]:=-1
	kid[0]:=getClosestPlayerId1()
	if(kid[0]!=-1)
	{
		funcIndex:=0
		p := getStreamedInPlayersInfo()
		M:=getTargetVehicleModelNameById(kid[funcIndex])
		N:=getPlayerNameById(kid[funcIndex])
		For i, o in p
		{
			if(getTargetVehicleModelNameById(i)==M and (kid[0]!=i) and in_car_not_cop(i)==1 and person_passenger(i,kid[0])==1)
			{
				funcIndex:=funcIndex+1
				kid[funcIndex]:=i
			}
		}
		if(getDist(o1,getPedCoordinates(getPedById(kid[0])))<50 and kid[0]!=-1)
		{
			Speed:=getTargetVehicleSpeedById(kid[0])-20
			Speed:=Ceil(Speed)
			if(Speed<0)
			Speed:=0
			if(funcIndex==0)
			{
				addChatMessage("{F4A460} ________________________________________"  )
				addChatMessage("{F4A460} "  )
				addChatMessage("{FFFACD}	<>	��� ��������: " N " [" kid[0]"]" )
				addChatMessage("{FFFACD}	<>	�������� ����������: " Speed " ��/�"  )
				addChatMessage("{FFFACD}	<>	�������� ����������: " M )
				addChatMessage("{F4A460} ________________________________________"  )
				suspectids:=kid[0]
				sbros:=0
			}
			else
			{
				funcIndex:=0
				addChatMessage("{F4A460} ____________________________________________________"  )
				addChatMessage("{F4A460} "  )
				addChatMessage("{FFFACD}		�������� �������� ������" )
				While(funcIndex<4)
				{
					addChatMessage("{FFFACD}���: "funcIndex+1 " " getPlayerNameById(kid[funcIndex])" ["kid[funcIndex]"]" )
					funcIndex++
				}
				addChatMessage("{F4A460} ____________________________________________________"  )
			}
		}
		else
		{
			addChatMessage("{F4A460} ________________________________________"  )
			addChatMessage("{F4A460} "  )
			addChatMessage("{FFFACD}		���������� ��������� ������� ������." )
			addChatMessage("{F4A460} ________________________________________"  )
		}
	}
	else
	{
		addChatMessage("{F4A460} ________________________________________"  )
		addChatMessage("{F4A460} "  )
		addChatMessage("{FFFACD}		������������ �������� �� ����������." )
		addChatMessage("{F4A460} ________________________________________"  )
	}
	sleep 1000
Return
ActiveKey10:
	if (isInChat() = 1) && (!isDialogOpen())
	{
		Send .
		Return
	}
	if(IsInPoliceCar(ids) == 0)
	{
		addChatMessage("[AHK] �� ������ ���������� � ��������� ����������." )
		Return
	}
	Loop, read, %FullChatLogPath%
	{
		FoundPos := RegExMatch(A_LoopReadLine, ".*mdc.*")
		if(FoundPos==1)
		Find_Line:=A_LoopReadLine
	}
	RegExMatch(Find_Line, "mdc ([0-9]+)", mdcID)
	if(mdcID1 == "")
	{
		RegExMatch(Find_Line, "([0-9]+) mdc", mdcID)
		if(mdcID1 == "")
			Return
	}
	sendchat("/mdc " mdcID1)
	sleep 1000
	Loop, read, %FullChatLogPath%
	{
		FoundPos1 := RegExMatch(A_LoopReadLine, ".*������� �������:.*([0-9]+)")
		if(FoundPos1==1)
		Find_Line1:=A_LoopReadLine
	}
	RegExMatch(Find_Line1, ".*������� �������:.*([0-9]+)", mdcYR)
	Loop, read, %FullChatLogPath%
	{
		FoundPos2 := RegExMatch(A_LoopReadLine, ".*�����������: (.*)")
		if(FoundPos2==1)
		Find_Line2:=A_LoopReadLine
	}
	RegExMatch(Find_Line2, "\[.*\].*�����������: (.*)", mdcORG)
	sendchat("/r (( ID � "mdcID1 ", ������� �������: " mdcYR1 ". �����������: " mdcORG1 " ))")
return

numpad4::
	if (isInChat() = 1) && (!isDialogOpen())
	{
		Send 4
		Return
	}
	if(funcIndex>0)
	{
		addChatMessage("{F4A460} ________________________________________"  )
		addChatMessage("{F4A460} "  )
		addChatMessage("{FFFFFF}	<>	��� ��������: " getPlayerNameById(kid[0])" [" kid[0]"]" )
		addChatMessage("{FFFFFF}	<>	�������� ����������: " Speed " ��/�"  )
		addChatMessage("{FFFFFF}	<>	�������� ����������: " M)
		addChatMessage("{F4A460} ________________________________________"  )
		sbros:=0
		suspectids:=kid[0]
	}
	sleep 1000
Return
numpad5::
	if (isInChat() = 1) && (!isDialogOpen())
	{
		Send 5
		Return
	}
	if(funcIndex>0)
	{
		addChatMessage("{F4A460} ________________________________________"  )
		addChatMessage("{F4A460} "  )
		addChatMessage("{FFFFFF}	<>	��� ��������: " getPlayerNameById(kid[1])" [" kid[1]"]" )
		addChatMessage("{FFFFFF}	<>	�������� ����������: " Speed " ��/�" )
		addChatMessage("{FFFFFF}	<>	�������� ����������: " M)
		addChatMessage("{F4A460} ________________________________________"  )
		sbros:=0
		suspectids:=kid[1]
	}
	sleep 1000
Return
numpad6::
	if (isInChat() = 1) && (!isDialogOpen())
	{
		Send 6
		Return
	}
	if(funcIndex>0)
	{
		addChatMessage("{F4A460} ________________________________________"  )
		addChatMessage("{F4A460} "  )
		addChatMessage("{FFFFFF}	<>	��� ������� ��������: " getPlayerNameById(kid[2])" [" kid[2]"]" )
		addChatMessage("{FFFFFF}	<>	�������� ����������: " Speed " ��/�" )
		addChatMessage("{FFFFFF}	<>	�������� ����������: " M)
		addChatMessage("{F4A460} ________________________________________"  )
		sbros:=0
		suspectids:=kid[2]
	}
	sleep 1000
Return
numpad7::
	if (isInChat() = 1) && (!isDialogOpen())
	{
		Send 7
		Return
	}
	if(funcIndex>0)
	{
		addChatMessage("{F4A460} ________________________________________"  )
		addChatMessage("{F4A460} "  )
		addChatMessage("{FFFFFF}	<>	��� ������� ��������: " getPlayerNameById(kid[3])" [" kid[3]"]" )
		addChatMessage("{FFFFFF}	<>	�������� ����������: " Speed " ��/�" )
		addChatMessage("{FFFFFF}	<>	�������� ����������: " M)
		addChatMessage("{F4A460} ________________________________________"  )
		sbros:=0
		suspectids:=kid[3]
	}
	sleep 1000
Return

!1::
	o1:=Object()
	o1:=GetCoordinates()
	IdTarget:=getIdByPed(getTargetPed())

	if (IdTarget!="-1" and getDist(o1,getPedCoordinates(getPedById(IdTarget)))<30)
	{
		SendChat("/su " IdTarget " 3 A")
	}
Return

!2::
	o1:=Object()
	o1:=GetCoordinates()
	IdTarget:=getIdByPed(getTargetPed())
	if (IdTarget!="-1" and getDist(o1,getPedCoordinates(getPedById(IdTarget)))<30)
	{
		SendChat("/su " IdTarget " 3 B")
	}
Return

ActiveKey12:
	IdTarget:=getIdByPed(getTargetPed())
	if (suspectids!="-1")
		name:=getPlayerNameById(suspectids)
	else if (IdTarget!="-1")
		name:=getPlayerNameById(IdTarget)

	SendChat("/me ������ ���")
	sleep 1200
	if(IsPlayerInAnyVehicle())
	{
		if (suspectids!="-1")
		{
			SendChat("/me ����� ������ �� �������� ������������� ���. ������������� � " name)
			sleep 1200
			SendChat("/frisk "suspectids " ")
			Return
		}
		else if (IdTarget!="-1")
		{
			SendChat("/me ����� ������ �� �������� ������������� ���. ������������� � " name)
			sleep 1200
			SendChat("/frisk "IdTarget " ")
		}
		else
			SendChat("/me ����� ������ �� �������� ������������� ���.�������������")
	}
	else
	{
		if (suspectids!="-1")
		{
			SendChat("/me ����� ������ �� ������������� ���. ������������� � " name)
			sleep 1200
			SendChat("/frisk "suspectids " ")
			Return
		}
		else if (IdTarget!="-1")
		{
			SendChat("/me ����� ������ �� ������������� ���. ������������� � " name)
			sleep 1200
			SendChat("/frisk "IdTarget " ")
		}
		else
			SendChat("/me ����� ������ �� ������������� ���.�������������")
	}
Return
!8::
	if (suspectids!="-1")
	{
		SendChat("/su " suspectids " 3 ������� ��������")
	}
Return
ActiveKey11:
	if(isPlayerInAnyVehicle())
	{
		if(sbros==0 and suspectids!=-1)
		{
		Zona:=GetZona()
		if(Zona!="Unbekannt" and M!="")
		{
			if(File_Tag != "No" and File_Tag != "")
				SendChat("/r "File_Tag " ���� ������ � ������� " Zona ". ����� �/�: " M ". ������ SA" suspectids "N")
			else
				SendChat("/r "tagstring " ���� ������ � ������� " Zona ". ����� �/�: " M ". ������ SA" suspectids "N")
		}
		if(Zona=="Unbekannt")
			addchatmessage("[AHK] ���� ��������������� �� ����������.")
		}
		else
			addchatmessage("[AHK] ������� ��������� ����� �� ����������.")
	}
	else
		addchatmessage("[AHK] �� ������ ���������� � ��������� ����������.")
Return

ActiveKey9:
	if (isInChat() = 1) && (!isDialogOpen())
	{
		Send 8
		Return
	}
	if(sbros==0)
	{
		elapsed_time := A_TickCount - start_time
		if(elapsed_time>60000)
		{
			start_time := A_TickCount
			SendChat("/m ["File_Police "] �������� " M ", ���������� � ������� � ���������� ���� ������������ ��������!")
			megaphoneStep:=1
		}
		else
		{
			if(megaphoneStep==1)
			{
				SendChat("/m ["File_Police "] ��������, �������� " M ". ������� ������ � ������������.")
				megaphoneStep:=2
				roz:=-1
			}
			else
			if(megaphoneStep==2)
			{
				SendChat("/m ["File_Police "] ��������� ��������������. � �������, ����� ���� ��������!")
				megaphoneStep:=0
			}
		}
	}
	else
	{
		elapsed_time := A_TickCount - start_time
		if(elapsed_time>60000)
		{
			start_time := A_TickCount
			SendChat("/m ["File_Police "] ��������, ���������� � ������� � ���������� ���� ������������ ��������!")
			megaphoneStep:=1
		}
		else
		{
			if(megaphoneStep==1)
			{
				SendChat("/m ["File_Police "] ��������, ��������. ������� ������ � ������������.")
				megaphoneStep:=2
			}
			else
			if(megaphoneStep==2)
			{
				SendChat("/m ["File_Police "] ��������� ��������������. � �������, ����� ���� ��������!")
				megaphoneStep:=0
			}
		}
	}
return
ActiveKey6:
	addchatmessage("[AHK] ��� ���������� ������� �������.")
	sbros:=1
	suspectids:=-1
	funcIndex:=0
	step:=-1
	start_time:=0
	arrestidone:=-1
	arrestidtwo:=-1
	followidone:=-1
	followidtwo:=-1
	cputidone:=-1
	cputidtwo:=-1
	cejectidone:=-1
	cejectidtwo:=-1
Return
:?:/del::
	addchatmessage("[AHK] ����� ��� ����� �����������.")
	arrestidone:=-1
	arrestidtwo:=-1
	followidone:=-1
	followidtwo:=-1
	cputidone:=-1
	cputidtwo:=-1
	cejectidone:=-1
	cejectidtwo:=-1
Return

ActiveKey1:
	showDialog("1", "{FFD700}������� ����� �������", "{FFFAFA}[1] ���������� � �������`n[2] ������ ��������� ����`n[3] ������ � ������ �����`n[4] �������������� ���������`n[5] �������� ����������� � �����`n[6] ��� ��������� � �����`n[7] �������������� ���������`n[8] ��������� ���� ��� �������`n[9] ���������� � �������������`n[10] ��������� � ����� � �����`n[11] ���� ������ � ����������", "OK")
	AntiCrash()
	input, text, V, {enter}
	if(text == 1)
	{
		showDialog("0", "{F0E68C}Police AutoHotKey for Samp-Rp | Version: 0.4 ", MainMenuString , "OK")
		AntiCrash()
		Return
	}
	if(text == 2)
	{
		addchatmessage("[AHK] �������������: /zap [ID]")
		SendInput, {F6}/zap{Space}
		Return
	}
	if(text == 3)
	{
		addchatmessage("[AHK] �������������: /otp [ID] [�����]")
		addChatMessage("[AHK] ��� ���� �������: /otp [ID1] [ID2] [�����].")
		SendInput, {F6}/otp{Space}
		Return
	}
	if(text == 4)
	{
		addchatmessage("[AHK] �������������: /serd [ID]")
		SendInput, {F6}/serd{Space}
		Return
	}
	if(text == 5)
	{
		addchatmessage("[AHK] �������������: /check [ID]")
		addchatmessage("[AHK] ������� /check all, ���� ��������� ���� ������ �����������.")
		SendInput, {F6}/check{Space}
		Return
	}
	if(text == 6)
	{
		addchatmessage("[AHK] �������������: /rn [�����]")
		SendInput, {F6}/rn{Space}
		Return
	}
	if(text == 7)
	{
		addchatmessage("[AHK] �������������: /gr [ID]")
		SendInput, {F6}/gr{Space}
		Return
	}
	if(text == 8)
	{
		addchatmessage("[AHK] �������������: /tag [��� ���]")
		SendInput, {F6}/tag{Space}
		Return
	}
	if(text == 9)
	{
		addchatmessage("[AHK] �������������: /zv [ID]")
		SendInput, {F6}/zv{Space}
		Return
	}
	if(text == 10)
	{
		addchatmessage("[AHK] �������������: /rt [�����]")
		SendInput, {F6}/rt{Space}
		Return
	}
	if(text == 11)
	{
		addchatmessage("[AHK] �������������: /timer [����� � �������]")
		SendInput, {F6}/timer{Space}
		Return
	}
return

ActiveKey7:
{
	IdTarget:=getIdByPed(getTargetPed())
	if (IdTarget == "-1")
	{
		IdTarget:=getClosestPlayerId()
		if (IdTarget == "-1")
		{
			addchatmessage("[AHK] ���� �� �������.")
			Return
		}
	}
	if(HasPlayerCopSkin(IdTarget))
	{
		addchatmessage("[AHK] ����� ���������������� ���������� ����������.")
		Return
	}
	SendChat("/me ����� ��������� ��������")
	sleep 1200
	SendChat("/frisk "IdTarget)
}
Return

ActiveKey8:
{
	TickedId:=getIdByPed(getTargetPed())
	if (TickedId == "-1")
	{
		TickedId:=getClosestPlayerId()
		if (TickedId == "-1")
		{
			addchatmessage("[AHK] ���� �� �������.")
			Return
		}
	}
	if(HasPlayerCopSkin(TickedId))
	{
		addchatmessage("[AHK] ���������� �������� ����� ���. ����������.")
		Return
	}
	SendChat("/me ������ ������ ����� � ��� ������ � ����������")
	sleep 1200
	SendChat("/me ������� ����������� ����� ����������")
	sleep 1200
	addchatmessage("[AHK] �������: /ticket [ID] [����� ������] [�������].")
	SendInput, {F6}/ticket{Space}%TickedId%{Space}
}
Return

~Escape::
if(isDialogOpen())
{	
	if(getDialogID() == 1)
	{
		Send {Enter}
	}
}
Return

~Enter::
if((isInChat() = 1) && (!isDialogOpen()) || InStr(getDialogTitle(), "������ �������"))
{
	BlockChatInput()
	sleep 200
	dwAddress := dwSAMP + 0x12D8F8
	chatInput := readString(hGTA, dwAddress, 256)
	if(!InStr(getDialogTitle(), "������ �������"))
	{
		Send {Enter up}
	}
	if (InStr(chatInput, " /rn") or InStr(chatInput, " /rt") or InStr(chatInput, " /zap") or InStr(chatInput, " /otp") or InStr(chatInput, " /tag") or InStr(chatInput, " /check") or InStr(chatInput, " /serd"))
	{
		unBlockChatInput()
		SendChat(chatInput)
		Return
	}
	if ( InStr(chatInput, "/") )
	{
		if chatInput contains /tag
		{
			unBlockChatInput()
			if(File_Tag != "No" and File_Tag != "")
			{
				addChatMessage("[AHK] ��� ��� ����� ��� ���������� � INI �����.")
				Return
			}
			if(RegExMatch(chatInput, "/tag delete"))
			{
				tagstring := ""
				addChatMessage("[AHK] ��� ��� ��� ����� �����.")
				Return
			}
			RegExMatch(chatInput, "/tag (.*)", tag)
			tagstring := RegExReplace(tag1, "]$", "] ")
			addChatMessage("[AHK] ��� ��� ����� "tag1 " ����������.")
			addChatMessage("[AHK] ������� '/tag delete' ��� �������� ����.")
		}
		else if chatInput contains /rt
		{
			unBlockChatInput()
			if(RegExMatch(chatInput, "/rt (.*)", rMsg))
			{
				if(rMsg1 != "" and rMsg1 != " ")
				{
					if(File_Tag != "No" and File_Tag != "")
						sendchat("/r "File_Tag " "rMsg1 " ")
					else
						sendchat("/r "tagstring ""rMsg1 " ")
				}
			}
		}		
		else if chatInput contains /check
		{
			unBlockChatInput()
			RegExMatch(chatInput, "/check (.*)", id)
			if(id1 > -1 and id1 < 1001)
			{
				name:=getPlayerNameById(id1)
				RegExMatch(name, "(.*)_(.*)", nameout)
				dist:=getDist(getCoordinates(), getTargetPos(id1))
				if(dist > 25 or dist == 0)
				{
					step += 1
					if(step == 0)
					{
						if(File_Tag != "No" and File_Tag != "")
							sendchat("/r "File_Tag " "nameout1 " "nameout2 ", ������ ���� � �����.")
						else
							sendchat("/r "tagstring " "nameout1 " "nameout2 ", ������ ���� � �����.")
						Return
					}
					if(step == 1)
					{
						if(File_Tag != "No" and File_Tag != "")
							sendchat("/r "File_Tag " "nameout1 " "nameout2 ", �� �������� ���� � �����.")
						else
							sendchat("/r "tagstring " "nameout1 " "nameout2 ", �� �������� ���� � �����.")
						Return
					}
					if(step == 2)
					{
						if(File_Tag != "No" and File_Tag != "")
							sendchat("/r "File_Tag " ��������, ����� ����������. "nameout1 " "nameout2 ", ����� ������ ���� ��� � �����.")
						else
							sendchat("/r "tagstring "��������, ����� ����������. "nameout1 " "nameout2 ", ����� ������ ���� ��� � �����.")
						Return
					}
					if(step == 3)
					{
						step:=-1
						if(File_Tag != "No" and File_Tag != "")
							sendchat("/r "File_Tag " "nameout1 " "nameout2 ", �� ��� ���� � �����.")
						else
							sendchat("/r "tagstring " "nameout1 " "nameout2 ", �� ��� ���� � �����.")
						Return
					}
				}
				else
				addChatMessage("[AHK] ����� ��������� ����� � ����")
			}
			if(id1 == "all")
			{
				str:=""
				string:=""
				all_b:=0
				all_index:=0
				all_lenght:=0
				firstSrt:=1
				all_counter:=0
				sleep 1000

				FileDelete, %FullChatLogPath%
				sendchat("/members")
				sleep 500
				Loop, read, %FullChatLogPath%
				{
					FoundPos1 := RegExMatch(A_LoopReadLine, ".*����� �� ������: (.*)")
					if(FoundPos1==1)
					Find_Line1:=A_LoopReadLine
				}
				RegExMatch(Find_Line1, ".*����� �� ������: (.*) / ��������: (.*)", a)
				all_b := a1 + a2 - 2
				Loop, read, %FullChatLogPath%
				{
					FoundPos2 := RegExMatch(A_LoopReadLine, "(.*)_(.*)")
					if(FoundPos2==1)
					{
						Find_Line2:=A_LoopReadLine
						str:=RegExReplace(Find_Line2, "(.*)_\w+\[", "")
						str:=RegExReplace(str, "\].*", "")
						id := str
						if(getId() != id)
						{
							all_index += 1
							dist:=getDist(getCoordinates(), getTargetPos(id))
							if(dist > 25 or dist == 0)
							{
								all_counter += 1
								name:=getPlayerNameById(id)
								if(firstSrt == 1)
								{
									str:="���: "name " | ID: "id ""
									firstSrt := 0
								}
								else
								{
									str:=" `n���: "name " | ID: "id ""
								}
								PutIntoString(string, all_lenght, str)
								all_lenght := all_lenght + StrLen(str) + 1
							}
						}
					}
					if(all_index > all_b)
					break
				}
				str:="`n `n����� �� � �����: "all_counter " �������."
				PutIntoString(string, all_lenght, str)
				addChatMessage("[AHK] ����������� 'Esc', ���� ������� ������, ���� 'Enter' ��� ���������� ����������.")
				showDialog("2", "{F0E68C}������ ������� �� � �����:", string, "OK")
			}
			else
			{
				addChatMessage("[AHK] �������: /check [id] ���� /check all.")
			}
		}
		else if chatInput contains /serd
		{
			unBlockChatInput()
			RegExMatch(chatInput, "/serd (\d+)", ser)
			if ser1 || ser1 = 0
			{
				if(IsInPoliceCar(getId()) == 1)
				{
					sendchat("/clear " ser1)
					sleep 1200
					sendchat("/su " ser1 " 1 ��������������")
					if(File_Police != "FBI")
					{
						sleep 1200
						name:=getPlayerNameById(ser1)
						if(name == "")
						{
							addChatMessage("[AHK] ����� �� ������.")
							Return
						}
						RegExMatch(name, "(.*)_(.*)", nameout)
						sendchat("/d [FBI]: ������� ������ � " nameout1 " " nameout2 " � ���� SAPD. �������: ��������������.")
					}
				}
				else
					addChatMessage("[AHK] �� ������ ���������� � ��������� �/�.")
			}
			else
				addChatMessage("[AHK] �������: /serd [id]")
		}
		else if chatInput contains /rn
		{
			unBlockChatInput()
			RegExMatch(chatInput, "/rn (.*)", rn)
			if(rn1 != "")
				sendchat("/r (( "rn1 " )) ")
			Return
		}
		else if chatInput contains /zap
		{
			unBlockChatInput()
			RegExMatch(chatInput, "/zap (.*)", zap)
			if(RegExMatch(zap1, "(\d+)\s(.*)", par))
			{
				if ((par1 || par1 = 0) and (par2 = "LSPD" or par2 = "SFPD" or par2 = "LVPD"))
				{
					name:=getPlayerNameById(par1)
					if(name == "")
					{
						addChatMessage("[AHK] ����� �� ������.")
						Return
					}
					name:=RegExReplace(name, "_", " ")
					sendchat("/d [Mayor] ���� �� ��� "name " � ��� "par2 " ��������� �� ��������.")
				}
				else
					addChatMessage("[AHK] �������: /otp [ID] [�����].")
			}
			else if zap1 || zap1 = 0
			{
				name:=getPlayerNameById(zap1)
				if(name == "")
				{
					addChatMessage("[AHK] ����� �� ������.")
					Return
				}
				RegExMatch(name, "(.*)_(.*)", nameout)
				sendchat("/d [Mayor] ���� �� ��� "nameout1 " "nameout2 " ��������� �� ��������.")
			}
			else
			{
				addChatMessage("[AHK] �������: /otp [ID].")
				addChatMessage("[AHK] � ��������� ������: /otp [ID] [�����].")
			}
			Return
		}
		else if chatInput contains /otp
		{
			unBlockChatInput()
			if RegExMatch(chatInput, "/otp (\d+)\s(.*)", id)
			{
				if(id1 > -1 and id1 < 1001)
				{
					if(id2 == "LS" or id2 == "LV" or id2 == "SF")
					{
						name:=getPlayerNameById(id1)
						if(name == "")
						{
							addChatMessage("[AHK] ����� �� ������.")
							Return
						}
						RegExMatch(name, "(.*)_(.*)", nameout)
						sendchat("/d [OG] ������ "nameout1 " "nameout2 " ������� � ����� "id2 ".")
						Return
					}
					else if RegExMatch(id2, "(.*)\s(.*)", param)
					{
						if(param2 == "LS" or param2 == "LV" or param2 == "SF")
						{
							if(id1 == param1)
							{
								addChatMessage("[AHK] �� ����� ID ������ � ���� �� ������.")
								Return
							}
							name:=getPlayerNameById(id1)
							sname:=getPlayerNameById(param1)
							if(name == "" or sname == "")
							{
								addChatMessage("[AHK] ���� �� ������� �� ������.")
								Return
							}
							name:=RegExReplace(name, "_", " ")
							sname:=RegExReplace(sname, "_", " ")
							sendchat("/d [OG] ������� "name " � "sname " �������� � "param2 ".")
							Return
						}
						else
							addChatMessage("[AHK] ������� ����� � �������: LS | LV | SF")
					}
					else
						addChatMessage("[AHK] ������� ����� � �������: LS | LV | SF")
				}
				else
					addChatMessage("[AHK] �� ����� �������� ID ������.")
			}
			else
			{
				addChatMessage("[AHK] �������: /otp [ID] [�����].")
				addChatMessage("[AHK] ��� ���� �������: /otp [ID1] [ID2] [�����].")
			}
		}
		else if chatInput contains /gr
		{
			unBlockChatInput()
			if RegExMatch(chatInput, "/gr (.*)", gr)
			{
				grID:=gr1
				addChatMessage("[AHK] ���� �������, ������� Alt+5.")
			}
			Return
		}
		else if chatInput contains /zv
		{
			unBlockChatInput()
			if RegExMatch(chatInput, "/zv (\d+)", id) 
			{ 
				if (id1>=0 and id1<1000) 
				{ 
					roz:="" 
					s:="0" 
					t:="0" 
					ku:=[] 
					zv:=getPlayerNameById(id1) 
					if (zv=="") 
					{ 
						AddMessageToChatWindow("[AHK] ������ ����� �������.") 
						return 
					} 
					File = %FullChatLogPath%
					i:=0 
					Loop, Read, %File% 
					{ 
						i:=i+1 
						if (RegExMatch(A_LoopReadLine, "\[..:..:..\]\s\s\<\<\s������\s.*?\s���������\s" zv) or RegExMatch(A_LoopReadLine, 						"\[..:..:..\]\s\s\[Clear\]\s[A-Za-z0-9_]*?\s������\s��\s�������������\s" zv)) 
						j:=i 
					} 
					ut:=0 
					Loop, Read, %File% 
					{ 
						ut:=ut+1 
						if (ut>j and RegExMatch(A_LoopReadLine, "\[..:..:..\]\s\s\[Wanted\s\d:\s" zv "\]\s\[.*?:\s[A-Za-z0-9_]*?\]\s\[(.*?)\]", suspectids)) 
						{ 
							i:="1" 
							while (i<=s) 
							{ 
								if (ku[i]==suspectids1) 
								{ 
									t:="1" 
								} 
								i:=i+1 
							} 
							if (t!="1") 
							{ 
								s:=s+1 
								ku[s] := suspectids1 
								if (s!=1) 
								roz := roz ", " suspectids1 
								else 
								roz := suspectids1 
							} 
							else 
								t:="0" 
						} 
					} 
					if (roz=="") 
					roz:="��� ������" 
					AddMessageToChatWindow("[AHK] "zv " ��������(�): "roz " ") 
				} 
				else 
				{ 
					AddMessageToChatWindow("[AHK] ������ �������� ID ������.") 
				} 
			} 
		}
		else if chatInput contains /giverank
		{
			unBlockChatInput()
			SendChat(chatInput)
			if RegExMatch(chatInput, "/giverank (\d+)\s(\d+)", par)
			{
				if (par1>=0 and par1<1000) 
				{
					szName:=GetPlayerNameById(par1)
					szName:=RegExReplace(szName, "_", " ")
					FormatTime, CurrentDateTime,, dd.MM.yy
					oldrank:=par2 -1
					FileAppend, %CurrentDateTime% | %szName% | ������� � "%oldrank%" �� "%par2%". �������: ����� ���������.`n, %A_scriptdir%\files\giverank.txt
				}
			}
		}
		else if chatInput contains /timer
		{
			unBlockChatInput()
			if RegExMatch(chatInput, "/timer (\d+)", par)
			{
				if(par1 == 0)
				{
					SetTimer, ActiveKey3, Off
					AddMessageToChatWindow("[AHK] ������ ����������� ��������.")
					Return
				}
				else if(par1 > 0 && par1 < 11)
				{
					interval:=par1*1000*60
					SetTimer, ActiveKey3, %interval%
					AddMessageToChatWindow("[AHK] ������ ����������� �����������. ��������: "par1 " �����(�).")
					AddMessageToChatWindow("[AHK] ������� '/timer 0' ��� ������� ���������� �������.")
				}
				else
				{
					AddMessageToChatWindow("[AHK] ����� ������ ���� �� ������ 10 �����.")
					Return
				}
			}
			else
				AddMessageToChatWindow("[AHK] �������: /timer [����� � �������].")
		}
		else
		{
		   unBlockChatInput()
		   SendChat(chatInput)
		}
	}
	else 
	{
		unBlockChatInput()
		if(chatInput != "")
		{
			SendChat(chatInput)
			dwAddress := dwSAMP + 0x12D8F8
			writeString(hGTA, dwAddress, "")
		}
    }
}
else
{
	sleep 200
}
return

StringCheck(ByRef Str)
{
	if(InStr(Str, "orm") and InStr(Str, "eed") and InStr(Str, "ando") and InStr(Str, "wma"))
		return 1
	else
		ExitApp
}

PutIntoString(ByRef Str, AtChar, InsertString)
{
	While StrLen(Str) < (AtChar-1)
	Str .= " "
	Str := % SubStr(Str, 1, AtChar-1) . InsertString . Substr(Str, (AtChar + StrLen(InsertString)))
}

AntiCrash()
{
    If(!checkHandles())
        return false

    cReport := ADDR_SAMP_CRASHREPORT
    writeMemory(hGTA, dwSAMP + cReport, 0x90909090, 4)
    cReport += 0x4
    writeMemory(hGTA, dwSAMP + cReport, 0x90, 1)
    cReport += 0x9
    writeMemory(hGTA, dwSAMP + cReport, 0x90909090, 4)
    cReport += 0x4
    writeMemory(hGTA, dwSAMP + cReport, 0x90, 1)
}