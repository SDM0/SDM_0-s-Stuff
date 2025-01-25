SMODS.Atlas{
    key = "sdm_bakery",
    path = "sdm_bakery.png",
    px = 71,
    py = 95
}

SMODS.ConsumableType {
    key = 'Bakery',
    collection_rows = { 5, 6 },
    primary_colour = HEX('e69138'),
    secondary_colour = HEX('ff7f00'),
    default = "c_sdm_bread",
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

SMODS.UndiscoveredSprite {
    key = 'Bakery',
    atlas = 'Tarot',
    prefix_config = {atlas = false},
    pos = {x = 5, y = 2}
}

-- Bread --

SMODS.Consumable{
    key = 'bread',
    name = 'Bread',
    set = 'Bakery',
    pos = {x = 0, y = 0},
    cost = 4,
    config = {extra = {chips = 30, triggers = 3}},
    loc_vars = function(self, info_queue, card)
        return {vars = {self.config.extra.chips, self.config.extra.triggers}}
    end,
    can_use = function(self, card, area, copier)
        return true
    end,
    use = function(self, card)
        if not G.GAME.bakery then G.GAME.bakery = {} end
        table.insert(G.GAME.bakery, {type = "chips", amount = card.ability.extra.chips, triggers = card.ability.extra.triggers})
    end,
    atlas = "sdm_bakery"
}

-- TODO: Do a Mult and Xmult bakery good, figure out a rarity system, make a booster pack, add config for both bakery (and bakery booster pack?)