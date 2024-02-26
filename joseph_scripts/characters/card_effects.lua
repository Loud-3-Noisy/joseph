local CardEffects = {}


function CardEffects:InitCardEffect(player, card)
    if card == Card.CARD_MAGICIAN then
        player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_SPOON_BENDER, true)
    else
        player:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_SPOON_BENDER)
    end

    if card == Card.CARD_STRENGTH then
        player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM, true)
    else
        player:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM)
        -- player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        -- player:EvaluateItems()
    end

    if card == Card.CARD_DEVIL then
        player:UseActiveItem(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL, false)
    else
        player:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL)
    end
end

function CardEffects:addCardStats(player, flag)
    local playerData = JosephMod.saveManager.GetRunSave(player)
    if not (playerData and playerData.EnchantedCard) then return end

    if playerData.EnchantedCard == Card.CARD_STRENGTH and flag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage * 0.83
    end

    if playerData.EnchantedCard == Card.CARD_DEVIL and flag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage - 0.5
    end

end
JosephMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, CardEffects.addCardStats)


function CardEffects:addRoomEffect()
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local playerData = JosephMod.saveManager.GetRunSave(player)
        if not (playerData and playerData.EnchantedCard) then return end


        if playerData.EnchantedCard == Card.CARD_MAGICIAN then
            player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_SPOON_BENDER, true)
        end

        if playerData.EnchantedCard == Card.CARD_STRENGTH then
            player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM, true)
        end

        if playerData.EnchantedCard == Card.CARD_DEVIL then
            player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL, true)
        end


    end
end
JosephMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, CardEffects.addRoomEffect)




return CardEffects