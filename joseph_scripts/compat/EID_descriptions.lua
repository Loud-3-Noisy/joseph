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
            description = "Permanent Homing Tears, but no range up"
        }
    },
    [Card.CARD_HIGH_PRIESTESS] = {
        en_us = {
            description = "50% chance for Mom's foot to stomp down on entering a new room"
        }
    },
    [Card.CARD_EMPRESS] = {
        en_us = {
            description = "Permanent Whore of Babylon state, with reduced stats"
        }
    },
    [Card.CARD_EMPEROR] = {
        en_us = {
            description = "Grants the effects of There's Options"
        }
    },
    [Card.CARD_HIEROPHANT] = {
        en_us = {
            description = "13% chance to spawn a bonus Soul Heart on room clear, first room is guaranteed"
        }
    },
    [Card.CARD_LOVERS] = {
        en_us = {
            description = "20% chance to spawn a bonus Red Heart on room clear, first room is guaranteed"
        }
    },
    [Card.CARD_CHARIOT] = {
        en_us = {
            description = "Upon room entry, continuously move for 10 seconds to become invincible"
        }
    },
    [Card.CARD_JUSTICE] = {
        en_us = {
            description = "14% chance to proc Justice effect on room clear, first room is guaranteed"
        }
    },
    [Card.CARD_HERMIT] = {
        en_us = {
            description = "Spawns a trapdoor in shops to an underground shop"
        }
    },
    [Card.CARD_WHEEL_OF_FORTUNE] = {
        en_us = {
            description = "Spawns a Lil Slot Machine Familiar or a Lil Fortune Teller"
        }
    },
    [Card.CARD_STRENGTH] = {
        en_us = {
            description = "Permanent all stat up, but not as strong as normal Strength."
        }
    },
    [Card.CARD_HANGED_MAN] = {
        en_us = {
            description = "Permanent Flight"
        }
    },
    [Card.CARD_DEATH] = {
        en_us = {
            description = "Spawns a Dry Baby"
        }
    },
    [Card.CARD_TEMPERANCE] = {
        en_us = {
            description = "Spawns a Lil Blood Machine"
        }
    },
    [Card.CARD_DEVIL] = {
        en_us = {
            description = "Permanent Beilial state, but with reduced stats"
        }
    },
    [Card.CARD_TOWER] = {
        en_us = {
            description = "Curse of the Tower lol"
        }
    },
    [Card.CARD_STARS] = {
        en_us = {
            description = "Grants the effects of More Options"
        }
    },
    [Card.CARD_MOON] = {
        en_us = {
            description = "Grants the effects of Luna"
        }
    },
    [Card.CARD_SUN] = {
        en_us = {
            description = "Grants the effects of Sol + All enemies are inflicted with burn status"
        }
    },
    [Card.CARD_JUDGEMENT] = {
        en_us = {
            description = "Spawns a Bum Friend or a Dark Bum"
        }
    },
        [Card.CARD_WORLD] = {
        en_us = {
            description = "It's the World, but permanent..."
        }
    },
    [Card.CARD_REVERSE_FOOL] = {
        en_us = {
            description = "Getting hit drops 3-5 pickups, with a 40% chance to drop the quarter if you have over 25 coins (or the other item drops reverse fool can drop)"
        }
    },
    [Card.CARD_REVERSE_MAGICIAN] = {
        en_us = {
            description = "Grants the effect of The Soul"
        }
    },
    [Card.CARD_REVERSE_HIGH_PRIESTESS] = {
        en_us = {
            description = "Lol lmao"
        }
    },
    [Card.CARD_REVERSE_EMPRESS] = {
        en_us = {
            description = "Trans your gender"
        }
    },
    [Card.CARD_REVERSE_EMPEROR] = {
        en_us = {
            description = "A Portal to another boss appears after defeating the boss of the floor, stays open until you enter it"
        }
    },
    [Card.CARD_REVERSE_HIEROPHANT] = {
        en_us = {
            description = "14% chance to spawn a bone heart on room clear, first room is guaranteed"
        }
    },
    [Card.CARD_REVERSE_LOVERS] = {
        en_us = {
            description = "Items are sometimes replaced with a Single Use Magic Skin"
        }
    },
    [Card.CARD_REVERSE_CHARIOT] = {
        en_us = {
            description = "Upon room entry, stand still for 4 sconds to become statue"
        }
    },
    [Card.CARD_REVERSE_JUSTICE] = {
        en_us = {
            description = "25% chance to replace room clear reward with a gold chest"
        }
    },
    [Card.CARD_REVERSE_HERMIT] = {
        en_us = {
            description = "Anything you touch that isn't coins, becomes coins"
        }
    },
    [Card.CARD_REVERSE_WHEEL_OF_FORTUNE] = {
        en_us = {
            description = "While Enchanted, newly generated floors will contain dice rooms"
        }
    },
    [Card.CARD_REVERSE_STRENGTH] = {
        en_us = {
            description = "Permanent reverse strength but you also get a 0.75x damage multiplier"
        }
    },
    [Card.CARD_REVERSE_HANGED_MAN] = {
        en_us = {
            description = "Permanent reverse hanged man but the dropped coins are disappearing and slight tears down"
        }
    },
    [Card.CARD_REVERSE_DEATH] = {
        en_us = {
            description = "Enemies have a chance to spawn bone orbitals, spurs, and friendly bonies on death"
        }
    },
    [Card.CARD_REVERSE_TEMPERANCE] = {
        en_us = {
            description = "20% Chance to take a random pill on room entry. Gives effect of Little baggy"
        }
    },
    [Card.CARD_REVERSE_DEVIL] = {
        en_us = {
            description = "Permanent Reverse Devil"
        }
    },
    [Card.CARD_REVERSE_TOWER] = {
        en_us = {
            description = "Nothing yet"
        }
    },
    [Card.CARD_REVERSE_STARS] = {
        en_us = {
            description = "All newly generated item pedestals are doubled, but getting hit instantly disenchants the card, deals 3 full hearts of non-lethal damage, and activates a D4 effect"
        }
    },
    [Card.CARD_REVERSE_MOON] = {
        en_us = {
            description = "On Room clear, spawns a red room if possible on an random adjacent wall. 50% chance to spawn one instead if already in a red room."
        }
    },
    [Card.CARD_REVERSE_SUN] = {
        en_us = {
            description = "Permanent Reverse Sun but -0.5 damage (+1 total)"
        }
    },
    [Card.CARD_REVERSE_JUDGEMENT] = {
        en_us = {
            description = "Busted"
        }
    },
    [Card.CARD_REVERSE_WORLD] = {
        en_us = {
            description = "Nothing yet"
        }
    },

}

return descriptions