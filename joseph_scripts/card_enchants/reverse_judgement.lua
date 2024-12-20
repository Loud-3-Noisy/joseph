local ReverseJudgement = {}

local utility = JosephMod.utility
local enums = JosephMod.enums


---@param player EntityPlayer
---@param card Card
---@param slot CardSlot
function ReverseJudgement:initReverseJudgement(player, card, slot)

end
JosephMod:AddCallback(enums.Callbacks.JOSEPH_POST_ENCHANT_ADD, ReverseJudgement.initReverseJudgement, Card.CARD_REVERSE_JUDGEMENT)
JosephMod:AddCallback(enums.Callbacks.JOSEPH_GAME_START_ENCHANT_REFRESH, ReverseJudgement.initReverseJudgement, Card.CARD_REVERSE_JUDGEMENT)

---@param player EntityPlayer
---@param card Card
---@param slot CardSlot
function ReverseJudgement:removeReverseJudgement(player, card, slot)
    utility:RemoveInnateItem(player, CollectibleType.COLLECTIBLE_SOUL)
end
JosephMod:AddCallback(enums.Callbacks.JOSEPH_POST_ENCHANT_REMOVE, ReverseJudgement.removeReverseJudgement, Card.CARD_REVERSE_JUDGEMENT)

function ReverseJudgement:ItemSpawn(item)
    local itemPool = Game():GetItemPool()
    local roomType = Game():GetRoom():GetType()
 
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        for j = 0, utility:GetEnchantmentCount(player, Card.CARD_REVERSE_JUDGEMENT) - 1, 1 do
            local seed = player:GetCardRNG(Card.CARD_REVERSE_JUDGEMENT):GetSeed()
            item:AddCollectibleCycle(itemPool:GetCollectible(itemPool:GetPoolForRoom(roomType, seed)))
        end
    end
end
JosephMod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, ReverseJudgement.ItemSpawn, PickupVariant.PICKUP_COLLECTIBLE)