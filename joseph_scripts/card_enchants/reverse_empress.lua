local ReverseEmpress = {}

local utility = JosephMod.utility
local enums = JosephMod.enums



---@param player EntityPlayer
---@param card Card
---@param slot CardSlot
function ReverseEmpress:initReverseEmpress(player, card, slot)
    player:GetEffects():AddNullEffect(NullItemID.ID_REVERSE_EMPRESS)
end
JosephMod:AddCallback(enums.Callbacks.JOSEPH_POST_ENCHANT_ADD, ReverseEmpress.initReverseEmpress, Card.CARD_REVERSE_EMPRESS)


---@param player EntityPlayer
---@param card Card
---@param slot CardSlot
function ReverseEmpress:removeReverseEmpress(player, card, slot)
    player:GetEffects():RemoveNullEffect(NullItemID.ID_REVERSE_EMPRESS)
end
JosephMod:AddCallback(enums.Callbacks.JOSEPH_POST_ENCHANT_REMOVE, ReverseEmpress.removeReverseEmpress, Card.CARD_REVERSE_EMPRESS)


function ReverseEmpress:ReapplyReverseHighPriestess()
    for i = 0, Game():GetNumPlayers()-1 do
        local player = Game():GetPlayer(i)
        if utility:HasEnchantment(player, Card.CARD_REVERSE_EMPRESS) and player:GetEffects():GetNullEffectNum(NullItemID.ID_REVERSE_EMPRESS) < 1 then
            player:GetEffects():AddNullEffect(NullItemID.ID_REVERSE_EMPRESS)
        end
    end
end
JosephMod:AddCallback(TSIL.Enums.CustomCallback.POST_NEW_ROOM_REORDERED, ReverseEmpress.ReapplyReverseHighPriestess)


-- JosephMod:AddCallback(TSIL.Enums.CustomCallback.POST_NEW_LEVEL_REORDERED, function ()
--     if gameContinued then 
--         gameContinued = false
--         return
--     end
--     JosephMod.Schedule(1, function ()
--         JosephMod.BaseCardEffects:ReapplyCardEffects()
--     end,{})
-- end)