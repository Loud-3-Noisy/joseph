local JosephChar = {}

local itemManager = JosephMod.HiddenItemManager
local utility = JosephMod.utility
local enums = JosephMod.enums

local vars = {
    "playerRNG",
    "EnchantedCard",
}
utility:CreateEmptyPlayerSaveDataVars(vars)

local cardChargeBar = {}
local startedUsingCard = {}
local framesHeld = {}
local earlyCancel = {}
local card = {}
local manualUse = {}



-- local dataPerPlayer = TSIL.SaveManager.GetPersistentVariable(JosephMod, "graterStacks")
--   local playerIndex = TSIL.Players.GetPlayerIndex(player)
--   local data = dataPerPlayer[playerIndex] or 0 --You can change 0 to whatever the default should be for each player

--   --Do stuff with the data
--   data = data + 1

--   --Save the changed data
--   dataPerPlayer[playerIndex] = data

local NUMBER_TAROT_CARDS = 22
local RECOMMENDED_SHIFT_IDX = 35
local DISENCHANT_ENTITY_ID = Isaac.GetEntityVariantByName("Disenchant Effect")
local josephType = Isaac.GetPlayerTypeByName("Joseph", false) -- Exactly as in the xml. The second argument is if you want the Tainted variant.
local hairCostume = Isaac.GetCostumeIdByPath("gfx/characters/joseph_hair.anm2") -- Exact path, with the "resources" folder as the root
local stolesCostume = Isaac.GetCostumeIdByPath("gfx/characters/joseph_poncho.anm2") -- Exact path, with the "resources" folder as the root
local chargebarPos = Vector(-30, -52)


local cardDisplayPosPerPlayer = {
    --Vector(394, 147),
    Vector(60, 50), --player 1 top left
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

    JosephMod.Schedule(1, function ()
        local config = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_STARTER_DECK)
        player:RemoveCostume(config)
    end,{})

    local rng = RNG()
    rng:SetSeed(player.InitSeed, RECOMMENDED_SHIFT_IDX)

    local randomCard = rng:RandomInt(NUMBER_TAROT_CARDS) + 1
    player:AddCard(randomCard)

    utility:SetPlayerSave(player, "playerRNG", rng)
end
JosephMod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, JosephChar.onPlayerInit)


--Remove starter deck costume every room in case it reappears
function JosephChar:onNewRoom()
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:GetPlayerType() == josephType then
            local config = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_STARTER_DECK)
            player:RemoveCostume(config)
        end
    end
end
JosephMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, JosephChar.onNewRoom)


--Make sure Joseph always has starter deck
JosephMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)

    if player:GetPlayerType() == josephType then
        itemManager:CheckStack(player, CollectibleType.COLLECTIBLE_STARTER_DECK, 1, JOSEPH)
    else
        itemManager:CheckStack(player, CollectibleType.COLLECTIBLE_STARTER_DECK, 0, JOSEPH)
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

    local playerData = JosephMod.saveManager.GetRunSave(player)
    if not (playerData) then return end

    --show chargebar if held for more than 10 frames
    if playerData.startedUsingCard == true and playerData.framesHeld > 10 then
        if not playerData.cardChargeBar then
            playerData.cardChargeBar = Sprite()
            playerData.cardChargeBar:Load("gfx/ui/card_chargebar.anm2",true)
        end
        JosephChar:ChargeBarRender(playerData.framesHeld,true,Isaac.WorldToScreen(player.Position+chargebarPos),playerData.cardChargeBar)
    end

    if playerData.earlyCancel and playerData.earlyCancel >= 1 then
        playerData.earlyCancel = playerData.earlyCancel + 1
        if not playerData.cardChargeBar then
            playerData.cardChargeBar = Sprite()
            playerData.cardChargeBar:Load("gfx/ui/card_chargebar.anm2",true)
        end
        JosephChar:ChargeBarRender(0,false,Isaac.WorldToScreen(player.Position+chargebarPos),playerData.cardChargeBar)
        if playerData.earlyCancel > 9 then playerData.earlyCancel = 0 end
    end

end
JosephMod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, JosephChar.showChargeBar, 0)


function JosephChar:trackFramesHeld(player)
    if player == nil then return end
    if player:GetPlayerType() ~= josephType then return end

    local playerData = JosephMod.saveManager.GetRunSave(player)
    if not (playerData and playerData.startedUsingCard == true) then return end


    --if card isnt in main slot anymore then cancel
    if player:GetCard(0) ~= playerData.card then
        playerData.startedUsingCard = false
        playerData.framesHeld = 0
        playerData.card = nil
        return
    end

    if Input.IsActionPressed(ButtonAction.ACTION_PILLCARD, player.ControllerIndex) then
        if playerData.framesHeld == nil then playerData.framesHeld = 0 end
        playerData.framesHeld = playerData.framesHeld + 1

    else
        playerData.startedUsingCard = false
    end
    
    --use the card if player presses for less than 15 frames
    if playerData.startedUsingCard == false and playerData.framesHeld < 20 then
        playerData.framesHeld = 0
        playerData.manualUse = true
        if player:HasCollectible(CollectibleType.COLLECTIBLE_TAROT_CLOTH) then
            player:UseCard(playerData.card)
            player:UseCard(playerData.card, UseFlag.USE_CARBATTERY)
        else
            player:UseCard(playerData.card)
        end

        playerData.manualUse = false
        JosephChar:RemoveCard(player, playerData.card)
        playerData.card = nil
    end

    --play chargebar disappear animation if let go early
    if playerData.framesHeld > 10 and playerData.startedUsingCard == false then
        playerData.earlyCancel = 1
        playerData.framesHeld = 0
        playerData.manualUse = false
        playerData.card = nil
    end

    --give enchantment if held longer than 100 frames
    if playerData.framesHeld > 100 then
        player:AnimateCard(playerData.card)
        JosephChar:RemoveCard(player, playerData.card)
        SFXManager():Play(SoundEffect.SOUND_POWERUP1, 1)
        
        local oldCard = utility:GetPlayerSave(player, "EnchantedCard")
        local newCard = playerData.card
        utility:SetPlayerSave(player, "EnchantedCard", newCard)
        JosephMod.cardEffects:RemoveCardEffect(player, oldCard)
        JosephMod.cardEffects:InitCardEffect(player, newCard)
        playerData.startedUsingCard = false
        playerData.framesHeld = 0
        playerData.manualUse = false
        playerData.card = nil
        JosephMod.saveManager.Save()
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

    local playerData = JosephMod.saveManager.GetRunSave(player)
    if not playerData then return end
    if playerData.manualUse ~= true then
        playerData.framesHeld = 0
        playerData.startedUsingCard = true
        playerData.card = card
        playerData.earlyCancel = 0
        player:AddCard(card)
        return true
    end
end
JosephMod:AddPriorityCallback(ModCallbacks.MC_PRE_USE_CARD, CallbackPriority.IMPORTANT, JosephChar.onCardUse)



function JosephChar:showEnchantment(player, i)

    if player == nil then return end
    if player:GetPlayerType() ~= josephType then return end

    local enchantedCard =  utility:GetPlayerSave(player, "EnchantedCard")
    if not enchantedCard or enchantedCard == 0 then return end
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

    local enchantedCard = utility:GetPlayerSave(player, "EnchantedCard")
    if enchantedCard == nil or enchantedCard == 0 then return end

    local rng = utility:GetPlayerSave(player, "playerRNG")
    if not rng then rng = JosephChar:CreateRNG(player) end

    local randomFloat = rng:RandomFloat()
    if randomFloat < 0.5 then
        local oldCard = enchantedCard
        utility:SetPlayerSave(player, "EnchantedCard", 0)
        JosephMod.cardEffects:RemoveCardEffect(player, oldCard)
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
