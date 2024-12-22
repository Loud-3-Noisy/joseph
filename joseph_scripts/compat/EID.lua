if not EID then return end

local Enums = JosephMod.enums
local josephType = Isaac.GetPlayerTypeByName("Joseph", false)
local Descriptions = include("joseph_scripts.compat.EID_descriptions")


local icons = Sprite()
icons:Load("gfx/ui/EID_icon.anm2", true)
EID:addIcon("Player"..josephType, "Joseph", 0, 16, 16, 5, 6, icons)
EID:addIcon("EnchantIcon", "Enchant", 0, 16, 16, 5, 6, icons)

EID:setModIndicatorName("Joseph ")
EID:setModIndicatorIcon("Player"..josephType)


EID:addBirthright(josephType,
    "Adds an additional permanent card enchant slot." ..
    "#The currently enchanted card will automatically be placed into this slot."

)

EID:addColor("ColorPurpleGlow", nil, function(color)
    local maxAnimTime = 60
    local frameCount = Game():GetFrameCount()
    local targetColor = { r = 124 / 255, g = 28 / 255, b = 135 / 255, a = 1 }
    local whiteColor = { r = 1, g = 1, b = 1, a = 1 }
    local oscillation = (math.sin((frameCount / maxAnimTime) * math.pi * 2) + 1) / 2

    local r = whiteColor.r * (1 - oscillation) + targetColor.r * oscillation
    local g = whiteColor.g * (1 - oscillation) + targetColor.g * oscillation
    local b = whiteColor.b * (1 - oscillation) + targetColor.b * oscillation
    local a = whiteColor.a * (1 - oscillation) + targetColor.a * oscillation
  
    color = EID:copyKColor(color) or EID:getTextColor()

    color = KColor(r, g, b, a)

    return color
end
)


-- Enchants

    local function shouldDisplayEnchantDescription(descObj)
        if descObj and descObj.ObjType == 5 and descObj.ObjVariant == 300 and Descriptions.Enchants[descObj.ObjSubType] then
            if (descObj.Entity ~= nil) then
                if PlayerManager.AnyoneIsPlayerType(josephType) or PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_BLANK_CARD) then return true end
            else
                if EID.holdTabPlayer and EID.holdTabPlayer:ToPlayer():GetPlayerType() == josephType or EID.holdTabPlayer:ToPlayer():HasCollectible(CollectibleType.COLLECTIBLE_BLANK_CARD) then return true end
            end
        end
    end
    local function getDescription(descObj)
        local lang = EID:getLanguage()
        local translatedHeader = Descriptions.Enchants["ENCHANT_HEADER"][lang].description or Descriptions.Enchants[descObj.ObjSubType]["en_us"].description or ""
        local translatedDescription = Descriptions.Enchants[descObj.ObjSubType][lang].description or Descriptions.Enchants[descObj.ObjSubType]["en_us"].description or "Enchant description unavailable"
        
        EID:appendToDescription(descObj, "#" .. translatedHeader .. "#" .. translatedDescription)
        return descObj
    end

    EID:addDescriptionModifier("CardEnchant", shouldDisplayEnchantDescription, getDescription)



-- Collectibles
for collectible, translations in pairs(Descriptions.Collectibles) do
    for language, description in pairs(translations) do
        EID:addCollectible(collectible, description.description, description.name, language)

        if description.abyss then
            if not EID.descriptions[language].abyssSynergies then
                EID.descriptions[language].abyssSynergies = {}
            end
            EID.descriptions[language].abyssSynergies[collectible] = description.abyss
        end

        if description.book_of_virtues then
            if not EID.descriptions[language].bookOfVirtuesWisps then
                EID.descriptions[language].bookOfVirtuesWisps = {}
            end
            EID.descriptions[language].bookOfVirtuesWisps[collectible] = description.book_of_virtues
        end

        if description.book_of_belial then
            if not EID.descriptions[language].bookOfBelialBuffs then
                EID.descriptions[language].bookOfBelialBuffs = {}
            end
            EID.descriptions[language].bookOfBelialBuffs[collectible] = description.book_of_belial
        end
    end
end

-- -- Trinkets
-- for trinket, translations in pairs(Descriptions.Trinkets) do
--     for language, description in pairs(translations) do
--         EID:addTrinket(trinket, description.description, description.name, language)

--         if description.double then
--             EID:addGoldenTrinketTable(trinket, { fullReplace = true })

--             if not EID.descriptions[language].goldenTrinketEffects then
--                 EID.descriptions[language].goldenTrinketEffects = {}
--             end

--             EID.descriptions[language].goldenTrinketEffects[trinket] = {
--                 description.description,
--                 description.double,
--                 description.triple or description.double
--             }
--         end
--     end
-- end

-- -- Pickups
-- for card, translations in pairs(Descriptions.Cards) do
--     for language, description in pairs(translations) do
--         EID:addCard(card, description.description, description.name, language)
--     end
-- end

-- -- Entities
-- for entity, translations in pairs(Descriptions.Entities) do
--     local tokens = TSIL.Utils.String.Split(entity, ".")
--     local type = tokens[1]
--     local variant = tokens[2] or 0
--     local subtype = tokens[3] or 0

--     for language, description in pairs(translations) do
--         EID:addEntity(
--             type,
--             variant,
--             subtype,
--             description.name,
--             description.description,
--             language
--         )
--     end
-- end



-- -- Special case for Soft Reset

-- local PICKUP_NAME = {
--     [PickupVariant.PICKUP_NULL] = {
--         en_us = "Nothing",
--         spa= "Nada"
--     },
--     [PickupVariant.PICKUP_COIN] = {
--         en_us = "coin",
--         spa = "moneda"
--     },
--     [PickupVariant.PICKUP_BOMB] = {
--         en_us = "bomb",
--         spa = "bomba"
--     },
--     [PickupVariant.PICKUP_KEY] = {
--         en_us = "key",
--         spa = "llave"
--     },
--     [PickupVariant.PICKUP_PILL] = {
--         en_us = "A pill",
--         spa = "Una píldora"
--     }
-- }

-- --Check if the target is soft reset
-- local function IsSoftReset(obj)
--     return obj.ObjType == EntityType.ENTITY_PICKUP
--         and obj.ObjVariant == PickupVariant.PICKUP_TRINKET
--         and obj.ObjSubType == Enums.Trinkets.SOFT_RESET
-- end


-- ---Appends an s to `str` if the amount is not 1.
-- ---@param str string
-- ---@param amount integer
-- ---@return string
-- local function MakePlural(str, amount)
--     if amount == 1 then
--         return str
--     else
--         return str .. "s"
--     end
-- end


-- ---Returns the pickup name according to the language.
-- ---@param variant PickupVariant
-- ---@return string
-- local function GetPickupName(variant)
--     local translations = PICKUP_NAME[variant]
--     if not translations then
--         translations = PICKUP_NAME[PickupVariant.PICKUP_NULL]
--     end

--     local eidLanguage = EID:getLanguage()

--     local name = translations[eidLanguage]
--     if not name then
--         name = translations["en_us"]
--     end

--     return name
-- end


-- ---Gets the description Soft Reset will have according to the pickups that
-- ---will spawn if the player holds Soft Reset.
-- ---@param player EntityPlayer
-- ---@return string
-- local function GetSoftResetDesc(player)
--     local playerType = player:GetPlayerType()
--     local playerConfig = EntityConfig.GetPlayer(playerType)

--     local SoftReset = MilkshakeVol2.Trinkets.SoftReset

--     --Get the amount of pickups
--     local coins = SoftReset:GetPickups(player, PickupVariant.PICKUP_COIN, function()
--         return playerConfig:GetCoins()
--     end)
--     local bombs = SoftReset:GetPickups(player, PickupVariant.PICKUP_BOMB, function()
--         return playerConfig:GetBombs()
--     end)
--     local keys = SoftReset:GetPickups(player, PickupVariant.PICKUP_KEY, function()
--         return playerConfig:GetKeys()
--     end)

--     local pill = SoftReset:GetPickups(player, PickupVariant.PICKUP_PILL, function()
--         return playerConfig:GetPill()
--     end)
--     local card = SoftReset:GetPickups(player, PickupVariant.PICKUP_TAROTCARD, function()
--         return playerConfig:GetCard()
--     end)
--     local trinket = SoftReset:GetPickups(player, PickupVariant.PICKUP_TRINKET, function()
--         return playerConfig:GetTrinket()
--     end)

--     --Put each description line together
--     local coinDesc = "#{{Coin}} " .. coins .. " " .. GetPickupName(PickupVariant.PICKUP_COIN)
--     local bombDesc = "#{{Bomb}} " .. bombs .. " " .. GetPickupName(PickupVariant.PICKUP_BOMB)
--     local keyDesc = "#{{Key}} " .. keys .. " " .. GetPickupName(PickupVariant.PICKUP_KEY)

--     local pillDesc = ""
--     if pill ~= 0 then
--         pillDesc = "#{{Pill" .. pill .. "}} " .. GetPickupName(PickupVariant.PICKUP_PILL)
--     end

--     local cardDesc = ""
--     if card ~= 0 then
--         local cardName = EID:getObjectName(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, card)
--         cardDesc = "#{{Card" .. card .. "}} " .. cardName
--     end

--     local trinketDesc = ""
--     if trinket ~= 0 then
--         local trinketName = EID:getObjectName(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, trinket)
--         trinketDesc = "#{{Trinket" .. trinket .. "}} " .. trinketName
--     end

--     coinDesc = MakePlural(coinDesc, coins)
--     bombDesc = MakePlural(bombDesc, bombs)
--     keyDesc = MakePlural(keyDesc, keys)

--     local final = ""

--     if coins >= 1 then final = final .. coinDesc end
--     if bombs >= 1 then final = final .. bombDesc end
--     if keys >= 1 then final = final .. keyDesc end

--     if not (pill == 0) then final = final .. pillDesc end
--     if not (card == 0) then final = final .. cardDesc end

--     if not (trinket == 0) then final = final .. trinketDesc end

--     final = final:sub(2)

--     if final:len() == 0 then
--         final = "{{UnknownHeart}} " .. GetPickupName(PickupVariant.PICKUP_NULL)
--     end

--     return final
-- end

-- ---Adds the pickups spawned by Soft Reset to the EID description.
-- local function AddPlayerDesc(obj)
--     local player = EID.holdTabPlayer
--     if obj.Entity then
--         player = Game():GetNearestPlayer(obj.Entity.Position)
--     end

--     EID:appendToDescription(obj,
--         "#{{Player" .. player:GetPlayerType() .. "}} {{ColorGray}}" .. player:GetName() ..
--         "#" .. GetSoftResetDesc(player:ToPlayer())
--     )
--     return obj
-- end

-- EID:addDescriptionModifier("MILKSHAKEVOL2_SoftResetDesc", IsSoftReset, AddPlayerDesc)