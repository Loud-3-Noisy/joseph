local utilityFunctions  = {}
local itemManager = JosephMod.HiddenItemManager

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
      TSIL.Enums.VariablePersistenceMode.RESET_RUN
    )
  end
end


function utilityFunctions:GetPlayerSave(player, var)
  local dataPerPlayer = TSIL.SaveManager.GetPersistentVariable(JosephMod, var) or {}
  local playerIndex = TSIL.Players.GetPlayerIndex(player)
  local data = dataPerPlayer[playerIndex] or nil --You can change 0 to whatever the default should be for each player
  return data
end

function utilityFunctions:SetPlayerSave(player, var, newData)
  local dataPerPlayer = TSIL.SaveManager.GetPersistentVariable(JosephMod, var) or {}
  local playerIndex = TSIL.Players.GetPlayerIndex(player)
  local data = dataPerPlayer[playerIndex]
  data = newData
  dataPerPlayer[playerIndex] = data
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
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local playerData = JosephMod.saveManager.GetRunSave(player)
        if (playerData and playerData.EnchantedCard and playerData.EnchantedCard == enchantment) then
            return true
        end
    end
    return false
end

function utilityFunctions:TryRemoveInnateCollectible(player, collectible, group)
  if itemManager:Has(player, collectible, group) then
    itemManager:Remove(player, collectible, group)
  end
end

return utilityFunctions