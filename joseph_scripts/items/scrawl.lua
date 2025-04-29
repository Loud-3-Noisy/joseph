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


---@param player EntityPlayer
function Scrawl:NewRoom(player)
    if Game():GetRoom():IsClear() or not Game():GetRoom():IsFirstVisit() then return end
    if not player:HasCollectible(SCRAWL) then return end
    local rng = player:GetCollectibleRNG(SCRAWL)
    local seed = rng:Next()
    local card = Game():GetItemPool():GetCard(seed, true, false, false)
    player:AddCard(card)
    player:AnimateCard(card, "HideItem")
    SFXManager():Play(SoundEffect.SOUND_BOOK_PAGE_TURN_12)
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_NEW_ROOM_TEMP_EFFECTS, Scrawl.NewRoom)



