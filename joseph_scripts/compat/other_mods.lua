local other_mods = {}

local enums = JosephMod.enums
local mod = JosephMod




function mod:CompatScripts()
    if TheFuture then
        TheFuture.ModdedCharacterDialogue["Joseph​"] = {
            "you look like you know your way around cards",
            "...",
            "up for a game of four souls?", }
    end
end
mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, mod.CompatScripts)