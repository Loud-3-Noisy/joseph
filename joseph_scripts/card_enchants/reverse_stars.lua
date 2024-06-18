local ReverseStars = {}

local utility = JosephMod.utility
local enums = JosephMod.enums

local RECOMMENDED_SHIFT_IDX = 35


---@param player EntityPlayer
---@param card Card
---@param slot CardSlot
function ReverseStars:initReverseStars(player, card, slot)
    player:AddInnateCollectible(CollectibleType.COLLECTIBLE_DAMOCLES_PASSIVE)
    JosephMod.Schedule(1, function ()

        local damoclesList = Isaac.FindByType(3, 202, 0)
        for key, damocles in pairs(damoclesList) do
            local damoclesFamiliar = damocles:ToFamiliar()
            if damoclesFamiliar and damoclesFamiliar.Player and GetPtrHash(damoclesFamiliar.Player) == GetPtrHash(player) then
                ReverseStars:MakeGold(damoclesFamiliar)
            end
        end

    end,{})
end
JosephMod:AddCallback(enums.Callbacks.JOSEPH_POST_ENCHANT_ADD, ReverseStars.initReverseStars, Card.CARD_REVERSE_STARS)
JosephMod:AddCallback(enums.Callbacks.JOSEPH_GAME_START_ENCHANT_REFRESH, ReverseStars.initReverseStars, Card.CARD_REVERSE_STARS)



---@param player EntityPlayer
---@param card Card
---@param slot CardSlot
function ReverseStars:removeReverseStars(player, card, slot)

    utility:RemoveInnateItem(player, CollectibleType.COLLECTIBLE_DAMOCLES_PASSIVE)
    if player:HasCollectible(CollectibleType.COLLECTIBLE_DAMOCLES_PASSIVE, false, true) then
        local damoclesList = Isaac.FindByType(3, 202, 0)
        for key, damocles in pairs(damoclesList) do
            local damoclesFamiliar = damocles:ToFamiliar()
            if damoclesFamiliar and damoclesFamiliar.Player and GetPtrHash(damoclesFamiliar.Player) == GetPtrHash(player) then
                local sprite = damoclesFamiliar:GetSprite()
                for idx = 0, 1 do
                    sprite:ReplaceSpritesheet(0, "gfx/familiar/003.202_damocles.png", true)
                end
            end
        end
    end
end
JosephMod:AddCallback(enums.Callbacks.JOSEPH_POST_ENCHANT_REMOVE, ReverseStars.removeReverseStars, Card.CARD_REVERSE_STARS)



function ReverseStars:OnHit(entity, amount, flags, source, countDown)

    local player = entity:ToPlayer()
    local fakeDamageFlags = DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_RED_HEARTS | DamageFlag.DAMAGE_FAKE
    if flags & fakeDamageFlags > 0 then return end
    if not utility:HasEnchantment(player, Card.CARD_REVERSE_STARS) then return end


    local damoclesList = Isaac.FindByType(3, 202, 0)
    for key, damocles in pairs(damoclesList) do
        local damoclesFamiliar = damocles:ToFamiliar()
        if damoclesFamiliar and damoclesFamiliar.Player and GetPtrHash(damoclesFamiliar.Player) == GetPtrHash(player) then
            local sprite = damoclesFamiliar:GetSprite()
            sprite:Play("Fall", true)
        end
    end
    player:Die()
    JosephMod.Schedule(26, function ()

        utility:RemoveInnateItem(player, CollectibleType.COLLECTIBLE_DAMOCLES_PASSIVE)

    end,{})
end
JosephMod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, ReverseStars.OnHit, EntityType.ENTITY_PLAYER)



---@param entity EntityFamiliar
function ReverseStars:MakeGold(entity)
    local sprite = entity:GetSprite()
    for idx = 0, 1 do
        sprite:ReplaceSpritesheet(0, "gfx/familiar/golden_damocles.png", true)
    end
end

-- ---@param familiar EntityFamiliar
-- function ReverseStars:DamoclesSpawn(familiar)
--     local player = familiar.Player
--     if utility:HasEnchantment(player, Card.CARD_REVERSE_STARS) then
--         ReverseStars:MakeGold(familiar)
--     end
-- end
-- JosephMod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, ReverseStars.DamoclesSpawn, FamiliarVariant.DAMOCLES)