SMODS.Atlas{
    key = "sdm_jokers",
    path = "sdm_jokers.png",
    px = 71,
    py = 95
}

--- Burger ---

SMODS.Joker{
    key = "burger",
    name = "Burger",
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = false,
    pos = {x = 1, y = 0},
    cost = 6,
    config = {extra = {Xmult = 1.25, mult = 15, chips = 30, remaining = 4}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.Xmult, card.ability.extra.mult, card.ability.extra.chips, card.ability.extra.remaining}}
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and no_bp_retrigger(context) then
            decrease_remaining_food(card)
        elseif context.joker_main then
            return {
                chips = card.ability.extra.chips,
                extra = {
                    mult = card.ability.extra.mult,
                    extra = {
                        Xmult = card.ability.extra.Xmult
                    }
                }
            }
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_burger = "Burger"
SDM_0s_Stuff_Mod.food_jokers.j_sdm_burger = "Burger"

--- Bounciest Ball ---

SMODS.Joker{
    key = "bounciest_ball",
    name = "Bounciest Ball",
    rarity = 1,
    blueprint_compat = true,
    perishable_compat = false,
    pos = {x = 2, y = 0},
    cost = 5,
    config = {extra = {chips = 0, chip_mod = 10}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chips, card.ability.extra.chip_mod, localize(get_most_played_better_hand() or "High Card", "poker_hands")}}
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.before and no_bp_retrigger(context) then
            if context.scoring_name == get_most_played_better_hand() then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.CHIPS,
                }
            end
        elseif context.joker_main and card.ability.extra.chips > 0 then
            return {
                chips = card.ability.extra.chips
            }
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_bounciest_ball = "Bounciest Ball"

--- Lucky Joker ---

SMODS.Joker{
    key = "lucky_joker",
    name = "Lucky Joker",
    rarity = 2,
    blueprint_compat = true,
    pos = {x = 3, y = 0},
    cost = 5,
    config = {extra = {repetition = 2}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card and card.ability.extra.repetition or 2}} -- Made this way to avoid Lucky 7 Deck crashing on Lucky Joker hover
    end,
    calculate = function(self, card, context)
        if context.repetition and not context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == 7 then
                return {
                    repetitions = card.ability.extra.repetition,
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
    name = "Iconic Icon",
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
                mult = card.ability.extra.mult,
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
SDM_0s_Stuff_Mod.meme_jokers.j_sdm_iconic_icon = "Iconic Icon"

--- Mult'N'Chips ---

SMODS.Joker{
    key = "mult_n_chips",
    name = "Mult'N'Chips",
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
                }
            elseif context.other_card.ability.effect == "Mult Card" then
                return {
                    chips = card.ability.extra.chips,
                }
            end
        end
    end,
    in_pool = function()
        for _, v in pairs(G.playing_cards) do
            if v.config.center == G.P_CENTERS.m_bonus or v.config.center == G.P_CENTERS.m_mult then
                return true
            end
        end
        return false
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_mult_n_chips = "Mult'N'Chips"

--- Moon Base ---

SMODS.Joker{
    key = "moon_base",
    name = "Moon Base",
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
                        if k ~= "j_sdm_moon_base" and G.P_CENTERS[k] ~= nil and not next(SMODS.find_card(k, true)) then
                            if not SDM_0s_Stuff_Config.limit_moon_base or (SDM_0s_Stuff_Config.limit_moon_base and type(G.P_CENTERS[k].rarity) ~= "string" and G.P_CENTERS[k].rarity < 4) then
                                table.insert(space, k)
                            end
                        end
                    end
                    if #space == 0 then table.insert(space, "j_space") end -- fallback
                    local chosen_space = space[pseudorandom(pseudoseed('mnb'), 1, #space)]
                    SMODS.add_card({key = chosen_space, key_append = 'mnb'})
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
    name = "Shareholder Joker",
    rarity = 1,
    pos = {x = 7, y = 0},
    cost = 5,
    config = {extra = {min = 1, max = 8}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.min, card.ability.extra.max}}
    end,
    calc_dollar_bonus = function(self, card)
        local rand_dollar = pseudorandom(pseudoseed('shareholder'), card.ability.extra.min, card.ability.extra.max)
        return rand_dollar
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_shareholder_joker = "Shareholder Joker"

--- Magic Hands ---

SMODS.Joker{
    key = "magic_hands",
    name = "Magic Hands",
    rarity = 2,
    pos = {x = 8, y = 0},
    cost = 6,
    -- Effect coded in lovely.toml --
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_magic_hands = "Magic Hands"

--- Tip Jar ---

SMODS.Joker{
    key = "tip_jar",
    name = "Tip Jar",
    rarity = 2,
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
    name = "Wandering Star",
    rarity = 1,
    pos = {x = 0, y = 1},
    cost = 5,
    config = {extra = 3},
    loc_vars = function(self, info_queue, card)
        return {vars = {G.GAME.probabilities.normal, card.ability.extra}}
    end,
    calculate = function(self, card, context)
        if context.reroll_shop and no_bp_retrigger(context) and pseudorandom(pseudoseed('wdrstr')) < G.GAME.probabilities.normal/card.ability.extra then
            local level_up_hands = {}
            for k, v in pairs(G.GAME.hands) do
                if v.visible then level_up_hands[#level_up_hands+1] = k end
            end
            local selected_hand = pseudorandom_element(level_up_hands, pseudoseed('wandering'))
            return {
                level_up = true,
                level_up_hand = selected_hand
            }
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_wandering_star = "Wandering Star"
SDM_0s_Stuff_Mod.space_jokers.j_sdm_wandering_star = "Wandering Star"

--- Ouija Board ---

SMODS.Joker{
    key = "ouija_board",
    name = "Ouija Board",
    rarity = 3,
    eternal_compat = false,
    perishable_compat = false,
    pos = {x = 1, y = 1},
    config = {extra = {rounds = 0, remaining = 6}},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.c_soul
        return {vars = {card.ability.extra.rounds, card.ability.extra.remaining}}
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and no_bp_retrigger(context) then
            if card.ability.extra.rounds < card.ability.extra.remaining then
                card.ability.extra.rounds = math.min(card.ability.extra.rounds + 1, card.ability.extra.remaining)
                if card.ability.extra.rounds <= card.ability.extra.remaining then
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = card.ability.extra.rounds .. "/" .. card.ability.extra.remaining})
                end
                if card.ability.extra.rounds >= card.ability.extra.remaining then
                    local eval = function(card) return not card.REMOVED end
                    juice_card_until(card, eval, true)
                end
            end
        end
        if context.selling_self and card.ability.extra.rounds >= card.ability.extra.remaining and no_bp_retrigger(context) then
            if not card.getting_sliced and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                SMODS.add_card({key = 'c_soul', key_append = 'ojb'})
                                G.GAME.consumeable_buffer = 0
                                return true
                            end}))
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral})
                    return true
                end)}))
            end
        end
    end,
    cost = 10,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_ouija_board = "Ouija Board"

--- La Révolution ---

SMODS.Joker{
    key = "la_revolution",
    name = "La Révolution",
    rarity = 3,
    blueprint_compat = true,
    pos = {x = 2, y = 1},
    cost = 8,
    config = {extra = {no_faces = true}},
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.after and no_bp_retrigger(context) then
            card.ability.extra.no_faces = true
            for i = 1, #context.full_hand do
                if context.full_hand[i]:is_face() then
                    card.ability.extra.no_faces = false
                    break
                end
            end
        end
        if context.end_of_round and context.main_eval and card.ability.extra.no_faces then
            return {
                level_up = true
            }
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_la_revolution = "La Révolution"

--- Clown Bank ---

SMODS.Joker{
    key = "clown_bank",
    name = "Clown Bank",
    rarity = 2,
    perishable_compat = false,
    blueprint_compat = true,
    pos = {x = 3, y = 1},
    cost = 8,
    config = {extra = {Xmult = 1, Xmult_mod = 0.1, dollars = 4, dollars_mod = 4}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.Xmult, card.ability.extra.Xmult_mod, card.ability.extra.dollars, card.ability.extra.dollars_mod}}
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced and no_bp_retrigger(context) then
            if to_big(G.GAME.dollars) - card.ability.extra.dollars >= to_big(G.GAME.bankrupt_at) then
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = "-"  .. localize('$') .. card.ability.extra.dollars,
                    colour = G.C.RED
                })
                ease_dollars(-card.ability.extra.dollars)
                card.ability.extra_value = card.ability.extra_value + card.ability.extra.dollars
                card:set_cost()
                G.E_MANAGER:add_event(Event({
                    func = function() card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_val_up'), colour = G.C.MONEY}); return true
                end}))
                return
            end
        elseif context.joker_main and card.ability.extra.Xmult > 1 then
            return {
                Xmult = card.ability.extra.Xmult
            }
        end
    end,
    update = function(self, card, dt)
        card.ability.extra.Xmult = 1 + math.floor(card.ability.extra_value/card.ability.extra.dollars_mod) * card.ability.extra.Xmult_mod
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_clown_bank = "Clown Bank"

--- Furnace ---

SMODS.Joker{
    key = "furnace",
    name = "Furnace",
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
    name = "Warehouse",
    rarity = 2,
    pos = {x = 5, y = 1},
    cost = 6,
    config = {extra = {h_size = 2}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.h_size}}
    end,
    add_to_deck = function(self, card, from_debuff)
        G.hand:change_size(card.ability.extra.h_size)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.h_size)
    end,
    -- "Others cards can't be sold" effect in "lovely.toml"
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_warehouse = "Warehouse"

--- Zombie Joker ---

SMODS.Joker{
    key = "zombie_joker",
    name = "Zombie Joker",
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
        if context.selling_card and no_bp_retrigger(context) then
            if context.card.ability.set == 'Joker' and pseudorandom(pseudoseed('zmbjkr')) < G.GAME.probabilities.normal/card.ability.extra then
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit or
                context.card.ability.set ~= 'Joker' and #G.consumeables.cards + G.GAME.consumeable_buffer <= G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 0.0,
                        func = (function()
                                SMODS.add_card({key = 'c_death', key_append = 'zmb'})
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
    name = "Mystery Joker",
    rarity = 1,
    blueprint_compat = true,
    pos = {x = 7, y = 1},
    cost = 6,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_TAGS.tag_rare
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval then
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
    name = "Infinite Staircase",
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
            local no_faces_and_ace = true
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
SDM_0s_Stuff_Mod.meme_jokers.j_sdm_infinite_staircase = "Infinite Staircase"

--- Ninja Joker ---

SMODS.Joker{
    key = "ninja_joker",
    name = "Ninja Joker",
    rarity = 3,
    pos = {x = 9, y = 1},
    cost = 8,
    loc_vars = function(self, info_queue, card)
        if not card.edition or (card.edition and not card.edition.negative) then
            info_queue[#info_queue+1] = G.P_CENTERS.e_negative
        end
    end,
    calculate = function(self, card, context)
        if (context.cards_destroyed and (context.glass_shattered and #context.glass_shattered > 0))
        or (context.remove_playing_cards and (context.removed and #context.removed > 0)) and no_bp_retrigger(context) then
            local my_pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then my_pos = i; break end
            end
            if my_pos and G.jokers.cards[my_pos-1] then
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        G.jokers.cards[my_pos-1]:set_edition("e_negative")
                        card:juice_up(0.3, 0.4)
                        card:start_dissolve({G.C.DARK_EDITION}, nil, 1.6)
                        return true
                    end)
                }))
            end
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_ninja_joker = "Ninja Joker"

--- Reach the Stars ---

SMODS.Joker{
    key = "reach_the_stars",
    name = "Reach the Stars",
    rarity = 1,
    blueprint_compat = true,
    pos = {x = 0, y = 2},
    cost = 5,
    config = {extra = {num_card1 = 1, num_card2 = 5, c1_scored = false, c2_scored = false}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.num_card1, card.ability.extra.num_card2,
        (card.ability.extra.c1_scored and card.ability.extra.num_card1) or "",
        (not card.ability.extra.c1_scored and card.ability.extra.num_card1) or "",
        (card.ability.extra.c2_scored and card.ability.extra.num_card2) or "",
        (not card.ability.extra.c2_scored and card.ability.extra.num_card2) or "",
    }}
    end,
    set_ability = function(self, card, initial, delay_sprites)
        local num_card1, num_card2 = rts_init()
        card.ability.extra.num_card1 = num_card1
        card.ability.extra.num_card2 = num_card2
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.final_scoring_step and not (context.before or context.after) and context.scoring_hand then
            if no_bp_retrigger(context) then
                if #context.scoring_hand == card.ability.extra.num_card1 and not card.ability.extra.c1_scored then
                    card.ability.extra.c1_scored = true
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = ((card.ability.extra.c2_scored and "2/") or "1/") .. 2,
                        colour = G.C.FILTER,
                    })
                elseif #context.scoring_hand == card.ability.extra.num_card2 and not card.ability.extra.c2_scored then
                    card.ability.extra.c2_scored = true
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = ((card.ability.extra.c1_scored and "2/") or "1/") ..  2,
                        colour = G.C.FILTER,
                    })
                end
            end
            if card.ability.extra.c1_scored and card.ability.extra.c2_scored then
                card.ability.extra.c1_scored = false
                card.ability.extra.c2_scored = false
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 0.0,
                        func = (function()
                            SMODS.add_card({set = 'Planet', key_append = 'rts'})
                            G.GAME.consumeable_buffer = 0
                            return true
                        end)}
                    ))
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = localize('k_plus_planet'),
                        colour = G.C.SECONDARY_SET.Planet,
                    })
                    if no_bp_retrigger(context) then
                        local num_card1, num_card2 = rts_init()
                        card.ability.extra.num_card1 = num_card1
                        card.ability.extra.num_card2 = num_card2
                        return {
                            message = localize('k_reset')
                        }
                    end
                end
            end
        end
    end,
    immutable = true, -- Cryptid compat to prevent impossible hand values
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_reach_the_stars = "Reach The Stars"
SDM_0s_Stuff_Mod.space_jokers.j_sdm_reach_the_stars = "Reach The Stars"

--- Crooked Joker ---

SMODS.Joker{
    key = "crooked_joker",
    name = "Crooked Joker",
    rarity = 1,
    pos = {x = 1, y = 2},
    cost = 1,
    loc_vars = function(self, info_queue, card)
        if Cryptid then
            return {key = self.key .. "_cryptid", vars = {}}
        end
    end,
    calculate = function(self, card, context)
        if context.sdm_adding_card and context.card and no_bp_retrigger(context) then
            if context.card ~= card and context.card.ability.set == 'Joker' and not context.card.not_crooked then
                local do_dupe = pseudorandom(pseudoseed('crkj'), 0, 1)
                if do_dupe == 1 then
                    if #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit - 1 then
                        G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = localize('k_plus_joker'),
                            colour = G.C.BLUE,
                        })
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                local new_card = copy_card(context.card, nil, nil, nil, nil)
                                new_card:add_to_deck2()
                                G.jokers:emplace(new_card)
                                new_card:start_materialize()
                                G.GAME.joker_buffer = 0
                                return true
                            end
                        }))
                    end
                elseif not (context.card.ability.eternal or context.card.getting_sliced) then
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
SDM_0s_Stuff_Mod.meme_jokers.j_sdm_crooked_joker = "Crooked Joker"

--- Property Damage ---

SMODS.Joker{
    key = "property_damage",
    name = "Property Damage",
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
        if context.pre_discard and no_bp_retrigger(context) then
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
                Xmult = card.ability.extra.Xmult
            }
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_property_damage = "Property Damage"
SDM_0s_Stuff_Mod.meme_jokers.j_sdm_property_damage = "Property Damage"

--- Rock'N'Roll ---

SMODS.Joker{
    key = "rock_n_roll",
    name = "Rock'N'Roll",
    rarity = 2,
    blueprint_compat = true,
    pos = {x = 3, y = 2},
    cost = 6,
    config = {extra = 1},
    calculate = function(self, card, context)
        if context.repetition and not context.individual and context.cardarea == G.play then
            if context.other_card.ability.effect ~= "Base" then
                return {
                    repetitions = card.ability.extra,
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
    name = "Contract",
    rarity = 2,
    pos = {x = 4, y = 2},
    cost = 6,
    config = {extra = {money = 8, blind_req = 2}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.money, card.ability.extra.blind_req}}
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced and no_bp_retrigger(context) then
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
    name = "Cupidon",
    rarity = 2,
    pos = {x = 5, y = 2},
    cost = 6,
    config = {extra = {hand = 1, handsize = 1, discard = 2}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.hand, card.ability.extra.handsize, card.ability.extra.discard}}
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            G.hand:change_size(card.ability.extra.handsize)
            G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hand
            ease_hands_played(card.ability.extra.hand)
            G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.discard
            ease_discard(-card.ability.extra.discard)
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if not from_debuff then
            G.hand:change_size(-card.ability.extra.handsize)
            G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hand
            G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.discard
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_cupidon = "Cupidon"

--- Pizza ---

SMODS.Joker{
    key = "pizza",
    name = "Pizza",
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = false,
    pos = {x = 6, y = 2},
    cost = 5,
    config = {extra = {hands = 4, hand_mod = 1}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.hands, card.ability.extra.hand_mod}}
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and no_bp_retrigger then
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
SDM_0s_Stuff_Mod.food_jokers.j_sdm_pizza = "Pizza"

--- Treasure Chest ---

SMODS.Joker{
    key = "treasure_chest",
    name = "Treasure Chest",
    rarity = 1,
    eternal_compat = false,
    pos = {x = 7, y = 2},
    cost = 0,
    config = {extra = 10},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra}}
    end,
    calculate = function(self, card, context)
        if context.selling_self then
            return {
                dollars = card.ability.extra
            }
        end
    end,
    pixel_size = {w = 71, h = 71},
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_treasure_chest = "Treasure Chest"

--- Bullet Train ---

SMODS.Joker{
    key = "bullet_train",
    name = "Bullet Train",
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
                chips = card.ability.extra
            }
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_bullet_train = "Bullet Train"

--- Chaos Theory ---

SMODS.Joker{
    key = "chaos_theory",
    name = "Chaos Theory",
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
                chips = card.ability.extra.chips
            }
        end
    end,
    update = function(self, card, dt)
        local num = sum_incremental(card.ability.extra.chip_mod)
        card.ability.extra.chips = num
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_chaos_theory = "Chaos Theory"

--- Jambo ---

SMODS.Joker{
    key = "jambo",
    name = "Jambo",
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
                    mult = mlt
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
    name = "Water Slide",
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
        if context.cardarea == G.jokers and context.before and context.scoring_hand and no_bp_retrigger(context) then
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:get_id() == 9 or
                context.scoring_hand[i]:get_id() == 7 or
                context.scoring_hand[i]:get_id() == 6 then
                    card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.BLUE,
                    })
                    break
                end
            end
        end
        if context.joker_main and card.ability.extra.chips > 0 then
            return {
                chips = card.ability.extra.chips,
            }
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_water_slide = "Water Slide"

--- Joker Voucher ---

SMODS.Joker{
    key = "joker_voucher",
    name = "Joker Voucher",
    rarity = 3,
    blueprint_compat = true,
    pos = {x = 2, y = 5},
    cost = 8,
    config = {extra = {Xmult_mod = 0.5}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.Xmult_mod, 1 + ((G.vouchers and #G.vouchers.cards) or 0) * card.ability.extra.Xmult_mod}}
    end,
    calculate = function(self, card, context)
        if context.buying_card and context.card.ability.set == "Voucher" then
            G.E_MANAGER:add_event(Event({
                func = function() card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_xmult',vars={1 + (#G.vouchers.cards or 0) * card.ability.extra.Xmult_mod}}}); return true
                end}))
            return
        end
        if context.joker_main then
            local xmlt = 1 + (#G.vouchers.cards or 0) * card.ability.extra.Xmult_mod
            if xmlt > 1 then
                return {
                    Xmult = xmlt
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
    name = "Free Pass",
    rarity = 1,
    pos = {x = 3, y = 5},
    cost = 5,
    config = {extra = 1},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra}}
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn and no_bp_retrigger(context) then
            local eval = function() return G.GAME.current_round.hands_played == 0 and G.GAME.current_round.discards_used == 0 end
            juice_card_until(card, eval, true)
        end
        if context.cardarea == G.jokers and context.before and (G.GAME.current_round.discards_used == 0 and G.GAME.current_round.hands_played == 0) then
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
        elseif context.pre_discard and (G.GAME.current_round.discards_used == 0 and G.GAME.current_round.hands_played == 0) then
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
    name = "Legionary Joker",
    rarity = 1,
    blueprint_compat = true,
    pos = {x = 4, y = 5},
    cost = 5,
    config = {extra = 5},
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
                    }
                else
                    return {
                        h_mult = card.ability.extra,
                    }
                end
            end
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_legionary_joker = "Legionary Joker"

--- Jack a Dit ---

SMODS.Joker{
    key = "jack_a_dit",
    name = "Jack a Dit",
    rarity = 1,
    blueprint_compat = true,
    pos = {x = 5, y = 5},
    cost = 5,
    config = {extra = 15},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra, localize(card.ability.jack_poker_hand1, 'poker_hands'), localize(card.ability.jack_poker_hand2, 'poker_hands')}}
    end,
    set_ability = function(self, card, initial, delay_sprites)
        local _poker_hands = {}
        for k, v in pairs(G.GAME.hands) do
            if v.visible then _poker_hands[#_poker_hands+1] = k end
        end
        local old_hand1, old_hand2 = card.ability.jack_poker_hand1, card.ability.jack_poker_hand2
        card.ability.jack_poker_hand1 = nil
        card.ability.jack_poker_hand2 = nil

        repeat
            card.ability.jack_poker_hand1 = pseudorandom_element(_poker_hands, pseudoseed((card.area and card.area.config.type == 'title') and 'false_to_do1' or 'to_do1'))
            if card.ability.jack_poker_hand1 == old_hand1 then card.ability.jack_poker_hand1 = nil end
            card.ability.jack_poker_hand2 = pseudorandom_element(_poker_hands, pseudoseed((card.area and card.area.config.type == 'title') and 'false_to_do2' or 'to_do2'))
            if card.ability.jack_poker_hand2 == old_hand2 then card.ability.jack_poker_hand2 = nil end
        until card.ability.jack_poker_hand1 and card.ability.jack_poker_hand2 and card.ability.jack_poker_hand1 ~= card.ability.jack_poker_hand2
    end,
    calculate = function(self, card, context)
        if context.joker_main and context.scoring_hand then
            local has_jack = false
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:get_id() == 11 then
                    has_jack = true
                    break
                end
            end
            if has_jack and (context.scoring_name and (context.scoring_name == card.ability.jack_poker_hand1 or context.scoring_name == card.ability.jack_poker_hand2)) then
                return {
                    mult = card.ability.extra,
                }
            end
        end
        if context.end_of_round and context.main_eval and no_bp_retrigger(context) then
            local _poker_hands = {}
            for k, v in pairs(G.GAME.hands) do
                if v.visible and k ~= card.ability.jack_poker_hand1 and k ~= card.ability.jack_poker_hand2 then _poker_hands[#_poker_hands+1] = k end
            end
            card.ability.jack_poker_hand1 = pseudorandom_element(_poker_hands, pseudoseed('jad1'))
            _poker_hands[card.ability.jack_poker_hand1] = nil
            card.ability.jack_poker_hand2 = pseudorandom_element(_poker_hands, pseudoseed('jad2'))
            return {
                message = localize('k_reset')
            }
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_jack_a_dit = "Jack A Dit"

--- Chain Reaction ---

SMODS.Joker{
    key = "chain_reaction",
    name = "Chain Reaction",
    rarity = 2,
    blueprint_compat = true,
    pos = {x = 6, y = 5},
    cost = 8,
    config = {extra = {mult = 0}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult}}
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.before and context.scoring_hand and context.scoring_name and no_bp_retrigger(context) then
            if string.match(string.lower(context.scoring_name), "%f[%w]kind%f[%W]$") then
                card.ability.extra.mult = card.ability.extra.mult + #context.scoring_hand
                return {
                    message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}}
                }
            end
        end
        if context.joker_main and card.ability.extra.mult > 0 then
            return {
                mult = card.ability.extra.mult
            }
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_chain_reaction = "Chain Reaction"

--- Consolation Prize ---

SMODS.Joker{
    key = "consolation_prize",
    name = "Consolation Prize",
    rarity = 2,
    blueprint_compat = true,
    pos = {x = 7, y = 5},
    cost = 6,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and G.GAME.current_round.hands_left == 0 then
            G.E_MANAGER:add_event(Event({
                func = (function()
                add_tag(Tag(get_next_tag_key("conso_prize")))
                play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {
                    message = localize('k_plus_tag'),
                    colour = G.C.FILTER,
                })
                return true
            end)
        }))
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_consolation_prize = "Consolation Prize"

--- Horoscopy ---

SMODS.Joker{
    key = "horoscopy",
    name = "Horoscopy",
    rarity = 3,
    blueprint_compat = true,
    pos = {x = 8, y = 5},
    cost = 8,
    config = {extra = 2},
    loc_vars = function(self, info_queue, card)
        return {vars = {G.GAME.probabilities.normal, card.ability.extra}}
    end,
    calculate = function(self, card, context)
        if context.using_consumeable and pseudorandom('horoscopy') < G.GAME.probabilities.normal/card.ability.extra then
            G.E_MANAGER:add_event(Event({
                func = (function()
                if context.consumeable.ability.set == 'Planet' and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 0.0,
                        func = (function()
                            SMODS.add_card({set = 'Tarot', key_append = 'ast'})
                            G.GAME.consumeable_buffer = 0
                            return true
                    end)}))
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.SECONDARY_SET.Tarot})
                end
                return true
            end)}))
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_horoscopy = "Horoscopy"
SDM_0s_Stuff_Mod.space_jokers.j_sdm_horoscopy = "Horoscopy"

--- Roulette ---

SMODS.Joker{
    key = "roulette",
    name = "Roulette",
    rarity = 3,
    blueprint_compat = true,
    pos = {x = 9, y = 5},
    cost = 8,
    config = {extra = 3},
    loc_vars = function(self, info_queue, card)
        return {vars = {G.GAME.probabilities.normal, card.ability.extra}}
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn then
            if pseudorandom('roulette') < G.GAME.probabilities.normal/card.ability.extra then
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                    local valid_cards = {}
                    for i = 1, #G.hand.cards do
                        if not G.hand.cards[i].edition then
                            table.insert(valid_cards, G.hand.cards[i])
                        end
                    end
                    for i = 1, #G.jokers.cards do
                        if not G.jokers.cards[i].edition then
                            table.insert(valid_cards, G.jokers.cards[i])
                        end
                    end
                    local edition = poll_edition('wheel_of_fortune', nil, true, true)
                    local random_card = valid_cards[pseudorandom('roulette', 1, #valid_cards)]
                    random_card:set_edition(edition, true)
                    card:juice_up(0.3, 0.5)
                    return true
                end }))
            else
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                    attention_text({
                        text = localize('k_nope_ex'),
                        scale = 1,
                        hold = 0.65*1.25-0.2,
                        major = card,
                        backdrop_colour = G.C.SECONDARY_SET.Tarot,
                        align = 'bm',
                        offset = {x = 0, y = 0.05*card.T.h},
                        silent = true
                        })
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                        play_sound('tarot2', 0.76, 0.4);
                        return true
                    end}))
                    play_sound('tarot2', 1, 0.4)
                    card:juice_up(0.6, 0.1)
                    G.ROOM.jiggle = G.ROOM.jiggle + 0.7
                    return true
                end}))
            end
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_roulette = "Roulette"

--- Carcinization ---

SMODS.Joker{
    key = "carcinization",
    name = "Carcinization",
    rarity = 2,
    blueprint_compat = true,
    pos = {x = 0, y = 6},
    cost = 7,
    config = {extra = {mult_mod = 4, mult = 0}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult_mod, card.ability.extra.mult}}
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced and no_bp_retrigger(context) then
            local my_pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then my_pos = i; break end
            end
            if my_pos and G.jokers.cards[my_pos-1] and G.jokers.cards[my_pos-1].ability.name ~= "Carcinization" and not G.jokers.cards[my_pos-1].ability.eternal then
                local carcinized_card = G.jokers.cards[my_pos-1]
                G.E_MANAGER:add_event(Event({func = function()
                    -- "set_ability" doesn't change the card's sell cost
                    carcinized_card.sell_cost = math.max(1, math.floor(G.jokers.cards[my_pos].cost/2)) + (carcinized_card.ability.extra_value or 0)
                    carcinized_card:set_ability(G.P_CENTERS["j_sdm_carcinization"], true)
                    carcinized_card:juice_up(0.3, 0.5)
                    card:juice_up(0.8, 0.8)
                    return true
                end}))
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("k_crab_ex"), colour = G.C.RED, no_juice = true})
            end
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end,
    update = function(self, card, dt)
        card.ability.extra.mult = card.ability.extra.mult_mod * get_crab_count()
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_carcinization = "Carcinization"

--- Wormhole ---

SMODS.Joker{
    key = "wormhole",
    name = "Wormhole",
    rarity = 2,
    pos = {x = 1, y = 6},
    cost = 6,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_wormhole = "Wormhole"
SDM_0s_Stuff_Mod.space_jokers.j_sdm_wormhole = "Wormhole"

--- Child ---

SMODS.Joker{
    key = "child",
    name = "Child",
    rarity = 1,
    blueprint_compat = true,
    pos = {x = 2, y = 6},
    cost = 4,
    config = {extra = 0.85},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra}}
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced then
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                G.GAME.blind.chips = math.floor(G.GAME.blind.chips * card.ability.extra)
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                local chips_UI = G.hand_text_area.blind_chips
                G.FUNCS.blind_chip_UI_scale(G.hand_text_area.blind_chips)
                G.HUD_blind:recalculate()
                if context.blueprint_card then context.blueprint_card:juice_up() else card:juice_up() end
                chips_UI:juice_up()
                if not silent then play_sound('chips2') end
            return true end }))
        end
    end,
    pixel_size = {w = 71, h = 71},
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_child = "Child"

--- Yo-yo ---

SMODS.Joker{
    key = "yo_yo",
    name = "Yo-Yo",
    rarity = 1,
    blueprint_compat = true,
    pos = {x = 3, y = 6},
    cost = 6,
    config = {extra = {low = false, low_xmult = 0.5, high_xmult = 2}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.low_xmult, card.ability.extra.high_xmult, (card.ability.extra.low and card.ability.extra.low_xmult) or card.ability.extra.high_xmult}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local curr_xmult = (card.ability.extra.low and card.ability.extra.low_xmult) or card.ability.extra.high_xmult
            if no_bp_retrigger(context) then
                card.ability.extra.low = not card.ability.extra.low
            end
            if curr_xmult ~= 1 then
                return {
                    Xmult = curr_xmult
                }
            end
        end
        if context.after and no_bp_retrigger(context) then
            local curr_xmult = (card.ability.extra.low and card.ability.extra.low_xmult) or card.ability.extra.high_xmult
            card_eval_status_text(card, 'extra', nil, nil, nil, {
                message = localize{type='variable',key='a_xmult',vars={curr_xmult}},
                colour = G.C.FILTER,
            })
        end
    end,
    atlas = "sdm_jokers"
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_yo_yo = "Yo-Yo"

--- Archibald ---

SMODS.Joker{
    key = "archibald",
    name = "Archibald",
    rarity = 4,
    blueprint_compat = true,
    config = {extra = {can_copy = true}},
    pos = {x = 0, y = 3},
    cost = 20,
    loc_vars = function(self, info_queue, card)
        if not card.edition or (card.edition and not card.edition.negative) then
            info_queue[#info_queue+1] = G.P_CENTERS.e_negative
        end
        return {vars = {(card.ability.extra.can_copy and localize("k_sdm_active")) or "", (not card.ability.extra.can_copy and localize("k_sdm_inactive")) or ""}}
    end,
    calculate = function(self, card, context)
        if context.ending_shop then
            if card.ability.extra.can_copy and #G.jokers.cards > 0 then
                local valid_cards = {}
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i].ability.name ~= "Archibald" then
                        table.insert(valid_cards, G.jokers.cards[i])
                    end
                end
                if #valid_cards > 0 then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            local rand_card = pseudorandom_element(valid_cards, pseudoseed('archi'))
                            local new_card = copy_card(rand_card, nil, nil, nil, true)
                            new_card:set_edition("e_negative", true)
                            new_card:start_materialize()
                            new_card:add_to_deck()
                            G.jokers:emplace(new_card)
                            if no_bp_retrigger(context) then
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
        if context.end_of_round and context.main_eval and no_bp_retrigger(context)
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
    name = "SDM_0",
    rarity = 4,
    perishable_compat = false,
    pos = {x = 1, y = 3},
    cost = 20,
    config = {extra = {jkr_slots = 1}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.jkr_slots}}
    end,
    calculate = function(self, card, context)
        if context.cards_destroyed and no_bp_retrigger(context) then
            if #context.glass_shattered > 0 then
                for _, v in ipairs(context.glass_shattered) do
                    if v:get_id() == 2 then
                        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.jkr_slots
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = localize{type = 'variable', key = 'a_joker_slot', vars = {card.ability.extra.jkr_slots}},
                            colour = G.C.DARK_EDITION,
                        })
                    end
                end
            end
        elseif context.remove_playing_cards and no_bp_retrigger(context) then
            if #context.removed > 0 then
                for _, v in ipairs(context.removed) do
                    if v:get_id() == 2 then
                        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.jkr_slots
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = localize{type = 'variable', key = 'a_joker_slot', vars = {card.ability.extra.jkr_slots}},
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

SDM_0s_Stuff_Mod.modded_objects.j_sdm_0 = "SDM_0"

--- Skelton ---

SMODS.Joker{
    key = "skelton",
    name = "Skelton",
    rarity = 4,
    pos = {x = 3, y = 3},
    cost = 20,
    config = {extra = {dollars = 0, dollar_mod = 1}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.dollars, card.ability.extra.dollar_mod}}
    end,
    calc_dollar_bonus = function(self, card)
        if card.ability.extra.dollars > 0 then
            return card.ability.extra.dollars
        end
    end,
    calculate = function(self, card, context)
        if context.destroying_card and context.cardarea == "unscored" and context.scoring_hand and no_bp_retrigger(context) then
            if #context.scoring_hand == 1 and context.scoring_hand[1]:get_id() == 11 then
                card.ability.extra.dollars = card.ability.extra.dollars + card.ability.extra.dollar_mod
                card.ability.skelton_triggered = true
                return {
                    remove = true,
                }
            end
		end
        if context.after and card.ability.skelton_triggered and no_bp_retrigger(context) then
            card.ability.skelton_triggered = nil
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.MONEY,
            }
        end
    end,
    atlas = "sdm_jokers",
    soul_pos = {x = 4, y = 4}
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_skelton = "Skelton"

--- Trance The Devil ---

SMODS.Joker{
    key = "trance_the_devil",
    name = "Trance The Devil",
    rarity = 4,
    perishable_compat = false,
    blueprint_compat = true,
    pos = {x = 2, y = 3},
    cost = 20,
    config = {extra = {Xmult = 1, Xmult_mod = 0.25}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.Xmult_mod, card.ability.extra.Xmult}}
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not (context.blueprint_card or card).getting_sliced and no_bp_retrigger(context) then
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
                Xmult = card.ability.extra.Xmult
            }
        end
    end,
    atlas = "sdm_jokers",
    soul_pos = {x = 2, y = 4}
}

SDM_0s_Stuff_Mod.modded_objects.j_sdm_trance_the_devil = "Trance The Devil"