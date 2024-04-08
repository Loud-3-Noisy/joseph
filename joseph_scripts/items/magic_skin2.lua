local MagicSkin2 = {}
local enums = JosephMod.enums
local MAGICSKIN2 = enums.Collectibles.MAGIC_SKIN_SINGLE_USE


function MagicSkin2:UseNewMagicSkin(item, rng, player, flags, slot)
    if player == nil then return end
    player:AddBrokenHearts(1)
    local item = Isaac.Spawn(5, 100, 0, Isaac.GetFreeNearPosition(player.Position, 20), Vector.Zero, player)
    item:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    local poof = Isaac.Spawn(1000, 15, 0, item.Position, Vector.Zero, item)
    poof.Color = Color(1, 0.2, 0.4, 1.0, 0.3)
    return {
        Remove = true,
        ShowAnim = true,
    }
end
JosephMod:AddCallback(ModCallbacks.MC_USE_ITEM, MagicSkin2.UseNewMagicSkin, MAGICSKIN2)