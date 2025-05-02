local CHARGE_TO_SPAWN_NUGGET = 30
local CHARGE_DEFAULT = -7
local MAX_CHARGE_TO_FORCE_INPUT = 0
local CHARGEBAR_OFFSET = Vector(0, 12)
local CHARGEBAR_FADE = 0.1

Chowder.CHOWDER_HEART_BLACKLIST = {
    [HeartSubType.HEART_BLACK] = true,
    [HeartSubType.HEART_HALF_SOUL] = true,
    [HeartSubType.HEART_SOUL] = true,
}

---@param player EntityPlayer
Chowder:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function (_, player)
    if player:GetPlayerType() ~= Chowder.Character.CHOWDER then return end
    Chowder:SetBloodTears(player, true, "Chower")
end)

---@param player EntityPlayer
---@param flag CacheFlag
Chowder:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function (_, player, flag)
    if flag == CacheFlag.CACHE_DAMAGE then
        if player:GetPlayerType() ~= Chowder.Character.CHOWDER then return end
        player.Damage = player.Damage * 1.2
    end
end)

---@param pickup EntityPickup
---@param collider Entity
Chowder:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function (_, pickup, collider)
    if pickup.Variant ~= PickupVariant.PICKUP_HEART then return end
    local player = collider and collider:ToPlayer() if not (player and player:GetPlayerType() == Chowder.Character.CHOWDER) then return end

    if Chowder.CHOWDER_HEART_BLACKLIST[pickup.SubType] then
        return pickup.Price ~= 0
    end

    if pickup.SubType == HeartSubType.HEART_BLENDED then
        local hearts = player:GetEffectiveMaxHearts() - player:GetHearts()

        if hearts == 0 then
            return pickup.Price ~= 0
        end

        if hearts == 1 then
            SFXManager():Play(SoundEffect.SOUND_HOLY, 0)
        end
    end
end)

if REPENTOGON then
    ---@param player EntityPlayer
    ---@param amt number
    ---@diagnostic disable-next-line: undefined-doc-name
    ---@param type AddHealthType | integer
    ---@diagnostic disable-next-line: undefined-field
    Chowder:AddCallback(ModCallbacks.MC_PRE_PLAYER_ADD_HEARTS, function (_, player, amt, type)
        if amt <= 0 or player:GetPlayerType() ~= Chowder.Character.CHOWDER then return end
        ---@diagnostic disable-next-line: undefined-global, param-type-mismatch
        if not Chowder:HasFlags(type, AddHealthType.SOUL) then return end
        player:AddHearts(amt)
        return 0
    end)
else
    ---@param player EntityPlayer
    Chowder:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function (_, player)
        if player:GetPlayerType() ~= Chowder.Character.CHOWDER then return end
        local soul = player:GetSoulHearts() if soul == 0 then return end
        player:AddHearts(soul)
        player:AddSoulHearts(-soul)
    end)
end

local function ChargeBar()
    local sprite = Sprite()

    sprite:Load("gfx/chargebar.anm2", true)

    return sprite
end

---@param player EntityPlayer
local function GetData(player)
    ---@class Chowder.ChowderData
    ---@field Charge integer
    ---@field ChargeBar Sprite
    ---@field Holding boolean
    ---@field ForceInput boolean
    ---@field SpawnedNugget boolean
    return Chowder:GetData(player, "Chowder", nil, {
        ChargeBar = ChargeBar(),
        Charge = CHARGE_DEFAULT
    })
end

if not REPENTOGON then
    local COSTUME = Isaac.GetCostumeIdByPath("gfx_chowder/costume_chowder.anm2")

    ---@param player EntityPlayer
    Chowder:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function (_, player)
        if player:GetPlayerType() ~= Chowder.Character.CHOWDER then return end
        player:AddNullCostume(COSTUME)
    end)
end

---@param player EntityPlayer
Chowder:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function (_, player)
    local data = Chowder:GetData(player, "Chowder")
    local q = Input.IsActionPressed(ButtonAction.ACTION_PILLCARD, player.ControllerIndex)

    data.Holding = q

    if not q then
        if data.Charge > CHARGE_DEFAULT and data.Charge < MAX_CHARGE_TO_FORCE_INPUT and not data.SpawnedNugget then
            data.ForceInput = true
        end

        data.Charge = CHARGE_DEFAULT
        data.SpawnedNugget = false
    end
end)

---@param player EntityPlayer
Chowder:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function (_, player)
    local data = GetData(player)

    if data.Holding then
        data.Charge = data.Charge + 1

        if data.Charge > CHARGE_TO_SPAWN_NUGGET then
            data.SpawnedNugget = true
            Chowder:DoThatFunnyBloodExplosion(player)
            data.Charge = 0
        end
    end

    if data.Charge > 0 then
        data.ChargeBar.Color = Color.Lerp(data.ChargeBar.Color, ksil.Color.DEFAULT, CHARGEBAR_FADE)
    else
        data.ChargeBar.Color = Color.Lerp(data.ChargeBar.Color, Chowder.Color.WHITE_0_ALPHA, CHARGEBAR_FADE)
    end
end)

---@param player EntityPlayer
Chowder:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, function (_, player)
    if player:GetPlayerType() ~= Chowder.Character.CHOWDER then return end
    local data = GetData(player)
    HudHelper.RenderChargeBar(data.ChargeBar, math.max(0, data.Charge), CHARGE_TO_SPAWN_NUGGET, Isaac.WorldToScreen(player.Position) + CHARGEBAR_OFFSET)
end)

---@param entity Entity?
---@param action ButtonAction
Chowder:AddCallback(ModCallbacks.MC_INPUT_ACTION, function (_, entity, _, action)
    if action ~= ButtonAction.ACTION_PILLCARD then return end
    local player = entity and entity:ToPlayer() if not (player and player:GetPlayerType() == Chowder.Character.CHOWDER) then return end
    local data = GetData(player)
    if data.ForceInput then
        data.ForceInput = false
        return true
    end
    return false
end, InputHook.IS_ACTION_TRIGGERED)