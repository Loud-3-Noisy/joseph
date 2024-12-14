local ReverseHighPreistess = {}

local utility = JosephMod.utility
local enums = JosephMod.enums



---@param player EntityPlayer
---@param card Card
---@param slot CardSlot
function ReverseHighPreistess:initReverseHighPreistess(player, card, slot)
    player:GetEffects():AddNullEffect(NullItemID.ID_REVERSE_HIGH_PRIESTESS)
    local effect = player:GetEffects():GetNullEffect(NullItemID.ID_REVERSE_HIGH_PRIESTESS)
    effect.Cooldown = 2147483646
end
JosephMod:AddCallback(enums.Callbacks.JOSEPH_POST_ENCHANT_ADD, ReverseHighPreistess.initReverseHighPreistess, Card.CARD_REVERSE_HIGH_PRIESTESS)


---@param player EntityPlayer
---@param card Card
---@param slot CardSlot
function ReverseHighPreistess:removeReverseHighPreistess(player, card, slot)
    player:GetEffects():RemoveNullEffect(NullItemID.ID_REVERSE_HIGH_PRIESTESS)
    local effect = player:GetEffects():GetNullEffect(NullItemID.ID_REVERSE_HIGH_PRIESTESS)
    if effect then
        effect.Cooldown = 1
    end
end
JosephMod:AddCallback(enums.Callbacks.JOSEPH_POST_ENCHANT_REMOVE, ReverseHighPreistess.removeReverseHighPreistess, Card.CARD_REVERSE_HIGH_PRIESTESS)


function ReverseHighPreistess:ReapplyReverseHighPriestess()
    for i = 0, Game():GetNumPlayers()-1 do
        local player = Game():GetPlayer(i)
        if utility:HasEnchantment(player, Card.CARD_REVERSE_HIGH_PRIESTESS) and player:GetEffects():HasNullEffect(NullItemID.ID_REVERSE_HIGH_PRIESTESS) then
            local effect = player:GetEffects():GetNullEffect(NullItemID.ID_REVERSE_HIGH_PRIESTESS)
            effect.Cooldown = 2147483646
        end
    end
end
JosephMod:AddCallback(TSIL.Enums.CustomCallback.POST_NEW_ROOM_REORDERED, ReverseHighPreistess.ReapplyReverseHighPriestess)


-- JosephMod:AddCallback(TSIL.Enums.CustomCallback.POST_NEW_LEVEL_REORDERED, function ()
--     if gameContinued then 
--         gameContinued = false
--         return
--     end
--     JosephMod.Schedule(1, function ()
--         JosephMod.BaseCardEffects:ReapplyCardEffects()
--     end,{})
-- end)