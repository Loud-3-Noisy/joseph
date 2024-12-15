local ReverseMagician = {}

local utility = JosephMod.utility
local enums = JosephMod.enums



---@param player EntityPlayer
---@param card Card
---@param slot CardSlot
function ReverseMagician:initReverseMagician(player, card, slot)
    player:GetEffects():AddNullEffect(NullItemID.ID_REVERSE_MAGICIAN)
    local effect = player:GetEffects():GetNullEffect(NullItemID.ID_REVERSE_MAGICIAN)
    effect.Cooldown = 2147483646
end
JosephMod:AddCallback(enums.Callbacks.JOSEPH_POST_ENCHANT_ADD, ReverseMagician.initReverseMagician, Card.CARD_REVERSE_MAGICIAN)


---@param player EntityPlayer
---@param card Card
---@param slot CardSlot
function ReverseMagician:removeReverseMagician(player, card, slot)
    player:GetEffects():RemoveNullEffect(NullItemID.ID_REVERSE_MAGICIAN)
    local effect = player:GetEffects():GetNullEffect(NullItemID.ID_REVERSE_MAGICIAN)
    if effect then
        effect.Cooldown = 1
    end
end
JosephMod:AddCallback(enums.Callbacks.JOSEPH_POST_ENCHANT_REMOVE, ReverseMagician.removeReverseMagician, Card.CARD_REVERSE_MAGICIAN)


function ReverseMagician:ReapplyReverseMagician()
    for i = 0, Game():GetNumPlayers()-1 do
        local player = Game():GetPlayer(i)
        if utility:HasEnchantment(player, Card.CARD_REVERSE_MAGICIAN) and player:GetEffects():HasNullEffect(NullItemID.ID_REVERSE_MAGICIAN) then
            local effect = player:GetEffects():GetNullEffect(NullItemID.ID_REVERSE_MAGICIAN)
            effect.Cooldown = 2147483646
        end
    end
end
JosephMod:AddCallback(TSIL.Enums.CustomCallback.POST_NEW_ROOM_REORDERED, ReverseMagician.ReapplyReverseMagician)


-- JosephMod:AddCallback(TSIL.Enums.CustomCallback.POST_NEW_LEVEL_REORDERED, function ()
--     if gameContinued then 
--         gameContinued = false
--         return
--     end
--     JosephMod.Schedule(1, function ()
--         JosephMod.BaseCardEffects:ReapplyCardEffects()
--     end,{})
-- end)