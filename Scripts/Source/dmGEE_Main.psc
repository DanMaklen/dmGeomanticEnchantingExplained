Scriptname dmGEE_Main extends ReferenceAlias

Perk Property IJGeomanticArmorEnchanting Auto
Perk Property IJGeomanticWeaponEnchanting Auto

FormList Property dmGEE_EnchList Auto

Event OnInit()
    ; Form[] items = PO3_SKSEFunctions.AddAllItemsToArray(self.GetReference())
    ; Enchantment[] items = PO3_SKSEFunctions.GetAllEnchantments()
    ; MiscUtil.PrintConsole("Item Count: " + items.Length)
    ; int i = 0
    ; While (i < items.Length)
    ;     MiscUtil.PrintConsole("item " + i + ": " + items[i])
    ;     i += 1
    ; EndWhile
    
    Debug.Notification("[DM] Geomantic Enchanting Explained Installed Successfully...")
EndEvent

