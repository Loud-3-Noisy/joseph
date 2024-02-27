local utilityFunctions  = {}

function utilityFunctions:HUDOffset(x, y, anchor)
    local notches = math.floor(Options.HUDOffset * 10 + 0.5)
    local xoffset = (notches*2)
    local yoffset = ((1/8)*(10*notches+(-1)^notches+7))
    if anchor == 'topleft' then
      xoffset = x+xoffset
      yoffset = y+yoffset
    elseif anchor == 'topright' then
      xoffset = x-xoffset
      yoffset = y+yoffset
    elseif anchor == 'bottomleft' then
      xoffset = x+xoffset
      yoffset = y-yoffset
    elseif anchor == 'bottomright' then
      xoffset = x-xoffset * 0.8
      yoffset = y-notches * 0.6
    else
      error('invalid anchor provided. Must be one of: \'topleft\', \'topright\', \'bottomleft\', \'bottomright\'', 2)
    end
    return math.floor(xoffset + 0.5), math.floor(yoffset + 0.5)
end

function utilityFunctions:AddDamage(player, amount)
    local damageModifier = amount
    if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
        damageModifier = damageModifier*0.2
    end
    player.Damage = player.Damage - damageModifier
end


function utilityFunctions:AnyPlayerHasEnchantment(enchantment)
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local playerData = JosephMod.saveManager.GetRunSave(player)
        if (playerData and playerData.EnchantedCard and playerData.EnchantedCard == enchantment) then
            return true
        end
    end
    return false
end

return utilityFunctions