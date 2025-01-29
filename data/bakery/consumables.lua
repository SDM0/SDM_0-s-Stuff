SMODS.Atlas{
    key = "sdm_bakery",
    path = "sdm_bakery.png",
    px = 71,
    py = 95
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
    rarity = 1,
    set = 'Bakery',
    pos = {x = 0, y = 0},
    cost = 4,
    config = {extra = {chips = 30, remaining = 5}},
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

SDM_0s_Stuff_Mod.modded_objects.c_sdm_pita = "Pita"

-- Sourdough --

SMODS.Consumable{
    key = 'sourdough',
    name = 'Sourdough',
    rarity = 1,
    set = 'Bakery',
    pos = {x = 0, y = 0},
    cost = 4,
    config = {extra = {mult = 15, remaining = 3}},
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

SDM_0s_Stuff_Mod.modded_objects.c_sdm_sourdough = "Sourdough"

-- Baguette --

SMODS.Consumable{
    key = 'baguette',
    name = 'Baguette',
    rarity = 1,
    set = 'Bakery',
    pos = {x = 0, y = 0},
    cost = 4,
    config = {extra = {X_mult = 1.5, remaining = 2}},
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

SDM_0s_Stuff_Mod.modded_objects.c_sdm_baguette = "Baguette"