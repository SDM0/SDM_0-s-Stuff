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

--- The Baker ---

SMODS.Consumable{
    key = 'baker',
    name = 'The Baker',
    set = 'Tarot',
    pos = {x = 2, y = 1},
    cost = 3,
    config = {extra = 1},
    loc_vars = function(self, info_queue, card)
        return {vars = {self.config.extra}}
    end,
    can_use = function(self, card, area, copier)
        return #G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables
    end,
    use = function(self, card)
        local used_tarot = card or self
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            if G.consumeables.config.card_limit > #G.consumeables.cards then
                play_sound('timpani')
                local _card = create_card('Bakery', G.consumeables, nil, nil, nil, nil, nil, bkr)
                _card:add_to_deck()
                G.consumeables:emplace(_card)
                used_tarot:juice_up(0.3, 0.5)
            end
        return true end }))
    end,
    atlas = "sdm_consumables"
}

SDM_0s_Stuff_Mod.modded_objects.c_sdm_baker = "Baker"

-- TODO: To add the vouchers bonus values, look at MathIsFun suggestion or do 2 config.extra values specifically for when the vouchers are redeemed
-- Ex: card.ability.amount, card.ability.amount_boosted, in loc_vars or calculate: (G.GAME.redeemed[x_voucher] and x) or y)

-- Pita --

SMODS.Bakery{
    key = 'pita',
    name = 'Pita',
    pos = {x = 0, y = 0},
    config = {extra = {amount = 30, remaining = 5}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.amount, card.ability.extra.remaining}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if no_bp_retrigger(context) then
                decrease_remaining_food(card)
            end
            return {
                chips = card.ability.extra.amount,
            }
        end
    end,
}

SDM_0s_Stuff_Mod.modded_objects.c_sdm_pita = "Pita"

-- Sourdough --

SMODS.Bakery{
    key = 'sourdough',
    name = 'Sourdough',
    pos = {x = 0, y = 0},
    config = {extra = {amount = 10, remaining = 5}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.amount, card.ability.extra.remaining}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if no_bp_retrigger(context) then
                decrease_remaining_food(card)
            end
            return {
                mult = card.ability.extra.amount,
            }
        end
    end,
}

SDM_0s_Stuff_Mod.modded_objects.c_sdm_sourdough = "Sourdough"

-- Baguette --

SMODS.Bakery{
    key = 'baguette',
    name = 'Baguette',
    pos = {x = 0, y = 0},
    config = {extra = {amount = 2, remaining = 3}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.amount, card.ability.extra.remaining}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if no_bp_retrigger(context) then
                decrease_remaining_food(card)
            end
            return {
                x_mult = card.ability.extra.amount,
            }
        end
    end,
}

SDM_0s_Stuff_Mod.modded_objects.c_sdm_baguette = "Baguette"

-- Dough --

SMODS.Bakery{
    key = 'dough',
    name = 'Dough',
    pos = {x = 0, y = 0},
    config = {extra = {amount = 4, remaining = 3}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.amount, card.ability.extra.remaining}}
    end,
    calc_dollar_bonus = function(self, card)
        local dollars = card.ability.extra.amount
        decrease_remaining_food(card)
        return dollars
    end,
}

SDM_0s_Stuff_Mod.modded_objects.c_sdm_dough = "Dough"

-- Banana Bread --

SMODS.Bakery{
    key = 'banana_bread',
    name = 'Banana Bread',
    pos = {x = 0, y = 0},
    config = {extra = {amount = 3, remaining = 4}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.amount, ''..(G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.remaining}}
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and no_bp_retrigger(context) then
            if pseudorandom('banabread') < G.GAME.probabilities.normal/card.ability.extra.remaining then
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
                x_mult = card.ability.extra.amount,
            }
        end
    end,
}

SDM_0s_Stuff_Mod.modded_objects.c_sdm_sourdough = "Sourdough"

-- Breadsticks --

SMODS.Bakery{
    key = 'breadsticks',
    name = 'Breadsticks',
    pos = {x = 0, y = 0},
    config = {extra = {amount = 1, remaining = 3}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.amount, card.ability.extra.remaining}}
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.amount
            ease_hands_played(card.ability.extra.amount)
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if not from_debuff then
            G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.amount
        end
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and no_bp_retrigger(context) then
            decrease_remaining_food(card)
        end
    end,
}

SDM_0s_Stuff_Mod.modded_objects.c_sdm_breadsticks = "Breadsticks"

-- Croissant --

SMODS.Bakery{
    key = 'croissant',
    name = 'Croissant',
    pos = {x = 0, y = 0},
    config = {extra = {amount = 1, remaining = 3}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.amount, card.ability.extra.remaining}}
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.amount
            ease_discard(card.ability.extra.amount)
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if not from_debuff then
            G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.amount
        end
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and no_bp_retrigger(context) then
            decrease_remaining_food(card)
        end
    end,
}

SDM_0s_Stuff_Mod.modded_objects.c_sdm_breadsticks = "Breadsticks"

-- Bread Loaf --

SMODS.Bakery{
    key = 'bread_loaf',
    name = 'Bread Loaf',
    pos = {x = 0, y = 0},
    config = {extra = {amount = 1, remaining = 3}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.amount, card.ability.extra.remaining}}
    end,
    add_to_deck = function(self, card, from_debuff)
        if G.hand then
            G.hand:change_size(card.ability.extra.amount)
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if G.hand then
            G.hand:change_size(-card.ability.extra.amount)
        end
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and no_bp_retrigger(context) then
            decrease_remaining_food(card)
        end
    end,
}

SDM_0s_Stuff_Mod.modded_objects.c_sdm_cake = "Cake"

-- Fortune Cookie --

SMODS.Bakery{
    key = 'fortune_cookie',
    name = 'Fortune Cookie',
    pos = {x = 0, y = 0},
    config = {extra = {amount = 1, remaining = 3}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.amount, card.ability.extra.remaining}}
    end,
    calculate = function(self, card, context)
        if context.setting_blind and no_bp_retrigger(context) then
            for i = 1, card.ability.extra.amount do
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
            end
            decrease_remaining_food(card)
        end
    end,
}

SDM_0s_Stuff_Mod.modded_objects.c_sdm_fortune_cookie = "Fortune Cookie"

-- Moon Cake --

SMODS.Bakery{
    key = 'moon_cake',
    name = 'Moon Cake',
    pos = {x = 0, y = 0},
    config = {extra = {amount = 1, remaining = 3}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.amount, card.ability.extra.remaining}}
    end,
    calculate = function(self, card, context)
        if context.setting_blind and no_bp_retrigger(context) then
            for i = 1, card.ability.extra.amount do
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
            end
            decrease_remaining_food(card)
        end
    end,
}

SDM_0s_Stuff_Mod.modded_objects.c_sdm_moon_cake = "Moon Cake"

-- Bread Monster --

SMODS.Bakery{
    key = 'bread_monster',
    name = 'Bread Monster',
    pos = {x = 0, y = 0},
    config = {extra = {amount = 1, remaining = 2}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.amount, card.ability.extra.remaining}}
    end,
    calculate = function(self, card, context)
        if context.setting_blind and no_bp_retrigger(context) then
            for i = 1, card.ability.extra.amount do
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 0.0,
                        func = (function()
                            SMODS.add_card({set = 'Spectral', key_append = 'bmt'})
                            G.GAME.consumeable_buffer = 0
                            return true
                        end)
                    }))
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = localize('k_plus_spectral'),
                        colour = G.C.SECONDARY_SET.Spectral,
                    })
                end
            end
            decrease_remaining_food(card)
        end
    end,
}

SDM_0s_Stuff_Mod.modded_objects.c_sdm_bread_monster = "Bread Monster"