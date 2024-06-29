local utilityFunctions  = {}

JosephMod.ScheduleData = {}
function JosephMod.Schedule(delay, func, args)
  table.insert(JosephMod.ScheduleData, {
    Time = Game():GetFrameCount(),
    Delay = delay,
    Call = func,
    Args = args
  })
end

JosephMod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
  local time = Game():GetFrameCount()
  for i = #JosephMod.ScheduleData, 1, -1 do
    local data = JosephMod.ScheduleData[i]
    if data.Time + data.Delay <= time then
      data.Call(table.unpack(data.Args))
      table.remove(JosephMod.ScheduleData, i)
    end
  end
end)


function utilityFunctions:CreateEmptyPlayerSaveDataVars(vars)
  if vars == nil then return end
  for i = 1, #vars do
    TSIL.SaveManager.AddPersistentVariable(
      JosephMod,
      vars[i],
      {},
      TSIL.Enums.VariablePersistenceMode.RESET_RUN,
      false
    )
  end
end

function utilityFunctions:GetPlayerSave(player, var)
  local dataPerPlayer = TSIL.SaveManager.GetPersistentVariable(JosephMod, var) or {}
  local playerIndex = TSIL.Players.GetPlayerIndex(player)
  local data = dataPerPlayer[playerIndex] --You can change 0 to whatever the default should be for each player
  return data
end

function utilityFunctions:SetPlayerSave(player, var, newData)
  local dataPerPlayer = TSIL.SaveManager.GetPersistentVariable(JosephMod, var) or {}
  local playerIndex = TSIL.Players.GetPlayerIndex(player)
  local data = dataPerPlayer[playerIndex]
  data = newData
  dataPerPlayer[playerIndex] = data
end

function utilityFunctions:SetPlayerSaveAtIndex(player, var, newData, index)
  local dataPerPlayer = TSIL.SaveManager.GetPersistentVariable(JosephMod, var) or {}
  local playerIndex = TSIL.Players.GetPlayerIndex(player)
  local data = dataPerPlayer[playerIndex]
  data[index] = newData
  dataPerPlayer[playerIndex] = data
end

function utilityFunctions:GetEnchantedCardsPerPlayer(player)
  local enchantedCardsPerPlayer = TSIL.SaveManager.GetPersistentVariable(JosephMod, "EnchantedCards")
  local playerIndex = TSIL.Players.GetPlayerIndex(player)

  local enchantedCards = enchantedCardsPerPlayer[playerIndex]

  if not enchantedCards then
    enchantedCards = {}
    enchantedCardsPerPlayer[playerIndex] = enchantedCards
  end

  return enchantedCards
end

---@param player EntityPlayer
---@param slot CardSlot
function utilityFunctions:GetEnchantedCardInPlayerSlot(player, slot)
  local enchantedCardsPerPlayer = TSIL.SaveManager.GetPersistentVariable(JosephMod, "EnchantedCards")
  local playerIndex = TSIL.Players.GetPlayerIndex(player)

  local enchantedCards = enchantedCardsPerPlayer[playerIndex]

  if not enchantedCards then
    enchantedCards = {0, 0, 0, 0, 0}
    enchantedCardsPerPlayer[playerIndex] = enchantedCards
  end
  return enchantedCards[slot]
end

function utilityFunctions:SetEnchantedCardInPlayerSlot(player, slot, card)
  local enchantedCards = JosephMod.utility:GetEnchantedCardsPerPlayer(player)
  enchantedCards[slot] = card
end

function utilityFunctions:GetPlayerVar(player, var)
  local playerIndex = TSIL.Players.GetPlayerIndex(player)
  return _G[var][playerIndex]
end

function utilityFunctions:toTearsPerSecond(maxFireDelay)
  return 30 / (maxFireDelay + 1)
end

function utilityFunctions:toMaxFireDelay(tearsPerSecond)
  return (30 / tearsPerSecond) - 1
end

function utilityFunctions:addTearMultiplier(player, multiplier)
  local tearsPerSecond = JosephMod.utility:toTearsPerSecond(player.MaxFireDelay)
  tearsPerSecond = tearsPerSecond * multiplier
  player.MaxFireDelay = JosephMod.utility:toMaxFireDelay(tearsPerSecond)
end

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
    player.Damage = player.Damage + damageModifier
end


function utilityFunctions:AnyPlayerHasEnchantment(enchantment)
  local playerEnchantments = TSIL.SaveManager.GetPersistentVariable(JosephMod, "EnchantedCards") or {}
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local playerIndex = TSIL.Players.GetPlayerIndex(player)
        if not playerEnchantments or not playerEnchantments[playerIndex] or playerEnchantments[playerIndex] == {} then return false end
        for key, value in pairs(playerEnchantments[playerIndex]) do
          if value == enchantment then return true end
        end
    end
    return false
end


function utilityFunctions:GetEnchantmentCount(player, enchantment)
  local playerEnchantments = TSIL.SaveManager.GetPersistentVariable(JosephMod, "EnchantedCards") or {}
  local enchantmentCount = 0
  local playerIndex = TSIL.Players.GetPlayerIndex(player)
  if not playerEnchantments or not playerEnchantments[playerIndex] or playerEnchantments[playerIndex] == {} then return 0 end
  for key, value in pairs(playerEnchantments[playerIndex]) do
    if value == enchantment then enchantmentCount = enchantmentCount + 1 end
  end

  return enchantmentCount
end


function utilityFunctions:HasEnchantment(player, enchantment)
  local playerEnchantments = TSIL.SaveManager.GetPersistentVariable(JosephMod, "EnchantedCards") or {}
  local hasEnchantment = false
  local playerIndex = TSIL.Players.GetPlayerIndex(player)
  if not playerEnchantments or not playerEnchantments[playerIndex] or playerEnchantments[playerIndex] == {} then return false end
  for key, value in pairs(playerEnchantments[playerIndex]) do
    if value == enchantment then hasEnchantment = true end
  end

  return hasEnchantment
end

function utilityFunctions:IsEnchantmentSlotEmpty(player, slot)
  local enchantedCard = utilityFunctions:GetEnchantedCardInPlayerSlot(player, slot)
  if enchantedCard == nil or enchantedCard == 0 then return true end
  return false
end


function utilityFunctions:RemoveInnateItem(player, item)
  if player:GetCollectibleNum(item) - player:GetCollectibleNum(item, false, true) > 0 then
    player:AddInnateCollectible(item, -1)
    local config = Isaac.GetItemConfig():GetCollectible(item)
    player:RemoveCostume(config)
  end
end

return utilityFunctions