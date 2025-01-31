SMODS.Atlas{
    key = "sdm_bakery_consumables",
    path = "bakery/sdm_bakery_consumables.png",
    px = 71,
    py = 95
}

SMODS.UndiscoveredSprite {
    key = 'Bakery',
    atlas = 'Tarot',
    prefix_config = {atlas = false},
    pos = {x = 5, y = 2}
}

-- Dough --

SMODS.Consumable{
    key = 'dough',
    name = 'Dough',
    set = 'Bakery',
    pos = {x = 0, y = 0},
    cost = 4,
    config = {extra = {dollars = 4, remaining = 5}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.dollars, card.ability.extra.remaining}}
    end,
    can_use = function(self, card, area, copier)
        return false
    end,
    --calc_dollar_bonus = function(self, card)
    --    local dollars = card.ability.extra.dollars
    --    decrease_remaining_food(G, card)
    --    return dollars
    --end,
    calculate = function(self, card, context)
        if context.end_of_round and not (context.individual or context.repetition) and no_bp_retrigger(context) then
            decrease_remaining_food(G, card)
        end
        if context.joker_main then
            return {
                dollars = card.ability.extra.dollars,
            }
        end
    end,
    atlas = "sdm_bakery"
}

SDM_0s_Stuff_Mod.modded_objects.c_sdm_dough = "Dough"

-- Pita --

SMODS.Consumable{
    key = 'pita',
    name = 'Pita',
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
        if context.end_of_round and not (context.individual or context.repetition) and no_bp_retrigger(context) then
            decrease_remaining_food(G, card)
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
    set = 'Bakery',
    pos = {x = 0, y = 0},
    cost = 4,
    config = {extra = {mult = 15, remaining = 5}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult, card.ability.extra.remaining}}
    end,
    can_use = function(self, card, area, copier)
        return false
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not (context.individual or context.repetition) and no_bp_retrigger(context) then
            decrease_remaining_food(G, card)
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
    set = 'Bakery',
    pos = {x = 0, y = 0},
    cost = 4,
    config = {extra = {X_mult = 1.5, remaining = 5}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.X_mult, card.ability.extra.remaining}}
    end,
    can_use = function(self, card, area, copier)
        return false
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not (context.individual or context.repetition) and no_bp_retrigger(context) then
            decrease_remaining_food(G, card)
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

-- Banana Bread --

SMODS.Consumable{
    key = 'banana_bread',
    name = 'Banana Bread',
    set = 'Bakery',
    pos = {x = 0, y = 0},
    cost = 4,
    config = {extra = {X_mult = 3, odds = 4}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.X_mult, ''..(G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds}}
    end,
    can_use = function(self, card, area, copier)
        return false
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not (context.individual or context.repetition) and no_bp_retrigger(context) then
            if pseudorandom('banabread') < G.GAME.probabilities.normal/card.ability.extra.odds then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                            func = function()
                                G.jokers:remove_card(card)
                                card:remove()
                                card = nil
                            return true; end}))
                        return true
                    end
                }))
                return {
                    message = localize('k_extinct_ex')
                }
            else
                return {
                    message = localize('k_safe_ex')
                }
            end
        end
        if context.joker_main then
            return {
                x_mult = card.ability.extra.X_mult,
            }
        end
    end,
    atlas = "sdm_bakery"
}

SDM_0s_Stuff_Mod.modded_objects.c_sdm_sourdough = "Sourdough"

-- Breadsticks --

SMODS.Consumable{
    key = 'breadsticks',
    name = 'Breadsticks',
    set = 'Bakery',
    pos = {x = 0, y = 0},
    cost = 4,
    config = {extra = {hands = 1, remaining = 4}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.hands, card.ability.extra.remaining}}
    end,
    can_use = function(self, card, area, copier)
        return false
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
            ease_hands_played(card.ability.extra.hand)
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if not from_debuff then
            G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
        end
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not (context.individual or context.repetition) and no_bp_retrigger(context) then
            decrease_remaining_food(G, card)
        end
    end,
    atlas = "sdm_bakery"
}

SDM_0s_Stuff_Mod.modded_objects.c_sdm_breadsticks = "Breadsticks"

-- Croissant --

SMODS.Consumable{
    key = 'croissant',
    name = 'Croissant',
    set = 'Bakery',
    pos = {x = 0, y = 0},
    cost = 4,
    config = {extra = {discards = 1, remaining = 4}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.discards, card.ability.extra.remaining}}
    end,
    can_use = function(self, card, area, copier)
        return false
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.discards
            ease_discard(card.ability.extra.discards)
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if not from_debuff then
            G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.discards
        end
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not (context.individual or context.repetition) and no_bp_retrigger(context) then
            decrease_remaining_food(G, card)
        end
    end,
    atlas = "sdm_bakery"
}

SDM_0s_Stuff_Mod.modded_objects.c_sdm_breadsticks = "Breadsticks"

-- Bread Loaf --

SMODS.Consumable{
    key = 'bread_loaf',
    name = 'Bread Loaf',
    set = 'Bakery',
    pos = {x = 0, y = 0},
    cost = 4,
    config = {extra = {handsize = 1, remaining = 3}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.handsize, card.ability.extra.remaining}}
    end,
    can_use = function(self, card, area, copier)
        return false
    end,
    add_to_deck = function(self, card, from_debuff)
        if G.hand then
            G.hand:change_size(card.ability.extra.handsize)
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if G.hand then
            G.hand:change_size(-card.ability.extra.handsize)
        end
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not (context.individual or context.repetition) and no_bp_retrigger(context) then
            decrease_remaining_food(G, card)
        end
    end,
    atlas = "sdm_bakery"
}

SDM_0s_Stuff_Mod.modded_objects.c_sdm_cake = "Cake"

-- Fortune Cookie --

SMODS.Consumable{
    key = 'fortune_cookie',
    name = 'Fortune Cookie',
    set = 'Bakery',
    pos = {x = 0, y = 0},
    cost = 4,
    config = {extra = {remaining = 3}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.remaining}}
    end,
    can_use = function(self, card, area, copier)
        return false
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not (context.individual or context.repetition) and no_bp_retrigger(context) then
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                        SMODS.add_card({set = 'Tarot', key_append = 'fck'})
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)}))
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = localize('k_plus_tarot'),
                    colour = G.C.SECONDARY_SET.Tarot,
                })
            end
            decrease_remaining_food(G, card)
        end
    end,
    atlas = "sdm_bakery"
}

SDM_0s_Stuff_Mod.modded_objects.c_sdm_fortune_cookie = "Fortune Cookie"

-- Moon Cake --

SMODS.Consumable{
    key = 'moon_cake',
    name = 'Moon Cake',
    set = 'Bakery',
    pos = {x = 0, y = 0},
    cost = 4,
    config = {extra = {remaining = 3}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.remaining}}
    end,
    can_use = function(self, card, area, copier)
        return false
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not (context.individual or context.repetition) and no_bp_retrigger(context) then
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                        SMODS.add_card({set = 'Planet', key_append = 'mck'})
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = localize('k_plus_planet'),
                    colour = G.C.SECONDARY_SET.Planet,
                })
            end
            decrease_remaining_food(G, card)
        end
    end,
    atlas = "sdm_bakery"
}

SDM_0s_Stuff_Mod.modded_objects.c_sdm_moon_cake = "Moon Cake"

-- Pączek --

SMODS.Consumable{
    key = 'paczek',
    name = 'Pączek',
    set = 'Bakery',
    pos = {x = 0, y = 0},
    cost = 4,
    config = {extra = {remaining = 3}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.remaining}}
    end,
    can_use = function(self, card, area, copier)
        return false
    end,
    add_to_deck = function(self, card, from_debuff)
        if G.GAME and G.GAME.probabilities then
            for k, v in pairs(G.GAME.probabilities) do
                G.GAME.probabilities[k] = v*2
            end
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if G.GAME and G.GAME.probabilities then
            for k, v in pairs(G.GAME.probabilities) do
                G.GAME.probabilities[k] = v/2
            end
        end
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not (context.individual or context.repetition) and no_bp_retrigger(context) then
            decrease_remaining_food(G, card)
        end
    end,
    atlas = "sdm_bakery"
}

SDM_0s_Stuff_Mod.modded_objects.c_sdm_paczek = "Pączek"