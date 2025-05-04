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
            description = "{{Coin}} Picks up nearby coins#Spawns {{Slotmachine}} Slot Machine drops every 3 coins",
        },
    },
	[enums.Collectibles.LIL_FORTUNE_TELLER] = {
		en_us = {
			name = "Lil Fortune Teller",
			description = "{{Coin}} Picks up nearby coins#Spawns {{FortuneTeller}} Fortune Teller drops every 4 coins",
		},
	},	
	[enums.Collectibles.LIL_BLOOD_BANK] = {
		en_us = {
			name = "Lil Blood Machine",
			description = "{{Heart}} Picks up nearby Red Hearts#Spawns {{BloodDonationMachine}} Blood Donation Machine drops based on heart value",
		},
	},
	[enums.Collectibles.SCRAWL] = {
		en_us = {
			name = "Scrawl",
			description = "{{Card}} Entering a room with enemies Spawns 1 card#{{Card}} Cards will now vanish when attempting to drop them on the floor",
		},
	},
	[enums.Collectibles.POKER_MAT] = {
		en_us = {
			name = "Poker Mat",
			description = "{{Card}} Spawns a card #{{RedCard}} Playing card effects are doubled or enhanced",
		},
	},
	[enums.Collectibles.SOUL_OF_ENVY] = {
		en_us = {
			name = "Soul of Envy",
			description = "↑ +1 damage up for each consumable at a count of 0#the damage up decreases the more pickups Isaac have, returning to +0 at:#{{Blank}} {{Coin}} 15 coins#{{Blank}} {{Bomb}} 5 bombs#{{Blank}} {{Key}} 5 keys",
		},
	},
	[enums.Collectibles.CARD_SLEEVE] = {
		en_us = {
			name = "Card Sleeve",
			description = "{{Card}} Consumes the currently held Tarot Card, enchancting it onto Isaac permanently#{{Card}} Enchanting a new card will remove the previous enchant's effect",
		},
	},
	[enums.Collectibles.CALENDAR] = {
		en_us = {
			name = "Calendar",
			description = "Boosts a stat based on the day of the week:#{{Blank}} Sun: ↑ +1 Damage up#{{Blank}} Mon: ↑ +0.7 Tears up#{{Blank}} Tue: ↑ +1 Damage up#{{Blank}} Wed: ↑ +0.3 Speed up#{{Blank}} Thur: ↑ +1 Health up#{{Blank}} Fri: ↑ +1 Health up#{{Blank}} Sat: ↑ +0.7 Tears up",
		},
	},
	[enums.Collectibles.SHREDDER] = {
		en_us = {
			name = "Shredder",
			description = "{{Card}} Shreds the currenlty selected card from Isaac's Consumable slot, permanantly removing that card from the pool for the rest of the run, and spawns 5 random pickups",
		},
	},
	
}
--TRINKET DESCRIPTIONS
descriptions.Trinkets = {	
	[enums.Trinkets.CUPPA_JOE] = {
		en_us = {
			name = "Cup of Joe",
			description = "Does not spawn normally, instead will randomly appear in an empty trinket slot upon leaving a room it would have spawned in#Copies the effect of the last item you picked up#Changes upon picking up a new item",
		},
	},
	[enums.Trinkets.EAR_OF_GRAIN] = {
		en_us = {
			name = "Ear of Grain",
			description = "Famine appears as an additional boss to fight upon entering a {{BossRoom}} boss room, and drops {{Collectible73}} cube of meat/{{Collectible207}} ball of bandages when killd#Famine's health scales per floor",
		},
	},
	[enums.Trinkets.ACE_OF_HEARTS] = {
		en_us = {
			name = "Ace of Hearts",
			description = "All {{Heart}} Heart pickups are replaced with {{Card}} Cards.",
		},
	},
	
}
--ENCHANT DESCRIPTIONS
descriptions.Enchants = {
    ENCHANT_HEADER = {
        en_us = {
            description = "{{ColorPurpleGlow}}When enchanted: "
        },
    },
    ZERO = {
        en_us = {
            description = "{{ColorLime}}0% "
        },
    },
    LOW = {
        en_us = {
            description = "{{ColorGreen}}LOW{{CR}} Disenchant Chance"
        },
    },
    MED = {
        en_us = {
            description = "{{ColorYellow}}MEDIUM{{CR}} Disenchant Chance"
        },
    },
    HIGH = {
        en_us = {
            description = "{{ColorRed}}HIGH{{CR}} Disenchant Chance"
        },
    },
    HUNDRED = {
        en_us = {
            description = "{{ColorRed}}100%{{CR}} Disenchant Chance"
        },
    },
    [Card.CARD_FOOL] = {
        en_us = {
            description = "Spawns a Portal to an unexplored room when the room is clear of enemies"
        },
    },
    [Card.CARD_MAGICIAN] = {
        en_us = {
            description = "Homing Tears"
        },
    },
    [Card.CARD_HIGH_PRIESTESS] = {
        en_us = {
            description = "50% chance for Mom's foot to stomp on an enemy when entering a new room"
        },
    },
    [Card.CARD_EMPRESS] = {
        en_us = {
            description = "↑ {{Speed}} +0.3 Speed#↑ {{Damage}} +1 Damage"
        },
    },
    [Card.CARD_EMPEROR] = {
        en_us = {
            description = "Allows Isaac to choose between 2 items after beating a boss"
        },
    },
    [Card.CARD_HIEROPHANT] = {
        en_us = {
            description = "{{SoulHeart}} 13% chance to spawn a bonus Soul Heart on room clear, first room is guaranteed"
        },
    },
    [Card.CARD_LOVERS] = {
        en_us = {
            description = "{{Heart}} 20% chance to spawn a bonus Red Heart on room clear, first room is guaranteed"
        },
    },
    [Card.CARD_CHARIOT] = {
        en_us = {
            description = "{{Chargeable}} Activates the normal effect by constantly moving for 10 seconds"
        },
    },
    [Card.CARD_JUSTICE] = {
        en_us = {
            description = "14% chance to proc the above effect on room clear, first room is guaranteed#Not all pickups may spawn"
        },
    },
    [Card.CARD_HERMIT] = {
        en_us = {
            description = "{{Shop}} Opens a trapdoor in every Shop#The trapdoor leads to an underground shop that sells trinkets, runes, cards, special hearts and items from any pool"
        },
    },
    [Card.CARD_WHEEL_OF_FORTUNE] = {
        en_us = {
            description = "Spawns a Lil Slot Machine Familiar or a Lil Fortune Teller Familiar"
        },
    },
    [Card.CARD_STRENGTH] = {
        en_us = {
            description = "Permanent all stat up, but not as strong as normal Strength."
        },
    },
    [Card.CARD_HANGED_MAN] = {
        en_us = {
            description = "Permanent Flight"
        },
    },
    [Card.CARD_DEATH] = {
        en_us = {
            description = "Spawns a Dry Baby"
        },
    },
    [Card.CARD_TEMPERANCE] = {
        en_us = {
            description = "Spawns a Lil Blood Machine Familiar"
        },
    },
    [Card.CARD_DEVIL] = {
        en_us = {
            description = "Permanent Beilial state, but with reduced stats"
        },
    },
    [Card.CARD_TOWER] = {
        en_us = {
            description = "Curse of the Tower lol"
        },
    },
    [Card.CARD_STARS] = {
        en_us = {
            description = "Grants the effects of More Options"
        },
    },
    [Card.CARD_MOON] = {
        en_us = {
            description = "Grants the effects of Luna"
        },
    },
    [Card.CARD_SUN] = {
        en_us = {
            description = "Grants the effects of Sol + All enemies are inflicted with burn status"
        }
    },
    [Card.CARD_JUDGEMENT] = {
        en_us = {
            description = "Spawns a Bum Friend or a Dark Bum"
        },
    },
        [Card.CARD_WORLD] = {
        en_us = {
            description = "It's the World, but permanent..."
        },
    },
    [Card.CARD_REVERSE_FOOL] = {
        en_us = {
            description = "Getting hit drops 3-5 pickups, with a 40% chance to drop the quarter if you have over 25 coins (or the other item drops reverse fool can drop)"
        },
    },
    [Card.CARD_REVERSE_MAGICIAN] = {
        en_us = {
            description = "Grants the effect of The Soul"
        },
    },
    [Card.CARD_REVERSE_HIGH_PRIESTESS] = {
        en_us = {
            description = "Lol lmao"
        },
    },
    [Card.CARD_REVERSE_EMPRESS] = {
        en_us = {
            description = "Trans your gender"
        },
    },
    [Card.CARD_REVERSE_EMPEROR] = {
        en_us = {
            description = "A Portal to another boss appears after defeating the boss of the floor, stays open until you enter it"
        },
    },
    [Card.CARD_REVERSE_HIEROPHANT] = {
        en_us = {
            description = "14% chance to spawn a bone heart on room clear, first room is guaranteed"
        },
    },
    [Card.CARD_REVERSE_LOVERS] = {
        en_us = {
            description = "Items are sometimes replaced with a Single Use Magic Skin"
        },
    },
    [Card.CARD_REVERSE_CHARIOT] = {
        en_us = {
            description = "Upon room entry, stand still for 4 sconds to become statue"
        },
    },
    [Card.CARD_REVERSE_JUSTICE] = {
        en_us = {
            description = "25% chance to replace room clear reward with a gold chest"
        },
    },
    [Card.CARD_REVERSE_HERMIT] = {
        en_us = {
            description = "Anything you touch that isn't coins, becomes coins"
        },
    },
    [Card.CARD_REVERSE_WHEEL_OF_FORTUNE] = {
        en_us = {
            description = "Spawns a dice room in a valid location"
        },
    },
    [Card.CARD_REVERSE_STRENGTH] = {
        en_us = {
            description = "Permanent reverse strength but you also get a 0.75x damage multiplier"
        },
    },
    [Card.CARD_REVERSE_HANGED_MAN] = {
        en_us = {
            description = "Permanent reverse hanged man but the dropped coins are disappearing and slight tears down"
        },
    },
    [Card.CARD_REVERSE_DEATH] = {
        en_us = {
            description = "Enemies have a chance to spawn bone orbitals, spurs, and friendly bonies on death"
        },
    },
    [Card.CARD_REVERSE_TEMPERANCE] = {
        en_us = {
            description = "20% Chance to take a random pill on room entry. Gives effect of Little baggy"
        },
    },
    [Card.CARD_REVERSE_DEVIL] = {
        en_us = {
            description = "Permanent Reverse Devil"
        },
    },
    [Card.CARD_REVERSE_TOWER] = {
        en_us = {
            description = "Triggers Reverse Tower effect upon getting hit"
        },
    },
    [Card.CARD_REVERSE_STARS] = {
        en_us = {
            description = "All newly generated item pedestals are doubled, but getting hit instantly disenchants the card, deals 3 full hearts of non-lethal damage, and activates a D4 effect"
        },
    },
    [Card.CARD_REVERSE_MOON] = {
        en_us = {
            description = "On Room clear, spawns a red room if possible on an random adjacent wall. 50% chance to spawn one instead if already in a red room."
        },
    },
    [Card.CARD_REVERSE_SUN] = {
        en_us = {
            description = "Permanent Reverse Sun but -0.5 damage (+1 total)"
        },
    },
    [Card.CARD_REVERSE_JUDGEMENT] = {
        en_us = {
            description = "Item pedestals will now cycle between two options"
        },
    },
    [Card.CARD_REVERSE_WORLD] = {
        en_us = {
            description = "Spawns a crawlspace in the starting room"
        },
    },

}

return descriptions