local CardSleeve = {}

local enums = JosephMod.enums
local utility = JosephMod.utility
local JosephChar = JosephMod.josephCharacter

local CARD_SLEEVE = Isaac.GetItemIdByName("Card Sleeve")


---@param player EntityPlayer
function CardSleeve:UseNewMagicSkin(item, rng, player, flags, slot)
    if player == nil then return end

    local heldCard = player:GetCard(PillCardSlot.PRIMARY)
    if not heldCard or heldCard == 0 or not enums.CardAnims[heldCard] then 
        return {Discharge = false, ShowAnim = true} 
    end

    player:RemovePocketItem(PillCardSlot.PRIMARY)
    JosephChar:EnchantCard(player, heldCard, enums.CardSlot.CARD_SLEEVE_MAIN, true)

    return {
        Remove = false,
        ShowAnim = true,
    }
end
JosephMod:AddCallback(ModCallbacks.MC_USE_ITEM, CardSleeve.UseNewMagicSkin, CARD_SLEEVE)





return CardSleeve