local JosephChar = {}

local itemManager = JosephMod.HiddenItemManager
local utility = JosephMod.utility

local NUMBER_TAROT_CARDS = 22
local RECOMMENDED_SHIFT_IDX = 35
local DAMAGE_REDUCTION = 0.6
local josephType = Isaac.GetPlayerTypeByName("Joseph", false) -- Exactly as in the xml. The second argument is if you want the Tainted variant.
local hairCostume = Isaac.GetCostumeIdByPath("gfx/characters/joseph_hair.anm2") -- Exact path, with the "resources" folder as the root
local stolesCostume = Isaac.GetCostumeIdByPath("gfx/characters/joseph_poncho.anm2") -- Exact path, with the "resources" folder as the root

local tarotCardAnims = {
    {Card.CARD_FOOL, "00_TheFool"},
    {Card.CARD_MAGICIAN, "01_TheMagician"},
    {Card.CARD_HIGH_PRIESTESS, "02_TheHighPriestess"},
    {Card.CARD_EMPRESS, "03_TheEmpress"},
    {Card.CARD_EMPEROR, "04_TheEmperor"},
    {Card.CARD_HIEROPHANT, "05_TheHierophant"},
    {Card.CARD_LOVERS, "06_TheLovers"},
    {Card.CARD_CHARIOT, "07_TheChariot"},
    {Card.CARD_JUSTICE, "08_TheJustice"},
    {Card.CARD_HERMIT, "09_TheHermit"},
    {Card.CARD_WHEEL_OF_FORTUNE, "10_WheelOfFortune"},
    {Card.CARD_STRENGTH, "11_Strength"},
    {Card.CARD_HANGED_MAN, "12_TheHangedMan"},
    {Card.CARD_DEATH, "13_Death"},
    {Card.CARD_TEMPERANCE, "14_Temperance"},
    {Card.CARD_DEVIL, "15_TheDevil"},
    {Card.CARD_TOWER, "16_TheTower"},
    {Card.CARD_STARS, "17_TheStars"},
    {Card.CARD_MOON, "18_TheMoon"},
    {Card.CARD_SUN, "19_TheSun"},
    {Card.CARD_JUDGEMENT, "20_Judgement"},
    {Card.CARD_WORLD, "21_TheWorld"}
}

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

function JosephChar:onPlayerInit(player)
    if player:GetPlayerType() ~= josephType then return end


    JosephMod.Schedule(1, function ()
        local config = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_STARTER_DECK)
        player:RemoveCostume(config)
    end,{})

    local startSeed = Game():GetSeeds():GetStartSeed()
    local rng = RNG()
    rng:SetSeed(startSeed, RECOMMENDED_SHIFT_IDX)
    
    local randomCard = rng:RandomInt(NUMBER_TAROT_CARDS) + 1
    player:AddCard(randomCard)
end
JosephMod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, JosephChar.onPlayerInit)


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


JosephMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)

    if player:GetPlayerType() == josephType then
        itemManager:CheckStack(player, CollectibleType.COLLECTIBLE_STARTER_DECK, 1, JOSEPH)
    else
        itemManager:CheckStack(player, CollectibleType.COLLECTIBLE_STARTER_DECK, 0, JOSEPH)
    end
end)


function JosephChar:HandleStartingStats(player, flag)
    if player:GetPlayerType() ~= josephType then return end

    if flag == CacheFlag.CACHE_DAMAGE then
        local damageModifier = DAMAGE_REDUCTION
        if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
            damageModifier = damageModifier*0.2
        end
        player.Damage = player.Damage - damageModifier
    end
end
JosephMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, JosephChar.HandleStartingStats)


function JosephChar:showChargeBar(player)
    if player == nil then return end
    if player:GetPlayerType() ~= josephType then return end

    local playerData = JosephMod.saveManager.GetRunSave(player)
    if not (playerData and playerData.usingCard == true) then return end
    playerData.usingCard = false

    --if card isnt in main slot anymore then cancel
    if player:GetCard(0) ~= playerData.card then
        playerData.usingCard = false
        playerData.framesHeld = 0
        playerData.card = nil
        return
    end

    if Input.IsActionPressed(ButtonAction.ACTION_PILLCARD, player.ControllerIndex) then
        playerData.usingCard = true
        if playerData.framesHeld == nil then playerData.framesHeld = 0 end
        playerData.framesHeld = playerData.framesHeld + 1
        --f:DrawString(tostring(playerData.framesHeld),60,50,KColor(1,1,1,1),0,true)
        --print(playerData.framesHeld)
    end
    
    --use the card if player presses for less than 15 frames
    if playerData.usingCard == false and playerData.framesHeld < 20 then
        playerData.usingCard = false
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

    --show chargebar if held for more than 10 frames
    if playerData.usingCard == true and playerData.framesHeld > 10 then
        if not playerData.cardChargeBar then
            playerData.cardChargeBar = Sprite()
            playerData.cardChargeBar:Load("gfx/ui/card_chargebar.anm2",true)
        end
        local chargePos = Vector(-30, -70)
        JosephChar:ChargeBarRender(playerData.framesHeld,true,Isaac.WorldToScreen(player.Position+chargePos),playerData.cardChargeBar)

    else

    --play chargebar disappear animation if let go early
    if playerData.usingCard == false and playerData.framesHeld > 10 then
        if not playerData.cardChargeBar then
            playerData.cardChargeBar = Sprite()
            playerData.cardChargeBar:Load("gfx/ui/card_chargebar.anm2",true)
        end
        local chargePos = Vector(-30, -70)
        JosephChar:ChargeBarRender(0,false,Isaac.WorldToScreen(player.Position+chargePos),playerData.cardChargeBar)
        playerData.framesHeld = 0
        playerData.manualUse = false
        playerData.card = nil
    end end

    --give enchantment if held longer than 100 frames
    if playerData.framesHeld > 100 then
        player:AnimateCard(playerData.card)
        JosephChar:RemoveCard(player, playerData.card)
        SFXManager():Play(SoundEffect.SOUND_POWERUP1, 1)
        playerData.EnchantedCard = playerData.card
        JosephMod.cardEffects:InitCardEffect(player, playerData.card)
        playerData.usingCard = false
        playerData.framesHeld = 0
        playerData.manualUse = false
        playerData.card = nil
        JosephMod.saveManager.Save()
    end
end
JosephMod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, JosephChar.showChargeBar, 0)


function JosephChar:onCardUse(card, player, useflags)
    if player == nil then return end
    local playerType = player:GetPlayerType()
    if not (playerType == josephType) then return end

    local fakeCardUseFlags = UseFlag.USE_NOANIM | UseFlag.USE_MIMIC | UseFlag.USE_NOHUD

    if useflags & fakeCardUseFlags > 0 then return end
    if card > 22 then return end --Just use non tarot cards normally

    local playerData = JosephMod.saveManager.GetRunSave(player)
    if not playerData then return end
    if playerData.manualUse ~= true then
        playerData.framesHeld = 0
        playerData.usingCard = true
        playerData.card = card
        player:AddCard(card)
        return true
    end
end
JosephMod:AddCallback(ModCallbacks.MC_PRE_USE_CARD, JosephChar.onCardUse)



function JosephChar:showEnchantment()
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:GetPlayerType() == josephType then

            local playerData = JosephMod.saveManager.GetRunSave(player)
            if (playerData and playerData.EnchantedCard) then
        
                local enchantmentDisplay = Sprite()
                if i == 0 then
                    enchantmentDisplay:Load("gfx/ui/enchanted_card_displays.anm2",true)
                    --enchantmentDisplay:Load("gfx/ui/ui_cardfronts.anm2",true)
                else
                    enchantmentDisplay:Load("gfx/ui/ui_cardfronts.anm2",true)
                end
                enchantmentDisplay:SetFrame(tarotCardAnims[playerData.EnchantedCard][2], 0)
                enchantmentDisplay:LoadGraphics()
                --if i ~= 0 then enchantmentDisplay.Scale = Vector(0.75, 0.75) end
                local displayPos = Vector(JosephMod.utility:HUDOffset(cardDisplayPosPerPlayer[i+1].X, cardDisplayPosPerPlayer[i+1].Y, playerAnchor[i+1]))
                enchantmentDisplay:Render(displayPos)
            end
        end
    end
end

function JosephChar:OnHUDRender()
    for i = 0, Game():GetNumPlayers()-1 do
        local player = Game():GetPlayer(i)
        JosephChar.showEnchantment(player)
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