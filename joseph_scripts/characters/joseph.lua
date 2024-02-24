local JosephChar = {}

local RECOMMENDED_SHIFT_IDX = 35
local DAMAGE_REDUCTION = 0.6

local josephType = Isaac.GetPlayerTypeByName("Joseph", false) -- Exactly as in the xml. The second argument is if you want the Tainted variant.
local hairCostume = Isaac.GetCostumeIdByPath("gfx/characters/joseph_hair.anm2") -- Exact path, with the "resources" folder as the root
local stolesCostume = Isaac.GetCostumeIdByPath("gfx/characters/joseph_poncho.anm2") -- Exact path, with the "resources" folder as the root

function JosephChar:GiveCostumesOnInit(player)
    if player:GetPlayerType() ~= josephType then return end

    player:AddInnateCollectible(CollectibleType.COLLECTIBLE_STARTER_DECK, 1)
    local config = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_STARTER_DECK)
    player:RemoveCostume(config)

    player:AddNullCostume(hairCostume)
    player:AddNullCostume(stolesCostume)

    local NUMBER_TAROT_CARDS = 22
    local cardList = {}
    for itr = 0, NUMBER_TAROT_CARDS do
        table.insert(cardList, itr)
    end

    local startSeed = Game():GetSeeds():GetStartSeed()
    local rng = RNG()
    rng:SetSeed(startSeed, RECOMMENDED_SHIFT_IDX)
    
    local randomCard = cardList[rng:RandomInt(NUMBER_TAROT_CARDS)]
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