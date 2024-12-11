local ReverseChariot = {}

local utility = JosephMod.utility
local enums = JosephMod.enums

local RECOMMENDED_SHIFT_IDX = 35
local chargeBarOffset = Vector(18,-5)
local chariotActived = {false, false, false, false}
local movementSpeedMaxThreshold = 0.3




---@param player EntityPlayer
---@param card Card
---@param slot CardSlot
function ReverseChariot:initReverseChariot(player, card, slot)

end
JosephMod:AddCallback(enums.Callbacks.JOSEPH_POST_ENCHANT_ADD, ReverseChariot.initReverseChariot, Card.CARD_REVERSE_CHARIOT)

---@param player EntityPlayer
---@param card Card
---@param slot CardSlot
function ReverseChariot:removeReverseChariot(player, card, slot)

end
JosephMod:AddCallback(enums.Callbacks.JOSEPH_POST_ENCHANT_REMOVE, ReverseChariot.removeReverseChariot, Card.CARD_REVERSE_CHARIOT)


function ReverseChariot:ReverseChariotNewRoom()
    for i = 0, Game():GetNumPlayers()-1 do
        local player = Game():GetPlayer(i)
        local playerIndex = TSIL.Players.GetPlayerIndex(player)

        chariotActived[playerIndex] = false
        local data = utility:GetData(player, "ReverseChariotCharge")
        data.Charge = 0
    end
end
JosephMod:AddCallback(TSIL.Enums.CustomCallback.POST_NEW_ROOM_REORDERED, ReverseChariot.ReverseChariotNewRoom)


function ReverseChariot:PlayerUpdate(player)
    local room = Game():GetRoom()
    if not room:IsFirstVisit() then return end
    if not utility:HasEnchantment(player, Card.CARD_REVERSE_CHARIOT) then return end

    local playerIndex = TSIL.Players.GetPlayerIndex(player)

    local data = utility:GetData(player, "ReverseChariotCharge")

    data.Chargebar = data.Chargebar or JosephMod.Chargebar()
    data.Charge = data.Charge or 0

    if chariotActived[playerIndex] == true then
        if player:GetEffects():GetNullEffectNum(NullItemID.ID_REVERSE_CHARIOT) >= 1 then
            data.Charge = 100
        else
            data.Charge = 0
        end
    else
        if player.Velocity:Length() <= movementSpeedMaxThreshold and player:GetMovementDirection() == -1 then
            data.Charge = math.min(100, data.Charge + 1)
        else
            data.Charge = math.max(0, data.Charge - 0.75)
        end
    end

    data.Chargebar:SetCharge(data.Charge, 100)


    if data.Charge == 100 and chariotActived[playerIndex] ~= true then
        player:UseCard(Card.CARD_REVERSE_CHARIOT, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
        chariotActived[playerIndex] = true
    end
end
JosephMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ReverseChariot.PlayerUpdate)


function ReverseChariot:Render()
    local room = Game():GetRoom()
    if not room:IsFirstVisit() then return end

    for i = 0, Game():GetNumPlayers()-1 do
        local player = Game():GetPlayer(i)
        ReverseChariot:PlayerRender(player)
    end
end
JosephMod:AddCallback(ModCallbacks.MC_POST_RENDER, ReverseChariot.Render)


function ReverseChariot:PlayerRender(player)
    -- Isaac.RenderText(player.Velocity:Length(), 60, 60, 1, 1, 1, 1)
    -- Isaac.RenderText(player.MoveSpeed*0.75, 60, 80, 1, 1, 1, 1)
    -- Isaac.RenderText(player:GetMovementDirection(), 60, 100, 1, 1, 1, 1)
    if not utility:HasEnchantment(player, Card.CARD_REVERSE_CHARIOT) then return end
    
    local data = utility:GetData(player, "ReverseChariotCharge")

    data.Chargebar = data.Chargebar or JosephMod.Chargebar()

    data.Chargebar:TryLoad("gfx/ui/chariot_chargebar.anm2")
    data.Chargebar:Render(Isaac.WorldToScreen(player.Position) + chargeBarOffset)
end
