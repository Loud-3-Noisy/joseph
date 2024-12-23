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



local enchantmentDisplay = Sprite()
enchantmentDisplay:Load("gfx/ui/enchanted_card_displays.anm2",true)

function CardSleeve:RenderEnchantedCard(player, slot, offset, alpha, scale, chargeBarOffset)

    if player:GetActiveItem(slot) ~= CARD_SLEEVE then return end

    local enchantedCard = utility:GetEnchantedCardInPlayerSlot(player, enums.CardSlot.CARD_SLEEVE_MAIN)
    print(enchantedCard)
    if enchantedCard and enchantedCard ~= 0 then

        enchantmentDisplay.Color = Color(1, 1, 1, 1)
        enchantmentDisplay.Scale = Vector(scale, scale)
        local displayPos = Vector(16, 16)

        local pocketItem = player:GetPocketItem(PillCardSlot.PRIMARY)
        local isSelectedPocketItem = pocketItem:GetType() == PocketItemType.ACTIVE_ITEM and pocketItem:GetSlot()-1 == ActiveSlot.SLOT_POCKET
        local isSelectedPocket2Item = pocketItem:GetType() == PocketItemType.ACTIVE_ITEM and pocketItem:GetSlot()-1 == ActiveSlot.SLOT_POCKET2

		if slot == ActiveSlot.SLOT_SECONDARY or (slot == ActiveSlot.SLOT_POCKET and not isSelectedPocketItem) or (slot == ActiveSlot.SLOT_POCKET2 and not isSelectedPocket2Item) then
			displayPos = displayPos / 2
		end


        enchantmentDisplay:SetFrame("CardFronts", enchantedCard)


        enchantmentDisplay:LoadGraphics()
        enchantmentDisplay:Render(displayPos + offset)
    end

end

JosephMod:AddCallback(ModCallbacks.MC_POST_PLAYERHUD_RENDER_ACTIVE_ITEM, CardSleeve.RenderEnchantedCard)



return CardSleeve