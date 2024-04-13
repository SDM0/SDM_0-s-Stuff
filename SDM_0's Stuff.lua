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
    trance_the_devil = true,
    burger = true,
    bounciest_ball = true,
    jokerekoj = true,
    lucky_joker = true,
    iconic_icon = true,
    mult_n_chips = true,
    moon_base = true,
    shareholder_joker = true,
    magic_hands = true,
    tip_jar = true,
    wandering_star = true,
    ouija_board = true,
    la_revolution = true,
    clown_bank = true,
    archibald = true,
}

local placeholder_art = false --- Set it to true if you want to play with placeholder art of this mod's jokers

local space_jokers = {
    ["Supernova"] = "j_supernova",
    ["Space Joker"] = "j_space",
    ["Constellation"] = "j_constellation",
    ["Rocket"] = "j_rocket",
    ["Satellite"] = "j_satellite",
    ["Moon Base"] = "j_moon_base",
    ["Wandering Star"] = "j_wandering_star",
}

--- Functions ---

--- Registering modded Jokers ---
function register_joker(id)
    new_id_slug = id.slug
    if placeholder_art and id.slug ~= "j_archibald" then
        new_id_slug = new_id_slug .. "_ph"
    end

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

--- Text ---

G.localization.misc.dictionary.k_all = "+/X All"
G.localization.misc.dictionary.k_lucky = "Lucky"

function SMODS.INIT.sdm_0s_stuff() 

    init_localization()

    --- Challenges ---

    --- Devil's Deal ---

    if config.trance_the_devil then

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
                {id = 'j_trance_the_devil', eternal = true},
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
                    {id = 'v_crystal_ball'},
                    {id = 'v_grabber'},
                    {id = 'v_nacho_tong'},
                    {id = 'v_wasteful'},
                    {id = 'v_recyclomancy'},
                    {id = 'v_blank'},
                    {id = 'v_antimatter'},
                },
                banned_tags = {},
                banned_other = {}
            }
        })
    end

    --- Gambling Addiction ---

    if config.lucky_joker then

        G.localization.misc.challenge_names["c_mod_sdm0_ga"] = "Gambling Addiction"
        
        table.insert(G.CHALLENGES,#G.CHALLENGES+1,{
            name = "Gambling Addiction",
            id = 'c_mod_sdm0_ga',
            rules = {
                custom = {
                },
                modifiers = {
                    {id = 'discards', value = 4},
                    {id = 'hands', value = 2},
                }
            },
            jokers = {
                {id = 'j_lucky_joker', eternal = true},
                {id = 'j_lucky_cat', eternal = true}
            },
            consumeables = {},
            vouchers = {
                {id = 'v_magic_trick'},
            },
            deck = {
                type = 'Challenge Deck',
                cards = {{s='D',r='2',},{s='D',r='3',},{s='D',r='4',},{s='D',r='5',},{s='D',r='6',},{s='D',r='7',},{s='D',r='8',},{s='D',r='9',},{s='D',r='T',},{s='D',r='A',},{s='C',r='2',},{s='C',r='3',},{s='C',r='4',},{s='C',r='5',},{s='C',r='6',},{s='C',r='7',},{s='C',r='8',},{s='C',r='9',},{s='C',r='T',},{s='C',r='A',},{s='H',r='2',},{s='H',r='3',},{s='H',r='4',},{s='H',r='5',},{s='H',r='6',},{s='H',r='7',},{s='H',r='8',},{s='H',r='9',},{s='H',r='T',},{s='H',r='A',},{s='S',r='2',},{s='S',r='3',},{s='S',r='4',},{s='S',r='5',},{s='S',r='6',},{s='S',r='7',},{s='S',r='8',},{s='S',r='9',},{s='S',r='T',},{s='S',r='A',}}

            },
            restrictions = {
                banned_cards = {
                    {id = 'v_grabber'},
                    {id = 'v_nacho_tong'},
                },
                banned_tags = {},
                banned_other = {}
            }
        })
    end

    --- Joker Abilities ---

    --- Trance The Devil ---

    if config.trance_the_devil then

        local trance_the_devil = SMODS.Joker:new(
            'Trance The Devil', 'trance_the_devil',
            {extra = 0.5}, {x=0, y=0}, 
            {
                name = "Trance The Devil",
                text = {
                    "{X:mult,C:white}X#1#{} Mult per {C:spectral}Trance{} and",
                    "{C:tarot}The Devil{} card used this run",
                    "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive})"
                }
            }, 2, 7, true, true, true, true
        )

        register_joker(trance_the_devil)


        SMODS.Jokers.j_trance_the_devil.loc_def = function(card)
            return {card.ability.extra, 1 + ((get_count('c_trance') or 1) / (1 / card.ability.extra) + (get_count('c_devil') or 1) / (1 / card.ability.extra))}
        end

        SMODS.Jokers.j_trance_the_devil.calculate = function(self, context)
            if context.using_consumeable and not context.blueprint then
                if context.consumeable.ability.name == 'Trance' or context.consumeable.ability.name == 'The Devil' then
                    G.E_MANAGER:add_event(Event({func = function()
                        card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_xmult',
                        vars={1 + ((get_count('c_trance') or 1) / (1 / self.ability.extra) + (get_count('c_devil') or 1) / (1 / self.ability.extra))}}, colour = G.C.RED});
                        return true end}))
                    return
                end
            elseif SMODS.end_calculate_context(context) and
                (1 + ((get_count('c_trance') or 1) / (1 / self.ability.extra) + (get_count('c_devil') or 1) / (1 / self.ability.extra)) > 1) then
                return {
                    message = localize{type='variable',key='a_xmult',vars={(1 + (get_count('c_trance') or 1) / 4 + (get_count('c_devil') or 1) / (1 / self.ability.extra))}},
                    Xmult_mod = 1 + ((get_count('c_trance') or 1) / (1 / self.ability.extra) + (get_count('c_devil') or 1) / (1 / self.ability.extra))
                }
            end
        end
    end

    --- Burger ---

    if config.burger then

        local burger = SMODS.Joker:new(
            "Burger", "burger",
            {extra = {Xmult=1.25, mult=10, chips=30, remaining=4}}, {x=0, y=0},
            {
                name = "Burger",
                text = {
                    "{C:chips}+#3#{} Chips, {C:mult}+#2#{} Mult and {X:mult,C:white}X#1#{} Mult",
                    "for the next {C:attention}#4#{} hands",
                }
            }, 3, 8, true, true, true, false
        )

        register_joker(burger)

        SMODS.Jokers.j_burger.loc_def = function(card)
            return {card.ability.extra.Xmult, card.ability.extra.mult, card.ability.extra.chips, card.ability.extra.remaining}
        end

        SMODS.Jokers.j_burger.calculate = function(self, context)
            if context.end_of_round and not (context.individual or context.repetition or context.blueprint) then
                if self.ability.extra.remaining - 1 <= 0 then 
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('tarot1')
                            self.T.r = -0.2
                            self:juice_up(0.3, 0.4)
                            self.states.drag.is = true
                            self.children.center.pinch.x = true
                            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                                func = function()
                                        G.jokers:remove_card(self)
                                        self:remove()
                                        self = nil
                                    return true; end})) 
                            return true
                        end
                    })) 
                    return {
                        message = localize('k_eaten_ex'),
                        colour = G.C.FILTER
                    }
                else
                    self.ability.extra.remaining = self.ability.extra.remaining - 1
                    return {
                        message = self.ability.extra.remaining..'',
                        colour = G.C.FILTER
                    }
                end
            elseif SMODS.end_calculate_context(context) then
                return {
                    message = localize('k_all'),
                    colour = G.C.PURPLE,
                    chip_mod = self.ability.extra.chips,
                    mult_mod = self.ability.extra.mult,
                    Xmult_mod = self.ability.extra.Xmult
                }
            end
        end
    end

    --- Bounciest Ball ---

    if config.bounciest_ball then

        local bounciest_ball = SMODS.Joker:new(
            "Bounciest Ball", "bounciest_ball",
            {extra = {chips = 10, chip_mod = 10}}, {x=0, y=0},
            {
                name = "Bounciest Ball",
                text = {
                    "Upgrade by {C:chips}+#2#{} Chips for each",
                    "{C:attention}Boss Blind{} defeated",
                    "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)"
            }}, 1, 6, true, true, true, true
        )

        register_joker(bounciest_ball)

        SMODS.Jokers.j_bounciest_ball.loc_def = function(card)
            return {card.ability.extra.chips, card.ability.extra.chip_mod}
        end

        SMODS.Jokers.j_bounciest_ball.calculate  = function(self, context)
            if context.end_of_round and not (context.individual or context.repetition or context.blueprint) and G.GAME.blind.boss then
                self.ability.extra.chips = self.ability.extra.chips + self.ability.extra.chip_mod
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.CHIPS
                }
            elseif SMODS.end_calculate_context(context) then
                return {
                    message = localize{type='variable',key='a_chips',vars={self.ability.extra.chips}},
                    chip_mod = self.ability.extra.chips
                }
            end
        end
    end

    --- Lucky Joker ---

    if config.lucky_joker then
        local lucky_joker = SMODS.Joker:new(
            "Lucky Joker", "lucky_joker",
            {extra = {chips = 7, mult = 7}},  {x=0, y=0},
            {
                name = "Lucky Joker",
                text = {
                    "Each played {C:attention}7{} gives {C:chips}+#1#{} Chips",
                    "and {C:mult}+#2#{} Mult when scored,",
                    "{C:attention}doubles{} it if {C:attention}Lucky{} card"
                },
            }, 1, 5, true, true, true, true
        )

        register_joker(lucky_joker)

        SMODS.Jokers.j_lucky_joker.loc_def = function(card)
            return {card.ability.extra.chips, card.ability.extra.mult}
        end

        SMODS.Jokers.j_lucky_joker.calculate  = function(self, context)
            if context.individual and context.cardarea == G.play and context.other_card:get_id() == 7 then
                if context.other_card.ability.effect == "Lucky Card" then
                    return {
                        chips = self.ability.extra.chips * 2,
                        mult = self.ability.extra.mult * 2,
                        card = self
                    }
                else return {
                    chips = self.ability.extra.chips,
                    mult = self.ability.extra.mult,
                    card = self
                }
                end
            end
        end
    end

    --- Iconic Icon ---

    if config.iconic_icon then

        local iconic_icon = SMODS.Joker:new(
            "Iconic Icon", "iconic_icon",
            {extra = {mult = 0, mult_mod = 4}},  {x=0, y=0},
            {
                name = "Iconic Icon",
                text = {
                    "{C:mult}+#2#{} Mult per{C:attention} Aces",
                    "in your {C:attention}full deck",
                    "{C:inactive}(Currently {C:mult}+#1#{C:inactive})"
                }
            }, 2, 7, true, true, true, true
        )

        register_joker(iconic_icon)

        SMODS.Jokers.j_iconic_icon.loc_def = function(card)
            return {card.ability.extra.mult, card.ability.extra.mult_mod}
        end

        SMODS.Jokers.j_iconic_icon.calculate  = function(self, context)
            if SMODS.end_calculate_context(context) then
                return {
                    message = localize{type='variable',key='a_mult',vars={self.ability.extra.mult}},
                    mult_mod = self.ability.extra.mult,
                    colour = G.C.MULT
                }
            end
        end
    end

    --- Mult N Chips Joker ---

    if config.mult_n_chips then

        local mult_n_chips = SMODS.Joker:new(
            "Mult'N'Chips", "mult_n_chips",
            {extra = {mult = 4, chips = 30}},  {x=0, y=0},
            {
                name = "Mult'N'Chips",
                text = {
                    "Scored {C:attention}Bonus{} cards gives {C:mult}+#1#{} Mult,",
                    "scored {C:attention}Mult{} cards gives {C:chips}+#2#{} Chips",
                }
            }, 1, 5, true, true, true, true
        )

        register_joker(mult_n_chips)

        SMODS.Jokers.j_mult_n_chips.loc_def = function(card)
            return {card.ability.extra.mult, card.ability.extra.chips}
        end

        SMODS.Jokers.j_mult_n_chips.calculate  = function(self, context)
            if context.individual and context.cardarea == G.play then
                if context.other_card.ability.effect == "Bonus Card" then
                    return {
                        mult = self.ability.extra.mult,
                        card = self
                    }
                elseif context.other_card.ability.effect == "Mult Card" then
                    return {
                        chips = self.ability.extra.chips,
                        card = self
                    }
                end
            end
        end
    end

    --- Moon Base ---

    if config.moon_base then

        local moon_base = SMODS.Joker:new(
            "Moon Base", "moon_base",
            {extra = 50},  {x=0, y=0},
            {
                name = "Moon Base",
                text = {
                    "{C:attention}Space{} Jokers each",
                    "give{C:chips} +#1# {}Chips",
                }
            }, 3, 8, true, true, true, true
        )

        register_joker(moon_base)

        SMODS.Jokers.j_moon_base.loc_def = function(card)
            return {card.ability.extra}
        end

        SMODS.Jokers.j_moon_base.calculate  = function(self, context)
            if context.other_joker then
                if space_jokers[context.other_joker.ability.name] and context.other_joker.ability.name ~= "Moon Base" then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            context.other_joker:juice_up(0.5, 0.5)
                            return true
                        end
                    })) 
                    return {
                        message = localize{type='variable',key='a_chips',vars={self.ability.extra}},
                        chip_mod = self.ability.extra
                    }
                end
            end
        end
    end

    --- Shareholder Joker ---

    if config.shareholder_joker then

        local shareholder_joker = SMODS.Joker:new(
            "Shareholder Joker", "shareholder_joker",
            {extra = {max = 10, min = -5}},  {x=0, y=0},
            {
                name = "Shareholder Joker",
                text = {
                    "Earn between {C:money}$#1#{} and {C:money}$#2#{}",
                    "at the end of round",
                }
            }, 1, 5, true, true, true, true
        )

        register_joker(shareholder_joker)

        SMODS.Jokers.j_shareholder_joker.loc_def = function(card)
            return {card.ability.extra.min, card.ability.extra.max}
        end

        SMODS.Jokers.j_shareholder_joker.calculate  = function(self, context)
            if context.end_of_round and not (context.individual or context.repetition) then
                local temp_Dollars = pseudorandom('shareholder_joker', self.ability.extra.min, self.ability.extra.max)
                ease_dollars(temp_Dollars)
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + temp_Dollars
                G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
                return {
                    message = localize('$')..temp_Dollars,
                    dollars = temp_Dollars,
                    colour = G.C.MONEY,
                }
            end
        end
    end

    --- Magic Hands ---

    if config.magic_hands then

        local magic_hands = SMODS.Joker:new(
            "Magic Hands", "magic_hands",
            {extra = 2},  {x=0, y=0},
            {
                name = "Magic Hands",
                text = {
                    "{X:mult,C:white}X#1#{} Mult if number of {C:chips}hands{} left + 1",
                    "equals the most prevalent card amount",
                    "{C:inactive}(ex: {C:attention}Four of a Kind{} {C:inactive}on {C:chips}Hand 4{C:inactive})",
                }
            }, 2, 6, true, true, true, true
        )

        register_joker(magic_hands)

        SMODS.Jokers.j_magic_hands.loc_def = function(card)
            return {card.ability.extra}
        end

        SMODS.Jokers.j_magic_hands.calculate  = function(self, context)
            if SMODS.end_calculate_context(context) then
                cards_id = {}
                for i = 1, #context.scoring_hand do
                    table.insert(cards_id, context.scoring_hand[i]:get_id())
                end
                max_card = count_max_occurence(cards_id) or 0
                if G.GAME.current_round.hands_left + 1 == max_card then
                    return {
                        message = localize{type='variable',key='a_xmult',vars={self.ability.extra}},
                        Xmult_mod = self.ability.extra
                    } 
                end
            end
        end
    end

    --- Tip Jar ---

    if config.tip_jar then

        local tip_jar = SMODS.Joker:new(
            "Tip Jar", "tip_jar",
            {},  {x=0, y=0},
            {
                name = "Tip Jar",
                text = {
                    "Earn your money's {C:attention}highest digit",
                    "at the end of round",
                }
            }, 1, 3, true, true, true, true
        )

        register_joker(tip_jar)

        SMODS.Jokers.j_tip_jar.loc_def = function(card)
            return {}
        end

        SMODS.Jokers.j_tip_jar.calculate  = function(self, context)
            if context.end_of_round and not (context.individual or context.repetition) then
                local highest = 0
                for digit in tostring(math.abs(G.GAME.dollars)):gmatch("%d") do
                    highest = math.max(highest, tonumber(digit))
                end
                if highest > 0 then
                    ease_dollars(highest)
                    G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + highest
                    G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
                    return {
                        message = localize('$')..highest,
                        dollars = highest,
                        colour = G.C.MONEY,
                    }
                end
            end
        end
    end

    --- Wandering Star ---

    if config.wandering_star then

        local wandering_star = SMODS.Joker:new(
            "Wandering Star", "wandering_star",
            {extra = {mult = 0, mult_mod = 2}},  {x=0, y=0},
            {
                name = "Wandering Star",
                text = {
                    "{C:red}+#2#{} Mult per",
                    "{C:planet}Planet{} card sold",
                    "{C:inactive}(Currently {C:red}+#1#{C:inactive} Mult)"
                }
            }, 1, 5, true, true, true, true
        )

        register_joker(wandering_star)

        SMODS.Jokers.j_wandering_star.loc_def = function(card)
            return {card.ability.extra.mult, card.ability.extra.mult_mod}
        end

        SMODS.Jokers.j_wandering_star.calculate  = function(self, context)
            if context.selling_card then
                if context.card.ability.set == 'Planet' and not context.blueprint then
                    self.ability.extra.mult = self.ability.extra.mult + self.ability.extra.mult_mod
                    G.E_MANAGER:add_event(Event({
                        func = function() card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_mult',vars={self.ability.extra.mult}}}); return true
                        end}))
                end
            elseif SMODS.end_calculate_context(context) then
                return {
                    message = localize{type='variable',key='a_mult',vars={self.ability.extra.mult}},
                    mult_mod = self.ability.extra.mult
                }
            end
        end
    end

    --- Ouija Board ---

    if config.ouija_board then

        local ouija_board = SMODS.Joker:new(
            "Ouija Board", "ouija_board",
            {extra = 50},  {x=0, y=0},
            {
                name = "Ouija Board",
                text = {
                    "When {C:attention}Blind{} is selected,",
                    "{C:green}#1# in #2#{} chance to create a {C:spectral}Soul{} card, or",
                    "{C:green}#1# in #3#{} chance to create a {C:tarot}Judgement{} card",
                    "{C:inactive}(Must have room)"
                }
            }, 2, 7, true, true, true, true
        )

        register_joker(ouija_board)

        SMODS.Jokers.j_ouija_board.loc_def = function(card)
            return {''..(G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra, card.ability.extra / 10}
        end

        SMODS.Jokers.j_ouija_board.calculate  = function(self, context)
            if context.setting_blind then
                if pseudorandom(pseudoseed('ojb1')) < G.GAME.probabilities.normal/self.ability.extra then
                    if not (context.blueprint_card or self).getting_sliced and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                        G.E_MANAGER:add_event(Event({
                            func = (function()
                                G.E_MANAGER:add_event(Event({
                                    func = function() 
                                        local card = create_card('Spectral',G.consumeables, nil, nil, nil, nil, 'c_soul', 'rtl')
                                        card:add_to_deck()
                                        G.consumeables:emplace(card)
                                        G.GAME.consumeable_buffer = 0
                                        return true
                                    end}))   
                                card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral})                       
                            return true
                        end)}))
                    end
                elseif pseudorandom(pseudoseed('ojb2')) < G.GAME.probabilities.normal/(self.ability.extra / 10) then
                    if not (context.blueprint_card or self).getting_sliced and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                        G.E_MANAGER:add_event(Event({
                            func = (function()
                                G.E_MANAGER:add_event(Event({
                                    func = function() 
                                        local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, 'c_judgement', 'rtl')
                                        card:add_to_deck()
                                        G.consumeables:emplace(card)
                                        G.GAME.consumeable_buffer = 0
                                        return true
                                    end}))   
                                card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.SECONDARY_SET.Tarot})                       
                            return true
                        end)}))
                    end
                end
            end
        end
    end

    --- La Révolution ---

    if config.la_revolution then

        local la_revolution = SMODS.Joker:new(
            "La Révolution", "la_revolution",
            {},  {x=0, y=0},
            {
                name = "La Révolution",
                text = {
                    "Upgrade {C:attention}most played hand{} by 3",
                    "if discarded poker hand",
                    "is a {C:attention}Royal Flush"
                }
            }, 3, 8, true, true, true, true
        )

        register_joker(la_revolution)

        SMODS.Jokers.j_la_revolution.loc_def = function(card)
            return {}
        end

        SMODS.Jokers.j_la_revolution.calculate  = function(self, context)
            if context.pre_discard and not context.hook then
                local text,disp_text = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
                if disp_text == "Royal Flush" then
                    local chosen_hand = 'High Card'
                    local highest_played = 0
                    for _, v in ipairs(G.handlist) do
                        if G.GAME.hands[v].played > highest_played then
                            chosen_hand = v
                            highest_played = G.GAME.hands[v].played
                        end
                    end
                    card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')})
                    update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(chosen_hand , 'poker_hands'),chips = G.GAME.hands[chosen_hand].chips, mult = G.GAME.hands[chosen_hand].mult, level=G.GAME.hands[chosen_hand].level})
                    level_up_hand(context.blueprint_card or self, chosen_hand, nil, 3)
                    update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
                end
            end
        end
    end

    --- Clown Bank ---

    if config.clown_bank then

        local clown_bank = SMODS.Joker:new(
            "Clown Bank", "clown_bank",
            {extra = {Xmult=1, Xmult_mod=0.25, dollars = 5, inflation = 5}},  {x=0, y=0},
            {
                name = "Clown Bank",
                text = {
                    "When {C:attention}Blind{} is selected,",
                    "if at {C:attention}leftmost{} position,",
                    "gains {X:mult,C:white}X#2#{} Mult for {C:money}#3#${},",
                    "increases cost by {C:money}#4#${}",
                    "{C:inactive}(Currenty {X:mult,C:white}X#1#{C:inactive} Mult)"
                }
            }, 3, 8, true, true, true, true
        )

        register_joker(clown_bank)

        SMODS.Jokers.j_clown_bank.loc_def = function(card)
            return {card.ability.extra.Xmult, card.ability.extra.Xmult_mod, card.ability.extra.dollars, card.ability.extra.inflation}
        end

        SMODS.Jokers.j_clown_bank.calculate  = function(self, context)
            if context.setting_blind and not context.blueprint then
                if G.jokers.cards[1] and G.jokers.cards[1].ability.name == "Clown Bank" then
                    if G.GAME.dollars - self.ability.extra.dollars >= G.GAME.bankrupt_at then
                        card_eval_status_text(self, 'extra', nil, nil, nil, {
                            message = localize('$') .. "-" .. self.ability.extra.dollars,
                            colour = G.C.MONEY
                        })
                        ease_dollars(-self.ability.extra.dollars)
                        self.ability.extra.Xmult = self.ability.extra.Xmult + self.ability.extra.Xmult_mod
                        self.ability.extra.dollars = self.ability.extra.dollars + self.ability.extra.inflation
                        G.E_MANAGER:add_event(Event({
                            func = function() card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_xmult',vars={self.ability.extra.Xmult}}}); return true
                            end}))
                        return
                    end
                end
            elseif SMODS.end_calculate_context(context) and self.ability.extra.Xmult > 1 then
                return {
                    message = localize{type='variable',key='a_xmult',vars={self.ability.extra.Xmult}},
                    Xmult_mod = self.ability.extra.Xmult
                }
            end
        end
    end

    --- Archibald ---

    if config.archibald then

        local archibald = SMODS.Joker:new(
            "Archibald", "archibald",
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

        register_joker(archibald)

        SMODS.Jokers.j_archibald.loc_def = function(card)
            return {card.ability.extra.remaining}
        end

        SMODS.Jokers.j_archibald.calculate  = function(self, context)
            if context.buying_card then
                if context.card.ability.set == 'Joker' then
                    if not context.blueprint then
                        self.ability.extra.remaining = self.ability.extra.remaining - 1
                    end
                    card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {
                        message = localize('k_plus_joker'),
                        colour = G.C.BLUE,
                    })
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            card = create_card('Joker', G.jokers, nil, nil, nil, nil, context.card.config.center.key, nil)
                            card:set_edition({negative = true}, true)
                            card.sell_cost = 0
                            card:add_to_deck()
                            G.jokers:emplace(card)
                            card:start_materialize()
                            return true
                        end
                    }))
                    if self.ability.extra.remaining >= 1 and not context.blueprint then
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, blockable = false,
                            func = function()
                                card_eval_status_text(self, 'extra', nil, nil, nil, {
                                    message =  self.ability.extra.remaining..'',
                                    colour = G.C.FILTER,
                                })
                                return true
                            end
                        }))
                    end
                    if self.ability.extra.remaining < 1 and not context.blueprint then 
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                card_eval_status_text(self, 'extra', nil, nil, nil, {
                                    message = localize('k_extinct_ex'),
                                    colour = G.C.MONEY,
                                })
                                play_sound('tarot1')
                                self.T.r = -0.2
                                self:juice_up(0.3, 0.4)
                                self.states.drag.is = true
                                self.children.center.pinch.x = true
                                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, blockable = false,
                                    func = function()
                                            G.jokers:remove_card(self)
                                            self:remove()
                                            self = nil
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
                if v:get_id() == 14 then
                    self.ability.extra.mult =  self.ability.extra.mult + self.ability.extra.mult_mod
                end
            end
        end
    end
    card_updateref(self, dt)
end

--- sendDebugMessage(inspect(context))

----------------------------------------------
------------MOD CODE END----------------------