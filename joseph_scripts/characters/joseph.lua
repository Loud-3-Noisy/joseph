local JosephChar = {}

local NUMBER_TAROT_CARDS = 22
local RECOMMENDED_SHIFT_IDX = 35
local DAMAGE_REDUCTION = 0.6

local josephType = Isaac.GetPlayerTypeByName("Joseph", false) -- Exactly as in the xml. The second argument is if you want the Tainted variant.
local hairCostume = Isaac.GetCostumeIdByPath("gfx/characters/joseph_hair.anm2") -- Exact path, with the "resources" folder as the root
local stolesCostume = Isaac.GetCostumeIdByPath("gfx/characters/joseph_poncho.anm2") -- Exact path, with the "resources" folder as the root


local f = Font() -- init font object
f:Load("font/terminus.fnt")

function JosephChar:GiveCostumesOnInit(player)
    if player:GetPlayerType() ~= josephType then return end

    player:AddInnateCollectible(CollectibleType.COLLECTIBLE_STARTER_DECK, 1)
    local config = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_STARTER_DECK)
    player:RemoveCostume(config)

    -- player:AddNullCostume(hairCostume)
    -- player:AddNullCostume(stolesCostume)

    local startSeed = Game():GetSeeds():GetStartSeed()
    local rng = RNG()
    rng:SetSeed(startSeed, RECOMMENDED_SHIFT_IDX)
    
    local randomCard = rng:RandomInt(NUMBER_TAROT_CARDS) + 1
    player:AddCard(randomCard)
end

JosephMod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, JosephChar.GiveCostumesOnInit)



function JosephChar:HandleStartingStats(player, flag)
    if player:GetPlayerType() ~= josephType then return end

    if flag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage - DAMAGE_REDUCTION
    end
end

JosephMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, JosephChar.HandleStartingStats)


function JosephChar:InputAction(player)
    if player == nil then return end
    if player:GetPlayerType() ~= josephType then return end

    local playerData = JosephMod.saveManager.GetRunSave(player)
    if not (playerData and playerData.usingCard == true) then return end
    playerData.usingCard = false

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
    
    if playerData.usingCard == false and playerData.framesHeld < 15 then --use the card if player presses for less than 15 frames
        playerData.usingCard = false
        playerData.framesHeld = 0
        playerData.manualUse = true
        player:UseCard(playerData.card)
        playerData.manualUse = false
        JosephChar:RemoveCard(player, playerData.card)
        playerData.card = nil
    end
    if playerData.usingCard == true and playerData.framesHeld > 10 then
        if not playerData.cardChargeBar then
            playerData.cardChargeBar = Sprite()
            playerData.cardChargeBar:Load("gfx/ui/card_chargebar.anm2",true)
        end
        local chargePos = Vector(-30, -70)
        JosephChar:ChargeBarRender(playerData.framesHeld,true,Isaac.WorldToScreen(player.Position+chargePos),playerData.cardChargeBar)

    else
    if playerData.usingCard == false and playerData.framesHeld > 10 then
        if not playerData.cardChargeBar then
            playerData.cardChargeBar = Sprite()
            playerData.cardChargeBar:Load("gfx/ui/card_chargebar.anm2",true)
        end
        local chargePos = Vector(-30, -70)
        JosephChar:ChargeBarRender(0,false,Isaac.WorldToScreen(player.Position+chargePos),playerData.cardChargeBar)
        print("peanut")
        playerData.framesHeld = 0
        playerData.manualUse = false
        playerData.card = nil
    end end


    if playerData.framesHeld > 100 then
        player:AnimateCard(playerData.card)
        JosephChar:RemoveCard(player, playerData.card)
        SFXManager():Play(SoundEffect.SOUND_POWERUP1, 1)
        playerData.usingCard = false
        playerData.framesHeld = 0
        playerData.manualUse = false
        playerData.card = nil
    end
end
JosephMod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, JosephChar.InputAction, 0)


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


function JosephChar:getAllJosephs(character)
    local josephs = {}
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        
        if player:GetPlayerType() == josephType then
            table.insert(josephs, player)
        end
    end
    return josephs
end

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