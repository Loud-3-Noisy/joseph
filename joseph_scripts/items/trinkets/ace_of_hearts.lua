local AceHearts = {}

local enums = JosephMod.enums
local aceTrinket = enums.Trinkets.ACE_OF_HEARTS
local utility = JosephMod.utility



function AceHearts:HeartSpawn(pickup, variant, subtype)
    if variant ~= PickupVariant.PICKUP_HEART then return end
    if not PlayerManager.AnyoneHasTrinket(aceTrinket) then return end
    local rng = PlayerManager.FirstTrinketOwner(aceTrinket):GetTrinketRNG(aceTrinket)
    print("Hi")

    local card = Game():GetItemPool():GetCard(rng:Next(), true, false, false)
    
    return {PickupVariant.PICKUP_TAROTCARD, card}

end
JosephMod:AddCallback(ModCallbacks.MC_POST_PICKUP_SELECTION, AceHearts.HeartSpawn)