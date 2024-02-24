local JosephMod = RegisterMod("Joseph", 1)

local josephType = Isaac.GetPlayerTypeByName("Joseph", false) -- Exactly as in the xml. The second argument is if you want the Tainted variant.
local hairCostume = Isaac.GetCostumeIdByPath("gfx/characters/joseph_hair.anm2") -- Exact path, with the "resources" folder as the root
local stolesCostume = Isaac.GetCostumeIdByPath("gfx/characters/joseph_poncho.anm2") -- Exact path, with the "resources" folder as the root

function JosephMod:GiveCostumesOnInit(player)
    if player:GetPlayerType() ~= josephType then return end

    player:AddNullCostume(hairCostume)
    player:AddNullCostume(stolesCostume)
end

JosephMod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, JosephMod.GiveCostumesOnInit)


--------------------------------------------------------------------------------------------------


local game = Game() -- We only need to get the game object once. It's good forever!
local DAMAGE_REDUCTION = 0.6
function JosephMod:HandleStartingStats(player, flag)
    if player:GetPlayerType() ~= josephType then
        return -- End the function early. The below code doesn't run, as long as the player isn't Joseph.
    end

    if flag == CacheFlag.CACHE_DAMAGE then
        -- Every time the game reevaluates how much damage the player should have, it will reduce the player's damage by DAMAGE_REDUCTION, which is 0.6
        player.Damage = player.Damage - DAMAGE_REDUCTION
    end
end

JosephMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, JosephMod.HandleStartingStats)