SMODS.Atlas{
    key = "sdm_bakery_consumables",
    path = "bakery/sdm_bakery_consumables.png",
    px = 70,
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
        return #G.consumeables.cards < G.consumeables.config.card_limit
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

SDM_0s_Stuff_Mod.modded_consumables.c_sdm_baker = "Baker"

-- Sourdough --

SMODS.Bakery{
    key = 'sourdough',
    name = 'Sourdough',
    pos = {x = 0, y = 0},
    soul_pos = {x = 0, y = 1},
    config = {extra = {amount = 2, remaining = 4}},
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xchips = card.ability.extra.amount,
                func = function()
                    if not context or SDM_0s_Stuff_Funcs.no_bp_retrigger(context) then
                        SDM_0s_Stuff_Funcs.decrease_remaining_food(card)
                    end
                end
            }
        end
    end,
}

SDM_0s_Stuff_Mod.modded_consumables.c_sdm_sourdough = "Sourdough"

-- Baguette --

SMODS.Bakery{
    key = 'baguette',
    name = 'Baguette',
    pos = {x = 1, y = 0},
    soul_pos = {x = 1, y = 1},
    config = {extra = {amount = 2, remaining = 4}},
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.amount,
                func = function()
                    if not context or SDM_0s_Stuff_Funcs.no_bp_retrigger(context) then
                        SDM_0s_Stuff_Funcs.decrease_remaining_food(card)
                    end
                end
            }
        end
    end,
}

SDM_0s_Stuff_Mod.modded_consumables.c_sdm_baguette = "Baguette"

-- Chocolate Truffles --

SMODS.Bakery{
    key = 'chocolate_truffles',
    name = 'Chocolate Truffles',
    pos = {x = 2, y = 0},
    soul_pos = {x = 2, y = 1},
    config = {extra = {amount = 6, remaining = 3}},
    calc_dollar_bonus = function(self, card)
        local dollars = card.ability.extra.amount
        SDM_0s_Stuff_Funcs.decrease_remaining_food(card)
        return dollars
    end,
}

SDM_0s_Stuff_Mod.modded_consumables.c_sdm_chocolate_truffles = "Chocolate Truffles"

-- Banana Bread --

SMODS.Bakery{
    key = 'banana_bread',
    name = 'Banana Bread',
    pos = {x = 3, y = 0},
    soul_pos = {x = 3, y = 1},
    config = {extra = {amount = 3, remaining = 4}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.amount, ''..(G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.remaining}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.amount,
                func = function()
                    if SDM_0s_Stuff_Funcs.proba_check(card.ability.extra.remaining, 'bananabread') then
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
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = localize('k_extinct_ex'),
                            colour = G.C.FILTER
                        })
                    else
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = localize('k_safe_ex'),
                            colour = G.C.FILTER
                        })
                    end
                end
            }
        end
    end,
}

SDM_0s_Stuff_Mod.modded_consumables.c_sdm_banana_bread = "Banana Bread"

-- Breadsticks --

SMODS.Bakery{
    key = 'breadsticks',
    name = 'Breadsticks',
    pos = {x = 4, y = 0},
    soul_pos = {x = 4, y = 1},
    config = {extra = {amount = 2, remaining = 2}},
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
        if context.end_of_round and context.main_eval and SDM_0s_Stuff_Funcs.no_bp_retrigger(context) then
            SDM_0s_Stuff_Funcs.decrease_remaining_food(card)
        end
    end,
}

SDM_0s_Stuff_Mod.modded_consumables.c_sdm_breadsticks = "Breadsticks"

-- Croissant --

SMODS.Bakery{
    key = 'croissant',
    name = 'Croissant',
    pos = {x = 5, y = 0},
    soul_pos = {x = 5, y = 1},
    config = {extra = {amount = 2, remaining = 2}},
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
        if context.end_of_round and context.main_eval and SDM_0s_Stuff_Funcs.no_bp_retrigger(context) then
            SDM_0s_Stuff_Funcs.decrease_remaining_food(card)
        end
    end,
}

SDM_0s_Stuff_Mod.modded_consumables.c_sdm_croissant = "Croissant"

-- Bread Loaf --

SMODS.Bakery{
    key = 'bread_loaf',
    name = 'Bread Loaf',
    pos = {x = 0, y = 2},
    soul_pos = {x = 0, y = 3},
    config = {extra = {amount = 2, remaining = 2}},
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
        if context.end_of_round and context.main_eval and SDM_0s_Stuff_Funcs.no_bp_retrigger(context) then
            SDM_0s_Stuff_Funcs.decrease_remaining_food(card)
        end
    end,
}

SDM_0s_Stuff_Mod.modded_consumables.c_sdm_bread_loaf = "Bread Loaf"

-- Sprinkle Donut --

SMODS.Bakery{
    key = 'sprinkle_donut',
    name = 'Sprinkle Donut',
    pos = {x = 1, y = 2},
    soul_pos = {x = 1, y = 3},
    config = {extra = {amount = 1, remaining = 2}},
    calculate = function(self, card, context)
        if context.first_hand_drawn and SDM_0s_Stuff_Funcs.no_bp_retrigger(context) then
            local no_edition_cards = {}
            for _, v in ipairs(G.hand.cards) do
                if not v.edition then no_edition_cards[#no_edition_cards+1] = v end
            end
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                local _card = pseudorandom_element(no_edition_cards, pseudoseed('dnt'))
                _card:set_edition('e_polychrome', true)
                card:juice_up(0.3, 0.5)
            return true end }))
            SDM_0s_Stuff_Funcs.decrease_remaining_food(card)
        end
    end,
}

SDM_0s_Stuff_Mod.modded_consumables.c_sdm_sprinkle_donut = "Sprinkle Donut"

-- Fortune Cookie --

SMODS.Bakery{
    key = 'fortune_cookie',
    name = 'Fortune Cookie',
    pos = {x = 2, y = 2},
    soul_pos = {x = 2, y = 3},
    config = {extra = {amount = 1, remaining = 3}},
    calculate = function(self, card, context)
        if context.setting_blind and SDM_0s_Stuff_Funcs.no_bp_retrigger(context) then
            for i = 1, card.ability.extra.amount do
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                        SMODS.add_card({set = 'Tarot', key_append = 'fck'})
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = localize('k_plus_tarot'),
                    colour = G.C.SECONDARY_SET.Tarot,
                })
            end
            SDM_0s_Stuff_Funcs.decrease_remaining_food(card)
        end
    end,
}

SDM_0s_Stuff_Mod.modded_consumables.c_sdm_fortune_cookie = "Fortune Cookie"

-- Moon Cakes --

SMODS.Bakery{
    key = 'moon_cakes',
    name = 'Moon Cakes',
    pos = {x = 3, y = 2},
    soul_pos = {x = 3, y = 3},
    config = {extra = {amount = 1, remaining = 3}},
    calculate = function(self, card, context)
        if context.setting_blind and SDM_0s_Stuff_Funcs.no_bp_retrigger(context) then
            for i = 1, card.ability.extra.amount do
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
            SDM_0s_Stuff_Funcs.decrease_remaining_food(card)
        end
    end,
}

SDM_0s_Stuff_Mod.modded_consumables.c_sdm_moon_cakes = "Moon Cakes"

-- Bread Monster --

SMODS.Bakery{
    key = 'bread_monster',
    name = 'Bread Monster',
    pos = {x = 4, y = 2},
    soul_pos = {x = 4, y = 3},
    config = {extra = {amount = 1, remaining = 2}},
    calculate = function(self, card, context)
        if context.setting_blind and SDM_0s_Stuff_Funcs.no_bp_retrigger(context) then
            for i = 1, card.ability.extra.amount do
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
                    message = localize('k_plus_Spectral'),
                    colour = G.C.SECONDARY_SET.Spectral,
                })
            end
            SDM_0s_Stuff_Funcs.decrease_remaining_food(card)
        end
    end,
}

SDM_0s_Stuff_Mod.modded_consumables.c_sdm_bread_monster = "Bread Monster"

-- Wedding Cake --

SMODS.Bakery{
    key = 'wedding_cake',
    name = 'Wedding Cake',
    set = 'Spectral',
    soul_set = 'Bakery',
    pos = {x = 5, y = 2},
    soul_pos = {x = 5, y = 3},
    config = {extra = {amount = 1, remaining = -1}},
    hidden = true,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.amount
            G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.extra.amount
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if not from_debuff then
            G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.amount
            G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.extra.amount
        end
    end,
}

SDM_0s_Stuff_Mod.modded_consumables.c_sdm_wedding_cake = "Wedding Cake"

--- Crossmod content ---

-- Sponge Cake (Tsunami) --

if next(SMODS.find_mod('Tsunami')) then
    SMODS.Bakery{
        key = 'sponge_cake',
        name = 'Sponge Cake',
        pos = {x = 1, y = 4},
        soul_pos = {x = 1, y = 5},
        config = {extra = {amount = 1, remaining = 2}},
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue+1] = G.P_CENTERS.j_splash
            return {vars = {
                (G.GAME and G.GAME.used_vouchers.v_sdm_bakery_factory and card.area ~= G.consumeables and card.ability.extra.amount * 2) or card.ability.extra.amount,
                (G.GAME and G.GAME.used_vouchers.v_sdm_bakery_shop and card.area ~= G.consumeables and card.ability.extra.remaining * 2) or card.ability.extra.remaining
            }}
        end,
        calculate = function(self, card, context)
            if context.setting_blind and SDM_0s_Stuff_Funcs.no_bp_retrigger(context) then
                for i = 1, card.ability.extra.amount do
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 0.0,
                        func = (function()
                            SMODS.add_card({key = 'j_splash', edition = 'e_negative', key_append = 'sck'})
                            return true
                        end)
                    }))
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = localize('k_plus_joker'),
                        colour = G.C.BLUE,
                    })
                end
                SDM_0s_Stuff_Funcs.decrease_remaining_food(card)
            end
        end,
    }

    SDM_0s_Stuff_Mod.modded_consumables.c_sdm_sponge_cake = "Sponge Cake"
end

-- Macarons (MoreFluff) --

if next(SMODS.find_mod('MoreFluff')) and mf_config and mf_config["Colour Cards"] then
    SMODS.Bakery{
        key = 'macarons',
        name = 'Macarons',
        pos = {x = 2, y = 4},
        soul_pos = {x = 2, y = 5},
        config = {extra = {amount = 1, remaining = 2}},
        calculate = function(self, card, context)
            if context.setting_blind and SDM_0s_Stuff_Funcs.no_bp_retrigger(context) then
                for i = 1, card.ability.extra.amount do
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 0.0,
                        func = (function()
                            SMODS.add_card({set = 'Colour', key_append = 'mcr'})
                            G.GAME.consumeable_buffer = 0
                            return true
                        end)
                    }))
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = localize('k_plus_colour'),
                        colour = G.C.PURPLE,
                    })
                end
                SDM_0s_Stuff_Funcs.decrease_remaining_food(card)
            end
        end,
        no_collection = not (mf_config and mf_config["Colour Cards"]),
        in_pool = function()
            return mf_config and mf_config["Colour Cards"]
        end,
    }

    SDM_0s_Stuff_Mod.modded_consumables.c_sdm_macarons = "Macarons"
end

-- King Cake (Paperback) --

if next(SMODS.find_mod('paperback')) then
    SMODS.Bakery{
        key = 'king_cake',
        name = 'King Cake',
        pos = {x = 3, y = 4},
        soul_pos = {x = 3, y = 5},
        config = {extra = {amount = 1, remaining = 2}},
        calculate = function(self, card, context)
            if context.setting_blind and SDM_0s_Stuff_Funcs.no_bp_retrigger(context) then
                for i = 1, card.ability.extra.amount do
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 0.0,
                        func = (function()
                            SMODS.add_card({set = 'paperback_minor_arcana', key_append = 'kgc'})
                            G.GAME.consumeable_buffer = 0
                            return true
                        end)
                    }))
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = localize('paperback_plus_minor_arcana'),
                        colour = G.C.PAPERBACK_MINOR_ARCANA,
                    })
                end
                SDM_0s_Stuff_Funcs.decrease_remaining_food(card)
            end
        end,
        no_collection = not (PB_UTIL and PB_UTIL.config.minor_arcana_enabled),
        in_pool = function()
            return PB_UTIL and PB_UTIL.config.minor_arcana_enabled
        end,
    }

    SDM_0s_Stuff_Mod.modded_consumables.c_sdm_king_cake = "King Cake"
end

-- Ambrosia Bread (Prism) --

if next(SMODS.find_mod('Prism')) then
    SMODS.Bakery{
        key = 'ambrosia_bread',
        name = 'Ambrosia Bread',
        pos = {x = 4, y = 4},
        soul_pos = {x = 4, y = 5},
        config = {extra = {amount = 1, remaining = 2}},
        calculate = function(self, card, context)
            if context.setting_blind and SDM_0s_Stuff_Funcs.no_bp_retrigger(context) then
                for i = 1, card.ability.extra.amount do
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 0.0,
                        func = (function()
                            SMODS.add_card({set = 'Myth', key_append = 'amb'})
                            G.GAME.consumeable_buffer = 0
                            return true
                        end)
                    }))
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = {"+1 Myth"},  -- The mod has no localization for adding Myth cards
                        colour = G.PRISM.C.myth_1,
                    })
                end
                SDM_0s_Stuff_Funcs.decrease_remaining_food(card)
            end
        end,
        no_collection = not (G.PRISM and G.PRISM.config.myth_enabled),
        in_pool = function()
            return G.PRISM and G.PRISM.config.myth_enabled
        end,
    }

    SDM_0s_Stuff_Mod.modded_consumables.c_sdm_ambrosia_bread = "Ambrosia Bread"
end