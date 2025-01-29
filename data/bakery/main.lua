SMODS.ConsumableType {
    key = 'Bakery',
    collection_rows = { 5, 6 },
    primary_colour = HEX('e69138'),
    secondary_colour = HEX('ff7f00'),
    default = "c_sdm_pita",
    rarities = {
        { key = "Common" },
        { key = "Uncommon" },
        { key = "Rare" },
    },
    loc_txt = {
        name = 'Bakery',
 		collection = 'Bakery Goods',
        undiscovered = {
            name = 'Not Discovered',
            text = {
                "Purchase or use",
                "this card in an",
                "unseeded run to",
                "learn what it does"
            },
        },
    },
}

SMODS.load_file("data/bakery/consumables.lua")()
SMODS.load_file("data/bakery/boosters.lua")()
--SMODS.load_file("data/bakery/tags.lua")() -- TODO: Make a tag for Mega Bakery Booster