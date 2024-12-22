local descriptions = {}

local descriptions = {}
local enums = JosephMod.enums

--[[
    Available Languages:
        -English: "en_us"
        -Russian: "ru"
        -French: "fr"
        -Portuguese: "pt"
        -Spanish: "spa"
        -Polish: "pl"
        -Bulgarian: "bul"
        -Turkish: "turkish"
        -Korean: "ko_kr"
        -Chinese: "zh_cn"

    How to add more descriptions:
        1- Add a new entry in the corresponding list, like this:
            [enums.X.X] = {

            },
        2- Inside those curly braces { } add an entry for each language description, like this:
            [enums.X.X] = {
                language_code =
                    {
                        name = "name",
                        description = "description",
                    },
            },
        3- To add more languages to an item, just add more language entries, like this:
            [enums.X.X] = {
                language_code = {
                        name = "name",
                        description = "description",
                },
                language_code_2 = {
                        name = "name 2",
                        description = "description 2",
                },
            },

    The language_code is the thing between quotes in the language list.
    To check what enum value correspond to the item, check the enums.lua file.
    Don't forget to add all the commas!
]]

local josephType = Isaac.GetPlayerTypeByName("Joseph", false)

--COLLECTIBLE DESCRIPTIONS
descriptions.Collectibles = {
    [enums.Collectibles.LIL_SLOT_MACHINE] = {
        en_us = {
            name = "Lil Slot Machine",
            description = "Goes around the room collecting coins and dropping pickups every few coins collected."
        },
    },

}

descriptions.Enchants = {
    ENCHANT_HEADER = {
        en_us = {
            description = "{{EnchantIcon}} {{ColorPurpleGlow}}When enchanted: "
        },
    },
    [Card.CARD_FOOL] = {
        en_us = {
            description = "In cleared rooms, spawns a portal that leads to a random unexplored non-special room"
        },
    },
    [Card.CARD_MAGICIAN] = {
        en_us = {
            description = "Permanent homing tears"
        }
    },
    [Card.CARD_HIGH_PRIESTESS] = {
        en_us = {
            description = "50% chance for Mom's foot to stomp down on entering a new room"
        }
    },
    [Card.CARD_EMPRESS] = {
        en_us = {
            description = "Placeholder"
        }
    },
    [Card.CARD_EMPEROR] = {
        en_us = {
            description = "Placeholder"
        }
    },
    [Card.CARD_HIEROPHANT] = {
        en_us = {
            description = "Placeholder"
        }
    },
    [Card.CARD_LOVERS] = {
        en_us = {
            description = "20% chance to spawn a bonus red heart on room clear"
        }
    },
    [Card.CARD_CHARIOT] = {
        en_us = {
            description = "Placeholder"
        }
    },
    [Card.CARD_JUSTICE] = {
        en_us = {
            description = "Placeholder"
        }
    },
    [Card.CARD_HERMIT] = {
        en_us = {
            description = "Placeholder"
        }
    },
    [Card.CARD_WHEEL_OF_FORTUNE] = {
        en_us = {
            description = "Placeholder"
        }
    },
    [Card.CARD_STRENGTH] = {
        en_us = {
            description = "Placeholder"
        }
    },
    [Card.CARD_HANGED_MAN] = {
        en_us = {
            description = "Placeholder"
        }
    },
    [Card.CARD_DEATH] = {
        en_us = {
            description = "Placeholder"
        }
    },
    [Card.CARD_TEMPERANCE] = {
        en_us = {
            description = "Placeholder"
        }
    },
    [Card.CARD_DEVIL] = {
        en_us = {
            description = "Placeholder"
        }
    },
    [Card.CARD_TOWER] = {
        en_us = {
            description = "Placeholder"
        }
    },
    [Card.CARD_STARS] = {
        en_us = {
            description = "Placeholder"
        }
    },
    [Card.CARD_MOON] = {
        en_us = {
            description = "Placeholder"
        }
    },
    [Card.CARD_SUN] = {
        en_us = {
            description = "Placeholder"
        }
    },
    [Card.CARD_JUDGEMENT] = {
        en_us = {
            description = "Placeholder"
        }
    },
        [Card.CARD_WORLD] = {
        en_us = {
            description = "Placeholder"
        }
    },
    [Card.CARD_REVERSE_FOOL] = {
        en_us = {
            description = "Placeholder"
        }
    },
    [Card.CARD_REVERSE_MAGICIAN] = {
        en_us = {
            description = "Placeholder"
        }
    },
    [Card.CARD_REVERSE_HIGH_PRIESTESS] = {
        en_us = {
            description = "Placeholder"
        }
    },
    [Card.CARD_REVERSE_EMPRESS] = {
        en_us = {
            description = "Placeholder"
        }
    },
    [Card.CARD_REVERSE_EMPEROR] = {
        en_us = {
            description = "Placeholder"
        }
    },
    [Card.CARD_REVERSE_HIEROPHANT] = {
        en_us = {
            description = "Placeholder"
        }
    },
    [Card.CARD_REVERSE_LOVERS] = {
        en_us = {
            description = "Placeholder"
        }
    },
    [Card.CARD_REVERSE_CHARIOT] = {
        en_us = {
            description = "Placeholder"
        }
    },
    [Card.CARD_REVERSE_JUSTICE] = {
        en_us = {
            description = "Placeholder"
        }
    },
    [Card.CARD_REVERSE_HERMIT] = {
        en_us = {
            description = "Placeholder"
        }
    },
    [Card.CARD_REVERSE_WHEEL_OF_FORTUNE] = {
        en_us = {
            description = "Placeholder"
        }
    },
    [Card.CARD_REVERSE_STRENGTH] = {
        en_us = {
            description = "Placeholder"
        }
    },
    [Card.CARD_REVERSE_HANGED_MAN] = {
        en_us = {
            description = "Placeholder"
        }
    },
    [Card.CARD_REVERSE_DEATH] = {
        en_us = {
            description = "Placeholder"
        }
    },
    [Card.CARD_REVERSE_TEMPERANCE] = {
        en_us = {
            description = "Placeholder"
        }
    },
    [Card.CARD_REVERSE_DEVIL] = {
        en_us = {
            description = "Placeholder"
        }
    },
    [Card.CARD_REVERSE_TOWER] = {
        en_us = {
            description = "Placeholder"
        }
    },
    [Card.CARD_REVERSE_STARS] = {
        en_us = {
            description = "Placeholder"
        }
    },
    [Card.CARD_REVERSE_MOON] = {
        en_us = {
            description = "Placeholder"
        }
    },
    [Card.CARD_REVERSE_SUN] = {
        en_us = {
            description = "Placeholder"
        }
    },
    [Card.CARD_REVERSE_JUDGEMENT] = {
        en_us = {
            description = "Placeholder"
        }
    },
    [Card.CARD_REVERSE_WORLD] = {
        en_us = {
            description = "Placeholder"
        }
    },

}

return descriptions