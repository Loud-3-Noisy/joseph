local Scrawl = {}
local mod = JosephMod

local enums = JosephMod.enums
local utility = JosephMod.utility

local SCRAWL = enums.Collectibles.SCRAWL


local droppedCard = false
---@param player EntityPlayer
---@param pickup EntityPickup
---@param slot any
function Scrawl:DropCard(player, pickup, slot)
    if Isaac.GetItemConfig():GetCard(pickup.SubType):IsRune() then return end
    if not player:HasCollectible(SCRAWL) then return end
    droppedCard = true
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_DROP_CARD, Scrawl.DropCard)


local droppedPill = false
---@param player EntityPlayer
---@param pickup EntityPickup
---@param slot any
function Scrawl:DropPill(player, pickup, slot)
    if Isaac.GetItemConfig():GetCard(pickup.SubType):IsRune() then return end
    if not (player:HasCollectible(SCRAWL) and player:HasCollectible(CollectibleType.COLLECTIBLE_LITTLE_BAGGY)) then return end
    droppedPill = true
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_DROP_PILL, Scrawl.DropPill)

function Scrawl:CardSpawn(pickup)
    Isaac.CreateTimer( function()
        if not droppedCard then return end
        droppedCard = false
        pickup:Remove()
        local poof = Isaac.Spawn(1000, 15, 0, pickup.Position, Vector.Zero, nil)
        poof.SpriteScale = poof.SpriteScale/1.5
        SFXManager():Play(SoundEffect.SOUND_SUMMON_POOF, 3, 2, false, 0.5)
    end, 1, 1, true)
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, Scrawl.CardSpawn, PickupVariant.PICKUP_TAROTCARD)

function Scrawl:PillSpawn(pickup)
    Isaac.CreateTimer( function()
        if not droppedPill then return end
        droppedPill = false
        pickup:Remove()
        local poof = Isaac.Spawn(1000, 15, 0, pickup.Position, Vector.Zero, nil)
        poof.SpriteScale = poof.SpriteScale/1.5
        SFXManager():Play(SoundEffect.SOUND_SUMMON_POOF, 3, 2, false, 0.5)
    end, 1, 1, true)
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, Scrawl.PillSpawn, PickupVariant.PICKUP_PILL)


---@param player EntityPlayer
function Scrawl:NewRoom(player)
    if Game():GetRoom():IsClear() or not Game():GetRoom():IsFirstVisit() then return end
    if not player:HasCollectible(SCRAWL) then return end
    local rng = player:GetCollectibleRNG(SCRAWL)
    local seed = rng:Next()

    if player:HasCollectible(CollectibleType.COLLECTIBLE_LITTLE_BAGGY) then
        local pill = Game():GetItemPool():GetPill(seed)
        player:AddPill(pill)
        player:AnimatePill(pill, "HideItem")
        SFXManager():Play(SoundEffect.SOUND_SHELLGAME)
    else
        local card = Game():GetItemPool():GetCard(seed, true, false, false)
        player:AddCard(card)
        player:AnimateCard(card, "HideItem")
        SFXManager():Play(SoundEffect.SOUND_BOOK_PAGE_TURN_12)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_NEW_ROOM_TEMP_EFFECTS, Scrawl.NewRoom)


if EID then
    local function HideCardEIDCondition(descObj)
        if descObj and descObj.ObjType == 5 and descObj.ObjVariant == 300 and
        not Isaac.GetItemConfig():GetCard(descObj.ObjSubType):IsRune() and
        PlayerManager.AnyoneHasCollectible(SCRAWL) then
            return true
        end
    end
    local function HideCardEIDCallback(descObj)
        descObj.Name = "{{ColorError}}Unidentified Card"
        descObj.Description = ""
        descObj.Icon = EID.InlineIcons["Card"]
        return descObj
    end

    EID:addDescriptionModifier("Scrawl", HideCardEIDCondition, HideCardEIDCallback)
end


