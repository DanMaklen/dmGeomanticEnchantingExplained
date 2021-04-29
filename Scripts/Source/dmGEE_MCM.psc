Scriptname dmGEE_MCM extends SKI_ConfigBase

string Page_StudyStudySessionStats = "Study Session Stats"
string Page_EnchantmentChecklist = "Enchantment Checklist"

FormList Property dmGEE_EnchList Auto

Event OnConfigInit()
	ModName = "[DM] Geomantic Enchanting Explained"
	Pages = new string[2]
	Pages[0] = Page_StudyStudySessionStats
	Pages[1] = Page_EnchantmentChecklist
EndEvent

Event OnPageReset(string pageName)
	; Form[] items = PO3_SKSEFunctions.AddAllItemsToArray(self.GetReference())
	Keyword[] keyList = new Keyword[1]
	keyList[0] = Keyword.GetKeyword("MagicEnchFortifyBlock")
	Enchantment[] items = PO3_SKSEFunctions.GetAllEnchantments()
	MiscUtil.PrintConsole("Item Count: " + items.Length)
	int i = 0
	int count = 0
	; FormList x
	; While (i < items.Length && i < 100)
	; 	If (items[i].GetBaseEnchantment() == none)
	; 		count += 1
	; 		MiscUtil.PrintConsole("item " + i + ": " + items[i] + " (" + PO3_SKSEFunctions.IntToString(items[i].GetFormID(), true) + " - " + items[i].GetName() + ")")
	; 	EndIf
	;     i += 1
	; EndWhile
	; MiscUtil.PrintConsole("Found: " + count)

	; int i = 0
	; While i < dmGEE_EnchList.GetSize()
	; 	FormList subList = dmGEE_EnchList.GetAt(i) as FormList
	; 	int j = 0
	; 	While j < subList.GetSize()
	; 		Enchantment ench = subList.GetAt(j) as Enchantment
	; 		If (ench.HasKeyword(keyList[0]))
	; 			MiscUtil.PrintConsole("ench " + i + ": " + ench + " (" + PO3_SKSEFunctions.IntToString(ench.GetFormID(), true) + " - " + ench.GetName() + ")")
	; 		EndIf
	; 		j += 1
	; 	EndWhile
	; 	i += 1
	; EndWhile
	
	Debug.Notification("[DM] Geomantic Enchanting Explained Installed Successfully...")
EndEvent