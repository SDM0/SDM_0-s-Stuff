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
        return #G.consumeables.cards < G.consumeables.config.card_limit or (card.area and card.area == G.consumeables)
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
        local mod_num, mod_den = SMODS.get_probability_vars(card, 1, card.ability.extra.remaining)
        return {vars = {card.ability.extra.amount, mod_num, mod_den}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.amount,
                func = function()
                    if SDM_0s_Stuff_Funcs.proba_check(card, card.ability.extra.remaining, 'bananabread') then
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
                        SMODS.calculate_context({sdm_bakery_consumed = true})
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
        SMODS.Bakery.add_to_deck(self, card, from_debuff)
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
        SMODS.Bakery.add_to_deck(self, card, from_debuff)
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
        SMODS.Bakery.add_to_deck(self, card, from_debuff)
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
        if context.first_hand_drawn then
            local no_edition_cards = {}
            for _, v in ipairs(G.hand.cards) do
                if not v.edition then no_edition_cards[#no_edition_cards+1] = v end
            end
            if no_edition_cards[1] then
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                    local _card = pseudorandom_element(no_edition_cards, pseudoseed('dnt'))
                    _card:set_edition('e_polychrome', true)
                    card:juice_up(0.3, 0.5)
                return true end }))
                SDM_0s_Stuff_Funcs.decrease_remaining_food(card)
            end
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
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.p_arcana_normal_1
        return SMODS.Bakery.loc_vars(self, info_queue, card)
    end,
    calculate = function(self, card, context)
        if context.starting_shop then
            for i = 1, card.ability.extra.amount do
                G.E_MANAGER:add_event(Event{
                    func = function()
                    local _booster = SMODS.add_booster_to_shop('p_arcana_normal_'..(math.random(1,4)))
                    _booster.cost = 0
                    return true
                end})
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = localize('k_plus_pack'),
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
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.p_celestial_normal_1
        return SMODS.Bakery.loc_vars(self, info_queue, card)
    end,
    calculate = function(self, card, context)
        if context.starting_shop then
            for i = 1, card.ability.extra.amount do
                G.E_MANAGER:add_event(Event{
                    func = function()
                    local _booster = SMODS.add_booster_to_shop('p_celestial_normal_'..(math.random(1,4)))
                    _booster.cost = 0
                    return true
                end})
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = localize('k_plus_pack'),
                    colour = G.C.SECONDARY_SET.Tarot,
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
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.p_spectral_normal_1
        return SMODS.Bakery.loc_vars(self, info_queue, card)
    end,
    calculate = function(self, card, context)
        if context.starting_shop then
            for i = 1, card.ability.extra.amount do
                G.E_MANAGER:add_event(Event{
                    func = function()
                    local _booster = SMODS.add_booster_to_shop('p_spectral_normal_'..(math.random(1,2)))
                    _booster.cost = 0
                    return true
                end})
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = localize('k_plus_pack'),
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
        SMODS.Bakery.add_to_deck(self, card, from_debuff)
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

if SDM_0s_Stuff_Config.sdm_bakery_cross then

    -- Sponge Cake (Tsunami) --

    if next(SMODS.find_mod('Tsunami')) then
        SMODS.Bakery{
            key = 'sponge_cake',
            name = 'Sponge Cake',
            pos = {x = 1, y = 4},
            soul_pos = {x = 1, y = 5},
            config = {extra = {amount = 1, remaining = 2}},
            loc_vars = function(self, info_queue, card)
                info_queue[#info_queue+1] = G.P_CENTERS.e_negative
                info_queue[#info_queue+1] = G.P_CENTERS.j_splash
                return SMODS.Bakery.loc_vars(self, info_queue, card)
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
            loc_vars = function(self, info_queue, card)
                info_queue[#info_queue+1] = G.P_CENTERS.p_mf_colour_normal_1
                return SMODS.Bakery.loc_vars(self, info_queue, card)
            end,
            calculate = function(self, card, context)
                if context.starting_shop then
                    for i = 1, card.ability.extra.amount do
                        G.E_MANAGER:add_event(Event{
                            func = function()
                            local _booster = SMODS.add_booster_to_shop('p_mf_colour_normal_'..(math.random(1,2)))
                            _booster.cost = 0
                            return true
                        end})
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = localize('k_plus_pack'),
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
            loc_vars = function(self, info_queue, card)
                info_queue[#info_queue+1] = G.P_CENTERS.p_paperback_minor_arcana_normal_1
                return SMODS.Bakery.loc_vars(self, info_queue, card)
            end,
            calculate = function(self, card, context)
                if context.starting_shop then
                    for i = 1, card.ability.extra.amount do
                        G.E_MANAGER:add_event(Event{
                            func = function()
                            local _booster = SMODS.add_booster_to_shop('p_paperback_minor_arcana_normal_'..(math.random(1,2)))
                            _booster.cost = 0
                            return true
                        end})
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = localize('k_plus_pack'),
                            colour = G.C.PAPERBACK_MINOR_ARCANA,
                        })
                    end
                    SDM_0s_Stuff_Funcs.decrease_remaining_food(card)
                end
            end,
            no_collection = not (PB_UTIL and PB_UTIL.config and PB_UTIL.config.minor_arcana_enabled),
            in_pool = function()
                return PB_UTIL and PB_UTIL.config and PB_UTIL.config.minor_arcana_enabled
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
            loc_vars = function(self, info_queue, card)
                info_queue[#info_queue+1] = G.P_CENTERS.p_prism_small_myth_1
                return SMODS.Bakery.loc_vars(self, info_queue, card)
            end,
            calculate = function(self, card, context)
                if context.starting_shop then
                    for i = 1, card.ability.extra.amount do
                        G.E_MANAGER:add_event(Event{
                            func = function()
                            local _booster = SMODS.add_booster_to_shop('p_prism_small_myth_'..(math.random(1,2)))
                            _booster.cost = 0
                            return true
                        end})
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = localize('k_plus_pack'),
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

    -- Peremech (TOGA's Stuff) --

    if next(SMODS.find_mod('TOGAPack')) then
        SMODS.Bakery{
            key = 'peremech',
            name = 'Peremech',
            pos = {x = 5, y = 4},
            soul_pos = {x = 5, y = 5},
            config = {extra = {amount = 1, remaining = 2}},
            loc_vars = function(self, info_queue, card)
                info_queue[#info_queue+1] = G.P_CENTERS.p_toga_togazipboosterpack
                info_queue[#info_queue+1] = G.P_CENTERS.p_toga_togaziparchivepack
                info_queue[#info_queue+1] = G.P_CENTERS.p_toga_togararpack
                info_queue[#info_queue+1] = G.P_CENTERS.p_toga_togacardcabpack
                info_queue[#info_queue+1] = G.P_CENTERS.p_toga_togaxcopydnapack
                return SMODS.Bakery.loc_vars(self, info_queue, card)
            end,
            calculate = function(self, card, context)
                if context.starting_shop then
                    for i = 1, card.ability.extra.amount do
                        G.E_MANAGER:add_event(Event{
                            func = function()
                            local _pack = get_pack(nil, 'TOGABoostPack')
                            local _booster = SMODS.add_booster_to_shop(_pack.key)
                            _booster.cost = 0
                            return true
                        end})
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = localize('k_plus_pack'),
                            colour = G.C.RED,
                        })
                    end
                    SDM_0s_Stuff_Funcs.decrease_remaining_food(card)
                end
            end,
        }

        SDM_0s_Stuff_Mod.modded_consumables.c_sdm_peremech = "Peremech"
    end

    -- Funnel Cake (Lucky Rabbit) --

    if next(SMODS.find_mod('LuckyRabbit')) then
        SMODS.Bakery{
            key = 'funnel_cake',
            name = 'Funnel Cake',
            pos = {x = 0, y = 6},
            soul_pos = {x = 0, y = 7},
            config = {extra = {amount = 1, remaining = 2}},
            loc_vars = function(self, info_queue, card)
                info_queue[#info_queue+1] = G.P_CENTERS.p_fmod_silly_small_2
                return SMODS.Bakery.loc_vars(self, info_queue, card)
            end,
            calculate = function(self, card, context)
                if context.starting_shop then
                    for i = 1, card.ability.extra.amount do
                        G.E_MANAGER:add_event(Event{
                            func = function()
                            -- First pack doesnt have a '_1'
                            local _pack = (math.random(1,4) == 1 and '') or ('_' ..(math.random(2,4)))
                            local _booster = SMODS.add_booster_to_shop('p_fmod_silly_small'.. _pack)
                            _booster.cost = 0
                            return true
                        end})
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = localize('k_plus_pack'),
                            colour = HEX("ff98e2"),
                        })
                    end
                    SDM_0s_Stuff_Funcs.decrease_remaining_food(card)
                end
            end,
            no_collection = not (SMODS.Mods['LuckyRabbit'] and SMODS.Mods['LuckyRabbit'].config and SMODS.Mods['LuckyRabbit'].config.silly_enabled),
            in_pool = function()
                return SMODS.Mods['LuckyRabbit'] and SMODS.Mods['LuckyRabbit'].config and SMODS.Mods['LuckyRabbit'].config.silly_enabled
            end,
        }
        SDM_0s_Stuff_Mod.modded_consumables.c_sdm_funnel_cake = "Funnel Cake"
    end

    -- Chiacchiere (Garbshit) --

    if next(SMODS.find_mod('GARBPACK')) then
        SMODS.Bakery{
            key = 'chiacchiere',
            name = 'Chiacchiere',
            pos = {x = 1, y = 6},
            soul_pos = {x = 1, y = 7},
            config = {extra = {amount = 1, remaining = 2}},
            loc_vars = function(self, info_queue, card)
                info_queue[#info_queue+1] = G.P_CENTERS.p_garb_stamp_booster
                return SMODS.Bakery.loc_vars(self, info_queue, card)
            end,
            calculate = function(self, card, context)
                if context.starting_shop then
                    for i = 1, card.ability.extra.amount do
                        G.E_MANAGER:add_event(Event{
                            func = function()
                            -- First pack doesnt have a '_1'
                            local _pack = (math.random(1,2) == 1 and '') or '_2'
                            local _booster = SMODS.add_booster_to_shop('p_garb_stamp_booster'.. _pack)
                            _booster.cost = 0
                            return true
                        end})
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = localize('k_plus_pack'),
                            colour = G.C.FILTER,
                        })
                    end
                    SDM_0s_Stuff_Funcs.decrease_remaining_food(card)
                end
            end,
        }
        SDM_0s_Stuff_Mod.modded_consumables.c_sdm_chiacchiere = "Chiacchiere"
    end
end