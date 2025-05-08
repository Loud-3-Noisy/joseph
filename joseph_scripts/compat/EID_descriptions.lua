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
			description = "{{Card}} Consumes the currently held Tarot Card, enchanting it onto Isaac while being held#{{Card}} Enchanting a new card will remove the previous enchant's effect",
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
			description = "{{Card}} Shreds the currently selected card from Isaac's consumable slot, permanently removing that card from the pool for the rest of the run, and spawns 5 random pickups",
		},
	},
    [enums.Collectibles.ACE_OF_HEARTS] = {
		en_us = {
			name = "Ace of Hearts",
			description = "All {{Heart}} Heart pickups are replaced with {{Card}} Cards.",
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
}
--PICKUP Cards
descriptions.Cards = {
	[enums.Cards.THE_AEON] = {
		en_us = {
			name = "XX - The Aeon",
			description = "Brings Isaac back to the previous room and reverses all actions done in the room the card was used in",
		},
	},
}
--ENCHANT DESCRIPTIONS
descriptions.Enchants = {
    ENCHANT_HEADER = {
        en_us = {
            description = "{{EnchantIcon}} {{ColorPurpleGlow}}When enchanted: "
        },
    },
    ZERO = {
        en_us = {
            description = "{{Warning}} {{ColorLime}}0%{{CR}} Disenchant Chance "
        },
    },
    LOW = {
        en_us = {
            description = "{{Warning}} {{ColorGreen}}LOW{{CR}} Disenchant Chance"
        },
    },
    MED = {
        en_us = {
            description = "{{Warning}} {{ColorYellow}}MEDIUM{{CR}} Disenchant Chance"
        },
    },
    HIGH = {
        en_us = {
            description = "{{Warning}} {{ColorRed}}HIGH{{CR}} Disenchant Chance"
        },
    },
    HUNDRED = {
        en_us = {
            description = "{{Warning}} {{ColorRed}}100%{{CR}} Disenchant Chance"
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
            description = "↑ {{Speed}} +0.3 Speed#↑ {{Damage}} {{ColorYellow}}+1 Damage"
        },
    },
    [Card.CARD_EMPEROR] = {
        en_us = {
            description = "{{BossRoom}} Allows Isaac to choose between 2 items after beating a boss"
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
            description = "{{Chargeable}} Activates the effect of {{Card8}} The Chariot by constantly moving for 10 seconds"
        },
    },
    [Card.CARD_JUSTICE] = {
        en_us = {
            description = "{{Card9}} 14% chance to proc the effect of Justice on room clear, first room is guaranteed#{{Warning}} Not all pickups may spawn"
        },
    },
    [Card.CARD_HERMIT] = {
        en_us = {
            description = "{{Shop}} Opens a trapdoor in every Shop#The trapdoor leads to an underground shop that sells trinkets, runes, cards, special hearts and items from any pool"
        },
    },
    [Card.CARD_WHEEL_OF_FORTUNE] = {
        en_us = {
            description = "{{Collectible" .. enums.Collectibles.LIL_SLOT_MACHINE .. "}} Spawns a Lil Slot Machine Familiar#{{Collectible" .. enums.Collectibles.LIL_FORTUNE_TELLER .. "}} or a Lil Fortune Teller Familiar"
        },
    },
    [Card.CARD_STRENGTH] = {
        en_us = {
            description = "↑ {{Speed}} +0.3 Speed#↑ {{Damage}} +0.3 Damage#↑ {{Damage}} {{ColorYellow}}x1.25 Damage multiplier#↑ {{Range}} +5.25 Range#↑ +0.5 Tear height"
        },
    },
    [Card.CARD_HANGED_MAN] = {
        en_us = {
            description = "Permanent Flight"
        },
    },
    [Card.CARD_DEATH] = {
        en_us = {
            description = "{{Collectible265}} Spawns a Dry Baby"
        },
    },
    [Card.CARD_TEMPERANCE] = {
        en_us = {
            description = "{{Collectible" .. enums.Collectibles.LIL_BLOOD_BANK .. "}}Spawns a Lil Blood Bank Familiar"
        },
    },
    [Card.CARD_DEVIL] = {
        en_us = {
            description = "↑ {{Damage}} {{ColorYellow}}+1.5 Damage"
        },
    },
    [Card.CARD_TOWER] = {
        en_us = {
            description = "{{Warning}} Taking damage spawns 6 Troll Bombs#The Troll Bombs inherit Isaac's bomb effects"
        },
    },
    [Card.CARD_STARS] = {
        en_us = {
            description = "{{TreasureRoom}} Allows Isaac to choose between 2 items in treasure rooms"
        },
    },
    [Card.CARD_MOON] = {
        en_us = {
            description = "Adds an extra {{SecretRoom}} Secret Room and {{SuperSecretRoom}} Super Secret Room to each floor#Reveals one Secret Room each floor#{{Timer}} Secret Rooms contain a beam of light that grant for the floor:#↑ {{Tears}} +0.5 Fire rate#↑ {{Tears}} Additional +0.5 Fire rate from the first beam per floor#{{HalfSoulHeart}} Half a Soul Heart"
        },
    },
    [Card.CARD_SUN] = {
        en_us = {
            description = "{{Burning}} Entering a room burns all enemies#When the floor boss is defeated, receive for the floor:#↑ {{Damage}} +3 Damage#↑ {{Luck}} +1 Luck#{{Card20}} The Sun effect#{{Battery}} Fully recharges the active item#{{CurseBlind}} Removes any curses"
        }
    },
    [Card.CARD_JUDGEMENT] = {
        en_us = {
            description = "{{Collectible144}} Spawns a Bum Friend Familiar#{{Collectible278}} or a Dark Bum Familiar"
        },	
    },
        [Card.CARD_WORLD] = {
        en_us = {
            description = "Full mapping effect for each floor (except {{SuperSecretRoom}} Super Secret Room)"
        },
    },
    [Card.CARD_REVERSE_FOOL] = {
        en_us = {
            description = "Taking damage makes Isaac drop 3-5 coins, bombs or keys#The pickups can be replaced with other variants, such as golden keys, nickels, dimes, etc# 40% chance for Coins and bombs to be dropped as {{Collectible74}} The Quarter or {{Collectible19}} Boom! if possible)"
        },
    },
    [Card.CARD_REVERSE_MAGICIAN] = {
        en_us = {
            description = "Grants an aura that repels enemies and projectiles"
        },
    },
    [Card.CARD_REVERSE_HIGH_PRIESTESS] = {
        en_us = {
            description = "{{Card58}} Removes the 60 second time limit from the effect of The Highpriestess? :)"
        },
    },
    [Card.CARD_REVERSE_EMPRESS] = {
        en_us = {
            description = "↑ {{Heart}} +2 Health#↑ {{Tears}} {{ColorYellow}}+1 Fire rate#↓ {{Speed}} -0.1 Speed"
        },
    },
    [Card.CARD_REVERSE_EMPEROR] = {
        en_us = {
            description = "{{Card60}} A Portal leading to The Emperor? Boss Room appears after defeating the Boss of the floor#stays open until you enter it"
        },
    },
    [Card.CARD_REVERSE_HIEROPHANT] = {
        en_us = {
            description = "{{EmptyBoneHeaet}} 14% chance to spawn a bone heart on room clear, first room is guaranteed"
        },
    },
    [Card.CARD_REVERSE_LOVERS] = {
        en_us = {
            description = "{{Collectible642}} Items are sometimes replaced with a Single Use Magic Skin"
        },
    },
    [Card.CARD_REVERSE_CHARIOT] = {
        en_us = {
            description = "{{Chargeable}} Activates the effect of {{Card63}} The Chariot? by standing still for 4 seconds"
        },
    },
    [Card.CARD_REVERSE_JUSTICE] = {
        en_us = {
            description = "25% chance to replace room clear reward with a gold chest"
        },
    },
    [Card.CARD_REVERSE_HERMIT] = {
        en_us = {
            description = "Touching any non coin pick up will turn them into a number of coins equal to their Shop value"
        },
    },
    [Card.CARD_REVERSE_WHEEL_OF_FORTUNE] = {
        en_us = {
            description = "{{DiceRoom}} Attempts to Spawn a Dice Room in a valid location"
        },
    },
    [Card.CARD_REVERSE_STRENGTH] = {
        en_us = {
            description = "{{Weakness}} Entering a room weakens all enemies for 10 seconds"
        },
    },
    [Card.CARD_REVERSE_HANGED_MAN] = {
        en_us = {
            description = "↓ {{Speed}} -0.1 Speed#Triple shot#{{Coin}} Killed enemies drop vanishing coins"
        },
    },
    [Card.CARD_REVERSE_DEATH] = {
        en_us = {
            description = "Enemies have a chance to spawn Bone entities on death"
        },
    },
    [Card.CARD_REVERSE_TEMPERANCE] = {
        en_us = {
            description = "{{Pill}} Entering a new room has a 20% Chance to force Isaac to eat a random pill#{{Collectible252}} Gives the effects of Little Baggy"
        },
    },
    [Card.CARD_REVERSE_DEVIL] = {
        en_us = {
            description = "Grants Flight#{{Collectible390}} Spawns a Seraphim familiar"
        },
    },
    [Card.CARD_REVERSE_TOWER] = {
        en_us = {
            description = "{{Card72}} Taking damage activates the effect of The Tower?"
        },
    },
    [Card.CARD_REVERSE_STARS] = {
        en_us = {
            description = "Hangs a golden sword above Isaac's head, which doubles all pedestal items#{{Warning}} After taking any damage, the sword will fall and deal 3 hearts of non-lethal damage to Isaac, rerolling all his passive items#Invincibility effects can prevent the damage, but your items will still be rerolled"
        },
    },
    [Card.CARD_REVERSE_MOON] = {
        en_us = {
            description = "Clearing a room will create a Red Key room if possible#50% chance to occur when in a red room"
        },
    },
    [Card.CARD_REVERSE_SUN] = {
        en_us = {
            description = "#↑ {{Damage}} {{ColorYellow}}+1 Damage#Flight and spectral tears#{{BoneHeart}} Converts heart containers into Bone Hearts (reverts)#{{CurseDarkness}} Curse of Darkness"
        },
    },
    [Card.CARD_REVERSE_JUDGEMENT] = {
        en_us = {
            description = "Item pedestals will now cycle between 2 random items"
        },
    },
    [Card.CARD_REVERSE_WORLD] = {
        en_us = {
            description = "{{LadderRoom}} Spawns a trap door to a crawlspace in the starting room"
        },
    },

}

return descriptions