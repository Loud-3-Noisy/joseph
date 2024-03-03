local CardEffects = {}
local itemManager = JosephMod.HiddenItemManager
local utility = JosephMod.utility
local enums = JosephMod.enums

local RED_HEART_REPLACE_CHANCE = 0.25
local SOUL_HEART_REPLACE_CHANCE = 0.143 -- 1/7
local JUSTICE_DROP_REPLACE_CHANCE = 0.20 

function CardEffects:addCardStats(player, flag)
    local playerData = JosephMod.saveManager.GetRunSave(player)
    if not (playerData and playerData.EnchantedCard) then return end

    if playerData.EnchantedCard == Card.CARD_EMPRESS and flag == CacheFlag.CACHE_DAMAGE then
        utility:AddDamage(player, -0.5)
    end

    if playerData.EnchantedCard == Card.CARD_STRENGTH and flag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage * 0.83
    end

    if playerData.EnchantedCard == Card.CARD_DEVIL and flag == CacheFlag.CACHE_DAMAGE then
        utility:AddDamage(player, -0.5)
    end

end
JosephMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, CardEffects.addCardStats)


function CardEffects:InitCardEffect(player, card)
    if card == Card.CARD_MAGICIAN then
        player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_SPOON_BENDER, true)
    else
        player:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_SPOON_BENDER)
    end

    if card == Card.CARD_EMPRESS then
        player:UseCard(Card.CARD_EMPRESS, UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD)
    else
        player:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_WHORE_OF_BABYLON)
    end

    if card == Card.CARD_CHARIOT then
        itemManager:Add(player, CollectibleType.COLLECTIBLE_TAURUS, 0, 1, ENCHANTMENT)
    else
        itemManager:Remove(player, CollectibleType.COLLECTIBLE_TAURUS, ENCHANTMENT)
    end

    if card == Card.CARD_WHEEL_OF_FORTUNE then

        if itemManager:Has(player, enums.Collectibles.LIL_SLOT_MACHINE, ENCHANTMENT) then
            itemManager:Remove(player, enums.Collectibles.LIL_SLOT_MACHINE, ENCHANTMENT)
        end
        if itemManager:Has(player, enums.Collectibles.LIL_FORTUNE_TELLER, ENCHANTMENT) then
            itemManager:Remove(player, enums.Collectibles.LIL_FORTUNE_TELLER, ENCHANTMENT)
        end

        JosephMod.Schedule(3, function ()
            local rng = player:GetCardRNG(Card.CARD_WHEEL_OF_FORTUNE)
            local rand = rng:RandomInt(2) + 1
            if rand == 1 then
                itemManager:Add(player, enums.Collectibles.LIL_SLOT_MACHINE, 0, 1, ENCHANTMENT)
            else
                itemManager:Add(player, enums.Collectibles.LIL_FORTUNE_TELLER, 0, 1, ENCHANTMENT)
            end
        end,{})

    else
        if itemManager:Has(player, enums.Collectibles.LIL_SLOT_MACHINE, ENCHANTMENT) then
            itemManager:Remove(player, enums.Collectibles.LIL_SLOT_MACHINE, ENCHANTMENT)
        end
        if itemManager:Has(player, enums.Collectibles.LIL_FORTUNE_TELLER, ENCHANTMENT) then
            itemManager:Remove(player, enums.Collectibles.LIL_FORTUNE_TELLER, ENCHANTMENT)
        end
    end

    if card == Card.CARD_STRENGTH then
        player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM, true)
    else
        player:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM)
        -- player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        -- player:EvaluateItems()
    end

    if card == Card.CARD_HANGED_MAN then
        player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_TRANSCENDENCE, true)
    else
        player:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_TRANSCENDENCE)
    end

    if card == Card.CARD_DEATH then
        itemManager:Add(player, CollectibleType.COLLECTIBLE_DRY_BABY, 0, 1, ENCHANTMENT)
    else
        itemManager:Remove(player, CollectibleType.COLLECTIBLE_DRY_BABY, ENCHANTMENT)
    end

    if card == Card.CARD_TEMPERANCE then
        if itemManager:Has(player, enums.Collectibles.LIL_BLOOD_BANK, ENCHANTMENT) then
            itemManager:Remove(player, enums.Collectibles.LIL_BLOOD_BANK, ENCHANTMENT)
        end

        JosephMod.Schedule(3, function ()
            itemManager:Add(player, enums.Collectibles.LIL_BLOOD_BANK, 0, 1, ENCHANTMENT)
        end,{})
    else
        if itemManager:Has(player, enums.Collectibles.LIL_BLOOD_BANK, ENCHANTMENT) then
            itemManager:Remove(player, enums.Collectibles.LIL_BLOOD_BANK, ENCHANTMENT)
        end
    end

    if card == Card.CARD_DEVIL then
        player:UseActiveItem(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL, false)
    else
        player:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL)
    end

    if card == Card.CARD_TOWER then
        itemManager:Add(player, CollectibleType.COLLECTIBLE_CURSE_OF_THE_TOWER, 0, 1, ENCHANTMENT)
    else
        itemManager:Remove(player, CollectibleType.COLLECTIBLE_CURSE_OF_THE_TOWER, ENCHANTMENT)
    end

    if card == Card.CARD_WORLD then
        Game():GetLevel():ShowMap()
    else
        itemManager:Remove(player, CollectibleType.COLLECTIBLE_MIND, ENCHANTMENT)
    end

    if card == Card.CARD_JUDGEMENT then
        itemManager:Add(player, CollectibleType.COLLECTIBLE_BUM_FRIEND, 0, 1, ENCHANTMENT)
    else
        itemManager:Remove(player, CollectibleType.COLLECTIBLE_BUM_FRIEND, ENCHANTMENT)
    end

    if card == Card.CARD_SUN then
        itemManager:Add(player, CollectibleType.COLLECTIBLE_SOL, 0, 1, ENCHANTMENT)
    else
        itemManager:Remove(player, CollectibleType.COLLECTIBLE_SOL, ENCHANTMENT)
    end
end


function CardEffects:addRoomEffect()

    local room = Game():GetRoom()
    local centerPos = room:IsLShapedRoom() and Vector(580, 420) or room:GetCenterPos()
    local offset = 40


    local roomData = JosephMod.saveManager.GetRoomSave(nil)
	if roomData then 
        roomData.hasStarsPortal = false
        roomData.hasEmporerPortal = false
        roomData.hasFoolPortal = false
        roomData.hasMoonPortal = false
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
            if playerData.EnchantedCard == Card.CARD_STARS and roomData.hasStarsPortal == false then
                local pos = Isaac.GetFreeNearPosition(Vector((centerPos.X - offset), centerPos.Y - offset), 10)
                JosephMod.cardEffects:spawnPortal(pos, player, 0)
                roomData.hasStarsPortal = true
            end

            if playerData.EnchantedCard == Card.CARD_MOON and roomData.hasMoonPortal == false then
                local pos = Isaac.GetFreeNearPosition(Vector((centerPos.X - offset), centerPos.Y + offset), 10)
                JosephMod.cardEffects:spawnPortal(pos, player, 2)
                roomData.hasMoonPortal = true
            end

            if playerData.EnchantedCard == Card.CARD_EMPEROR and roomData.hasEmporerPortal == false then
                local pos = Isaac.GetFreeNearPosition(Vector((centerPos.X + offset), centerPos.Y - offset), 10)
                JosephMod.cardEffects:spawnPortal(pos, player, 1)
                roomData.hasEmporerPortal = true
            end

            if playerData.EnchantedCard == Card.CARD_FOOL and roomData.hasFoolPortal == false then
                local pos = Isaac.GetFreeNearPosition(Vector((centerPos.X + offset), centerPos.Y + offset), 10)
                JosephMod.cardEffects:spawnPortal(pos, player, 3)
                roomData.hasFoolPortal = true
            end
        end


    end
end
JosephMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, CardEffects.addRoomEffect)


function CardEffects:RoomClearEffect(rng, spawnPos)
    local room = Game():GetRoom()
    local roomType = room:GetType()
    local centerPos = room:IsLShapedRoom() and Vector(580, 420) or room:GetCenterPos()
    local portalsCount = 0
    local offset = 40
    local overrideClearReward = false

    local roomData = JosephMod.saveManager.GetRoomSave(nil)
	if roomData then 
        roomData.hasStarsPortal = false
        roomData.hasEmporerPortal = false
        roomData.hasFoolPortal = false
        roomData.hasMoonPortal = false
    end
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local playerData = JosephMod.saveManager.GetRunSave(player)
        if (playerData and playerData.EnchantedCard) then

            if playerData.EnchantedCard == Card.CARD_STARS and roomData.hasStarsPortal == false then
                local pos = Isaac.GetFreeNearPosition(Vector((centerPos.X - offset), centerPos.Y - offset), 10)
                JosephMod.cardEffects:spawnPortal(pos, player, 0)
                roomData.hasStarsPortal = true
            end

            if playerData.EnchantedCard == Card.CARD_MOON and roomData.hasMoonPortal == false then
                local pos = Isaac.GetFreeNearPosition(Vector((centerPos.X - offset), centerPos.Y + offset), 10)
                JosephMod.cardEffects:spawnPortal(pos, player, 2)
                roomData.hasMoonPortal = true
            end

            if playerData.EnchantedCard == Card.CARD_EMPEROR and roomData.hasEmporerPortal == false then
                local pos = Isaac.GetFreeNearPosition(Vector((centerPos.X + offset), centerPos.Y - offset), 10)
                JosephMod.cardEffects:spawnPortal(pos, player, 1)
                roomData.hasEmporerPortal = true
            end

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



return CardEffects