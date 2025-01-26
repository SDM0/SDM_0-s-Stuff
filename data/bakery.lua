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

-- Pita --

SMODS.Consumable{
    key = 'pita',
    name = 'Pita',
    set = 'Bakery',
    pos = {x = 0, y = 0},
    cost = 4,
    config = {extra = {chips = 30, remaining = 3}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chips, card.ability.extra.remaining}}
    end,
    can_use = function(self, card, area, copier)
        return false
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and no_bp_retrigger(context) and context.after then
            return decrease_remaining_food(G, card)
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
            }
        end
    end,
    atlas = "sdm_bakery"
}

-- Sourdough --

SMODS.Consumable{
    key = 'sourdough',
    name = 'Sourdough',
    set = 'Bakery',
    pos = {x = 0, y = 0},
    cost = 4,
    config = {extra = {mult = 4, remaining = 3}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult, card.ability.extra.remaining}}
    end,
    can_use = function(self, card, area, copier)
        return false
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and no_bp_retrigger(context) and context.after then
            return decrease_remaining_food(G, card)
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult,
            }
        end
    end,
    atlas = "sdm_bakery"
}

-- Baguette --

SMODS.Consumable{
    key = 'baguette',
    name = 'Baguette',
    set = 'Bakery',
    pos = {x = 0, y = 0},
    cost = 4,
    config = {extra = {X_mult = 1.5, remaining = 3}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.X_mult, card.ability.extra.remaining}}
    end,
    can_use = function(self, card, area, copier)
        return false
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and no_bp_retrigger(context) and context.after then
            return decrease_remaining_food(G, card)
        end
        if context.joker_main then
            return {
                x_mult = card.ability.extra.X_mult,
            }
        end
    end,
    atlas = "sdm_bakery"
}

-- TODO: Figure out a rarity system, make a booster pack, add config for bakery (and bakery booster pack?)
-- Hide greyed "Use" button