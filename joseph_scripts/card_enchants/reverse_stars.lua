local ReverseStars = {}

local utility = JosephMod.utility
local enums = JosephMod.enums
local char = JosephMod.josephCharacter
local RECOMMENDED_SHIFT_IDX = 35

local vars = {
    "starsDamoclesFell"
}
utility:CreateEmptyPlayerSaveDataVars(vars)

---@param player EntityPlayer
---@param card Card
---@param slot CardSlot
function ReverseStars:initReverseStars(player, card, slot)
    player:AddInnateCollectible(CollectibleType.COLLECTIBLE_DAMOCLES_PASSIVE)
    JosephMod.Schedule(1, function ()

        local damoclesList = Isaac.FindByType(3, 202)
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
        local damoclesList = Isaac.FindByType(3, 202)
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
    --if utility:GetPlayerSave(player, "starsDamoclesFell") == true then return end
    utility:SetPlayerSave(player, "starsDamoclesFell", true)
    ReverseStars:DamoclesFall(player)
end
JosephMod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, ReverseStars.OnHit, EntityType.ENTITY_PLAYER)

---@param player EntityPlayer
function ReverseStars:DamoclesFall(player)
    local damoclesList = Isaac.FindByType(3, 202)
    for key, damocles in pairs(damoclesList) do

        local damoclesFamiliar = damocles:ToFamiliar()
        if damoclesFamiliar and damoclesFamiliar.Player and GetPtrHash(damoclesFamiliar.Player) == GetPtrHash(player) then
            local sprite = damoclesFamiliar:GetSprite()
            sprite:Play("Fall", true)
            Isaac.CreateTimer( function ()
                for _, cardSlot in pairs(enums.CardSlot) do
                    if utility:GetEnchantedCardInPlayerSlot(player, cardSlot) == Card.CARD_REVERSE_STARS then
                        JosephMod.josephCharacter:DisenchantCard(player, Card.CARD_REVERSE_STARS, cardSlot, true)
                    end
                end

                player:ResetDamageCooldown()
                for i = 1, 6 do
                    player:TakeDamage(1, DamageFlag.DAMAGE_NOKILL | DamageFlag.DAMAGE_NO_MODIFIERS, EntityRef(player), 0)
                    player:ResetDamageCooldown()
                end

                player:SetMinDamageCooldown(60)

                SFXManager():Play(SoundEffect.SOUND_MEATY_DEATHS)
                player:SpawnBloodEffect()
                player:UseActiveItem(CollectibleType.COLLECTIBLE_D4, UseFlag.USE_NOANIM)
                local entity = Isaac.Spawn(1000, enums.Effects.FALLEN_GOLD_DAMOCLES, 0, player.Position, Vector(0, 0), player)
                utility:SetPlayerSave(player, "starsDamoclesFell", false)
             end, 13, 0, true)
        end
    end
end



function ReverseStars:PlayerRejoin(isContinued)
if not isContinued then return end
Isaac.CreateTimer( function ()
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if utility:HasEnchantment(player, Card.CARD_REVERSE_STARS) and utility:GetPlayerSave(player, "starsDamoclesFell") then
            ReverseStars:DamoclesFall(player)
        end
    end
end, 10, 0, true)

end
JosephMod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, ReverseStars.PlayerRejoin)

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