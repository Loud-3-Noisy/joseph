JosephMod = RegisterMod("Joseph", 1)
if REPENTOGON then
    include("joseph_scripts.enums")
    JosephMod.saveManager = include("joseph_scripts.utility.save_manager")
    JosephMod.HiddenItemManager = require("joseph_scripts.utility.hidden_item_manager")
    JosephMod.saveManager.Init(JosephMod)
    JosephMod.HiddenItemManager:Init(JosephMod)

    require("JOSEPH_TSIL.TSIL").Init("JOSEPH_TSIL")

    JosephMod.utility = include('joseph_scripts.utility.functions')
    JosephMod.cardEffects = include("joseph_scripts.characters.card_effects")
    include("joseph_scripts.characters.joseph")
    include("joseph_scripts.characters.slotmachines")
    include("joseph_scripts.items.magic_skin2")

    function JosephMod:PreSave(data)
        -- notice how this callback is provided the entire save file
        local hiddenItemData = JosephMod.HiddenItemManager:GetSaveData()
      -- Include` hiddenItemData` in your SaveData table!
      
        local save = JosephMod.saveManager.GetRunSave(nil)
        if save then save.HIDDEN_ITEM_DATA = hiddenItemData end
      end
      
      -- also notice that custom callbacks use a special function in the save manager!!!
      JosephMod.saveManager.AddCallback(JosephMod.saveManager.Utility.CustomCallback.PRE_DATA_SAVE, JosephMod.PreSave)
      
      -- this primarily handles luamod
      function JosephMod:PostLoad(data)
        local save = JosephMod.saveManager.GetRunSave(nil)
        if save then JosephMod.HiddenItemManager:LoadData(save.HIDDEN_ITEM_DATA) end
      end
      -- also notice that custom callbacks use a special function in the save manager!!!
      JosephMod.saveManager.AddCallback(JosephMod.saveManager.Utility.CustomCallback.POST_DATA_LOAD, JosephMod.PostLoad)
      
      -- UnlockAPI wipes data on game start, which is later than the initial load, so load it again in that case.
      function JosephMod:PostLoadGameStart()
        local save = JosephMod.saveManager.GetRunSave(nil)
        if save then JosephMod.HiddenItemManager:LoadData(save.HIDDEN_ITEM_DATA) end
      end
      JosephMod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, JosephMod.PostLoadGameStart)
else
    JosephMod:AddCallback(ModCallbacks.MC_POST_RENDER, function ()
        local pos = 50
        local scale = 0.5
        local warning = "REPENTOGON is required to use Joseph mod and is not installed! Check out repentogon.com for more information!"
        Isaac.RenderScaledText(warning, pos, pos, scale, scale, 1, 0, 0 ,1)
    end)
end