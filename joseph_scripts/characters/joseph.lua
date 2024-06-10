local JosephChar = {}

local utility = JosephMod.utility
local enums = JosephMod.enums

local vars = {
    "playerRNG",
    "EnchantedCards",
}
utility:CreateEmptyPlayerSaveDataVars(vars)
-- EnchantedCard slots:
-- 1 - Joseph Base
-- 2 - Joseph Birthright
-- 3 - Card Sleeve
-- 4 - Card Sleeve Schoolbag
-- 5 - Card Sleeve Pocket

local CardChargeBar = {}
local StartedUsingCard = {}
local FramesHeld = {}
local EarlyCancel = {}
local Card = {}
local ManualUse = {}



local NUMBER_TAROT_CARDS = 22
local RECOMMENDED_SHIFT_IDX = 35
local DISENCHANT_ENTITY_ID = Isaac.GetEntityVariantByName("Disenchant Effect")
local josephType = Isaac.GetPlayerTypeByName("Joseph", false) -- Exactly as in the xml. The second argument is if you want the Tainted variant.
local chargebarPos = Vector(-30, -52)


local cardDisplayPosPerPlayer = {
    --Vector(394, 147),
    Vector(150, 14), --player 1 top left
    Vector(332, 50), --player 2 top right
    Vector(30, 250), --player 3 bottom left
    Vector(326, 250), --player 4 bottom right but slightly less
}
local birthrightCardDisplayPosPerPlayer = {
    Vector(180, 14), --player 1 top left
    Vector(332, 50), --player 2 top right
    Vector(30, 250), --player 3 bottom left
    Vector(326, 250), --player 4 bottom right but slightly less
}
local playerAnchor = {
    "topleft",
    "topright",
    "bottomleft",
    "bottomright",
}

local f = Font() -- init font object
f:Load("font/terminus.fnt")


--Give random card on player init
function JosephChar:onPlayerInit(player)
    if player:GetPlayerType() ~= josephType then return end

    local rng = RNG()
    rng:SetSeed(player.InitSeed, RECOMMENDED_SHIFT_IDX)

    local randomCard = rng:RandomInt(NUMBER_TAROT_CARDS) + 1
    player:AddCard(randomCard)

    utility:SetPlayerSave(player, "playerRNG", rng)
end
JosephMod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, JosephChar.onPlayerInit)



--Make sure Joseph always has starter deck
JosephMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)

    if player:GetPlayerType() == josephType then
        if not player:HasCollectible(CollectibleType.COLLECTIBLE_STARTER_DECK) then
           player:AddInnateCollectible(CollectibleType.COLLECTIBLE_STARTER_DECK)
           local config = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_STARTER_DECK)
           player:RemoveCostume(config)
        end
    end
    
end)


--Modify starting stats
function JosephChar:HandleStartingStats(player, flag)
    if player:GetPlayerType() ~= josephType then return end

    if flag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage * 0.85
    end

    if flag == CacheFlag.CACHE_FIREDELAY then
        utility:addTearMultiplier(player, 1.1)
    end

    if flag == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = player.MoveSpeed - 0.1
    end
end
JosephMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, JosephChar.HandleStartingStats)


function JosephChar:showChargeBar(player)
    if player == nil then return end
    if player:GetPlayerType() ~= josephType then return end
    local playerIndex = TSIL.Players.GetPlayerIndex(player)
    
    --if not playerData then return end
    --show chargebar if held for more than 10 frames
    if StartedUsingCard[playerIndex] == true and FramesHeld[playerIndex] > 10 then
        if not CardChargeBar[playerIndex] then
            CardChargeBar[playerIndex] = Sprite()
            CardChargeBar[playerIndex]:Load("gfx/ui/card_chargebar.anm2",true)
        end
        JosephChar:ChargeBarRender(FramesHeld[playerIndex],true,Isaac.WorldToScreen(player.Position+chargebarPos),CardChargeBar[playerIndex])
    end

    if EarlyCancel[playerIndex] and EarlyCancel[playerIndex] >= 1 then
        EarlyCancel[playerIndex] = EarlyCancel[playerIndex] + 1
        if not CardChargeBar[playerIndex] then
            CardChargeBar[playerIndex] = Sprite()
            CardChargeBar[playerIndex]:Load("gfx/ui/card_chargebar.anm2",true)
        end
        JosephChar:ChargeBarRender(0,false,Isaac.WorldToScreen(player.Position+chargebarPos),CardChargeBar[playerIndex])
        if EarlyCancel[playerIndex] > 9 then EarlyCancel[playerIndex] = 0 end
    end

end
JosephMod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, JosephChar.showChargeBar, 0)


function JosephChar:trackFramesHeld(player)
    if player == nil then return end
    if player:GetPlayerType() ~= josephType then return end

    local playerIndex = TSIL.Players.GetPlayerIndex(player)

    --if not playerData then return end
    if not (StartedUsingCard[playerIndex] == true) then return end


    --if card isnt in main slot anymore then cancel
    if player:GetCard(0) ~= Card[playerIndex] then
        StartedUsingCard[playerIndex] = false
        FramesHeld[playerIndex] = 0
        Card[playerIndex] = nil
        return
    end

    if Input.IsActionPressed(ButtonAction.ACTION_PILLCARD, player.ControllerIndex) then
        if FramesHeld[playerIndex] == nil then FramesHeld[playerIndex] = 0 end
        FramesHeld[playerIndex] = FramesHeld[playerIndex] + 1

    else
        StartedUsingCard[playerIndex] = false
    end
    
    --use the card if player presses for less than 15 frames
    if StartedUsingCard[playerIndex] == false and FramesHeld[playerIndex] < 20 then
        FramesHeld[playerIndex] = 0
        ManualUse[playerIndex] = true
        if player:HasCollectible(CollectibleType.COLLECTIBLE_TAROT_CLOTH) then
            player:UseCard(Card[playerIndex])
            player:UseCard(Card[playerIndex], UseFlag.USE_CARBATTERY)
        else
            player:UseCard(Card[playerIndex])
        end

        ManualUse[playerIndex] = false
        JosephChar:RemoveCard(player, Card[playerIndex])
        Card[playerIndex] = nil
    end

    --play chargebar disappear animation if let go early
    if FramesHeld[playerIndex] > 10 and StartedUsingCard[playerIndex] == false then
        EarlyCancel[playerIndex] = 1
        FramesHeld[playerIndex] = 0
        ManualUse[playerIndex] = false
        Card[playerIndex] = nil
    end

    --give enchantment if held longer than 100 frames
    if FramesHeld[playerIndex] > 100 then
        player:AnimateCard(Card[playerIndex])
        JosephChar:RemoveCard(player, Card[playerIndex])
        SFXManager():Play(SoundEffect.SOUND_POWERUP1, 1)
        
        local oldCard = utility:GetEnchantedCardInPlayerSlot(player, enums.CardSlot.JOSEPH_INNATE)
        local newCard = Card[playerIndex]
        utility:SetEnchantedCardInPlayerSlot(player, enums.CardSlot.JOSEPH_INNATE, newCard)
        if oldCard and oldCard ~= 0 then
            JosephMod.BaseCardEffects:RemoveCardEffect(player, oldCard)
        end
        JosephMod.BaseCardEffects:InitCardEffect(player, newCard)
        StartedUsingCard[playerIndex] = false
        FramesHeld[playerIndex] = 0
        ManualUse[playerIndex] = false
        Card[playerIndex] = nil
    end

end
JosephMod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, JosephChar.trackFramesHeld, 0)


function JosephChar:onCardUse(card, player, useflags)
    if player == nil then return end
    local playerType = player:GetPlayerType()
    if not (playerType == josephType) then return end

    local fakeCardUseFlags = UseFlag.USE_NOANIM | UseFlag.USE_MIMIC | UseFlag.USE_NOHUD

    if useflags & fakeCardUseFlags > 0 then return end
    if enums.CardAnims[card] == nil then return end --Just use non tarot cards normally

    local playerIndex = TSIL.Players.GetPlayerIndex(player)
    --if not playerData then return end
    if ManualUse[playerIndex] ~= true then
        FramesHeld[playerIndex] = 0
        StartedUsingCard[playerIndex] = true
        Card[playerIndex] = card
        EarlyCancel[playerIndex] = 0
        player:AddCard(card)
        return true
    end
end
JosephMod:AddPriorityCallback(ModCallbacks.MC_PRE_USE_CARD, CallbackPriority.IMPORTANT, JosephChar.onCardUse)



function JosephChar:pickupBirthright(CollectibleType, Charge, FirstTime, Slot, VarData, player)
    if not player:GetPlayerType() ==  josephType or not FirstTime then return end
    local oldCard = utility:GetEnchantedCardInPlayerSlot(player, enums.CardSlot.JOSEPH_INNATE)

    if oldCard then
        utility:SetEnchantedCardInPlayerSlot(player, enums.CardSlot.JOSEPH_INNATE, 0)
        JosephMod.BaseCardEffects:RemoveCardEffect(player, oldCard)

        utility:SetEnchantedCardInPlayerSlot(player, enums.CardSlot.JOSEPH_BIRTHRIGHT, oldCard)
        JosephMod.BaseCardEffects:InitCardEffect(player, oldCard)
    end
end
JosephMod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, JosephChar.pickupBirthright, 619)



function JosephChar:showEnchantment(player, i)

    if player == nil then return end
    if player:GetPlayerType() ~= josephType then return end
    local enchantedCards =  utility:GetEnchantedCardsPerPlayer(player)


    local enchantedCard = enchantedCards[enums.CardSlot.JOSEPH_INNATE]
    if enchantedCard and enchantedCard ~= 0 then
        local enchantmentDisplay = Sprite()

        if i == 0 then
            enchantmentDisplay:Load("gfx/ui/enchanted_card_displays.anm2",true)
            enchantmentDisplay:SetFrame("CardFronts", enchantedCard)
        else
            enchantmentDisplay:Load("gfx/ui/ui_cardspills.anm2",true)
            if enchantedCard < 23 then
                enchantmentDisplay:SetFrame("CardFronts", enchantedCard)
            else
                enchantmentDisplay:SetFrame("CardFronts", enchantedCard)
            end
        end

        enchantmentDisplay:LoadGraphics()
        local displayPos = Vector(JosephMod.utility:HUDOffset(cardDisplayPosPerPlayer[i+1].X, cardDisplayPosPerPlayer[i+1].Y, playerAnchor[i+1]))
        enchantmentDisplay:Render(displayPos)
    end

    local birthrightCard = enchantedCards[enums.CardSlot.JOSEPH_BIRTHRIGHT]
    if birthrightCard and birthrightCard ~= 0 then
        local birthrightDisplay = Sprite()
        if i == 0 then
            birthrightDisplay:Load("gfx/ui/enchanted_card_displays.anm2",true)
            birthrightDisplay:SetFrame("CardFronts", birthrightCard)
        else
            birthrightDisplay:Load("gfx/ui/ui_cardspills.anm2",true)
            if birthrightCard < 23 then
                birthrightDisplay:SetFrame("CardFronts", birthrightCard)
            else
                birthrightDisplay:SetFrame("CardFronts", birthrightCard)
            end
        end

        birthrightDisplay:LoadGraphics()
        local displayPos = Vector(JosephMod.utility:HUDOffset(birthrightCardDisplayPosPerPlayer[i+1].X, birthrightCardDisplayPosPerPlayer[i+1].Y, playerAnchor[i+1]))
        birthrightDisplay:Render(displayPos)
    end
end


function JosephChar:OnHUDRender()
    for i = 0, Game():GetNumPlayers()-1 do
        local player = Game():GetPlayer(i)
        JosephChar:showEnchantment(player, i)
    end
  end
JosephMod:AddCallback(ModCallbacks.MC_POST_HUD_RENDER, JosephChar.OnHUDRender)



function JosephChar:ChargeBarRender(Meter,IsCharging,pos,Sprite) --Function credit: Ginger
    if not Game():GetHUD ():IsVisible () then return end
    if Meter == nil then Meter = 0 end
    local charge_percentage = Meter
    local render_pos = pos
        if IsCharging == true then
            if charge_percentage < 99 then
                Sprite:SetFrame("Charging", math.floor(charge_percentage))
            elseif Sprite:IsFinished("Charged") or Sprite:IsFinished("StartCharged") then
                if not Sprite:IsPlaying("Charged") then
                    Sprite:Play("Charged", true)
                end
            elseif not Sprite:IsPlaying("Charged") then
                if not Sprite:IsPlaying("StartCharged") then
                    Sprite:Play("Charged", true)
                end
            end
        elseif not Sprite:IsPlaying("Disappear") and not Sprite:IsFinished("Disappear") then
            Sprite:Play("Disappear", true)
        end
    Sprite:Render(render_pos,Vector.Zero, Vector.Zero)
    Sprite:Update()
end



function JosephChar:OnHit(entity, amount, flags, source, countDown)

    local player = entity:ToPlayer()
    if player:GetPlayerType() ~= josephType then return end
    local fakeDamageFlags = DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_RED_HEARTS | DamageFlag.DAMAGE_FAKE
    if flags & fakeDamageFlags > 0 then return end

    local enchantedCard = utility:GetEnchantedCardInPlayerSlot(player, enums.CardSlot.JOSEPH_INNATE)
    if enchantedCard == nil or enchantedCard == 0 then return end

    local rng = utility:GetPlayerSave(player, "playerRNG")
    if not rng then rng = JosephChar:CreateRNG(player) end

    local randomFloat = rng:RandomFloat()
    if randomFloat < enums.CardDisenchantChances[enchantedCard] then
        local oldCard = enchantedCard
        utility:SetEnchantedCardInPlayerSlot(player, enums.CardSlot.JOSEPH_INNATE, 0)
        JosephMod.BaseCardEffects:RemoveCardEffect(player, oldCard)
        SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN)
        JosephChar:PlayDisenchantAnimation(player, oldCard)
    end
    utility:SetPlayerSave(player, "PlayerRNG", rng)

end
JosephMod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, JosephChar.OnHit, EntityType.ENTITY_PLAYER)



function JosephChar:PlayDisenchantAnimation(player, card)
    local disenchantEffectVariant = Isaac.GetEntityVariantByName("Disenchant Effect")

    local entity = Isaac.Spawn(1000, disenchantEffectVariant, 0, player.Position, 4*RandomVector(), player)

    local sprite = entity:GetSprite()

    sprite:ReplaceSpritesheet(0, "gfx/effects/" .. enums.CardAnims[card] .. ".png")
    sprite:LoadGraphics()
end


function JosephChar:DisenchantAnimationInit(entity)
    entity:GetSprite():Play("Appear", true)
end
JosephMod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, JosephChar.DisenchantAnimationInit, DISENCHANT_ENTITY_ID)


function JosephChar:DisenchantAnimationUpdate(entity)
    local sprite = entity:GetSprite()
    if sprite:IsFinished("Appear") then
        Isaac.Spawn(1000, 15, 0, entity.Position, Vector(0, 0), entity)
        entity:Remove()
    end
end
JosephMod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, JosephChar.DisenchantAnimationUpdate, DISENCHANT_ENTITY_ID)


function JosephChar:CreateRNG(player)
    local rng = RNG()
    rng:SetSeed(player.InitSeed, RECOMMENDED_SHIFT_IDX)
    utility:SetPlayerSave(player, "playerRNG", rng)
    return utility:GetPlayerSave(player, "playerRNG")
end


function JosephChar:RemoveCard(player, card)
    if player:GetCard(0) == card then
        local secondaryCard = player:GetCard(1)
        if secondaryCard ~= nil then
            player:SetCard(0, secondaryCard)
            player:SetCard(1, 0)

        else
            player:SetCard(0, 0)
        end
    end
end


function JosephChar:UseDeckOfCards(CollectibleType, RNG, player, UseFlags, ActiveSlot)
    if player:GetPlayerType() ~= josephType then return end

    local randomCard = RNG:RandomInt(22) + 1
    player:AnimateCard(randomCard, "UseItem")
    player:AddCard(randomCard)

    return true
end
JosephMod:AddPriorityCallback(ModCallbacks.MC_PRE_USE_ITEM, CallbackPriority.LATE, JosephChar.UseDeckOfCards, CollectibleType.COLLECTIBLE_DECK_OF_CARDS)
