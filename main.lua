JosephMod = RegisterMod("Joseph", 1)
if REPENTOGON then
  require("JOSEPH_TSIL.TSIL").Init("JOSEPH_TSIL")

  include("joseph_scripts.enums")
  JosephMod.utility = include('joseph_scripts.utility.functions')
  JosephMod.BaseCardEffects = include('joseph_scripts.card_enchants.base_card_effects')
  JosephMod.josephCharacter = include("joseph_scripts.characters.joseph")
  JosephMod.Chargebar = include("joseph_scripts.chargebar")
  include("joseph_scripts.card_enchants.chariot")

  include("joseph_scripts.card_enchants.reverse_empress")
  include("joseph_scripts.card_enchants.reverse_chariot")
  include("joseph_scripts.card_enchants.reverse_high_priestess")
  include("joseph_scripts.card_enchants.reverse_lovers")
  include("joseph_scripts.card_enchants.reverse_stars")
  include("joseph_scripts.card_enchants.reverse_emperor")
  include("joseph_scripts.card_enchants.reverse_magician")
  include("joseph_scripts.card_enchants.reverse_hanged_man")
  include("joseph_scripts.card_enchants.reverse_devil")
  include("joseph_scripts.card_enchants.reverse_sun")

  include("joseph_scripts.characters.slotmachines")
  --include("joseph_scripts.items.lil_slots")

else
  JosephMod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
      local pos = 50
      local scale = 0.5
      local warning =
          "REPENTOGON is required to use Joseph mod and is not installed! Check out repentogon.com for more information!"
      Isaac.RenderScaledText(warning, pos, pos, scale, scale, 1, 0, 0, 1)
  end)
end

-- JosephMod.Debug = false
-- --JosephMod.Render = "hi"

-- if JosephMod.Debug == true then
--   function JosephMod:Debug()
--       local effect = Isaac.GetPlayer():GetEffects():GetNullEffect(NullItemID.ID_REVERSE_HIGH_PRIESTESS)
--       if effect then
--         Isaac.RenderText(tostring(effect.Cooldown), 50, 80, 1, 1, 1, 1)
--       end
--   end
-- JosephMod:AddCallback(ModCallbacks.MC_POST_RENDER, JosephMod.Debug)

-- end
