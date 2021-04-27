Scriptname dmGEE_MCM extends SKI_ConfigBase

string Page_StudyStudySessionStats = "Study Session Stats"
string Page_EnchantmentChecklist = "Enchantment Checklist"
Perk Property X Auto
Event OnConfigInit()
	ModName = "[DM] Geomantic Enchanting Explained"
	Pages = new string[2]
	Pages[0] = Page_StudyStudySessionStats
	Pages[1] = Page_EnchantmentChecklist
EndEvent