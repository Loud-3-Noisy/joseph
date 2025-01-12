local JosephAchievements = {}

local enums = JosephMod.enums
local utility = JosephMod.utility
local JosephChar = JosephMod.josephCharacter


TSIL.SaveManager.AddPersistentVariable(
      JosephMod,
      "CardsUsed",
      {[Card.CARD_FOOL] = false,
      [Card.CARD_MAGICIAN] = false,
      [Card.CARD_HIGH_PRIESTESS] = false,
      [Card.CARD_EMPRESS] = false,
      [Card.CARD_EMPEROR] = false,
      [Card.CARD_HIEROPHANT] = false,
      [Card.CARD_LOVERS] = false,
      [Card.CARD_CHARIOT] = false,
      [Card.CARD_JUSTICE] = false,
      [Card.CARD_HERMIT] = false,
      [Card.CARD_WHEEL_OF_FORTUNE] = false,
      [Card.CARD_STRENGTH] = false,
      [Card.CARD_HANGED_MAN] = false,
      [Card.CARD_DEATH] = false,
      [Card.CARD_TEMPERANCE] = false,
      [Card.CARD_DEVIL] = false,
      [Card.CARD_TOWER] = false,
      [Card.CARD_STARS] = false,
      [Card.CARD_MOON] = false,
      [Card.CARD_SUN] = false,
      [Card.CARD_JUDGEMENT] = false,
      [Card.CARD_WORLD] = false,},
      TSIL.Enums.VariablePersistenceMode.NONE,
      false
)

local function allTrue(table)
    for i = 1, 22, 1 do
        print(i)
        print(table[i])
        if table[i] ~= true then return false end
    end
    return true
end

function JosephAchievements:UseCard(card, player, flags)
    local gameData = Isaac.GetPersistentGameData()
    if gameData:Unlocked(enums.Achievements.JOSEPH) then return end

    if not (card >= Card.CARD_FOOL and card <= Card.CARD_WORLD) then return end

    local cardsUsed = TSIL.SaveManager.GetPersistentVariable(JosephMod, "CardsUsed")
    cardsUsed[card] = true
    TSIL.SaveManager.SetPersistentVariable(JosephMod, "CardsUsed", cardsUsed)

    if allTrue(cardsUsed) then
        gameData:TryUnlock(enums.Achievements.JOSEPH)
    end

end
JosephMod:AddCallback(ModCallbacks.MC_USE_CARD, JosephAchievements.UseCard)






