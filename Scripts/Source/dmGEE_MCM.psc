Scriptname dmGEE_MCM extends SKI_ConfigBase

string Page_ItemKeywords = "Item Keywords"
string Page_EnchantmentChecklist_Skyrim = "Checklist - Skyrim"
string Page_EnchantmentChecklist_Summermyst_Armor = "Checklist - Summermyst: Armor"
string Page_EnchantmentChecklist_Summermyst_Weapon = "Checklist - Summermyst: Weapon"
string Page_EnchantmentChecklist_Misc = "Checklist - Misc"

FormList Property dmGEE_EnchList_Base_Armor Auto
FormList Property dmGEE_EnchList_Base_Weapon Auto
FormList Property dmGEE_EnchList_SUM_Armor Auto
FormList Property dmGEE_EnchList_SUM_Weapon Auto
FormList Property dmGEE_EnchList_DBM_Weapon Auto

Event OnConfigInit()
	ModName = "[DM] Geomantic Enchanting Explained"
	Pages = new string[5]
	Pages[0] = Page_ItemKeywords
	Pages[1] = Page_EnchantmentChecklist_Skyrim
	Pages[2] = Page_EnchantmentChecklist_Summermyst_Armor
	Pages[3] = Page_EnchantmentChecklist_Summermyst_Weapon
	Pages[4] = Page_EnchantmentChecklist_Misc
EndEvent

Event OnPageReset(string pageName)
	If (pageName == Page_ItemKeywords)
		AddPage_ItemKeywords()
	ElseIf(pageName == Page_EnchantmentChecklist_Skyrim)
		AddPage_EnchantmentChecklist_Skyrim()
	ElseIf(pageName == Page_EnchantmentChecklist_Summermyst_Armor)
		AddPage_EnchantmentChecklist_Summermyst_Armor()
	ElseIf(pageName == Page_EnchantmentChecklist_Summermyst_Weapon)
		AddPage_EnchantmentChecklist_Summermyst_Weapon()
	ElseIf(pageName == Page_EnchantmentChecklist_Misc)
		AddPage_EnchantmentChecklist_Misc()
	EndIf
EndEvent
Event OnConfigOpen()
	InitPage_ItemKeywords()
EndEvent
Event OnConfigClose()
	CleanUpPage_ItemKeywords()
EndEvent

; Page 1 - Item Keywords
	Form[] equippedItems
	int selectedItemIndex
	Function AddPage_ItemKeywords()
		AddHeaderOption("Item Keywords")
		AddItemSelect()
		AddKeywordList()
	EndFunction
	Function InitPage_ItemKeywords()
		equippedItems = PO3_SKSEFunctions.AddAllEquippedItemsToArray(Game.GetPlayer())
		selectedItemIndex = -1
	EndFunction
	Function CleanUpPage_ItemKeywords()
		equippedItems = none
	EndFunction

	Function AddItemSelect()
		int disabledFlag = OPTION_FLAG_NONE
		If (equippedItems.Length == 0)
			disabledFlag = OPTION_FLAG_DISABLED
		EndIf
		string value = "Select Item"
		If (selectedItemIndex != -1)
			value = equippedItems[selectedItemIndex].GetName()
		EndIf
		AddMenuOptionST("ItemSelect", "", value, disabledFlag)
	EndFunction
	State ItemSelect
		Event OnMenuOpenST()
			int jobj = JArray.object()
			int i = 0
			While (i < equippedItems.Length)
				JArray.addStr(jobj, equippedItems[i].GetName())
				i += 1
			EndWhile
			SetMenuDialogOptions(JArray.asStringArray(jobj))
			SetMenuDialogStartIndex(selectedItemIndex)
			SetMenuDialogDefaultIndex(0)
		EndEvent
		Event OnMenuAcceptST(int index)
			selectedItemIndex = index
			ForcePageReset()
		EndEvent
		Event OnHighlightST()
			SetInfoText("Select an item to analyze it's enchanting keywords.\nItem has to be equipped.")
		EndEvent
		Event OnDefaultST()
			selectedItemIndex = -1
			ForcePageReset()
		EndEvent
	EndState

	Function AddKeywordList()
		If (equippedItems.Length == 0 || selectedItemIndex == -1)
			return
		EndIf
		Form item = equippedItems[selectedItemIndex]
		int i = 0
		While (i < item.GetNumKeywords())
			Keyword itemKeyword = item.GetNthKeyword(i)
			AddTextOption(itemKeyword.GetString(), "", OPTION_FLAG_DISABLED)
			i += 1
		EndWhile
	EndFunction

; Page 2: Enchantment Checklist - Skyrim
	Function AddPage_EnchantmentChecklist_Skyrim()
		AddChecklist_Generic_Horizontal("Skyirm: Armor", dmGEE_EnchList_Base_Armor)
		AddChecklist_Generic_Horizontal("Skyrim: Weapon", dmGEE_EnchList_Base_Weapon)
	EndFunction
; Page 3: Enchantment Checklist - Summermyst: Armor
	Function AddPage_EnchantmentChecklist_Summermyst_Armor()
		AddChecklist_Generic_Horizontal("Summermyst: Armor", dmGEE_EnchList_SUM_Armor)
	EndFunction
; Page 4: Enchantment Checklist - Summermyst: Weapon
	Function AddPage_EnchantmentChecklist_Summermyst_Weapon()
		AddChecklist_Generic_Horizontal("Summermyst: Weapon", dmGEE_EnchList_SUM_Weapon)
	EndFunction
; Page 5: Enchantment Checklist - Misc
	Function AddPage_EnchantmentChecklist_Misc()
		AddChecklist_Generic_Vertical("Legacy of the Dragonborn", dmGEE_EnchList_DBM_Weapon)
	EndFunction

; Enchantment Checlist Helpers
	Function AddChecklist_Generic_Horizontal(string checklistTitle, FormList enchList)
		SetCursorFillMode(LEFT_TO_RIGHT)
		AddHeaderOption(checklistTitle)
		AddTextOption("Known", GetKnownCountString(enchList), OPTION_FLAG_DISABLED)
		FillChecklist(enchList)
		If (enchList.GetSize() % 2 == 1)
			AddEmptyOption()
		EndIf
	EndFunction
	Function AddChecklist_Generic_Vertical(string checklistTitle, FormList enchList)
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption(checklistTitle + " " + GetKnownCountString(enchList))
		FillChecklist(enchList)
	EndFunction
	Function FillChecklist(FormList enchList)
		int i = 0
		While (i < enchList.GetSize())
			Form ench = enchList.GetAt(i)
			AddToggleOption(ench.GetName(), ench.PlayerKnows())
			i += 1
		EndWhile
	EndFunction
	string Function GetKnownCountString(FormList enchList)
		int knownCount = 0
		int i = 0
		While (i < enchList.GetSize())
			If (enchList.GetAt(i).PlayerKnows())
				knownCount += 1
			EndIf
			i += 1
		EndWhile
		return knownCount + "/" + enchList.GetSize() + " (" + FloatToPercentage(knownCount as float / enchList.GetSize() as float) + ")"
	EndFunction

; Utilities
	string Function FloatToString(float val, int precision = 2) global
		int decimalUnit = Math.pow(10, precision) as int
		int fixedDecimalValue = (val * decimalUnit) as int
		Return (fixedDecimalValue / decimalUnit) + "." + AppendFillCharacter(fixedDecimalValue % decimalUnit, "0", precision)
	EndFunction

	string Function FloatToPercentage(float val, int precision = 2) global
		return FloatToString(val * 100, precision) + "%"
	EndFunction

	string Function AppendFillCharacter(string str, string char, int width) global
		int count = width - StringUtil.GetLength(str)
		While (count > 0)
			str = char + str
			count -= 1
		EndWhile
		return str
	EndFunction