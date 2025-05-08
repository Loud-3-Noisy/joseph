local AceHearts = {}

local enums = JosephMod.enums
local ace = enums.Collectibles.ACE_OF_HEARTS
local utility = JosephMod.utility

local heartsToSpawn = 0


function AceHearts:HeartSpawn(pickup)
    if not PlayerManager.AnyoneHasCollectible(ace) then return end
    local rng = PlayerManager.FirstCollectibleOwner(ace):GetCollectibleRNG(ace)
print(heartsToSpawn)
    if heartsToSpawn > 0 then
        heartsToSpawn = heartsToSpawn - 1
        return
    end
    pickup:Remove()
    if rng:RandomFloat() < 0.5 then
        Isaac.Spawn(5, 0, NullPickupSubType.NO_COLLECTIBLE_TRINKET_CHEST, pickup.Position, pickup.Velocity, pickup.SpawnerEntity)
        return
    end

    local card = Game():GetItemPool():GetCard(rng:Next(), true, false, false)
    Isaac.Spawn(5, PickupVariant.PICKUP_TAROTCARD, card, pickup.Position, pickup.Velocity, pickup.SpawnerEntity)

end
JosephMod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, AceHearts.HeartSpawn, PickupVariant.PICKUP_HEART)



function AceHearts:UseHeartCard(card, player, flags)
    if not PlayerManager.AnyoneHasCollectible(ace) then return end
    if card == Card.CARD_LOVERS or card == Card.CARD_HIEROPHANT or card == Card.CARD_REVERSE_HIEROPHANT then
        heartsToSpawn = 2
        print("a " .. heartsToSpawn)
    end
end
JosephMod:AddCallback(ModCallbacks.MC_PRE_USE_CARD, AceHearts.UseHeartCard)