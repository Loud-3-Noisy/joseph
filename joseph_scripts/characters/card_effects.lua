local CardEffects = {}
local utility = JosephMod.utility
local enums = JosephMod.enums


local RED_HEART_REPLACE_CHANCE = 0.25
local SOUL_HEART_REPLACE_CHANCE = 0.143 -- 1/7
local JUSTICE_DROP_REPLACE_CHANCE = 0.20 

function CardEffects:addCardStats(player, flag)
    local enchantedCard = utility:GetPlayerSave(player, "EnchantedCard")

    if enchantedCard == Card.CARD_EMPRESS and flag == CacheFlag.CACHE_DAMAGE then
        utility:AddDamage(player, -0.5)
    end

    if enchantedCard == Card.CARD_STRENGTH and flag == CacheFlag.CACHE_DAMAGE and
    (player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM)
    + player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM) < 1) then
        player.Damage = player.Damage * 0.83
    end

    if enchantedCard == Card.CARD_DEVIL and flag == CacheFlag.CACHE_DAMAGE then
        utility:AddDamage(player, -0.5)
    end

end
JosephMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, CardEffects.addCardStats)


function CardEffects:InitCardEffect(player, card)

    if card == Card.CARD_EMPEROR then
        player:AddInnateCollectible(CollectibleType.COLLECTIBLE_THERES_OPTIONS)
    end

    if card == Card.CARD_STARS then
        player:AddInnateCollectible(CollectibleType.COLLECTIBLE_MORE_OPTIONS)
    end

    if card == Card.CARD_HERMIT then
        player:AddInnateCollectible(CollectibleType.COLLECTIBLE_MEMBER_CARD)
    end

    if card == Card.CARD_MOON then
        player:AddInnateCollectible(CollectibleType.COLLECTIBLE_LUNA)
    end

    if card == Card.CARD_MAGICIAN then
        player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_SPOON_BENDER, true)
    end

    if card == Card.CARD_EMPRESS then
        player:UseCard(Card.CARD_EMPRESS, UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD)
    end

    if card == Card.CARD_CHARIOT then
        player:AddInnateCollectible(CollectibleType.COLLECTIBLE_TAURUS)
    end

    if card == Card.CARD_WHEEL_OF_FORTUNE then

        player:AddInnateCollectible(enums.Collectibles.LIL_SLOT_MACHINE, -1)
        player:AddInnateCollectible(enums.Collectibles.LIL_FORTUNE_TELLER, -1)

        JosephMod.Schedule(3, function ()
            local rng = player:GetCardRNG(Card.CARD_WHEEL_OF_FORTUNE)
            local rand = rng:RandomInt(2) + 1
            if rand == 1 then
                player:AddInnateCollectible(enums.Collectibles.LIL_SLOT_MACHINE)
            else
                player:AddInnateCollectible(enums.Collectibles.LIL_SLOT_MACHINE)
            end
        end,{})
    end

    if card == Card.CARD_STRENGTH then
        player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM, true)
    end

    if card == Card.CARD_HANGED_MAN then
        player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_TRANSCENDENCE, true)
    end

    if card == Card.CARD_DEATH then
        player:AddInnateCollectible(CollectibleType.COLLECTIBLE_DRY_BABY)
    end

    if card == Card.CARD_TEMPERANCE then
        player:AddInnateCollectible(enums.Collectibles.LIL_BLOOD_BANK, -1)

        JosephMod.Schedule(3, function ()
            player:AddInnateCollectible(enums.Collectibles.LIL_BLOOD_BANK)
        end,{})
    end

    if card == Card.CARD_DEVIL then
        player:UseActiveItem(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL, false)
    end

    if card == Card.CARD_TOWER then
        player:AddInnateCollectible(CollectibleType.COLLECTIBLE_CURSE_OF_THE_TOWER)
    end

    if card == Card.CARD_WORLD then
        Game():GetLevel():ShowMap()
    end

    if card == Card.CARD_JUDGEMENT then
        local rng = player:GetCardRNG(Card.CARD_JUDGEMENT)
        local rand = rng:RandomInt(2) + 1
        if rand == 1 then
            player:AddInnateCollectible(CollectibleType.COLLECTIBLE_BUM_FRIEND)
        else
            player:AddInnateCollectible(CollectibleType.COLLECTIBLE_DARK_BUM)
        end
    end

    if card == Card.CARD_SUN then
        player:AddInnateCollectible(CollectibleType.COLLECTIBLE_SOL)
    end
end


--Runs when removing an enchantment before applying a new one
function CardEffects:RemoveCardEffect(player, card)


    local switch = {
        [Card.CARD_FOOL] = function()
             -- Code for CARD_FOOL
        end,
        [Card.CARD_MAGICIAN] = function()
            -- Code for CARD_MAGICIAN
            player:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_SPOON_BENDER)
        end,
        [Card.CARD_HIGH_PRIESTESS] = function()
            -- Code for CARD_HIGH_PRIESTESS
        end,
        [Card.CARD_EMPRESS] = function()
            -- Code for CARD_EMPRESS
            player:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_WHORE_OF_BABYLON)
        end,
        [Card.CARD_EMPEROR] = function()
            -- Code for CARD_EMPEROR
            player:AddInnateCollectible(CollectibleType.COLLECTIBLE_THERES_OPTIONS, -1)
        end,
        [Card.CARD_HIEROPHANT] = function()
            -- Code for CARD_HIEROPHANT
        end,
        [Card.CARD_LOVERS] = function()
            -- Code for CARD_LOVERS
        end,
        [Card.CARD_CHARIOT] = function()
            -- Code for CARD_CHARIOT
            player:AddInnateCollectible(CollectibleType.COLLECTIBLE_TAURUS, -1)
        end,
        [Card.CARD_JUSTICE] = function()
            -- Code for CARD_JUSTICE
        end,
        [Card.CARD_HERMIT] = function()
            -- Code for CARD_HERMIT
            player:AddInnateCollectible(CollectibleType.COLLECTIBLE_MEMBER_CARD, -1)
            JosephMod.Schedule(1, function ()
                CardEffects:RemoveShopTrapdoor()
            end,{})

        end,
        [Card.CARD_WHEEL_OF_FORTUNE] = function()
            -- Code for CARD_WHEEL_OF_FORTUNE
            player:AddInnateCollectible(enums.Collectibles.LIL_SLOT_MACHINE)
            player:AddInnateCollectible(enums.Collectibles.LIL_FORTUNE_TELLER)
        end,
        [Card.CARD_STRENGTH] = function()
            -- Code for CARD_STRENGTH
            player:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM)
        end,
        [Card.CARD_HANGED_MAN] = function()
            -- Code for CARD_HANGED_MAN
            player:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_TRANSCENDENCE)
        end,
        [Card.CARD_DEATH] = function()
            -- Code for CARD_DEATH
            player:AddInnateCollectible(CollectibleType.COLLECTIBLE_DRY_BABY, -1)
        end,
        [Card.CARD_TEMPERANCE] = function()
            -- Code for CARD_TEMPERANCE
            player:AddInnateCollectible(enums.Collectibles.LIL_BLOOD_BANK, -1)
        end,
        [Card.CARD_DEVIL] = function()
            -- Code for CARD_DEVIL
            player:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL)
        end,
        [Card.CARD_TOWER] = function()
            -- Code for CARD_TOWER
            player:AddInnateCollectible(CollectibleType.COLLECTIBLE_CURSE_OF_THE_TOWER, -1)
        end,
        [Card.CARD_STARS] = function()
            -- Code for CARD_STAR
            player:AddInnateCollectible(CollectibleType.COLLECTIBLE_MORE_OPTIONS, -1)
        end,
        [Card.CARD_MOON] = function()
            -- Code for CARD_MOON
            player:AddInnateCollectible(CollectibleType.COLLECTIBLE_LUNA, -1)
        end,
        [Card.CARD_SUN] = function()
            -- Code for CARD_SUN
            player:AddInnateCollectible(CollectibleType.COLLECTIBLE_SOL, -1)
        end,
        [Card.CARD_JUDGEMENT] = function()
            -- Code for CARD_JUDGEMENT
            player:AddInnateCollectible(CollectibleType.COLLECTIBLE_BUM_FRIEND, -1)
            player:AddInnateCollectible(CollectibleType.COLLECTIBLE_DARK_BUM, -1)
        end,
        [Card.CARD_WORLD] = function()
            -- Code for CARD_WORLD
        end,
        
        ["default"] = function()
            -- Code for default case
        end
    }
   
   if switch[card] then
      switch[card]()
   else
      switch["default"]()
   end
end

local hasFoolPortal = false

function CardEffects:addRoomEffect()

    local room = Game():GetRoom()
    local centerPos = room:IsLShapedRoom() and Vector(853, 270) or room:GetCenterPos()
    local offset = 40

    CardEffects:RemoveShopTrapdoor()

    hasFoolPortal = false

    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local enchantedCard = utility:GetPlayerSave(player, "EnchantedCard")


        if enchantedCard == Card.CARD_MAGICIAN then
            player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_SPOON_BENDER, true)
        end

        if enchantedCard == Card.CARD_HIGH_PRIESTESS and (room:IsFirstVisit() or not room:IsClear()) then
            local rng = player:GetCardRNG(Card.CARD_HIGH_PRIESTESS)
            if rng:RandomFloat() > 0.5 or (room:IsFirstVisit() and room:IsClear()) then
                player:UseCard(Card.CARD_HIGH_PRIESTESS, UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD | UseFlag.USE_NOANIM)
            end
        end

        if enchantedCard == Card.CARD_EMPRESS then
            player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_WHORE_OF_BABYLON, true)
        end

        if enchantedCard == Card.CARD_STRENGTH then
            player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM, true)
        end

        if enchantedCard == Card.CARD_HANGED_MAN then
            player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_TRANSCENDENCE, true)
        end

        if enchantedCard == Card.CARD_DEVIL then
            player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL, true)
        end

        if room:IsClear() and room:IsFirstVisit() then
            if enchantedCard == Card.CARD_FOOL and hasFoolPortal == false then
                local pos = Isaac.GetFreeNearPosition(Vector((centerPos.X + offset), centerPos.Y + offset), 10)
                JosephMod.cardEffects:spawnPortal(pos, player, 3)
                hasFoolPortal = true
            end
        end
    end
end
JosephMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, CardEffects.addRoomEffect)
--JosephMod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, CardEffects.addRoomEffect)

function CardEffects:RoomClearEffect(rng, spawnPos)
    local room = Game():GetRoom()
    local roomType = room:GetType()
    local centerPos = room:IsLShapedRoom() and Vector(580, 420) or room:GetCenterPos()
    local portalsCount = 0
    local offset = 40
    local overrideClearReward = false

    hasFoolPortal = false

    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local enchantedCard = utility:GetPlayerSave(player, "EnchantedCard")
        if (enchantedCard and enchantedCard ~= 0) then

            if enchantedCard == Card.CARD_FOOL and hasFoolPortal == false then
                local pos = Isaac.GetFreeNearPosition(Vector((centerPos.X + offset), centerPos.Y + offset), 10)
                JosephMod.cardEffects:spawnPortal(pos, player, 3)
                hasFoolPortal = true
            end


            if roomType ~= RoomType.ROOM_BOSS then

                if enchantedCard == Card.CARD_LOVERS and rng:RandomFloat() <= RED_HEART_REPLACE_CHANCE then
                    SFXManager():Play(SoundEffect.SOUND_THUMBSUP)
                    local pos = room:FindFreePickupSpawnPosition(spawnPos)
                    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 1, pos, Vector(0, 0), nil)
                end

                if enchantedCard == Card.CARD_HIEROPHANT and rng:RandomFloat() <= SOUL_HEART_REPLACE_CHANCE then
                    SFXManager():Play(SoundEffect.SOUND_THUMBSUP)
                    local pos = room:FindFreePickupSpawnPosition(spawnPos)
                    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 3, pos, Vector(0, 0), nil)
                end

                if enchantedCard == Card.CARD_JUSTICE and rng:RandomFloat() <= JUSTICE_DROP_REPLACE_CHANCE then
                    SFXManager():Play(SoundEffect.SOUND_THUMBSUP)
                    for i=10, 40, 10 do
                        if rng:RandomFloat() <= 0.90 then
                            local pos = room:FindFreePickupSpawnPosition(spawnPos)
                            Isaac.Spawn(EntityType.ENTITY_PICKUP, i, 0, pos, Vector(0, 0), nil)
                        end
                    end
                end

                local level = Game():GetLevel()
                local roomDesc = level:GetRoomByIdx(level:GetCurrentRoomIndex())
                roomDesc.AwardSeed = rng:GetSeed()
            end
        end
    end
end
JosephMod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, CardEffects.RoomClearEffect)



function CardEffects.ApplyNewFloorEffect(curses)
    if not utility:AnyPlayerHasEnchantment(Card.CARD_WORLD) then return end
    Game():GetLevel():ShowMap()
end
JosephMod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, CardEffects.ApplyNewFloorEffect)


local function isDoor(pos)
	local gridEntity = Game():GetRoom():GetGridEntityFromPos(pos)
	if gridEntity then
		return gridEntity:GetType() == GridEntityType.GRID_DOOR
	end
	return false
end

function CardEffects:spawnPortal(pos, player, portalType)
    local marg = 40
    local existingPortals = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.PORTAL_TELEPORT)
    local canFly = player.CanFly
    local tempNPC, pathFinder
    local attempts = 0
    repeat
        if not canFly then
            tempNPC = Isaac.Spawn(EntityType.ENTITY_GAPER, 0, 0, pos, Vector.Zero, nil):ToNPC()
            tempNPC.Visible = false
            if tempNPC then pathFinder = tempNPC.Pathfinder end
        end
        local overlaps

        local scale = 40
        local X = pos.X
        local Y = pos.Y
        local Up = Vector(X, Y - scale)
	    local Down = Vector(X, Y + scale)
	    local Left = Vector(X - scale, Y)
	    local Right = Vector(X + scale, Y)
        if ((pathFinder and not pathFinder:HasPathToPos(player.Position, true)) or isDoor(Up) or isDoor(Down) or isDoor(Left) or isDoor(Right)) then
            overlaps = true
            marg = marg + 10
            pos = Isaac.GetFreeNearPosition(pos, marg)
        end
        if tempNPC then tempNPC:Remove() end
        attempts = attempts + 1 
    until not overlaps or attempts > 20
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PORTAL_TELEPORT, portalType, pos, Vector.Zero, player):ToEffect()
end

function CardEffects:RemoveShopTrapdoor()
    local room = Game():GetRoom()
    local roomType = room:GetType()
    if roomType ~= RoomType.ROOM_SHOP then return end
    if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_MEMBER_CARD) then return end
    if utility:AnyPlayerHasEnchantment(Card.CARD_HERMIT) then return end
    local shopCrawlSpaces = TSIL.GridSpecific.GetCrawlSpaces(TSIL.Enums.CrawlSpaceVariant.SECRET_SHOP)
    if (next(shopCrawlSpaces) ~= nil) then
        local shopDoor = shopCrawlSpaces[1]
        Isaac.Spawn(1000, 15, 0, shopDoor.Position, Vector(0, 0), nil)
        TSIL.GridEntities.RemoveGridEntity(shopDoor)
    end
end



return CardEffects