SMODS.Atlas{
    key = "sdm_jokers",
    path = "sdm_jokers.png",
    px = 71,
    py = 95
}

--- Trance The Devil ---

SMODS.Joker{
    key = "trance_the_devil",
    rarity = 2,
    perishable_compat = false,
    blueprint_compat = true,
    pos = {x = 0, y = 0},
    cost = 6,
    config = {extra = {Xmult = 1, Xmult_mod = 0.15}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.Xmult_mod, card.ability.extra.Xmult}}
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not (context.blueprint_card or card).getting_sliced and not context.blueprint then
            if G.consumeables and #G.consumeables.cards > 0 then
                local destructable_consus = {}
                for i = 1, #G.consumeables.cards do
                    if not G.consumeables.cards[i].ability.eternal and not G.consumeables.cards[i].getting_sliced then
                        destructable_consus[#destructable_consus+1] = G.consumeables.cards[i]
                    end
                end
                if #destructable_consus > 0 then
                    for _, v in ipairs(destructable_consus) do
                        v.getting_sliced = true
                        G.E_MANAGER:add_event(Event({func = function()
                            card:juice_up(0.8, 0.8)
                            v:start_dissolve({G.C.RED}, nil, 1.6)
                        return true end }))
                        card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}}})
                    end
                end
            end
        elseif context.joker_main and card.ability.extra.Xmult > 1 then
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
                Xmult_mod = card.ability.extra.Xmult
            }
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_trance_the_devil = "Trance The Devil"

--- Burger ---

SMODS.Joker{
    key = "burger",
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = false,
    pos = {x = 1, y = 0},
    cost = 8,
    config = {extra = {Xmult = 1.5, mult = 15, chips = 30, remaining = 5}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.Xmult, card.ability.extra.mult, card.ability.extra.chips, card.ability.extra.remaining}}
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not (context.individual or context.repetition or context.blueprint) then
            if card.ability.extra.remaining - 1 <= 0 then 
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
                    message = localize('k_eaten_ex'),
                    colour = G.C.FILTER
                }
            else
                card.ability.extra.remaining = card.ability.extra.remaining - 1
                return {
                    message = card.ability.extra.remaining..'',
                    colour = G.C.FILTER
                }
            end
        elseif context.joker_main then
            SMODS.eval_this(context.blueprint_card or card, {chip_mod = card.ability.extra.chips, message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}}})
            SMODS.eval_this(context.blueprint_card or card, {mult_mod = card.ability.extra.mult, message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}}})
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
                Xmult_mod = card.ability.extra.Xmult
            }
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_burger = "Burger"

--- Bounciest Ball ---

SMODS.Joker{
    key = "bounciest_ball",
    rarity = 1,
    blueprint_compat = true,
    perishable_compat = false,
    pos = {x = 2, y = 0},
    cost = 5,
    config = {extra = {chips = 0, chip_mod = 15}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chips, card.ability.extra.chip_mod, get_most_played_better_hand() or "High Card"}}
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.before and not context.blueprint then
            if context.scoring_name == get_most_played_better_hand() then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.CHIPS,
                    card = card
                }
            elseif card.ability.extra.chips > 2 then
                card.ability.extra.chips = math.floor(card.ability.extra.chips / 2)
                return {
                    message = localize('k_halved_ex'),
                    colour = G.C.RED,
                }
            end
        elseif context.joker_main and card.ability.extra.chips > 0 then
            return {
                message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
                chip_mod = card.ability.extra.chips
            }
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_bounciest_ball = "Bounciest Ball"

--- Lucky Joker ---

SMODS.Joker{
    key = "lucky_joker",
    rarity = 2,
    blueprint_compat = true,
    pos = {x = 3, y = 0},
    cost = 5,
    config = {extra = {repetition = 2}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card and card.ability.extra.repetition or 2}} -- Made this way to avoid Lucky Deck crashing on Lucky Joker hover
    end,
    calculate = function(self, card, context)
        if context.repetition and not context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == 7 then
                return {
                    message = localize('k_again_ex'),
                    repetitions = card.ability.extra.repetition,
                    card = card
                }
            end
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_lucky_joker = "Lucky Joker"

--- Iconic Icon ---

SMODS.Joker{
    key = "iconic_icon",
    rarity = 1,
    blueprint_compat = true,
    pos = {x = 4, y = 0},
    cost = 5,
    config = {extra = {mult = 0, mult_mod = 2}},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = "modified_card", set = "Other"}
        return {vars = {card.ability.extra.mult, card.ability.extra.mult_mod, card.ability.extra.mult_mod * 2}}
    end,
    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.mult > 0 then
            return {
                message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
                mult_mod = card.ability.extra.mult,
                colour = G.C.MULT
            }
        end
    end,
    update = function(self, card, dt)
        card.ability.extra.mult = 0
        if G.playing_cards then
            for _, v in pairs(G.playing_cards) do
                if v:get_id() == 14 then
                    card.ability.extra.mult =  card.ability.extra.mult + card.ability.extra.mult_mod
                    if (v.edition or v.seal or v.ability.effect ~= "Base") then
                        card.ability.extra.mult =  card.ability.extra.mult + card.ability.extra.mult_mod
                    end
                end
            end
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_iconic_icon = "Iconic Icon"

--- Mult'N'Chips ---

SMODS.Joker{
    key = "mult_n_chips",
    rarity = 1,
    blueprint_compat = true,
    pos = {x = 5, y = 0},
    cost = 5,
    config = {extra = {mult = 4, chips = 30}},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_bonus
        info_queue[#info_queue+1] = G.P_CENTERS.m_mult
        return {vars = {card.ability.extra.mult, card.ability.extra.chips}}
    end,
    calculate = function(self, card, context)
        if not context.end_of_round and context.individual and context.cardarea == G.play then
            if context.other_card.ability.effect == "Bonus Card" then
                return {
                    mult = card.ability.extra.mult,
                    card = card
                }
            elseif context.other_card.ability.effect == "Mult Card" then
                return {
                    chips = card.ability.extra.chips,
                    card = card
                }
            end
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_mult_n_chips = "Mult'N'Chips"

--- Moon Base ---

SMODS.Joker{
    key = "moon_base",
    rarity = 1,
    blueprint_compat = true,
    pos = {x = 6, y = 0},
    cost = 6,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = "space_jokers", set = "Other"}
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
            G.GAME.joker_buffer = G.GAME.joker_buffer + 1
            G.E_MANAGER:add_event(Event({
                func = function() 
                    local space = {}
                    for k, _ in pairs(SDM_0s_Stuff_Mod.space_jokers) do
                        if k ~= "j_sdm_moon_base" and G.P_CENTERS[k] ~= nil then
                            if not sdm_config.limit_moon_base or (sdm_config.limit_moon_base and type(G.P_CENTERS[k].rarity) ~= "string" and G.P_CENTERS[k].rarity < 4) then
                                table.insert(space, k)
                            end
                        end
                    end
                    local chosen_space = space[pseudorandom(pseudoseed('mnb'), 1, #space)]
                    local card = create_card('Joker', G.jokers, nil, nil, nil, nil, chosen_space, 'mnb')
                    card:add_to_deck()
                    G.jokers:emplace(card)
                    card:start_materialize()
                    G.GAME.joker_buffer = 0
                    return true
                end}))   
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_joker'), colour = G.C.BLUE}) 
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_moon_base = "Moon Base"
SDM_0s_Stuff_Mod.space_jokers.j_sdm_moon_base = "Moon Base"

--- Shareholder Joker ---

SMODS.Joker{
    key = "shareholder_joker",
    rarity = 1,
    blueprint_compat = false,
    pos = {x = 7, y = 0},
    cost = 5,
    config = {extra = {min = 1, max = 8}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.min, card.ability.extra.max}}
    end,
    calc_dollar_bonus = function(self, card)
        rand_dollar = pseudorandom(pseudoseed('shareholder'), card.ability.extra.min, card.ability.extra.max)
        return rand_dollar
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_shareholder_joker = "Shareholder Joker"

--- Magic Hands ---

SMODS.Joker{
    key = "magic_hands",
    rarity = 2,
    blueprint_compat = true,
    pos = {x = 8, y = 0},
    cost = 6,
    config = {extra = 3},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra, (not G.jokers and 4) or G.GAME.current_round.hands_left}}
    end,
    calculate = function(self, card, context)
        if context.joker_main and context.scoring_hand then
            cards_id = {}
            for i = 1, #context.scoring_hand do
                table.insert(cards_id, context.scoring_hand[i]:get_id())
            end
            max_card = count_max_occurence(cards_id) or 0
            if G.GAME.current_round.hands_left + 1 == max_card then
                return {
                    message = localize{type='variable',key='a_xmult',vars={card.ability.extra}},
                    Xmult_mod = card.ability.extra
                } 
            end
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_magic_hands = "Magic Hands"

--- Tip Jar ---

SMODS.Joker{
    key = "tip_jar",
    rarity = 2,
    blueprint_compat = false,
    pos = {x = 9, y = 0},
    cost = 6,
    calc_dollar_bonus = function(self, card)
        local highest = 0
        for digit in tostring(math.abs(G.GAME.dollars)):gmatch("%d") do
            highest = math.max(highest, tonumber(digit))
        end
        if highest > 0 then
            return highest
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_tip_jar = "Tip Jar"

--- Wandering Star ---

SMODS.Joker{
    key = "wandering_star",
    rarity = 2,
    blueprint_compat = true,
    pos = {x = 0, y = 1},
    cost = 6,
    config = {extra = {repetition = true}},
    loc_vars = function(self, info_queue, card)
        return {vars = {(card.ability.extra.repetition and "Active") or "", (not card.ability.extra.repetition and "Inactive") or ""}}
    end,
    calculate = function(self, card, context)
        if context.using_consumeable and card.ability.extra.repetition then
            if context.consumeable.ability.set == "Planet" and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                card.ability.extra.repetition = false
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                local _card = create_card('Planet', G.consumeables, nil, nil, nil, nil, context.consumeable.config.center.key, 'wds')
                                _card:add_to_deck()
                                G.consumeables:emplace(_card)
                                G.GAME.consumeable_buffer = 0
                                return true
                            end}))   
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet})
                    return true
                end)}))
            end
        end
        if context.end_of_round and not (context.individual or context.repetition or context.blueprint)
        and not card.ability.extra.repetition then
            card.ability.extra.repetition = true
            card_eval_status_text(card, 'extra', nil, nil, nil, {
                message = localize('k_active_ex'),
                colour = G.C.FILTER,
            })
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_wandering_star = "Wandering Star"
SDM_0s_Stuff_Mod.space_jokers.j_sdm_wandering_star = "Wandering Star"

--- Ouija Board ---

SMODS.Joker{
    key = "ouija_board",
    rarity = 3,
    eternal_compat = false,
    pos = {x = 1, y = 1},
    cost = 8,
    config = {extra = {remaining = 0, rounds = 3, sold_rare = false, scored_secret = false, used_spectral = false}},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.c_soul
        return {vars = {card.ability.extra.remaining, card.ability.extra.rounds,
        (card.ability.extra.sold_rare and "Rare") or "", (not card.ability.extra.sold_rare and "Rare") or "",
        (card.ability.extra.scored_secret and "Secret") or "", (not card.ability.extra.scored_secret and "Secret") or "",
        (card.ability.extra.used_spectral and "Spectral") or "", (not card.ability.extra.used_spectral and "Spectral") or ""}}
    end,
    calculate = function(self, card, context)
        if context.selling_card and not context.blueprint and context.card.ability.set == 'Joker' then
            if context.card.config.center.rarity == 3 then
                if not card.ability.extra.sold_rare then
                    card.ability.extra.sold_rare = true
                    card.ability.extra.remaining = card.ability.extra.remaining + 1
                    ouija_check(card, context)
                end
            end
        end
        if context.using_consumeable and not context.blueprint then
            if context.consumeable.ability.set == "Spectral" then
                if not card.ability.extra.used_spectral then
                    card.ability.extra.used_spectral = true
                    card.ability.extra.remaining = card.ability.extra.remaining + 1
                    ouija_check(card, context)
                end
            end
        end
        if context.joker_main and not context.blueprint then
            if context.scoring_name and context.scoring_name == 'Five of a Kind' or context.scoring_name == 'Flush House' or context.scoring_name == 'Flush Five' then
                if not card.ability.extra.scored_secret then
                    card.ability.extra.scored_secret = true
                    card.ability.extra.remaining = card.ability.extra.remaining + 1
                    ouija_check(card, context)
                end
            end
        end
        if context.selling_self and not context.blueprint then
            if card.ability.extra.sold_rare and card.ability.extra.used_spectral and card.ability.extra.scored_secret then
                if not card.getting_sliced and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            G.E_MANAGER:add_event(Event({
                                func = function() 
                                    local new_card = create_card('Spectral',G.consumeables, nil, nil, nil, nil, 'c_soul', 'rtl')
                                    new_card:add_to_deck()
                                    G.consumeables:emplace(new_card)
                                    G.GAME.consumeable_buffer = 0
                                    return true
                                end}))   
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral})                
                        return true
                    end)}))
                end
            end
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_ouija_board = "Ouija Board"

--- La Révolution ---

SMODS.Joker{
    key = "la_revolution",
    rarity = 3,
    blueprint_compat = true,
    pos = {x = 2, y = 1},
    cost = 8,
    config = {hand = "High Card"},
    calculate = function(self, card, context)
        if context.cardarea == G.jokers then
            if context.before and context.scoring_name then
                card.ability.hand = context.scoring_name
            elseif context.after and G.GAME.chips + hand_chips * mult > G.GAME.blind.chips then
                no_faces = true
                for i = 1, #context.full_hand do
                    if context.full_hand[i]:is_face() then
                        no_faces = false
                        break
                    end
                end
                if no_faces then
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')})
                    update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(card.ability.hand, 'poker_hands'),chips = G.GAME.hands[card.ability.hand].chips, mult = G.GAME.hands[card.ability.hand].mult, level=G.GAME.hands[card.ability.hand].level})
                    level_up_hand(context.blueprint_card or card, card.ability.hand, nil, 1)
                    update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
                end
            end
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_la_revolution = "La Révolution"

--- Clown Bank ---

SMODS.Joker{
    key = "clown_bank",
    rarity = 3,
    perishable_compat = false,
    blueprint_compat = true,
    pos = {x = 3, y = 1},
    cost = 8,
    config = {extra = {Xmult = 1, Xmult_mod = 0.25, dollars = 1, inflation = 1}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.Xmult, card.ability.extra.Xmult_mod, card.ability.extra.dollars, card.ability.extra.inflation}}
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced and not context.blueprint then
            if G.GAME.dollars - card.ability.extra.dollars >= G.GAME.bankrupt_at then
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = "-"  .. localize('$') .. card.ability.extra.dollars,
                    colour = G.C.RED
                })
                ease_dollars(-card.ability.extra.dollars)
                card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
                card.ability.extra.dollars = card.ability.extra.dollars + card.ability.extra.inflation
                G.E_MANAGER:add_event(Event({
                    func = function() card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}}}); return true
                    end}))
                return
            end
        elseif context.joker_main and card.ability.extra.Xmult > 1 then
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
                Xmult_mod = card.ability.extra.Xmult
            }
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_clown_bank = "Clown Bank"

--- Furnace ---

SMODS.Joker{
    key = "furnace",
    rarity = 2,
    blueprint_compat = true,
    pos = {x = 4, y = 1},
    cost = 6,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_gold
        info_queue[#info_queue+1] = G.P_CENTERS.m_steel
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn then
            G.E_MANAGER:add_event(Event({
                func = function() 
                    local _card = create_playing_card({
                        front = pseudorandom_element(G.P_CARDS, pseudoseed('furn_fr')), 
                        center = G.P_CENTERS.c_base}, G.hand, nil, nil, {G.C.SECONDARY_SET.Enhanced})
                    local enhance_type = pseudorandom(pseudoseed('furned'))
                    if enhance_type > 0.5 then _card:set_ability(G.P_CENTERS.m_gold)
                    else _card:set_ability(G.P_CENTERS.m_steel)
                    end
                    G.GAME.blind:debuff_card(_card)
                    G.hand:sort()
                    if context.blueprint_card then context.blueprint_card:juice_up() else card:juice_up() end
                    return true
                end}))
            playing_card_joker_effects({true})
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_furnace = "Furnace"

--- Warehouse ---

SMODS.Joker{
    key = "warehouse",
    rarity = 2,
    pos = {x = 5, y = 1},
    cost = 6,
    config = {extra = {h_size = 2, c_size = 1, dollars = -100}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.h_size, card.ability.extra.c_size, -card.ability.extra.dollars}}
    end,
    add_to_deck = function(self, card, from_debuff)
        G.hand:change_size(card.ability.extra.h_size)
        G.consumeables:change_size(-card.ability.extra.c_size)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.h_size)
        G.consumeables:change_size(card.ability.extra.c_size)
    end,
    update = function(self, card, dt)
        if card.set_cost and card.ability.extra_value ~= card.ability.extra.dollars - math.floor(card.cost / 2) then 
            card.ability.extra_value = card.ability.extra.dollars - math.floor(card.cost / 2)
            card:set_cost()
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_warehouse = "Warehouse"

--- Zombie Joker ---

SMODS.Joker{
    key = "zombie_joker",
    rarity = 1,
    pos = {x = 6, y = 1},
    cost = 5,
    config = {extra = 3},
    loc_txt = {
        name = "Zombie Joker",
        text = {
            "{C:green}#1# in #2#{} chance to create a",
            "{C:tarot}Death{} card when {C:attention}selling{}",
            "a card other than {C:tarot}Death{}",
            "{C:inactive}(Must have room)"
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.c_death
        return {vars = {''..(G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra}}
    end,
    calculate = function(self, card, context)
        if context.selling_card and not context.blueprint then
            if context.card.ability.name ~= "Death" and pseudorandom(pseudoseed('zmbjkr')) < G.GAME.probabilities.normal/card.ability.extra then
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit or
                context.card.ability.set ~= 'Joker' and #G.consumeables.cards + G.GAME.consumeable_buffer <= G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 0.0,
                        func = (function()
                                local new_card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, 'c_death', 'zmb')
                                new_card:add_to_deck()
                                G.consumeables:emplace(new_card)
                                G.GAME.consumeable_buffer = 0
                            return true
                        end)}))
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.SECONDARY_SET.Tarot})
                end
            end
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_zombie_joker = "Zombie Joker"

--- Mystery Joker ---

SMODS.Joker{
    key = "mystery_joker",
    rarity = 1,
    blueprint_compat = true,
    pos = {x = 7, y = 1},
    cost = 6,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_TAGS.tag_rare
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not (context.individual or context.repetition) then
            if G.GAME.blind.boss then
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        add_tag(Tag('tag_rare'))
                        card:juice_up(0.3, 0.4)
                        play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                        play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                        return true
                    end)
                }))
            end
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_mystery_joker = "Mystery Joker"

--- Infinite Staircase ---

SMODS.Joker{
    key = "infinite_staircase",
    rarity = 2,
    blueprint_compat = true,
    pos = {x = 8, y = 1},
    cost = 6,
    config = {extra = {Xmult = 3}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.Xmult}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            no_faces_and_ace = true
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:is_face() or context.scoring_hand[i]:get_id() == 14 then
                    no_faces_and_ace = false
                end
            end
            if no_faces_and_ace and next(context.poker_hands["Straight"]) then
                return {
                    message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
                    Xmult_mod = card.ability.extra.Xmult
                }
            end
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_infinite_staircase = "Infinite Staircase"

--- Ninja Joker ---

SMODS.Joker{
    key = "ninja_joker",
    rarity = 2,
    blueprint_compat = true,
    pos = {x = 9, y = 1},
    cost = 8,
    config = {extra = {can_dupe = true, active = "Active", inactive = ""}},
    loc_vars = function(self, info_queue, card)
        if not card.edition or (card.edition and not card.edition.negative) then
            info_queue[#info_queue+1] = G.P_TAGS.tag_negative
        end
        return {vars = {card.ability.extra.active, card.ability.extra.inactive}}
    end,
    calculate = function(self, card, context)
        if context.playing_card_added  and not card.getting_sliced and not context.blueprint then
            if not card.ability.extra.can_dupe then
                card.ability.extra.active = "Active"
                card.ability.extra.inactive = ""
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = localize('k_active_ex'),
                    colour = G.C.FILTER,
                })
                card.ability.extra.can_dupe = true
            end
        end
        if context.cards_destroyed and card.ability.extra.can_dupe then
            if #context.glass_shattered > 0 then
                if not context.blueprint then
                    card.ability.extra.active = ""
                    card.ability.extra.inactive = "Inactive"
                    card.ability.extra.can_dupe = false
                end
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        add_tag(Tag('tag_negative'))
                        card:juice_up(0.3, 0.4)
                        play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                        play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                        return true
                    end)
                }))
            end
        elseif context.remove_playing_cards and card.ability.extra.can_dupe then
            if #context.removed > 0 then
                if not context.blueprint then
                    card.ability.extra.active = ""
                    card.ability.extra.inactive = "Inactive"
                    card.ability.extra.can_dupe = false
                end
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        add_tag(Tag('tag_negative'))
                        card:juice_up(0.3, 0.4)
                        play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                        play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                        return true
                    end)
                }))
            end
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_ninja_joker = "Ninja Joker"

--- Reach The Stars ---

SMODS.Joker{
    key = "reach_the_stars",
    rarity = 1,
    blueprint_compat = true,
    pos = {x = 0, y = 2},
    cost = 5,
    config = {extra = {num_card1 = 1, num_card2 = 5, rts_scored = 0, remaining = 2, c1_scored = false, c2_scored = false}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.num_card1, card.ability.extra.num_card2,
        (card.ability.extra.c1_scored and card.ability.extra.num_card1) or "",
        (not card.ability.extra.c1_scored and card.ability.extra.num_card1) or "",
        (card.ability.extra.c2_scored and card.ability.extra.num_card2) or "",
        (not card.ability.extra.c2_scored and card.ability.extra.num_card2) or "",
    }}
    end,
    set_ability = function(self, card, initial, delay_sprites)
        local valid_nums = {1, 2, 3, 4, 5}
        local c1 = pseudorandom_element(valid_nums, pseudoseed('rts'))
        table.remove(valid_nums, c1)
        local c2 = pseudorandom_element(valid_nums, pseudoseed('rts'))
        if c1 > c2 then
            card.ability.extra.num_card1 = c2
            card.ability.extra.num_card2 = c1
        elseif c1 < c2 then
            card.ability.extra.num_card1 = c1
            card.ability.extra.num_card2 = c2
        end
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and not (context.before or context.after) then
            if context.scoring_hand then 
                if #context.scoring_hand == card.ability.extra.num_card1 and not card.ability.extra.c1_scored then
                    if not context.blueprint then 
                        card.ability.extra.c1_scored = true
                        card.ability.extra.rts_scored = card.ability.extra.rts_scored + 1
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = card.ability.extra.rts_scored .. '/' .. card.ability.extra.remaining,
                            colour = G.C.FILTER,
                        })
                    end
                elseif #context.scoring_hand == card.ability.extra.num_card2 and not card.ability.extra.c2_scored then
                    if not context.blueprint then 
                        card.ability.extra.c2_scored = true
                        card.ability.extra.rts_scored = card.ability.extra.rts_scored + 1
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = card.ability.extra.rts_scored .. '/' .. card.ability.extra.remaining,
                            colour = G.C.FILTER,
                        })
                    end
                end
                if card.ability.extra.c1_scored and card.ability.extra.c2_scored then
                    card.ability.extra.rts_scored = 0
                    card.ability.extra.c1_scored = false
                    card.ability.extra.c2_scored = false
                    if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                        G.E_MANAGER:add_event(Event({
                            trigger = 'before',
                            delay = 0.0,
                            func = (function()
                                local new_card = create_card('Planet', G.consumeables, nil, nil, nil, nil, nil, 'rts')
                                new_card:add_to_deck()
                                G.consumeables:emplace(new_card)
                                G.GAME.consumeable_buffer = 0
                                return true
                            end)}))
                        return {
                            message = localize('k_plus_planet'),
                            colour = G.C.SECONDARY_SET.Planet,
                            card = card
                        }
                    end
                end
            end
        end
        if context.end_of_round and not (context.individual or context.repetition or context.blueprint) then
            card.ability.extra.rts_scored = 0
            card.ability.extra.c1_scored = false
            card.ability.extra.c2_scored = false
            local valid_nums = {1, 2, 3, 4, 5}
            local c1 = pseudorandom_element(valid_nums, pseudoseed('rts'))
            table.remove(valid_nums, c1)
            local c2 = pseudorandom_element(valid_nums, pseudoseed('rts'))
            if c1 > c2 then
                card.ability.extra.num_card1 = c2
                card.ability.extra.num_card2 = c1
            elseif c1 < c2 then
                card.ability.extra.num_card1 = c1
                card.ability.extra.num_card2 = c2
            end
            return {
                message = localize('k_reset')
            }
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_reach_the_stars = "Reach The Stars"
SDM_0s_Stuff_Mod.space_jokers.j_sdm_reach_the_stars = "Reach The Stars"

--- Crooked Joker ---

SMODS.Joker{
    key = "crooked_joker",
    rarity = 1,
    pos = {x = 1, y = 2},
    cost = 1,
    calculate = function(self, card, context)
        if context.sdm_adding_card and not context.blueprint then
            if context.card and context.card ~= card and context.card.ability.set == 'Joker' then
                do_dupe = pseudorandom(pseudoseed('crkj'), 0, 1)
                if do_dupe == 1 then
                    if #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit - 1 then
                        G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = localize('k_plus_joker'),
                            colour = G.C.BLUE,
                        })
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                new_card = copy_card(context.card, nil, nil, nil, nil)
                                new_card:add_to_deck2()
                                G.jokers:emplace(new_card)
                                new_card:start_materialize()
                                G.GAME.joker_buffer = 0
                                return true
                            end
                        }))
                    end
                elseif not context.card.ability.eternal then
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = localize('k_nope_ex'),
                        colour = G.C.RED,
                    })
                    G.E_MANAGER:add_event(Event({func = function()
                        context.card.getting_sliced = true
                        context.card:start_dissolve({G.C.RED}, nil, 1.6)
                    return true end }))
                end
            end
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_crooked_joker = "Crooked Joker"

--- Property Damage ---

SMODS.Joker{
    key = "property_damage",
    rarity = 3,
    perishable_compat = false,
    blueprint_compat = true,
    pos = {x = 2, y = 2},
    cost = 8,
    config = {extra = {Xmult = 1, Xmult_mod = 0.25}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.Xmult, card.ability.extra.Xmult_mod}}
    end,
    calculate = function(self, card, context)
        if context.pre_discard and not context.blueprint then
            local eval = evaluate_poker_hand(G.hand.highlighted)
            if eval["Full House"] and eval["Full House"][1] then
                card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
                G.E_MANAGER:add_event(Event({func = function()
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}}});
                    return true end}))
                return
            end
        elseif context.joker_main and card.ability.extra.Xmult > 1 then
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
                Xmult_mod = card.ability.extra.Xmult
            }
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_property_damage = "Property Damage"

--- Rock'N'Roll ---

SMODS.Joker{
    key = "rock_n_roll",
    rarity = 2,
    blueprint_compat = true,
    pos = {x = 3, y = 2},
    cost = 6,
    config = {extra = 1},
    calculate = function(self, card, context)
        if context.repetition and not context.individual and context.cardarea == G.play then
            if context.other_card.ability.effect ~= "Base" then
                return {
                    message = localize('k_again_ex'),
                    repetitions = card.ability.extra,
                    card = card
                }
            end
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_rock_n_roll = "Rock'N'Roll"

--- Contract ---

SMODS.Joker{
    key = "contract",
    rarity = 2,
    pos = {x = 4, y = 2},
    cost = 6,
    config = {extra = {money = 8, blind_req = 2}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.money, card.ability.extra.blind_req}}
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced and not context.blueprint then
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                G.GAME.blind.chips = math.floor(G.GAME.blind.chips * card.ability.extra.blind_req)
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)

                local chips_UI = G.hand_text_area.blind_chips
                G.FUNCS.blind_chip_UI_scale(G.hand_text_area.blind_chips)
                G.HUD_blind:recalculate() 
                chips_UI:juice_up()

                if not silent then play_sound('chips2') end
            return true end }))
        end
    end,
    calc_dollar_bonus = function(self, card)
        return card.ability.extra.money
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_contract = "Contract"

--- Cupidon ---

SMODS.Joker{
    key = "cupidon",
    rarity = 1,
    pos = {x = 5, y = 2},
    cost = 6,
    config = {extra = 0.8},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra}}
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced and not context.blueprint then
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                G.GAME.blind.chips = math.floor(G.GAME.blind.chips * card.ability.extra)
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)

                local chips_UI = G.hand_text_area.blind_chips
                G.FUNCS.blind_chip_UI_scale(G.hand_text_area.blind_chips)
                G.HUD_blind:recalculate() 
                chips_UI:juice_up()

                if not silent then play_sound('chips2') end
            return true end }))
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_cupidon = "Cupidon"

--- Pizza ---

SMODS.Joker{
    key = "pizza",
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = false,
    pos = {x = 6, y = 2},
    cost = 5,
    config = {extra = {hands = 4, hand_mod = 1}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.hands, card.ability.extra.hand_mod, (card.ability.extra.hands > 1 and "hands") or "hand"}}
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not (context.individual or context.repetition or context.blueprint) then
            card.ability.extra.hands = card.ability.extra.hands - card.ability.extra.hand_mod
            if card.ability.extra.hands > 0 then
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = card.ability.extra.hands .. '',
                    colour = G.C.CHIPS
                })
            else    
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
                    message = localize('k_shared_ex'),
                    colour = G.C.FILTER
                }
            end
        end
        if context.setting_blind and not (context.blueprint_card or card).getting_sliced then
            G.E_MANAGER:add_event(Event({func = function()
                ease_hands_played(card.ability.extra.hands)
                if card.ability.extra.hands > 1 then
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_hands', vars = {card.ability.extra.hands}}})
                else
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_hand', vars = {card.ability.extra.hands}}})
                end
            return true end }))
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_pizza = "Pizza"

--- Treasure Chest ---

SMODS.Joker{
    key = "treasure_chest",
    rarity = 1,
    eternal_compat = false,
    pos = {x = 7, y = 2},
    cost = 4,
    config = {extra = 2},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra}}
    end,
    set_ability = function(self, card, initial, delay_sprites)
        local W, H = card.T.w, card.T.h
        local scale = 1
        card.children.center.scale.y = card.children.center.scale.x
        H = W
        card.T.h = H*scale
        card.T.w = W*scale
    end,
    calculate = function(self, card, context)
        if context.selling_card and not context.blueprint then
            if context.card.ability.set ~= 'Joker' then
                G.E_MANAGER:add_event(Event({
                    func = function()
                    card.ability.extra_value = card.ability.extra_value + card.ability.extra
                    card:set_cost()
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = localize('k_val_up'),
                        colour = G.C.MONEY
                    })
                    return true
                end}))
            end
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_treasure_chest = "Treasure Chest"

--- Bullet Train ---

SMODS.Joker{
    key = "bullet_train",
    rarity = 1,
    blueprint_compat = true,
    pos = {x = 8, y = 2},
    cost = 6,
    config = {extra = 150},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra}}
    end,
    calculate = function(self, card, context)
        if context.joker_main and G.GAME.current_round.hands_played == 0 and G.GAME.current_round.discards_used == 0 then
            return {
                message = localize{type='variable',key='a_chips',vars={card.ability.extra}},
                chip_mod = card.ability.extra
            }
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_bullet_train = "Bullet Train"

--- Chaos Theory ---

SMODS.Joker{
    key = "chaos_theory",
    rarity = 3,
    blueprint_compat = true,
    pos = {x = 9, y = 2},
    cost = 8,
    config = {extra = {chips = 0, chip_mod = 2}},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = "chaos_exceptions", set = "Other"}
        return {vars = {card.ability.extra.chip_mod, card.ability.extra.chips}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
                chip_mod = card.ability.extra.chips
            }
        end
    end,
    update = function(self, card, dt)
        card.ability.extra.chips = sum_incremental(2)
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_chaos_theory = "Chaos Theory"

--- Jambo ---

SMODS.Joker{
    key = "jambo",
    rarity = 1,
    blueprint_compat = true,
    pos = {x = 0, y = 5},
    cost = 6,
    calculate = function(self, card, context)
        if context.joker_main and (G.discard and #G.discard.cards > 0) then
            local _card = pseudorandom_element(G.discard.cards, pseudoseed('jambo'))
            if _card.debuff then
                return {
                    message = localize('k_debuffed'),
                }
            end
            local mlt = _card.base.nominal * 2
            if mlt > 0 then
                return {
                    message = localize{type='variable',key='a_mult',vars={mlt}},
                    mult_mod = mlt
                }
            end
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_jambo = "Jambo"

--- Water Slide ---

SMODS.Joker{
    key = "water_slide",
    rarity = 1,
    blueprint_compat = true,
    perishable_compat = false,
    pos = {x = 1, y = 5},
    cost = 4,
    config = {extra = {chips = 0, chip_mod = 8}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chip_mod, card.ability.extra.chips}}
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.before and context.scoring_hand and not context.blueprint then
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:get_id() == 9 or
                context.scoring_hand[i]:get_id() == 7 or
                context.scoring_hand[i]:get_id() == 6 then
                    card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.BLUE,
                        card = card
                    }
                end
            end
        end
        if context.joker_main and card.ability.extra.chips > 0 then
            return {
                message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
                chip_mod = card.ability.extra.chips,
            }
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_water_slide = "Water Slide"

--- Joker Voucher ---

SMODS.Joker{
    key = "joker_voucher",
    rarity = 3,
    blueprint_compat = true,
    pos = {x = 2, y = 5},
    cost = 8,
    config = {extra = {Xmult_mod = 0.5}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.Xmult_mod, 1 + redeemed_voucher_count() * card.ability.extra.Xmult_mod}}
    end,
    calculate = function(self, card, context)
        if context.buying_card and context.card.ability.set == "Voucher" then
            G.E_MANAGER:add_event(Event({
                func = function() card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_xmult',vars={1 + redeemed_voucher_count() * card.ability.extra.Xmult_mod}}}); return true
                end}))
            return
        end
        if context.joker_main then
            local xmlt = 1 + redeemed_voucher_count() * card.ability.extra.Xmult_mod
            if xmlt > 1 then
                return {
                    message = localize{type='variable',key='a_xmult',vars={xmlt}},
                    Xmult_mod = xmlt,
                }
            end
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_joker_voucher = "Joker Voucher"

--- Free Pass ---

SMODS.Joker{
    key = "free_pass",
    rarity = 1,
    pos = {x = 3, y = 5},
    cost = 5,
    config = {extra = 1},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra}}
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.before and (context.full_hand and #context.full_hand == 1)
        and (G.GAME.current_round.discards_used == 0 and G.GAME.current_round.hands_played == 0) then
            G.E_MANAGER:add_event(Event({
                func = function()
                    ease_hands_played(card.ability.extra)
                    if card.ability.extra <= 1 then
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_hand', vars = {card.ability.extra}}, colour = G.C.BLUE})
                    else
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_hands', vars = {card.ability.extra}}, colour = G.C.BLUE})
                    end
                    return true
                end}))
            return
        elseif context.discard and (context.full_hand and #context.full_hand == 1)
        and (G.GAME.current_round.discards_used == 0 and G.GAME.current_round.hands_played == 0) then
            G.E_MANAGER:add_event(Event({
                func = function()
                    ease_discard(card.ability.extra)
                    if card.ability.extra <= 1 then
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_discard', vars = {card.ability.extra}}, colour = G.C.RED})
                    else
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_discards', vars = {card.ability.extra}}, colour = G.C.RED})
                    end
                    return true
                end}))
            return
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_free_pass = "Free Pass"

--- Legionary Joker ---

SMODS.Joker{
    key = "legionary_joker",
    rarity = 1,
    blueprint_compat = true,
    pos = {x = 4, y = 5},
    cost = 5,
    config = {extra = 4},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra}}
    end,
    calculate = function(self, card, context)
        if not context.end_of_round and context.individual and context.cardarea == G.hand then
            if context.other_card and context.other_card:is_suit("Spades", nil, true)
            or context.other_card:is_suit("Diamonds", nil, true) then
                if context.other_card.debuff then
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.RED,
                        card = self,
                    }
                else
                    return {
                        h_mult = card.ability.extra,
                        card = card
                    }
                end
            end
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_legionary_joker = "Legionary Joker"

-- TODO:
-- Jack à dit: Jack scores x2, x0.5 if no played Jack
-- ???: Level up scored hand of 3 cards(?)

--- Jack A Dit ---

SMODS.Joker{
    key = "jack_a_dit",
    rarity = 2,
    blueprint_compat = true,
    pos = {x = 0, y = 0},
    cost = 6,
    config = {extra = 2},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra, math.floor(1 / card.ability.extra)}}
    end,
    calculate = function(self, card, context)
        if context.joker_main and context.scoring_hand then
            local has_jack = false
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:get_id() == 12 then
                    has_jack = true
                    break
                end
            end
            local xmlt = (has_jack and card.ability.extra) or math.floor(1 / card.ability.extra)
            return {
                message = localize{type='variable',key='a_xmult',vars={xmlt}},
                Xmult_mod = xmlt,
            }
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_jack_a_dit = "Jack A Dit"

--- Asteroid Belt ---

SMODS.Joker{
    key = "asteroid_belt",
    rarity = 3,
    pos = {x = 0, y = 0},
    cost = 8,
    config = {extra = 2},
    loc_vars = function(self, info_queue, card)
        return {vars = {''..(G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra}}
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.before and (context.scoring_hand and #context.scoring_hand <= 3)
        and pseudorandom(pseudoseed('abjkr')) < G.GAME.probabilities.normal/card.ability.extra then
            return {
                card = card,
                level_up = true,
                message = localize('k_level_up_ex')
            }
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_asteroid_belt = "Asteroid Belt"

--- Archibald ---

SMODS.Joker{
    key = "archibald",
    rarity = 4,
    blueprint_compat = true,
    config = {extra = {can_copy = true, active = "Active", inactive = ""}},
    pos = {x = 0, y = 3},
    cost = 20,
    loc_vars = function(self, info_queue, card)
        if not card.edition or (card.edition and not card.edition.negative) then
            info_queue[#info_queue+1] = G.P_CENTERS.e_negative
        end
        return {vars = {(card.ability.extra.can_copy and "Active") or "", (not card.ability.extra.can_copy and "Inactive") or ""}}
    end,
    calculate = function(self, card, context)
        if context.ending_shop then
            if card.ability.extra.can_copy and #G.jokers.cards > 0 then
                local valid_cards = {}
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i].ability.name ~= "j_sdm_archibald" then
                        table.insert(valid_cards, G.jokers.cards[i])
                    end
                end
                if #valid_cards > 0 then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            local rand_card = pseudorandom_element(valid_cards, pseudoseed('archi'))
                            local new_card = create_card('Joker', G.jokers, nil, nil, nil, nil, rand_card.config.center.key, nil)
                            new_card:set_edition({negative = true}, true)
                            new_card:add_to_deck()
                            G.jokers:emplace(new_card)
                            new_card:start_materialize()
                            if not context.blueprint then
                                card.ability.extra.can_copy = false
                            end
                            return true
                        end
                    }))
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {
                        message = localize('k_plus_joker'),
                        colour = G.C.DARK_EDITION,
                    })
                end
            end
        end
        if context.end_of_round and not (context.individual or context.repetition or context.blueprint)
        and G.GAME.blind.boss and not card.ability.extra.can_copy then
            card.ability.extra.can_copy = true
            card_eval_status_text(card, 'extra', nil, nil, nil, {
                message = localize('k_active_ex'),
                colour = G.C.FILTER,
            })
        end
    end,
    atlas = "sdm_jokers",
    soul_pos = {x = 0, y = 4}
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_archibald = "Archibald"

--- SDM_0 ---

SMODS.Joker{
    key = "sdm_0",
    rarity = 4,
    blueprint_compat = false,
    perishable_compat = true,
    pos = {x = 1, y = 3},
    cost = 20,
    config = {extra = {jkr_slots = 0, extra_slots = 2}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.extra_slots, card.ability.extra.jkr_slots, (card.ability.extra.jkr_slots > 1 and "Slots") or "Slot"}}
    end,
    add_to_deck = function(self, card, from_debuff)
        if G.jokers and not from_debuff then
            G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.jkr_slots
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if G.jokers and not from_debuff then 
            G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.jkr_slots
        end
    end,
    calculate = function(self, card, context)
        if context.cards_destroyed and not context.blueprint then
            if #context.glass_shattered > 0 then
                for _, v in ipairs(context.glass_shattered) do
                    if v:get_id() == 2 then
                        card.ability.extra.jkr_slots = card.ability.extra.jkr_slots + card.ability.extra.extra_slots
                        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.extra_slots
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = localize('k_upgrade_ex'),
                            colour = G.C.DARK_EDITION,
                        })
                    end
                end
            end
        elseif context.remove_playing_cards and not context.blueprint then
            if #context.removed > 0 then
                for _, v in ipairs(context.removed) do
                    if v:get_id() == 2 then
                        card.ability.extra.jkr_slots = card.ability.extra.jkr_slots + card.ability.extra.extra_slots
                        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.extra_slots
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = localize('k_upgrade_ex'),
                            colour = G.C.DARK_EDITION,
                        })
                    end
                end
            end
        end
    end,
    atlas = "sdm_jokers",
    soul_pos = {x = 1, y = 4}
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_sdm_0 = "SDM_0"

return