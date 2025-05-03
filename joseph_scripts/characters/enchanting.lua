local Enchanting = {}
local mod = JosephMod

local enums = JosephMod.enums
local utility = JosephMod.utility


local CHARGE_TO_ENCHANT = 50
local CHARGE_DEFAULT = -7
local MAX_CHARGE_TO_FORCE_INPUT = 0
local CHARGEBAR_OFFSET = Vector(0, 12)
local CHARGEBAR_FADE = 0.1
local chargebarPos = Vector(-30, -52)



---@param player EntityPlayer
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function (_, player)
    local data = utility:GetData(player, "Enchanting")
    local holding = Input.IsActionPressed(ButtonAction.ACTION_PILLCARD, player.ControllerIndex)

    if not data.Charge then data.Charge = CHARGE_DEFAULT end
    data.Holding = holding

    if not holding or (not enums.CardAnims[player:GetCard(0)]) then
        if data.Charge > CHARGE_DEFAULT and data.Charge < MAX_CHARGE_TO_FORCE_INPUT and not data.EnchantingFinished then
            data.ForceInput = true
        end

        data.Charge = CHARGE_DEFAULT
        data.EnchantingFinished = false
        data.FramesNotHolding = math.min(data.FramesNotHolding + 1 or 0, 10)
    else
        data.FramesNotHolding = 0
    end
end)

---@param player EntityPlayer
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function (_, player)
    local data = utility:GetData(player, "Enchanting")

    if data.Holding and not data.EnchantingFinished then
        data.Charge = (data.Charge + 1) or CHARGE_DEFAULT

        if data.Charge > CHARGE_TO_ENCHANT then
            data.EnchantingFinished = true
            data.Charge = CHARGE_DEFAULT
            if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and
            utility:IsEnchantmentSlotEmpty(player, enums.CardSlot.JOSEPH_BIRTHRIGHT) then
                JosephMod.josephCharacter:EnchantCard(player, player:GetCard(0), enums.CardSlot.JOSEPH_BIRTHRIGHT, true)
            else
                JosephMod.josephCharacter:EnchantCard(player, player:GetCard(0), enums.CardSlot.JOSEPH_INNATE, true)
            end
        end
    end
end)

---@param player EntityPlayer
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, function (_, player)
    if player:GetPlayerType() ~= enums.PlayerType.PLAYER_JOSEPH then return end
    local data = utility:GetData(player, "Enchanting")

    if ((not data.Charge) or (data.Charge < 0)) and (not data.FramesNotHolding or data.FramesNotHolding < 1) then return end
    if not data.ChargeBar then
        local chargeSprite = Sprite()
        chargeSprite:Load("gfx/ui/card_chargebar.anm2",true)
        data.ChargeBar = chargeSprite
    end

    if data.FramesNotHolding < 1 then
        local chargePercent = math.ceil(math.max(0, data.Charge)/CHARGE_TO_ENCHANT * 100)
        Enchanting:ChargeBarRender(chargePercent, true, Isaac.WorldToScreen(player.Position+chargebarPos), data.ChargeBar)
    else
        Enchanting:ChargeBarRender(data.FramesNotHolding, false, Isaac.WorldToScreen(player.Position+chargebarPos), data.ChargeBar)
    end
end)


---@param entity Entity?
---@param action ButtonAction
mod:AddCallback(ModCallbacks.MC_INPUT_ACTION, function (_, entity, _, action)
    if action ~= ButtonAction.ACTION_PILLCARD then return end
    local player = entity and entity:ToPlayer() 
    if not (player and player:GetPlayerType() == enums.PlayerType.PLAYER_JOSEPH) then return end

    local data = utility:GetData(player, "Enchanting")
    if data.ForceInput then
        data.ForceInput = false
        return true
    end
    return false
end, InputHook.IS_ACTION_TRIGGERED)


function Enchanting:ChargeBarRender(Meter,IsCharging,pos,sprite) --Function credit: Ginger
    if not Game():GetHUD ():IsVisible () then return end
    if not sprite then return end
    if Meter == nil then Meter = 0 end
    local charge_percentage = Meter
    local render_pos = pos
        if IsCharging == true then
            if charge_percentage < 99 then
                sprite:SetFrame("Charging", math.floor(charge_percentage))
            elseif sprite:IsFinished("Charged") or sprite:IsFinished("StartCharged") then
                if not sprite:IsPlaying("Charged") then
                    sprite:Play("Charged", true)
                end
            elseif not sprite:IsPlaying("Charged") then
                if not sprite:IsPlaying("StartCharged") then
                    sprite:Play("Charged", true)
                end
            end
        elseif not sprite:IsPlaying("Disappear") and not sprite:IsFinished("Disappear") then
            sprite:Play("Disappear", true)
        end
    sprite:Render(render_pos,Vector.Zero, Vector.Zero)
    sprite:Update()
end


function mod:PlayerInit(player)
    local data = utility:GetData(player, "Enchanting")
    data.Charge = CHARGE_DEFAULT
    local chargeSprite = Sprite()
    chargeSprite:Load("gfx/ui/card_chargebar.anm2",true)
    data.ChargeBar = chargeSprite
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mod.PlayerInit)