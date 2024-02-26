local CardEffects = {}


function CardEffects:InitCardEffect(player, card)
    if card == Card.CARD_MAGICIAN then
        player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_SPOON_BENDER, true)
    else
        player:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_SPOON_BENDER)
    end

    if card == Card.CARD_STRENGTH then
        player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM, true)
    else
        player:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM)
        -- player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        -- player:EvaluateItems()
    end

    if card == Card.CARD_DEVIL then
        player:UseActiveItem(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL, false)
    else
        player:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL)
    end
end

function CardEffects:addCardStats(player, flag)
    local playerData = JosephMod.saveManager.GetRunSave(player)
    if not (playerData and playerData.EnchantedCard) then return end

    if playerData.EnchantedCard == Card.CARD_STRENGTH and flag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage * 0.83
    end

    if playerData.EnchantedCard == Card.CARD_DEVIL and flag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage - 0.5
    end

end
JosephMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, CardEffects.addCardStats)


function CardEffects:addRoomEffect()
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local playerData = JosephMod.saveManager.GetRunSave(player)
        if not (playerData and playerData.EnchantedCard) then return end


        if playerData.EnchantedCard == Card.CARD_MAGICIAN then
            player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_SPOON_BENDER, true)
        end

        if playerData.EnchantedCard == Card.CARD_STRENGTH then
            player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM, true)
        end

        if playerData.EnchantedCard == Card.CARD_DEVIL then
            player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL, true)
        end


    end
end
JosephMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, CardEffects.addRoomEffect)


function CardEffects:RoomClearEffect(_, spawnPos)
    local room = Game():GetRoom()
    local centerPos = room:IsLShapedRoom() and Vector(580, 420) or room:GetCenterPos()
    local portalsCount = 0
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
        end
    end
end
JosephMod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, CardEffects.RoomClearEffect)

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
    repeat
        if not canFly then
            tempNPC = Isaac.Spawn(EntityType.ENTITY_GAPER, 0, 0, pos, Vector.Zero, nil):ToNPC()
            tempNPC.Visible = false
            if tempNPC then pathFinder = tempNPC.Pathfinder end
        end
        local overlaps

        print(pathFinder:HasPathToPos(player.Position, true))
        local scale = 40
        local X = pos.X
        local Y = pos.Y
        local Up = Vector(X, Y - scale)
	    local Down = Vector(X, Y + scale)
	    local Left = Vector(X - scale, Y)
	    local Right = Vector(X + scale, Y)
        if ((pathFinder and not pathFinder:HasPathToPos(player.Position, true)) or isDoor(Up) or isDoor(Down) or isDoor(Left) or isDoor(Right)) then
            print("overlaps")
            overlaps = true
            marg = marg + 10
            pos = Isaac.GetFreeNearPosition(pos, marg)
        end
        if tempNPC then tempNPC:Remove() end
    until not overlaps
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PORTAL_TELEPORT, portalType, pos, Vector.Zero, player):ToEffect()
end



return CardEffects