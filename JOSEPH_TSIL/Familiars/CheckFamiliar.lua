local familiarGenerationRNG = nil


function TSIL.Familiars.CheckFamiliar(player, collectibleType, targetCount, familiarVariant, familiarSubtype)
    if not familiarGenerationRNG then
        familiarGenerationRNG = TSIL.RNG.NewRNG()
    end

    familiarGenerationRNG:Next()

    local itemConfigItem = Isaac.GetItemConfig():GetCollectible(collectibleType)

    player:CheckFamiliar(familiarVariant, targetCount, familiarGenerationRNG, itemConfigItem, familiarSubtype)
end


function TSIL.Familiars.CheckFamiliarFromCollectibles(player, collectibleType, familiarVariant, familiarSubtype)
    local numCollectibles = player:GetCollectibleNum(collectibleType)

    local effects = player:GetEffects()
    local numCollectibleEffects = effects:GetCollectibleEffectNum(collectibleType)

    local targetCount = numCollectibles + numCollectibleEffects

    TSIL.Familiars.CheckFamiliar(
        player,
        collectibleType,
        targetCount,
        familiarVariant,
        familiarSubtype
    )
end