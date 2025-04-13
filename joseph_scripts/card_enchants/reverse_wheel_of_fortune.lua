local ReverseWheelOfFortune = {}

local utility = JosephMod.utility
local enums = JosephMod.enums

local game = Game()

-- Adds another treasure room to the floor at a random valid location.
function ReverseWheelOfFortune:AddAnotherDiceRoomToTheFloorAtARandomValidLocation()
    local level = game:GetLevel()

    local dimension = -1  -- current dimension
    local seed = level:GetDungeonPlacementSeed()

    -- Fetch a random RoomConfig for a new treasure room.
    local roomConfig = RoomConfigHolder.GetRandomRoom(seed, true, StbType.SPECIAL_ROOMS, RoomType.ROOM_DICE, RoomShape.ROOMSHAPE_1x1)

    -- Disallow placements with multiple doors, or placements that connect to other special rooms.
    local allowMultipleDoors = false
    local allowSpecialNeighbors = false

    -- Fetch all valid locations.
    local options = level:FindValidRoomPlacementLocations(roomConfig, dimension, allowMultipleDoors, allowSpecialNeighbors)

    for _, gridIndex in pairs(options) do
        -- You may have additional conditions or priorities when it comes to where you would prefer to place your room.
        -- For the purposes of this example we arbitarily forbid the new room from being connected to the starting room,
        -- and otherwise just place the room at the first place we check.

        -- Get the RoomDescriptors of all rooms that would be neighboring the room if placed here.
        local neighbors = level:GetNeighboringRooms(gridIndex, roomConfig.Shape, dimension)

        local connectsToStartingRoom = false

        for doorSlot, neighborDesc in pairs(neighbors) do
            if neighborDesc.GridIndex == level:GetStartingRoomIndex() then
                connectsToStartingRoom = true
            end
        end

        if not connectsToStartingRoom then
            -- Try to place the room.
            local room = level:TryPlaceRoom(roomConfig, gridIndex, dimension, seed, allowMultipleDoors, allowSpecialNeighbors)
            if room then
                -- The room was placed successfully!
                return
            end
        end
    end
end

-- ---@param player EntityPlayer
---@param card Card
function ReverseWheelOfFortune:initReverseWheelOfFortune(player, card, firstTime)
    if not firstTime then return end
    ReverseWheelOfFortune:AddAnotherDiceRoomToTheFloorAtARandomValidLocation()

end
JosephMod:AddCallback(enums.Callbacks.JOSEPH_POST_ENCHANT_ADD, ReverseWheelOfFortune.initReverseWheelOfFortune, Card.CARD_REVERSE_WHEEL_OF_FORTUNE)
JosephMod:AddCallback(enums.Callbacks.JOSEPH_GAME_START_ENCHANT_REFRESH, ReverseWheelOfFortune.initReverseWheelOfFortune, Card.CARD_REVERSE_WHEEL_OF_FORTUNE)

---@param player EntityPlayer
---@param card Card
---@param slot CardSlot
function ReverseWheelOfFortune:removeReverseWheelOfFortune(player, card, slot)

end
JosephMod:AddCallback(enums.Callbacks.JOSEPH_POST_ENCHANT_REMOVE, ReverseWheelOfFortune.removeReverseWheelOfFortune, Card.CARD_REVERSE_WHEEL_OF_FORTUNE)