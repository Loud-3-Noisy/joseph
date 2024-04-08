local CardEffects = {}
local itemManager = JosephMod.HiddenItemManager
local utility = JosephMod.utility
local enums = JosephMod.enums
local saveManager = JosephMod.saveManager

local RED_HEART_REPLACE_CHANCE = 0.25
local SOUL_HEART_REPLACE_CHANCE = 0.143 -- 1/7
local JUSTICE_DROP_REPLACE_CHANCE = 0.20 

function CardEffects:addCardStats(player, flag)
    local playerData = JosephMod.saveManager.GetRunSave(player)
    if not (playerData and playerData.EnchantedCard) then return end

    if playerData.EnchantedCard == Card.CARD_EMPRESS and flag == CacheFlag.CACHE_DAMAGE then
        utility:AddDamage(player, -0.5)
    end

    if playerData.EnchantedCard == Card.CARD_STRENGTH and flag == CacheFlag.CACHE_DAMAGE and
    (player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM)
    + player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM) < 1) then
        player.Damage = player.Damage * 0.83
    end

    if playerData.EnchantedCard == Card.CARD_DEVIL and flag == CacheFlag.CACHE_DAMAGE then
        utility:AddDamage(player, -0.5)
    end

end
JosephMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, CardEffects.addCardStats)


function CardEffects:InitCardEffect(player, card)

    if card == Card.CARD_EMPEROR then
        itemManager:Add(player, CollectibleType.COLLECTIBLE_THERES_OPTIONS, 0, 1, ENCHANTMENT)
    end

    if card == Card.CARD_STARS then
        itemManager:Add(player, CollectibleType.COLLECTIBLE_MORE_OPTIONS, 0, 1, ENCHANTMENT)
    end

    if card == Card.CARD_HERMIT then
        itemManager:Add(player, CollectibleType.COLLECTIBLE_MEMBER_CARD, 0, 1, ENCHANTMENT)
        local save = saveManager.GetRunSave()
        if save then save.RemovedShopTrapdoor = false end
    end

    if card == Card.CARD_MOON then
        itemManager:Add(player, CollectibleType.COLLECTIBLE_LUNA, 0, 1, ENCHANTMENT)
    end

    if card == Card.CARD_MAGICIAN then
        player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_SPOON_BENDER, true)
    end

    if card == Card.CARD_EMPRESS then
        player:UseCard(Card.CARD_EMPRESS, UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD)
    end

    if card == Card.CARD_CHARIOT then
        itemManager:Add(player, CollectibleType.COLLECTIBLE_TAURUS, 0, 1, ENCHANTMENT)
    end

    if card == Card.CARD_WHEEL_OF_FORTUNE then

        utility:TryRemoveInnateCollectible(player, enums.Collectibles.LIL_SLOT_MACHINE, ENCHANTMENT)
        utility:TryRemoveInnateCollectible(player, enums.Collectibles.LIL_FORTUNE_TELLER, ENCHANTMENT)

        JosephMod.Schedule(3, function ()
            local rng = player:GetCardRNG(Card.CARD_WHEEL_OF_FORTUNE)
            local rand = rng:RandomInt(2) + 1
            if rand == 1 then
                itemManager:Add(player, enums.Collectibles.LIL_SLOT_MACHINE, 0, 1, ENCHANTMENT)
            else
                itemManager:Add(player, enums.Collectibles.LIL_FORTUNE_TELLER, 0, 1, ENCHANTMENT)
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
        itemManager:Add(player, CollectibleType.COLLECTIBLE_DRY_BABY, 0, 1, ENCHANTMENT)
    end

    if card == Card.CARD_TEMPERANCE then
        utility:TryRemoveInnateCollectible(player, enums.Collectibles.LIL_BLOOD_BANK, ENCHANTMENT)

        JosephMod.Schedule(3, function ()
            itemManager:Add(player, enums.Collectibles.LIL_BLOOD_BANK, 0, 1, ENCHANTMENT)
        end,{})
    end

    if card == Card.CARD_DEVIL then
        player:UseActiveItem(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL, false)
    end

    if card == Card.CARD_TOWER then
        itemManager:Add(player, CollectibleType.COLLECTIBLE_CURSE_OF_THE_TOWER, 0, 1, ENCHANTMENT)
    end

    if card == Card.CARD_WORLD then
        Game():GetLevel():ShowMap()
    end

    if card == Card.CARD_JUDGEMENT then
        itemManager:Add(player, CollectibleType.COLLECTIBLE_BUM_FRIEND, 0, 1, ENCHANTMENT)
    end

    if card == Card.CARD_SUN then
        itemManager:Add(player, CollectibleType.COLLECTIBLE_SOL, 0, 1, ENCHANTMENT)
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
            utility:TryRemoveInnateCollectible(player, CollectibleType.COLLECTIBLE_THERES_OPTIONS, ENCHANTMENT)
        end,
        [Card.CARD_HIEROPHANT] = function()
            -- Code for CARD_HIEROPHANT
        end,
        [Card.CARD_LOVERS] = function()
            -- Code for CARD_LOVERS
        end,
        [Card.CARD_CHARIOT] = function()
            -- Code for CARD_CHARIOT
            utility:TryRemoveInnateCollectible(player, CollectibleType.COLLECTIBLE_TAURUS, ENCHANTMENT)
        end,
        [Card.CARD_JUSTICE] = function()
            -- Code for CARD_JUSTICE
        end,
        [Card.CARD_HERMIT] = function()
            -- Code for CARD_HERMIT
            utility:TryRemoveInnateCollectible(player, CollectibleType.COLLECTIBLE_MEMBER_CARD, ENCHANTMENT)
            JosephMod.Schedule(1, function ()
                CardEffects:RemoveShopTrapdoor()
            end,{})

        end,
        [Card.CARD_WHEEL_OF_FORTUNE] = function()
            -- Code for CARD_WHEEL_OF_FORTUNE
            utility:TryRemoveInnateCollectible(player, enums.Collectibles.LIL_SLOT_MACHINE, ENCHANTMENT)
            utility:TryRemoveInnateCollectible(player, enums.Collectibles.LIL_FORTUNE_TELLER, ENCHANTMENT)
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
            utility:TryRemoveInnateCollectible(player, CollectibleType.COLLECTIBLE_DRY_BABY, ENCHANTMENT)
        end,
        [Card.CARD_TEMPERANCE] = function()
            -- Code for CARD_TEMPERANCE
            utility:TryRemoveInnateCollectible(player, enums.Collectibles.LIL_BLOOD_BANK, ENCHANTMENT)
        end,
        [Card.CARD_DEVIL] = function()
            -- Code for CARD_DEVIL
            player:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL)
        end,
        [Card.CARD_TOWER] = function()
            -- Code for CARD_TOWER
            utility:TryRemoveInnateCollectible(player, CollectibleType.COLLECTIBLE_CURSE_OF_THE_TOWER, ENCHANTMENT)
        end,
        [Card.CARD_STARS] = function()
            -- Code for CARD_STAR
            utility:TryRemoveInnateCollectible(player, CollectibleType.COLLECTIBLE_MORE_OPTIONS, ENCHANTMENT)
        end,
        [Card.CARD_MOON] = function()
            -- Code for CARD_MOON
            utility:TryRemoveInnateCollectible(player, CollectibleType.COLLECTIBLE_LUNA, ENCHANTMENT)
        end,
        [Card.CARD_SUN] = function()
            -- Code for CARD_SUN
            utility:TryRemoveInnateCollectible(player, CollectibleType.COLLECTIBLE_SOL, ENCHANTMENT)
        end,
        [Card.CARD_JUDGEMENT] = function()
            -- Code for CARD_JUDGEMENT
            utility:TryRemoveInnateCollectible(player, CollectibleType.COLLECTIBLE_BUM_FRIEND, ENCHANTMENT)
            utility:TryRemoveInnateCollectible(player, CollectibleType.COLLECTIBLE_DARK_BUM, ENCHANTMENT)
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



function CardEffects:addRoomEffect()

    local room = Game():GetRoom()
    local centerPos = room:IsLShapedRoom() and Vector(853, 270) or room:GetCenterPos()
    local offset = 40

    CardEffects:RemoveShopTrapdoor()

    local roomData = JosephMod.saveManager.GetRoomSave(nil)
	if roomData then 
        -- roomData.hasStarsPortal = false
        -- roomData.hasEmporerPortal = false
        roomData.hasFoolPortal = false
        -- roomData.hasMoonPortal = false
    end
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local playerData = JosephMod.saveManager.GetRunSave(player)
        if not (playerData and playerData.EnchantedCard) then return end


        if playerData.EnchantedCard == Card.CARD_MAGICIAN then
            player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_SPOON_BENDER, true)
        end

        if playerData.EnchantedCard == Card.CARD_HIGH_PRIESTESS and (room:IsFirstVisit() or not room:IsClear()) then
            player:UseCard(Card.CARD_HIGH_PRIESTESS, UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD | UseFlag.USE_NOANIM)
        end

        if playerData.EnchantedCard == Card.CARD_EMPRESS then
            player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_WHORE_OF_BABYLON, true)
        end

        if playerData.EnchantedCard == Card.CARD_STRENGTH then
            player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM, true)
        end

        if playerData.EnchantedCard == Card.CARD_HANGED_MAN then
            player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_TRANSCENDENCE, true)
        end

        if playerData.EnchantedCard == Card.CARD_DEVIL then
            player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL, true)
        end

        if room:IsClear() and room:IsFirstVisit() then
            -- if playerData.EnchantedCard == Card.CARD_STARS and roomData.hasStarsPortal == false then
            --     local pos = Isaac.GetFreeNearPosition(Vector((centerPos.X - offset), centerPos.Y - offset), 10)
            --     JosephMod.cardEffects:spawnPortal(pos, player, 0)
            --     roomData.hasStarsPortal = true
            -- end

            -- if playerData.EnchantedCard == Card.CARD_MOON and roomData.hasMoonPortal == false then
            --     local pos = Isaac.GetFreeNearPosition(Vector((centerPos.X - offset), centerPos.Y + offset), 10)
            --     JosephMod.cardEffects:spawnPortal(pos, player, 2)
            --     roomData.hasMoonPortal = true
            -- end

            -- if playerData.EnchantedCard == Card.CARD_EMPEROR and roomData.hasEmporerPortal == false then
            --     local pos = Isaac.GetFreeNearPosition(Vector((centerPos.X + offset), centerPos.Y - offset), 10)
            --     JosephMod.cardEffects:spawnPortal(pos, player, 1)
            --     roomData.hasEmporerPortal = true
            -- end

            if playerData.EnchantedCard == Card.CARD_FOOL and roomData.hasFoolPortal == false then
                local pos = Isaac.GetFreeNearPosition(Vector((centerPos.X + offset), centerPos.Y + offset), 10)
                JosephMod.cardEffects:spawnPortal(pos, player, 3)
                roomData.hasFoolPortal = true
            end
        end


    end
end
JosephMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, CardEffects.addRoomEffect)
JosephMod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, CardEffects.addRoomEffect)

function CardEffects:RoomClearEffect(rng, spawnPos)
    local room = Game():GetRoom()
    local roomType = room:GetType()
    local centerPos = room:IsLShapedRoom() and Vector(580, 420) or room:GetCenterPos()
    local portalsCount = 0
    local offset = 40
    local overrideClearReward = false

    local roomData = JosephMod.saveManager.GetRoomSave(nil)
	if roomData then 
        -- roomData.hasStarsPortal = false
        -- roomData.hasEmporerPortal = false
        roomData.hasFoolPortal = false
        -- roomData.hasMoonPortal = false
    end
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local playerData = JosephMod.saveManager.GetRunSave(player)
        if (playerData and playerData.EnchantedCard) then

            -- if playerData.EnchantedCard == Card.CARD_STARS and roomData.hasStarsPortal == false then
            --     local pos = Isaac.GetFreeNearPosition(Vector((centerPos.X - offset), centerPos.Y - offset), 10)
            --     JosephMod.cardEffects:spawnPortal(pos, player, 0)
            --     roomData.hasStarsPortal = true
            -- end

            -- if playerData.EnchantedCard == Card.CARD_MOON and roomData.hasMoonPortal == false then
            --     local pos = Isaac.GetFreeNearPosition(Vector((centerPos.X - offset), centerPos.Y + offset), 10)
            --     JosephMod.cardEffects:spawnPortal(pos, player, 2)
            --     roomData.hasMoonPortal = true
            -- end

            -- if playerData.EnchantedCard == Card.CARD_EMPEROR and roomData.hasEmporerPortal == false then
            --     local pos = Isaac.GetFreeNearPosition(Vector((centerPos.X + offset), centerPos.Y - offset), 10)
            --     JosephMod.cardEffects:spawnPortal(pos, player, 1)
            --     roomData.hasEmporerPortal = true
            -- end

            if playerData.EnchantedCard == Card.CARD_FOOL and roomData.hasFoolPortal == false then
                local pos = Isaac.GetFreeNearPosition(Vector((centerPos.X + offset), centerPos.Y + offset), 10)
                JosephMod.cardEffects:spawnPortal(pos, player, 3)
                roomData.hasFoolPortal = true
            end


            if roomType ~= RoomType.ROOM_BOSS then

                if playerData.EnchantedCard == Card.CARD_LOVERS and rng:RandomFloat() <= RED_HEART_REPLACE_CHANCE then
                    SFXManager():Play(SoundEffect.SOUND_THUMBSUP)
                    local pos = room:FindFreePickupSpawnPosition(spawnPos)
                    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 1, pos, Vector(0, 0), nil)
                end

                if playerData.EnchantedCard == Card.CARD_HIEROPHANT and rng:RandomFloat() <= SOUL_HEART_REPLACE_CHANCE then
                    SFXManager():Play(SoundEffect.SOUND_THUMBSUP)
                    local pos = room:FindFreePickupSpawnPosition(spawnPos)
                    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 3, pos, Vector(0, 0), nil)
                end

                if playerData.EnchantedCard == Card.CARD_JUSTICE and rng:RandomFloat() <= JUSTICE_DROP_REPLACE_CHANCE then
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
    local save = saveManager.GetRunSave()
    if not (save and save.RemovedShopTrapdoor == false) then return end
    local shopCrawlSpaces = TSIL.GridSpecific.GetCrawlSpaces(TSIL.Enums.CrawlSpaceVariant.SECRET_SHOP)
    if (next(shopCrawlSpaces) ~= nil) then
        local shopDoor = shopCrawlSpaces[1]
        Isaac.Spawn(1000, 15, 0, shopDoor.Position, Vector(0, 0), nil)
        TSIL.GridEntities.RemoveGridEntity(shopDoor)
        save.RemovedShopTrapdoor = true
    end


end



return CardEffects