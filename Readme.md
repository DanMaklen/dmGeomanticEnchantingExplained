# [DM] Geomantic Enchanting Explained
This is a Skyrim Mod. This is intended for personal use mostly.

[Immersive Jewelry](https://www.nexusmods.com/skyrimspecialedition/mods/5336) introduced an enchanting system called "Geomantic Enchanting". However, it is not very well explained. In that system you get some buffs or debuffs to the enchanting done depending on the material of the item enchanted and the enchantment itself. So some items are better for some enchantments than other.

While developing this mod, I noticed some inconsistencies in [Immersive Jewelry](https://www.nexusmods.com/skyrimspecialedition/mods/5336). So, I fixed some of them along the way.

Note: This is tied to my current load order. Future improvement is to remove the direct dependencies and either move them to add-ons or automatic detection if the mods exist.

## Fixes
The final values can be found on this [sheet](https://docs.google.com/spreadsheets/d/1lx3P6f6BYfjzA0KwJxvX-f3pAsRVIuYNd_FjL9IBm_I).
Below are the list of fixes done by this mod:
- Copied over changed from [Summermyst X Immersive Jewelry](https://www.nexusmods.com/skyrimspecialedition/mods/30463) and fixed some more that were missed by the mod.
- Now all perk conditions are 'OR'. Some conditions were 'and'. While it is possible that it is intended by the mod authour, I noticed some cases where it didn't make sense. So I opted to count them as mistakes.
- Some inconcsistencies between related keywords (*Note*: Based on a lot of assumptions).

## Compatability
- [Unofficial Skyrim Special Edition Patch](https://www.nexusmods.com/skyrimspecialedition/mods/266)
  - `Smithing Expertise`: is *not* obtainable because the mod makes `Notched Pickaxe` unique and no longer dis-enchantable.
  - `Shadowthrive`, `Shadowstrength`, `Shadowsight` and `Shadowstrike`: are *not* obtainable.
- [Cutting Room Floor](https://www.nexusmods.com/skyrimspecialedition/mods/276)
  - `Briarheart Geis`: is obtainable optainable.
- [Summermyst](https://www.nexusmods.com/skyrimspecialedition/mods/6285)
  - Accomodated for the newly added enchantments.
  - `Shadowthrive`, `Shadowstrength`, `Shadowsight` and `Shadowstrike`: the fix from USSEP is takes presendence.
- [Legacy of the Dragonborn](https://www.nexusmods.com/skyrimspecialedition/mods/11802)
  - `Veloth's Judgement`: Accomodated for the newly added enchantment.
