--- STEAMODDED HEADER
--- MOD_NAME: SDM_0's Stuff
--- MOD_ID: sdm_0s_stuff
--- MOD_AUTHOR: [SDM_0]
--- MOD_DESCRIPTION: Bunch of stuff I've modded into Balatro. Enjoy!
--- BADGE_COLOUR: c20000

----------------------------------------------
------------MOD CODE -------------------------

--- Config ---

local config = {
    j_sdm_trance_the_devil = true,
    j_sdm_burger = true,
    j_sdm_bounciest_ball = true,
    j_sdm_lucky_joker = true,
    j_sdm_iconic_icon = true,
    j_sdm_mult_n_chips = true,
    j_sdm_moon_base = true,
    j_sdm_shareholder_joker = true,
    j_sdm_magic_hands = true,
    j_sdm_tip_jar = true,
    j_sdm_wandering_star = true,
    j_sdm_ouija_board = true,
    j_sdm_la_revolution = true,
    j_sdm_clown_bank = true,
    j_sdm_furnace = true,
    j_sdm_warehouse = true,
    j_sdm_zombie_joker = true,
    j_sdm_mystery_joker = true,
    j_sdm_infinite_staircase = true,
    j_sdm_ninja_joker = true,
    j_sdm_archibald = true,
}

local placeholder_art = false --- Set it to true if you want to play with placeholder art of this mod's jokers

local space_jokers = {
    -- Vanilla --
    ["Supernova"] = "j_supernova",
    ["Space Joker"] = "j_space",
    ["Constellation"] = "j_constellation",
    ["Rocket"] = "j_rocket",
    ["Satellite"] = "j_satellite",
    ["Astronomer"] = "j_astronomer",

    -- SDM_0's Stuff --
    ["Moon Base"] = "j_sdm_moon_base",
    ["Wandering Star"] = "j_sdm_wandering_star",

    -- Other mods --
    ["Afterburner"] = "j_fuel_tank", -- Ortolab
    ["Blue Moon"] = "j_mmc_blue_moon", -- Mika's Mod
    ["Sentai Joker"] = "j_sentai", -- Jank Jonklers
    ["Ternary System"] = "j_ternary_system", -- Jank Jonklers
    ["Big Bang"] = "j_big_bang", -- Fusion Joker
}

--- Functions ---

--- Registering modded Jokers ---
function register_elem(id)
    new_id_slug = id.slug

    if placeholder_art and id.slug ~= "j_sdm_archibald" then
        new_id_slug = new_id_slug .. "_ph"
    end

    if new_id_slug:sub(1, 1) == "j" then
        local sprite = SMODS.Sprite:new(
            id.slug,
            SMODS.findModByID("sdm_0s_stuff").path,
            new_id_slug .. ".png",
            71,
            95,
            "asset_atli"
        )

        id:register()
        sprite:register()
    else
        id:register()
    end
end

--- Get the amount of time a consumable has been used, returns 0 if never used
function get_count(card)
    if G.GAME.consumeable_usage[card] and G.GAME.consumeable_usage[card].count then
        return G.GAME.consumeable_usage[card].count
    else
        return 0
    end
end

--- Get the max occurence of a card in a hand
function count_max_occurence(table)
    local max_card = 0
    local counts = {}
    for _, value in ipairs(table) do
        counts[value] = (counts[value] or 0) + 1
    end

    for _, v in pairs(counts) do
        if v > max_card then
            max_card = v
        end
    end
    return max_card
end

-- Get n jokers from SDM_0's Stuff
function get_random_sdm_modded_jokers(n, no_legend)
    local modded_jokers = {}
    local random_jokers = {}

    for k,v in pairs(config) do
        if v then
            if no_legend and k ~= "j_sdm_archibald" then
                table.insert(modded_jokers, k)
            end
        end
    end

    if modded_jokers and #modded_jokers >= n then
        while n > 0 do
            if G.GAME then
                r_joker = modded_jokers[pseudorandom("deck_create", 1, #modded_jokers)]
            end
            table.insert(random_jokers, r_joker)
            for i = 1, #modded_jokers do
                if modded_jokers[i] == r_joker then
                    table.remove(modded_jokers, i)
                end
            end
            n = n - 1
        end
        return random_jokers
    else
        return nil
    end
end

--- Text ---

G.localization.misc.dictionary.k_all = "+/X All"
G.localization.misc.v_text.ch_c_no_shop_planets = {"{C:planet}Planets{} no longer appear in the {C:attention}shop"}

function SMODS.INIT.sdm_0s_stuff() 

    init_localization()

    --- Deck ---

    --- SDM_0's Deck ---

    if get_random_sdm_modded_jokers(2, true) then

        local b_sdm_sdm_0_s_deck_loc_def = {
            name ="SDM_0's Deck",
            text ={
                "Start run with",
                "{C:attention}2{} random {C:eternal}Eternal non-{C:legendary}legendary",
                "{C:attention}SDM_0's Stuff{} jokers",
        },
        }

        local b_sdm_sdm_0_s_deck = SMODS.Deck:new(
            "SDM_0's Deck", "sdm_sdm_0_s_deck",
            {b_sdm_sdm_0_s_deck = true},
            {x = 5, y = 2},
            b_sdm_sdm_0_s_deck_loc_def
        )

        register_elem(b_sdm_sdm_0_s_deck)
    end

    --- Challenges ---

    --- Devil's Deal ---

    if config.j_sdm_trance_the_devil then

        G.localization.misc.challenge_names["c_mod_sdm0_dd"] = "Devil's Deal"

        table.insert(G.CHALLENGES,#G.CHALLENGES+1,{
            name = "Devil's Deal",
            id = 'c_mod_sdm0_dd',
            rules = {
                custom = {
                },
                modifiers = {
                    {id = 'dollars', value = 0},
                    {id = 'discards', value = 3},
                    {id = 'hands', value = 3},
                    {id = 'reroll_cost', value = 8},
                    {id = 'joker_slots', value = 4},
                }
            },
            jokers = {
                {id = 'j_sdm_trance_the_devil', eternal = true},
            },
            consumeables = {
                {id = 'c_trance'},
                {id = 'c_devil'},
            },
            vouchers = {
                {id = 'v_tarot_merchant'},
                {id = 'v_tarot_tycoon'},
                {id = 'v_omen_globe'},
            },
            deck = {
                type = 'Challenge Deck'
            },
            restrictions = {
                banned_cards = {
                    {id = 'j_burglar'},
                    {id = 'j_drunkard'},
                    {id = 'j_merry_andy'},
                    {id = 'v_crystal_ball'},
                    {id = 'v_grabber'},
                    {id = 'v_nacho_tong'},
                    {id = 'v_wasteful'},
                    {id = 'v_recyclomancy'},
                },
                banned_tags = {},
                banned_other = {}
            }
        })
    end

    --- Scientific Downfall ---

    if config.j_sdm_la_revolution then

        G.localization.misc.challenge_names["c_mod_sdm0_sd"] = "Scientific Downfall"

        table.insert(G.CHALLENGES,#G.CHALLENGES+1,{
            name = "Scientific Downfall",
            id = 'c_mod_sdm0_sd',
            rules = {
                custom = {
                    {id = 'no_shop_planets'},
                },
                modifiers = {
                    {id = 'discards', value = 4},
                    {id = 'hands', value = 2},
                },
            },
            jokers = {
                {id = 'j_sdm_la_revolution', eternal = true},
            },
            consumeables = {
            },
            vouchers = {
            },
            deck = {
                type = 'Challenge Deck'
            },
            restrictions = {
                banned_cards = {
                    {id = 'c_high_priestess'},
                    {id = 'c_black_hole'},
                    {id = 'c_trance'},
                    {id = 'p_celestial_normal_1', ids = {
                        'p_celestial_normal_1','p_celestial_normal_2','p_celestial_normal_3','p_celestial_normal_4','p_celestial_jumbo_1','p_celestial_jumbo_2','p_celestial_mega_1','p_celestial_mega_2',
                    }},
                    {id = 'j_8_ball'},
                    {id = 'j_space'},
                    {id = 'j_constellation'},
                    {id = 'j_certificate'},
                    {id = 'j_satellite'},
                    {id = 'j_astronomer'},
                    {id = 'j_burnt'},
                    {id = 'j_sdm_wandering_star'},
                    {id = 'v_telescope'},
                    {id = 'v_observatory'},
                    {id = 'v_planet_merchant'},
                    {id = 'v_planet_tycoon'},
                },
                banned_tags = {
                    {id = 'tag_meteor'},
                    {id = 'tag_orbital'},
                },
                banned_other = {}
            }
        })
    end

    --- A Plumber's Hassle ---

    if config.j_sdm_infinite_staircase then

        G.localization.misc.challenge_names["c_mod_sdm0_aph"] = "A Plumber's Hassle"

        table.insert(G.CHALLENGES,#G.CHALLENGES+1,{
            name = "A Plumber's Hassle",
            id = 'c_mod_sdm0_aph',
            rules = {
                custom = {
                },
                modifiers = {
                    {id = 'joker_slots', value = 4},
                    {id = 'hands', value = 3},
                },
            },
            jokers = {
                {id = 'j_sdm_infinite_staircase', eternal = true},
                {id = 'j_runner', eternal = true},
            },
            consumeables = {
            },
            vouchers = {
            },
            deck = {
                type = 'Challenge Deck'
            },
            restrictions = {
                banned_cards = {
                    {id = 'v_grabber'},
                    {id = 'v_nacho_tong'},
                    {id = 'j_burglar'},
                },
                banned_tags = {
                },
                banned_other = {}
            }
        })
    end

    --- Spare Change ---

    if config.j_sdm_clown_bank and config.j_sdm_tip_jar then

        G.localization.misc.challenge_names["c_mod_sdm0_sc"] = "Spare Change"

        table.insert(G.CHALLENGES,#G.CHALLENGES+1,{
            name = "Spare Change",
            id = 'c_mod_sdm0_sc',
            rules = {
                custom = {
                    {id = 'no_extra_hand_money'},
                    {id = 'no_interest'}
                },
                modifiers = {
                },
            },
            jokers = {
                {id = 'j_sdm_clown_bank', eternal = true},
                {id = 'j_sdm_tip_jar', eternal = true},
            },
            consumeables = {
            },
            vouchers = {
            },
            deck = {
                type = 'Challenge Deck'
            },
            restrictions = {
                banned_cards = {
                    {id = 'v_seed_money'},
                    {id = 'v_money_tree'},
                    {id = 'j_to_the_moon'},
                    {id = 'j_rocket'},
                    {id = 'j_golden'},
                    {id = 'j_satellite'},
                    {id = 'j_sdm_shareholder_joker'},
                },
                banned_tags = {
                },
                banned_other = {}
            }
        })
    end

    --- Archifoolery ---

    if config.j_sdm_archibald then

        G.localization.misc.challenge_names["c_mod_sdm0_af"] = "Archifoolery"

        table.insert(G.CHALLENGES,#G.CHALLENGES+1,{
            name = "Archifoolery",
            id = 'c_mod_sdm0_af',
            rules = {
                custom = {
                },
                modifiers = {
                    {id = 'joker_slots', value = 1},
                },
            },
            jokers = {
                {id = 'j_sdm_archibald', edition = "negative"},
            },
            consumeables = {
            },
            vouchers = {
            },
            deck = {
                type = 'Challenge Deck'
            },
            restrictions = {
                banned_cards = {
                },
                banned_tags = {
                },
                banned_other = {}
            }
        })
    end

    --- Joker Abilities ---

    --- Trance The Devil ---

    if config.j_sdm_trance_the_devil then

        local j_sdm_trance_the_devil = SMODS.Joker:new(
            'Trance The Devil', 'sdm_trance_the_devil',
            {extra = 0.25}, {x=0, y=0}, 
            {
                name = "Trance The Devil",
                text = {
                    "{X:mult,C:white}X#1#{} Mult per {C:spectral}Trance{} and",
                    "{C:tarot}The Devil{} card used this run",
                    "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive})"
                }
            }, 2, 6, true, true, true, true
        )

        register_elem(j_sdm_trance_the_devil)


        SMODS.Jokers.j_sdm_trance_the_devil.loc_def = function(card)
            return {card.ability.extra, 1 + ((get_count('c_trance') or 1) / (1 / card.ability.extra) + (get_count('c_devil') or 1) / (1 / card.ability.extra))}
        end

        SMODS.Jokers.j_sdm_trance_the_devil.calculate = function(card, context)
            if context.using_consumeable and not context.blueprint then
                if context.consumeable.ability.name == 'Trance' or context.consumeable.ability.name == 'The Devil' then
                    G.E_MANAGER:add_event(Event({func = function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_xmult',
                        vars={1 + ((get_count('c_trance') or 1) / (1 / card.ability.extra) + (get_count('c_devil') or 1) / (1 / card.ability.extra))}}});
                        return true end}))
                    return
                end
            elseif SMODS.end_calculate_context(context) and
                (1 + ((get_count('c_trance') or 1) / (1 / card.ability.extra) + (get_count('c_devil') or 1) / (1 / card.ability.extra)) > 1) then
                return {
                    message = localize{type='variable',key='a_xmult',vars={1 + ((get_count('c_trance') or 1) / (1 / card.ability.extra) + (get_count('c_devil') or 1) / (1 / card.ability.extra))}},
                    Xmult_mod = 1 + ((get_count('c_trance') or 1) / (1 / card.ability.extra) + (get_count('c_devil') or 1) / (1 / card.ability.extra))
                }
            end
        end
    end

    --- Burger ---

    if config.j_sdm_burger then

        local j_sdm_burger = SMODS.Joker:new(
            "Burger", "sdm_burger",
            {extra = {Xmult=1.25, mult=10, chips=30, remaining=4}}, {x=0, y=0},
            {
                name = "Burger",
                text = {
                    "{C:chips}+#3#{} Chips, {C:mult}+#2#{} Mult and {X:mult,C:white}X#1#{} Mult",
                    "for the next {C:attention}#4#{} rounds",
                }
            }, 3, 8, true, true, true, false
        )

        register_elem(j_sdm_burger)

        SMODS.Jokers.j_sdm_burger.loc_def = function(card)
            return {card.ability.extra.Xmult, card.ability.extra.mult, card.ability.extra.chips, card.ability.extra.remaining}
        end

        SMODS.Jokers.j_sdm_burger.calculate = function(card, context)
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
            elseif SMODS.end_calculate_context(context) then
                return {
                    message = localize('k_all'),
                    colour = G.C.PURPLE,
                    chip_mod = card.ability.extra.chips,
                    mult_mod = card.ability.extra.mult,
                    Xmult_mod = card.ability.extra.Xmult
                }
            end
        end
    end

    --- Bounciest Ball ---

    if config.j_sdm_bounciest_ball then

        local j_sdm_bounciest_ball = SMODS.Joker:new(
            "Bounciest Ball", "sdm_bounciest_ball",
            {extra = {chips = 0, chip_mod = 10, hand = "High Card"}}, {x=0, y=0},
            {
                name = "Bounciest Ball",
                text = {
                    "This Joker gains {C:chips}+#2#{} Chips every time",
                    "a {C:attention}#3#{} is scored, reset and",
                    "change on {C:attention}different hand{}",
                    "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)"
            }}, 1, 5, true, true, true, true
        )

        register_elem(j_sdm_bounciest_ball)

        SMODS.Jokers.j_sdm_bounciest_ball.loc_def = function(card)
            return {card.ability.extra.chips, card.ability.extra.chip_mod, card.ability.extra.hand}
        end

        SMODS.Jokers.j_sdm_bounciest_ball.calculate  = function(card, context)
            if context.cardarea == G.jokers and context.before and not context.blueprint then
                if context.scoring_name == card.ability.extra.hand then
                    card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.CHIPS,
                        card = card
                    }
                else
                    card.ability.extra.chips = 0
                    card.ability.extra.hand = context.scoring_name
                    return {
                        message = localize('k_reset'),
                        colour = G.C.RED,
                    }
                end
            elseif SMODS.end_calculate_context(context) and card.ability.extra.chips > 0 then
                return {
                    message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
                    chip_mod = card.ability.extra.chips
                }
            end
        end
    end

    --- Lucky Joker ---

    if config.j_sdm_lucky_joker then

        local j_sdm_lucky_joker = SMODS.Joker:new(
            "Lucky Joker", "sdm_lucky_joker",
            {extra = {chips = 7, mult = 7, repitition = 1}},  {x=0, y=0},
            {
                name = "Lucky Joker",
                text = {
                    "Retrigger each played {C:attention}Lucky{} card {C:attention}7{},",
                    "each played {C:attention}7{} gives {C:chips}+#1#{} Chips",
                    "and {C:mult}+#2#{} Mult when scored",
                },
            }, 1, 4, true, true, true, true
        )

        register_elem(j_sdm_lucky_joker)

        SMODS.Jokers.j_sdm_lucky_joker.loc_def = function(card)
            return {card.ability.extra.chips, card.ability.extra.mult}
        end

        SMODS.Jokers.j_sdm_lucky_joker.calculate  = function(card, context)
            if context.repetition and not context.individual and context.cardarea == G.play
            and context.other_card:get_id() == 7 and context.other_card.ability.effect == "Lucky Card" then
                return {
                    message = localize('k_again_ex'),
                    repetitions = card.ability.extra.repitition,
                    card = card
                }
            end
            if context.individual and context.cardarea == G.play and context.other_card:get_id() == 7 then
                return {
                    chips = card.ability.extra.chips,
                    mult = card.ability.extra.mult,
                    card = card
                }
            end
        end
    end

    --- Iconic Icon ---

    if config.j_sdm_iconic_icon then

        local j_sdm_iconic_icon = SMODS.Joker:new(
            "Iconic Icon", "sdm_iconic_icon",
            {extra = {mult = 0, mult_mod = 4}},  {x=0, y=0},
            {
                name = "Iconic Icon",
                text = {
                    "{C:mult}+#2#{} Mult per{C:attention} modified Aces",
                    "(enhancement, seal, edition)",
                    "in your {C:attention}full deck",
                    "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
                }
            }, 1, 6, true, true, true, true
        )

        register_elem(j_sdm_iconic_icon)

        SMODS.Jokers.j_sdm_iconic_icon.loc_def = function(card)
            return {card.ability.extra.mult, card.ability.extra.mult_mod}
        end

        SMODS.Jokers.j_sdm_iconic_icon.calculate  = function(card, context)
            if SMODS.end_calculate_context(context) and card.ability.extra.mult > 0 then
                return {
                    message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
                    mult_mod = card.ability.extra.mult,
                    colour = G.C.MULT
                }
            end
        end
    end

    --- Mult N Chips Joker ---

    if config.j_sdm_mult_n_chips then

        local j_sdm_mult_n_chips = SMODS.Joker:new(
            "Mult'N'Chips", "sdm_mult_n_chips",
            {extra = {mult = 4, chips = 30}},  {x=0, y=0},
            {
                name = "Mult'N'Chips",
                text = {
                    "Scored {C:attention}Bonus{} cards gives {C:mult}+#1#{} Mult,",
                    "scored {C:attention}Mult{} cards gives {C:chips}+#2#{} Chips",
                }
            }, 1, 5, true, true, true, true
        )

        register_elem(j_sdm_mult_n_chips)

        SMODS.Jokers.j_sdm_mult_n_chips.loc_def = function(card)
            return {card.ability.extra.mult, card.ability.extra.chips}
        end

        SMODS.Jokers.j_sdm_mult_n_chips.calculate  = function(card, context)
            if context.individual and context.cardarea == G.play then
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
        end
    end

    --- Moon Base ---

    if config.j_sdm_moon_base then

        local j_sdm_moon_base = SMODS.Joker:new(
            "Moon Base", "sdm_moon_base",
            {extra = 50},  {x=0, y=0},
            {
                name = "Moon Base",
                text = {
                    "{C:attention}Space{} Jokers each",
                    "give{C:chips} +#1# {}Chips",
                }
            }, 2, 7, true, true, true, true
        )

        register_elem(j_sdm_moon_base)

        SMODS.Jokers.j_sdm_moon_base.loc_def = function(card)
            return {card.ability.extra}
        end

        SMODS.Jokers.j_sdm_moon_base.calculate  = function(card, context)
            if context.other_joker then
                if space_jokers[context.other_joker.ability.name] and context.other_joker ~= card then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            context.other_joker:juice_up(0.5, 0.5)
                            return true
                        end
                    })) 
                    return {
                        message = localize{type='variable',key='a_chips',vars={card.ability.extra}},
                        chip_mod = card.ability.extra
                    }
                end
            end
        end
    end

    --- Shareholder Joker ---

    if config.j_sdm_shareholder_joker then

        local j_sdm_shareholder_joker = SMODS.Joker:new(
            "Shareholder Joker", "sdm_shareholder_joker",
            {extra = {min = 1, max = 8}},  {x=0, y=0},
            {
                name = "Shareholder Joker",
                text = {
                    "Earn between {C:money}$#1#{} and {C:money}$#2#{}",
                    "at end of round",
                }
            }, 1, 5, true, true, false, true
        )

        register_elem(j_sdm_shareholder_joker)

        SMODS.Jokers.j_sdm_shareholder_joker.loc_def = function(card)
            return {card.ability.extra.min, card.ability.extra.max}
        end
    end

    --- Magic Hands ---

    if config.j_sdm_magic_hands then

        local j_sdm_magic_hands = SMODS.Joker:new(
            "Magic Hands", "sdm_magic_hands",
            {extra = 3},  {x=0, y=0},
            {
                name = "Magic Hands",
                text = {
                    "{X:mult,C:white}X#1#{} Mult if number of {C:chips}hands{} left + 1",
                    "equals the most prevalent card amount",
                    "{C:inactive}(ex: {C:attention}Four of a Kind{} {C:inactive}on {C:chips}Hand 4{C:inactive})",
                }
            }, 2, 6, true, true, true, true
        )

        register_elem(j_sdm_magic_hands)

        SMODS.Jokers.j_sdm_magic_hands.loc_def = function(card)
            return {card.ability.extra}
        end

        SMODS.Jokers.j_sdm_magic_hands.calculate  = function(card, context)
            if SMODS.end_calculate_context(context) then
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
        end
    end

    --- Tip Jar ---

    if config.j_sdm_tip_jar then

        local j_sdm_tip_jar = SMODS.Joker:new(
            "Tip Jar", "sdm_tip_jar",
            {},  {x=0, y=0},
            {
                name = "Tip Jar",
                text = {
                    "Earn your money's {C:attention}highest digit",
                    "at end of round",
                }
            }, 2, 6, true, true, false, true
        )

        register_elem(j_sdm_tip_jar)

        SMODS.Jokers.j_sdm_tip_jar.loc_def = function(card)
            return {}
        end
    end

    --- Wandering Star ---

    if config.j_sdm_wandering_star then

        local j_sdm_wandering_star = SMODS.Joker:new(
            "Wandering Star", "sdm_wandering_star",
            {extra = {mult = 0, mult_mod = 3}},  {x=0, y=0},
            {
                name = "Wandering Star",
                text = {
                    "{C:red}+#2#{} Mult per",
                    "{C:planet}Planet{} card sold",
                    "{C:inactive}(Currently {C:red}+#1#{C:inactive} Mult)"
                }
            }, 1, 6, true, true, true, true
        )

        register_elem(j_sdm_wandering_star)

        SMODS.Jokers.j_sdm_wandering_star.loc_def = function(card)
            return {card.ability.extra.mult, card.ability.extra.mult_mod}
        end

        SMODS.Jokers.j_sdm_wandering_star.calculate  = function(card, context)
            if context.selling_card and not context.blueprint then
                if context.card.ability.set == 'Planet' then
                    card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
                    G.E_MANAGER:add_event(Event({
                        func = function() card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}}}); return true
                    end}))
                end
            end
            if SMODS.end_calculate_context(context) and card.ability.extra.mult > 0 then
                return {
                    message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
                    mult_mod = card.ability.extra.mult
                }
            end
        end
    end

    --- Ouija Board ---

    if config.j_sdm_ouija_board then

        local j_sdm_ouija_board = SMODS.Joker:new(
            "Ouija Board", "sdm_ouija_board",
            {extra = {remaining = 0, rounds = 3, sold_rare = false, scored_secret = false, used_spectral = false}},  {x=0, y=0},
            {
                name = "Ouija Board",
                text = {
                    "After selling a {C:red}Rare {C:attention}Joker{}, scoring a",
                    "{C:attention}secret poker hand{} and using a {C:spectral}Spectral card{},",
                    "sell this card to create a {C:spectral}Soul{} card",
                    "{C:inactive}(Must have room)",
                    "{C:inactive}(Remaining {C:attention}#1#{C:inactive}/#2#)"
                }
            }, 3, 8, true, true, false, false
        )

        register_elem(j_sdm_ouija_board)

        SMODS.Jokers.j_sdm_ouija_board.loc_def = function(card)
            return {card.ability.extra.remaining, card.ability.extra.rounds}
        end

        SMODS.Jokers.j_sdm_ouija_board.calculate  = function(card, context)
            if context.selling_card and not context.blueprint and context.card.ability.set == 'Joker' then
                if context.card.config.center.rarity == 3 then
                    if not card.ability.extra.sold_rare then
                        card.ability.extra.sold_rare = true
                        card.ability.extra.remaining = card.ability.extra.remaining + 1
                        if card.ability.extra.remaining == card.ability.extra.rounds then 
                            local eval = function(card) return not card.REMOVED end
                            juice_card_until(card, eval, true)
                        end
                        if card.ability.extra.remaining < card.ability.extra.rounds then
                            card_eval_status_text(card, 'extra', nil, nil, nil, {
                                message = card.ability.extra.remaining ..'/'.. card.ability.extra.rounds,
                                colour = G.C.FILTER
                            })
                        else
                            G.E_MANAGER:add_event(Event({
                                func = (function()
                                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                                        message = localize('k_active_ex'),
                                        colour = G.C.FILTER
                                    })
                                    G.E_MANAGER:add_event(Event({
                                        func = function() 
                                            local eval = function(card) return not card.REMOVED end
                                            juice_card_until(card, eval, true)
                                            return true
                                        end}))
                                return true
                            end)}))
                        end
                    end
                end
            end
            if context.using_consumeable and not context.blueprint then
                if context.consumeable.ability.set == "Spectral" then
                    if not card.ability.extra.used_spectral then
                        card.ability.extra.used_spectral = true
                        card.ability.extra.remaining = card.ability.extra.remaining + 1
                        if card.ability.extra.remaining == card.ability.extra.rounds then 
                            local eval = function(card) return not card.REMOVED end
                            juice_card_until(card, eval, true)
                        end
                        if card.ability.extra.remaining < card.ability.extra.rounds then
                            card_eval_status_text(card, 'extra', nil, nil, nil, {
                                message = card.ability.extra.remaining ..'/'.. card.ability.extra.rounds,
                                colour = G.C.FILTER
                            })
                        else
                            G.E_MANAGER:add_event(Event({
                                func = (function()
                                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                                        message = localize('k_active_ex'),
                                        colour = G.C.FILTER
                                    })
                                    G.E_MANAGER:add_event(Event({
                                        func = function() 
                                            local eval = function(card) return not card.REMOVED end
                                            juice_card_until(card, eval, true)
                                            return true
                                        end}))
                                return true
                            end)}))
                        end
                    end
                end
            end
            if SMODS.end_calculate_context(context) and not context.blueprint then
                if context.scoring_name and context.scoring_name == 'Five of a Kind' or context.scoring_name == 'Flush House' or context.scoring_name == 'Flush Five' then
                    if not card.ability.extra.scored_secret then
                        card.ability.extra.scored_secret = true
                        card.ability.extra.remaining = card.ability.extra.remaining + 1
                        if card.ability.extra.remaining < card.ability.extra.rounds then
                            card_eval_status_text(card, 'extra', nil, nil, nil, {
                                message = card.ability.extra.remaining ..'/'.. card.ability.extra.rounds,
                                colour = G.C.FILTER
                            })
                        else
                            G.E_MANAGER:add_event(Event({
                                func = (function()
                                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                                        message = localize('k_active_ex'),
                                        colour = G.C.FILTER
                                    })
                                    G.E_MANAGER:add_event(Event({
                                        func = function() 
                                            local eval = function(card) return not card.REMOVED end
                                            juice_card_until(card, eval, true)
                                            return true
                                        end}))
                                return true
                            end)}))
                        end
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
        end
    end

    --- La Révolution ---

    if config.j_sdm_la_revolution then

        local j_sdm_la_revolution = SMODS.Joker:new(
            "La Révolution", "sdm_la_revolution",
            {hand = "High Card"},  {x=0, y=0},
            {
                name = "La Révolution",
                text = {
                    "Upgrade {C:attention}winning poker hand{} by 1",
                    "if played hand contains no {C:attention}face{} cards",
                }
            }, 3, 7, true, true, true, true
        )

        register_elem(j_sdm_la_revolution)

        SMODS.Jokers.j_sdm_la_revolution.loc_def = function(card)
            return {}
        end

        SMODS.Jokers.j_sdm_la_revolution.calculate  = function(card, context)
            if context.cardarea == G.jokers then
                if context.before and context.scoring_name then
                    card.ability.hand = context.scoring_name
                elseif context.after and G.GAME.chips + hand_chips * mult > G.GAME.blind.chips then
                    no_faces = true
                    for i = 1, #context.full_hand do
                        if context.full_hand[i]:is_face() then
                            no_faces = false
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
        end
    end

    --- Clown Bank ---

    if config.j_sdm_clown_bank then

        local j_sdm_clown_bank = SMODS.Joker:new(
            "Clown Bank", "sdm_clown_bank",
            {extra = {Xmult=1, Xmult_mod=0.25, dollars = 1, inflation = 1}},  {x=0, y=0},
            {
                name = "Clown Bank",
                text = {
                    "When {C:attention}Blind{} is selected, this Joker gains",
                    "{X:mult,C:white}X#2#{} Mult for {C:money}$#3#{} if possible,",
                    "increases cost by {C:money}$#4#{}",
                    "{C:inactive}(Currenty {X:mult,C:white}X#1#{C:inactive} Mult)"
                }
            }, 3, 8, true, true, true, true
        )

        register_elem(j_sdm_clown_bank)

        SMODS.Jokers.j_sdm_clown_bank.loc_def = function(card)
            return {card.ability.extra.Xmult, card.ability.extra.Xmult_mod, card.ability.extra.dollars, card.ability.extra.inflation}
        end

        SMODS.Jokers.j_sdm_clown_bank.calculate  = function(card, context)
            if context.setting_blind and not context.blueprint then
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
            elseif SMODS.end_calculate_context(context) and card.ability.extra.Xmult > 1 then
                return {
                    message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
                    Xmult_mod = card.ability.extra.Xmult
                }
            end
        end
    end

    --- Furnace ---

    if config.j_sdm_furnace then
        
        local j_sdm_furnace = SMODS.Joker:new(
            "Furnace", "sdm_furnace",
            {extra = {Xmult= 1, dollars = 0, Xmult_mod = 0.5, dollars_mod = 2}},  {x=0, y=0},
            {
                name = "Furnace",
                text = {
                    "If {C:attention}first played hand{} is a",
                    "single {C:attention}Steel{} card or {C:attention}Gold{} card,",
                    "destroy it and gain {X:mult,C:white}X#3#{} or {C:money}$#4#{},",
                    "{C:inactive}(Currenty {X:mult,C:white}X#1#{C:inactive} Mult, {C:money}$#2#{C:inactive})"
                }
            }, 2, 8, true, true, true, true
        )

        register_elem(j_sdm_furnace)

        SMODS.Jokers.j_sdm_furnace.loc_def = function(card)
            return {card.ability.extra.Xmult, card.ability.extra.dollars, card.ability.extra.Xmult_mod, card.ability.extra.dollars_mod}
        end

        SMODS.Jokers.j_sdm_furnace.calculate  = function(card, context)
            if context.cardarea == G.jokers and context.before and not context.blueprint then
                if #context.full_hand == 1 and G.GAME.current_round.hands_played == 0 then
                    if context.full_hand[1].ability.name == 'Gold Card' then
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')})
                        card.ability.extra.dollars =  card.ability.extra.dollars + card.ability.extra.dollars_mod
                    elseif context.full_hand[1].ability.name == 'Steel Card' then
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')})
                        card.ability.extra.Xmult =  card.ability.extra.Xmult + card.ability.extra.Xmult_mod
                    end
                end
            end
            if context.destroying_card and not context.blueprint and #context.full_hand == 1 and G.GAME.current_round.hands_played == 0 then
                    if context.full_hand[1].ability.name == 'Gold Card' or context.full_hand[1].ability.name == 'Steel Card' then
                       return true
                    end
                return nil
            end
            if SMODS.end_calculate_context(context) and card.ability.extra.Xmult > 1 then
                return {
                    message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
                    Xmult_mod = card.ability.extra.Xmult
                }
            end
        end
    end

    --- Warehouse ---

    if config.j_sdm_warehouse then
        
        local j_sdm_warehouse = SMODS.Joker:new(
            "Warehouse", "sdm_warehouse",
            {extra = {h_size = 3, c_size = 0, dollars = -50}},  {x=0, y=0},
            {
                name = "Warehouse",
                text = {
                    "{C:attention}+#1#{} hand size,",
                    "{C:red}No consumable slots{},",
                    "lose {C:money}$#2#{} if sold"
                }
            }, 2, 6, true, true, false, true
        )

        register_elem(j_sdm_warehouse)

        SMODS.Jokers.j_sdm_warehouse.loc_def = function(card)
            return {card.ability.extra.h_size, -card.ability.extra.dollars}
        end

        SMODS.Jokers.j_sdm_warehouse.set_ability = function(card)
            if card.set_cost then 
                card.ability.extra_value = card.ability.extra.dollars - math.floor(card.base_cost / 2)
                card:set_cost()
            end
        end
    end

    --- Zombie Joker ---

    if config.j_sdm_zombie_joker then
        
        local j_sdm_zombie_joker = SMODS.Joker:new(
            "Zombie Joker", "sdm_zombie_joker",
            {extra = 3},  {x=0, y=0},
            {
                name = "Zombie Joker",
                text = {
                    "{C:green}#1# in #2#{} chance to create a",
                    "{C:tarot}Death{} card when {C:attention}selling{}",
                    "a card other than {C:tarot}Death{}",
                    "{C:inactive}(Must have room)"
                }
            }, 1, 4, true, true, true, true
        )

        register_elem(j_sdm_zombie_joker)

        SMODS.Jokers.j_sdm_zombie_joker.loc_def = function(card)
            return {''..(G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra}
        end

        SMODS.Jokers.j_sdm_zombie_joker.calculate = function(card, context)
            if context.selling_card then
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
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.SECONDARY_SET.Tarot})
                    end
                end
            end
        end
    end

    --- Mystery Joker ---

    if config.j_sdm_mystery_joker then
        
        local j_sdm_mystery_joker = SMODS.Joker:new(
            "Mystery Joker", "sdm_mystery_joker",
            {},  {x=0, y=0},
            {
                name = "Mystery Joker",
                text = {
                    "Create a {C:red}Rare {C:attention}Joker Tag",
                    "when {C:attention}Boss Blind{} is defeated",
                }
            }, 1, 6, true, true, true, true
        )

        register_elem(j_sdm_mystery_joker)

        SMODS.Jokers.j_sdm_mystery_joker.loc_def = function(card)
            return {}
        end

        SMODS.Jokers.j_sdm_mystery_joker.calculate = function(card, context)
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
        end
    end

    --- Infinite Staircase ---

    if config.j_sdm_infinite_staircase then
        
        local j_sdm_infinite_staircase = SMODS.Joker:new(
            "Infinite Staircase", "sdm_infinite_staircase",
            {extra = {mult = 0, mult_mod = 4}},  {x=0, y=0},
            {
                name = "Infinite Staircase",
                text = {
                    "This Joker gains {C:red}+#2#{} Mult if",
                    "{C:attention}scored hand{} contains a numerical {C:attention}Straight{},",
                    "increase rank of scored cards by {C:attention}1",
                    "{C:inactive}(Currently {C:red}+#1#{C:inactive} Mult)"
                }
            }, 1, 5, true, true, true, true
        )

        register_elem(j_sdm_infinite_staircase)

        SMODS.Jokers.j_sdm_infinite_staircase.loc_def = function(card)
            return {card.ability.extra.mult, card.ability.extra.mult_mod}
        end

        SMODS.Jokers.j_sdm_infinite_staircase.calculate = function(card, context)
            if context.cardarea == G.jokers and not context.blueprint and (context.poker_hands and (next(context.poker_hands['Straight']))) then
                if context.before then
                    no_faces = true
                    for i = 1, #context.scoring_hand do
                        if context.scoring_hand[i]:is_face() then
                            no_faces = false
                        end
                    end
                    if no_faces then
                        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
                        return {
                            message = localize('k_upgrade_ex'),
                            colour = G.C.MULT,
                            card = card
                        }
                    end
                elseif context.after then
                    no_faces = true
                    for i = 1, #context.scoring_hand do
                        if context.scoring_hand[i]:is_face() then
                            no_faces = false
                        end
                    end
                    if no_faces then
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_active_ex'),colour = G.C.FILTER})
                        for i = 1, #context.scoring_hand do
                            local percent = 1.15 - (i-0.999)/(#context.scoring_hand-0.998)*0.3
                            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() context.scoring_hand[i]:flip();play_sound('card1', percent);context.scoring_hand[i]:juice_up(0.3, 0.3);return true end }))
                        end
                        delay(0.2)
                        for i = 1, #context.scoring_hand do
                            local card = context.scoring_hand[i]
                            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.0,func = function()
                                local suit_prefix = string.sub(card.base.suit, 1, 1)..'_'
                                local rank_suffix = card.base.id == 14 and 2 or math.min(card.base.id+1, 14)
                                if rank_suffix < 10 then rank_suffix = tostring(rank_suffix)
                                elseif rank_suffix == 10 then rank_suffix = 'T'
                                elseif rank_suffix == 11 then rank_suffix = 'J'
                                elseif rank_suffix == 12 then rank_suffix = 'Q'
                                elseif rank_suffix == 13 then rank_suffix = 'K'
                                elseif rank_suffix == 14 then rank_suffix = 'A'
                                end
                                card:set_base(G.P_CARDS[suit_prefix..rank_suffix])
                            return true end }))
                        end
                        for i = 1, #context.scoring_hand do
                            local percent = 0.85 + (i-0.999)/(#context.scoring_hand-0.998)*0.3
                            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() context.scoring_hand[i]:flip();play_sound('tarot2', percent, 0.6);context.scoring_hand[i]:juice_up(0.3, 0.3);return true end }))
                        end
                    end
                    delay(1.5)
                end
            end
            if SMODS.end_calculate_context(context) and card.ability.extra.mult > 0 then
                return {
                    message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
                    mult_mod = card.ability.extra.mult
                }
            end
        end
    end

    --- Ninja Joker ---

    if config.j_sdm_ninja_joker then
        
        local j_sdm_ninja_joker = SMODS.Joker:new(
            "Ninja Joker", "sdm_ninja_joker",
            {extra = {can_dupe = true, active = "Active", inactive = ""}},  {x=0, y=0},
            {
                name = "Ninja Joker",
                text = {
                    "Creates a {C:dark_edition}Negative{C:attention} Tag",
                    "if a card is {C:attention}destroyed{}, reactivates",
                    "when a {C:attention}playing card{} is added",
                    "{C:inactive}(Currently {C:attention}#1#{C:inactive}#2#{C:inactive})"
                }
            }, 2, 6, true, true, true, true
        )

        register_elem(j_sdm_ninja_joker)

        SMODS.Jokers.j_sdm_ninja_joker.loc_def = function(card)
            return {card.ability.extra.active, card.ability.extra.inactive}
        end

        SMODS.Jokers.j_sdm_ninja_joker.calculate = function(card, context)
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
        end
    end

    --- Archibald ---

    if config.j_sdm_archibald then

        local j_sdm_archibald = SMODS.Joker:new(
            "Archibald", "sdm_archibald",
            {extra = {remaining = 4}},  {x=0, y=0},
            {
                name = "Archibald",
                text = {
                    "On {C:attention}Joker{} purchased,",
                    "creates a {C:dark_edition}Negative{} copy",
                    "{C:inactive}({C:dark_edition}Negative{C:inactive} copy sells for {C:money}$0{C:inactive})",
                    "{C:inactive}(Remaining {C:attention}#1#{C:inactive})"
                }
            }, 4, 20, true, true, true, false, nil, nil, {x = 0, y = 1}
        )

        register_elem(j_sdm_archibald)

        SMODS.Jokers.j_sdm_archibald.loc_def = function(card)
            return {card.ability.extra.remaining}
        end

        SMODS.Jokers.j_sdm_archibald.calculate  = function(card, context)
            if context.buying_card then
                if context.card.ability.set == 'Joker' then
                    if not context.blueprint then
                        card.ability.extra.remaining = card.ability.extra.remaining - 1
                    end
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {
                        message = localize('k_plus_joker'),
                        colour = G.C.BLUE,
                    })
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            new_card = create_card('Joker', G.jokers, nil, nil, nil, nil, context.card.config.center.key, nil)
                            new_card:set_edition({negative = true}, true)
                            new_card.archibald_dupe = true
                            new_card:add_to_deck()
                            G.jokers:emplace(new_card)
                            new_card:start_materialize()
                            return true
                        end
                    }))
                    if card.ability.extra.remaining >= 1 and not context.blueprint then
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, blockable = false,
                            func = function()
                                card_eval_status_text(card, 'extra', nil, nil, nil, {
                                    message =  card.ability.extra.remaining..'',
                                    colour = G.C.FILTER,
                                })
                                return true
                            end
                        }))
                    end
                    if card.ability.extra.remaining < 1 and not context.blueprint then 
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                card_eval_status_text(card, 'extra', nil, nil, nil, {
                                    message = localize('k_extinct_ex'),
                                    colour = G.C.MONEY,
                                })
                                play_sound('tarot1')
                                card.T.r = -0.2
                                card:juice_up(0.3, 0.4)
                                card.states.drag.is = true
                                card.children.center.pinch.x = true
                                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, blockable = false,
                                    func = function()
                                            G.jokers:remove_card(card)
                                            card:remove()
                                            card = nil
                                        return true; end})) 
                                return true
                            end
                        }))
                    end
                end
            end
        end
    end
end

local card_updateref = Card.update
function Card.update(self, dt)
    if G.STAGE == G.STAGES.RUN then
        if self.ability.name == 'Iconic Icon' then
            self.ability.extra.mult = 0
            for _, v in pairs(G.playing_cards) do
                if v:get_id() == 14 and (v.edition or v.seal or v.ability.effect ~= "Base") then
                    self.ability.extra.mult =  self.ability.extra.mult + self.ability.extra.mult_mod
                end
            end
        elseif self.ability.name == 'Bounciest Ball' then
            self.ability.extra.hand = G.GAME.last_hand_played or "High Card"
        elseif self.ability.name == 'Warehouse' then
            if self.set_cost and self.ability.extra_value ~= self.ability.extra.dollars - math.floor(self.base_cost / 2) then 
                self.ability.extra_value = self.ability.extra.dollars - math.floor(self.base_cost / 2)
                self:set_cost()
            end
        end
        if self.archibald_dupe then
            self.sell_cost = 0
        end
    end
    card_updateref(self, dt)
end

local game_start_runref = Game.start_run
function Game:start_run(args)
    game_start_runref(self, args)
    local saveTable = args.savetext or nil
    if not saveTable then
        if args.challenge then
            local _ch = args.challenge
            if _ch.rules then
                if _ch.rules.custom then
                    for k, v in ipairs(_ch.rules.custom) do
                        if v.id == 'no_shop_planets' then
                            self.GAME.planet_rate = 0
                        end
                    end
                end
            end
        end
    end
end

local calculate_dollar_bonusref = Card.calculate_dollar_bonus
function Card.calculate_dollar_bonus(self)
    if self.debuff then return end
    if self.ability.set == "Joker" then
        if self.ability.name == "Tip Jar" then
            local highest = 0
            for digit in tostring(math.abs(G.GAME.dollars)):gmatch("%d") do
                highest = math.max(highest, tonumber(digit))
            end
            if highest > 0 then
                return highest
            end
        elseif self.ability.name == "Shareholder Joker" then
            rand_dollar = pseudorandom(pseudoseed('shareholder'), self.ability.extra.min, self.ability.extra.max)
            if rand_dollar > 0 then
                return rand_dollar
            end
        elseif self.ability.name == "Furnace" then
            if self.ability.extra.dollars > 0 then
                return self.ability.extra.dollars
            end
        end
    end
    return calculate_dollar_bonusref(self)
end

local add_to_deckref = Card.add_to_deck
function Card.add_to_deck(self, from_debuff)
    if not self.added_to_deck then
        if self.ability.name == 'Warehouse' then
            self.ability.extra.c_size = G.consumeables.config.card_limit
            G.hand:change_size(self.ability.extra.h_size)
            G.consumeables:change_size(-self.ability.extra.c_size)
        end
    end
    add_to_deckref(self, from_debuff)
end

local remove_from_deckref = Card.remove_from_deck
function Card.remove_from_deck(self, from_debuff)
    if self.added_to_deck then
        if self.ability.name == 'Warehouse' then
            G.hand:change_size(-self.ability.extra.h_size)
            G.consumeables:change_size(self.ability.extra.c_size)
        end
    end
    remove_from_deckref(self, from_debuff)
end

local backapply_to_runref = Back.apply_to_run
function Back.apply_to_run(arg_56_0)
    backapply_to_runref(arg_56_0)

    if arg_56_0.effect.config.b_sdm_sdm_0_s_deck then
        G.E_MANAGER:add_event(Event({
            func = function()
                rand_jokers = get_random_sdm_modded_jokers(2, true)
                for i = 1, #rand_jokers do
                    add_joker(rand_jokers[i], nil, true, true)
                end
                return true
            end
        }))
    end
end
--- sendDebugMessage(inspect(context))

----------------------------------------------
------------MOD CODE END----------------------