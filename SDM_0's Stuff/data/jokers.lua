local parameters = NFS.load(SMODS.current_mod.path.."config.lua")()
local config, space_jokers = parameters.config, parameters.space_jokers

SMODS.Atlas{
    key = "sdm_jokers",
    path = "sdm_jokers.png",
    px = 71,
    py = 95
}

if config.jokers then

    --- Trance The Devil ---

    if config.j_sdm_trance_the_devil then
        SMODS.Joker{
            key = "trance_the_devil",
            name = "Trance The Devil",
            rarity = 2,
            discovered = true,
            perishable_compat = false,
            blueprint_compat = true,
            pos = {x = 0, y = 0},
            cost = 6,
            config = {extra = 0.25},
            loc_txt = {
                name = "Trance The Devil",
                text = {
                    "{X:mult,C:white}X#1#{} Mult per {C:spectral}Trance{} and",
                    "{C:tarot}The Devil{} card used this run",
                    "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive})"
                }
            },
            loc_vars = function(self, info_queue, card)
                return {vars = {card.ability.extra, 1 + ((get_count('c_trance') or 1) / (1 / card.ability.extra) + (get_count('c_devil') or 1) / (1 / card.ability.extra))}}
            end,
            calculate = function(card, context)
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
            end,
            atlas = "sdm_jokers"
        }
    end

    --- Burger ---

    if config.j_sdm_burger then
        SMODS.Joker{
            key = "burger",
            name = "Burger",
            rarity = 3,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = false,
            pos = {x = 1, y = 0},
            cost = 8,
            config = {extra = {Xmult = 1.25, mult = 10, chips = 30, remaining = 4}},
            loc_txt = {
                name = "Burger",
                text = {
                    "{C:chips}+#3#{} Chips, {C:mult}+#2#{} Mult",
                    "and {X:mult,C:white}X#1#{} Mult for",
                    "the next {C:attention}#4#{} rounds",
                }
            },
            loc_vars = function(self, info_queue, card)
                return {vars = {card.ability.extra.Xmult, card.ability.extra.mult, card.ability.extra.chips, card.ability.extra.remaining}}
            end,
            calculate = function(card, context)
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
                    SMODS.eval_this(card, {chip_mod = card.ability.extra.chips, message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}}})
                    SMODS.eval_this(card, {mult_mod = card.ability.extra.mult, message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}}})
                    return {
                        message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
                        Xmult_mod = card.ability.extra.Xmult
                    }
                end
            end,
            atlas = "sdm_jokers"
        }
    end

    --- Bounciest Ball ---

    if config.j_sdm_bounciest_ball then
        SMODS.Joker{
            key = "bounciest_ball",
            name = "Bounciest Ball",
            rarity = 1,
            discovered = true,
            blueprint_compat = true,
            perishable_compat = false,
            pos = {x = 2, y = 0},
            cost = 5,
            config = {extra = {chips = 0, chip_mod = 10, hand = "High Card"}},
            loc_txt = {
                name = "Bounciest Ball",
                text = {
                    "This Joker gains {C:chips}+#2#{} Chips every time",
                    "a {C:attention}#3#{} is scored, reset and",
                    "change on {C:attention}different hand{}",
                    "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)"
                }
            },
            loc_vars = function(self, info_queue, card)
                return {vars = {card.ability.extra.chips, card.ability.extra.chip_mod, card.ability.extra.hand}}
            end,
            calculate = function(card, context)
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
            end,
            atlas = "sdm_jokers"
        }
    end

    --- Lucky Joker ---

    if config.j_sdm_lucky_joker then
        SMODS.Joker{
            key = "lucky_joker",
            name = "Lucky Joker",
            rarity = 2,
            discovered = true,
            blueprint_compat = true,
            pos = {x = 3, y = 0},
            cost = 7,
            config = {extra = {repitition = 2}},
            loc_txt = {
                name = "Lucky Joker",
                text = {
                    "Retrigger each played",
                    "{C:attention}Lucky{} card {C:attention}7{}",
                    "{C:attention}#1#{} additional times"
                },
            },
            loc_vars = function(self, info_queue, card)
                return {vars = {card.ability.extra.repitition}}
            end,
            calculate = function(card, context)
                if context.repetition and not context.individual and context.cardarea == G.play then
                    if context.other_card:get_id() == 7 and context.other_card.ability.effect == "Lucky Card" then
                        return {
                            message = localize('k_again_ex'),
                            repetitions = card.ability.extra.repitition,
                            card = card
                        }
                    end
                end
            end,
            atlas = "sdm_jokers"
        }
    end

    --- Iconic Icon ---

    if config.j_sdm_iconic_icon then
        SMODS.Joker{
            key = "iconic_icon",
            name = "Iconic Icon",
            rarity = 1,
            discovered = true,
            blueprint_compat = true,
            pos = {x = 4, y = 0},
            cost = 6,
            config = {extra = {mult = 0, mult_mod = 4}},
            loc_txt = {
                name = "Iconic Icon",
                text = {
                    "{C:mult}+#2#{} Mult per{C:attention} modified Aces",
                    "(enhancement, seal, edition)",
                    "in your {C:attention}full deck",
                    "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
                }
            },
            loc_vars = function(self, info_queue, card)
                return {vars = {card.ability.extra.mult, card.ability.extra.mult_mod}}
            end,
            calculate = function(card, context)
                if SMODS.end_calculate_context(context) and card.ability.extra.mult > 0 then
                    return {
                        message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
                        mult_mod = card.ability.extra.mult,
                        colour = G.C.MULT
                    }
                end
            end,
            atlas = "sdm_jokers"
        }
    end

    --- Mult'N'Chips ---

    if config.j_sdm_mult_n_chips then
        SMODS.Joker{
            key = "mult_n_chips",
            name = "Mult'N'Chips",
            rarity = 1,
            discovered = true,
            blueprint_compat = true,
            pos = {x = 5, y = 0},
            cost = 5,
            config = {extra = {mult = 4, chips = 30}},
            loc_txt = {
                name = "Mult'N'Chips",
                text = {
                    "Scored {C:attention}Bonus{} cards",
                    "gives {C:mult}+#1#{} Mult,",
                    "scored {C:attention}Mult{} cards",
                    "gives {C:chips}+#2#{} Chips",
                }
            },
            loc_vars = function(self, info_queue, card)
                return {vars = {card.ability.extra.mult, card.ability.extra.chips}}
            end,
            calculate = function(card, context)
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
            end,
            atlas = "sdm_jokers"
        }
    end

    --- Moon Base ---

    if config.j_sdm_moon_base then
        SMODS.Joker{
            key = "moon_base",
            name = "Moon Base",
            rarity = 2,
            discovered = true,
            blueprint_compat = true,
            pos = {x = 6, y = 0},
            cost = 7,
            config = {extra = 50},
            loc_txt = {
                name = "Moon Base",
                text = {
                    "{C:attention}Space{} Jokers each",
                    "give{C:chips} +#1# {}Chips",
                }
            },
            loc_vars = function(self, info_queue, card)
                return {vars = {card.ability.extra}}
            end,
            calculate = function(card, context)
                if context.other_joker then
                    sendDebugMessage(context.other_joker.config.center_key)
                    if space_jokers[context.other_joker.config.center_key] and context.other_joker ~= card then
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
            end,
            atlas = "sdm_jokers"
        }
    end

    --- Shareholder Joker ---

    if config.j_sdm_shareholder_joker then
        SMODS.Joker{
            key = "shareholder_joker",
            name = "Shareholder Joker",
            rarity = 1,
            discovered = true,
            pos = {x = 7, y = 0},
            cost = 5,
            config = {extra = {min = 1, max = 8}},
            loc_txt = {
                name = "Shareholder Joker",
                text = {
                    "Earn between",
                    "{C:money}$#1#{} and {C:money}$#2#{}",
                    "at end of round",
                }
            },
            loc_vars = function(self, info_queue, card)
                return {vars = {card.ability.extra.min, card.ability.extra.max}}
            end,
            atlas = "sdm_jokers"
        }
    end

    --- Magic Hands ---

    if config.j_sdm_magic_hands then
        SMODS.Joker{
            key = "magic_hands",
            name = "Magic Hands",
            rarity = 2,
            discovered = true,
            blueprint_compat = true,
            pos = {x = 8, y = 0},
            cost = 6,
            config = {extra = 3},
            loc_txt = {
                name = "Magic Hands",
                text = {
                    "{X:mult,C:white}X#1#{} Mult if number of {C:chips}hands{} left + 1",
                    "equals the most prevalent card amount",
                    "{C:inactive}(ex: {C:attention}Four of a Kind{} {C:inactive}on {C:chips}Hand 4{C:inactive})",
                }
            },
            loc_vars = function(self, info_queue, card)
                return {vars = {card.ability.extra}}
            end,
            calculate = function(card, context)
                if SMODS.end_calculate_context(context) and context.scoring_hand then
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
    end

    --- Tip Jar ---

    if config.j_sdm_tip_jar then
        SMODS.Joker{
            key = "tip_jar",
            name = "Tip Jar",
            rarity = 2,
            discovered = true,
            pos = {x = 9, y = 0},
            cost = 6,
            loc_txt = {
                name = "Tip Jar",
                text = {
                    "Earn your money's",
                    "{C:attention}highest digit",
                    "at end of round",
                }
            },
            atlas = "sdm_jokers"
        }
    end

    --- Wandering Star ---

    if config.j_sdm_wandering_star then
        SMODS.Joker{
            key = "wandering_star",
            name = "Wandering Star",
            rarity = 1,
            discovered = true,
            perishable_compat = false,
            blueprint_compat = true,
            pos = {x = 0, y = 1},
            cost = 6,
            config = {extra = {mult = 0, mult_mod = 3}},
            loc_txt = {
                name = "Wandering Star",
                text = {
                    "This Joker gains {C:red}+#2#{} Mult",
                    "per {C:planet}Planet{} card sold",
                    "{C:inactive}(Currently {C:red}+#1#{C:inactive} Mult)"
                }
            },
            loc_vars = function(self, info_queue, card)
                return {vars = {card.ability.extra.mult, card.ability.extra.mult_mod}}
            end,
            calculate = function(card, context)
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
            end,
            atlas = "sdm_jokers"
        }
    end

    --- Ouija Board ---

    if config.j_sdm_ouija_board then
        SMODS.Joker{
            key = "ouija_board",
            name = "Ouija Board",
            rarity = 3,
            discovered = true,
            eternal_compat = false,
            pos = {x = 1, y = 1},
            cost = 8,
            config = {extra = {remaining = 0, rounds = 3, sold_rare = false, scored_secret = false, used_spectral = false}},
            loc_txt = {
                name = "Ouija Board",
                text = {
                    "After selling a {C:red}Rare {C:attention}Joker{}",
                    "scoring a {C:attention}secret poker hand{}",
                    "and using a {C:spectral}Spectral{} card,",
                    "sell this card to create a {C:spectral}Soul{} card",
                    "{s:0.8,C:inactive}(Must have room)",
                    "{C:inactive}(Remaining {C:attention}#1#{C:inactive}/#2#)"
                }
            },
            loc_vars = function(self, info_queue, card)
                return {vars = {card.ability.extra.remaining, card.ability.extra.rounds}}
            end,
            calculate = function(card, context)
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
                if SMODS.end_calculate_context(context) and not context.blueprint then
                    if context.scoring_name and context.scoring_name == 'Five of a Kind' or context.scoring_name == 'Flush House' or context.scoring_name == 'Flush Five' then
                        if not card.ability.extra.scored_secret then
                            card.ability.extra.scored_secret = true
                            card.ability.extra.remaining = card.ability.extra.remaining + 1
                            ouija_check(card, context)
                        end
                    end
                end
                if context.selling_card and not context.blueprint then
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
    end

    --- La Révolution ---

    if config.j_sdm_la_revolution then
        SMODS.Joker{
            key = "la_revolution",
            name = "La Révolution",
            rarity = 3,
            discovered = true,
            blueprint_compat = true,
            pos = {x = 2, y = 1},
            cost = 8,
            config = {hand = "High Card"},
            loc_txt = {
                name = "La Révolution",
                text = {
                    "Upgrade {C:attention}winning poker hand{}",
                    "by {C:attention}1{} if played hand",
                    "contains no {C:attention}face{} cards",
                }
            },
            calculate = function(card, context)
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
            end,
            atlas = "sdm_jokers"
        }
    end

    --- Clown Bank ---

    if config.j_sdm_clown_bank then
        SMODS.Joker{
            key = "clown_bank",
            name = "Clown Bank",
            rarity = 3,
            discovered = true,
            perishable_compat = false,
            blueprint_compat = true,
            pos = {x = 3, y = 1},
            cost = 8,
            config = {extra = {Xmult=1, Xmult_mod=0.25, dollars = 1, inflation = 1}},
            loc_txt = {
                name = "Clown Bank",
                text = {
                    "When {C:attention}Blind{} is selected, this Joker",
                    "gains {X:mult,C:white}X#2#{} Mult for {C:money}$#3#{} if possible,",
                    "increases cost by {C:money}$#4#{}",
                    "{C:inactive}(Currenty {X:mult,C:white}X#1#{C:inactive} Mult)"
                }
            },
            loc_vars = function(self, info_queue, card)
                return {vars = {card.ability.extra.Xmult, card.ability.extra.Xmult_mod, card.ability.extra.dollars, card.ability.extra.inflation}}
            end,
            calculate = function(card, context)
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
                elseif SMODS.end_calculate_context(context) and card.ability.extra.Xmult > 1 then
                    return {
                        message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
                        Xmult_mod = card.ability.extra.Xmult
                    }
                end
            end,
            atlas = "sdm_jokers"
        }
    end

    --- Furnace ---

    if config.j_sdm_furnace then
        SMODS.Joker{
            key = "furnace",
            name = "Furnace",
            rarity = 2,
            discovered = true,
            perishable_compat = false,
            blueprint_compat = true,
            pos = {x = 4, y = 1},
            cost = 8,
            config = {extra = {Xmult= 1, dollars = 0, Xmult_mod = 0.5, dollars_mod = 2}},
            loc_txt = {
                name = "Furnace",
                text = {
                    "If {C:attention}first played hand{} is a",
                    "single {C:attention}Steel{} card or {C:attention}Gold{} card,",
                    "destroy it and gain {X:mult,C:white}X#3#{} or {C:money}$#4#{},",
                    "{C:inactive}(Currenty {X:mult,C:white}X#1#{C:inactive} Mult, {C:money}$#2#{C:inactive})"
                }
            },
            loc_vars = function(self, info_queue, card)
                return {vars = {card.ability.extra.Xmult, card.ability.extra.dollars, card.ability.extra.Xmult_mod, card.ability.extra.dollars_mod}}
            end,
            calculate = function(card, context)
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
            end,
            atlas = "sdm_jokers"
        }
    end

    --- Warehouse ---

    if config.j_sdm_warehouse then
        SMODS.Joker{
            key = "warehouse",
            name = "Warehouse",
            rarity = 2,
            discovered = true,
            perishable_compat = false,
            pos = {x = 5, y = 1},
            cost = 6,
            config = {extra = {h_size = 3, c_size = 0, dollars = -50}},
            loc_txt = {
                name = "Warehouse",
                text = {
                    "{C:attention}+#1#{} hand size,",
                    "{C:red}no consumable slots{},",
                    "lose {C:money}$#2#{} if sold"
                }
            },
            loc_vars = function(self, info_queue, card)
                return {vars = {card.ability.extra.h_size, -card.ability.extra.dollars}}
            end,
            atlas = "sdm_jokers"
        }
    end

    --- Zombie Joker ---

    if config.j_sdm_zombie_joker then
        SMODS.Joker{
            key = "zombie_joker",
            name = "Zombie Joker",
            rarity = 1,
            discovered = true,
            blueprint_compat = true,
            pos = {x = 6, y = 1},
            cost = 4,
            config = {extra = 2},
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
                return {vars = {''..(G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra}}
            end,
            calculate = function(card, context)
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
            end,
            atlas = "sdm_jokers"
        }
    end

    --- Mystery Joker ---

    if config.j_sdm_mystery_joker then
        SMODS.Joker{
            key = "mystery_joker",
            name = "Mystery Joker",
            rarity = 1,
            discovered = true,
            blueprint_compat = true,
            pos = {x = 7, y = 1},
            cost = 6,
            loc_txt = {
                name = "Mystery Joker",
                text = {
                    "Create a {C:red}Rare {C:attention}Joker Tag",
                    "when {C:attention}Boss Blind{} is defeated",
                }
            },
            calculate = function(card, context)
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
    end

    --- Infinite Staircase ---

    if config.j_sdm_infinite_staircase then
        SMODS.Joker{
            key = "infinite_staircase",
            name = "Infinite Staircase",
            rarity = 2,
            discovered = true,
            blueprint_compat = true,
            pos = {x = 8, y = 1},
            cost = 6,
            config = {extra = {Xmult = 2}},
            loc_txt = {
                name = "Infinite Staircase",
                text = {
                    "{X:red,C:white}X#1#{} Mult if scored hand",
                    "contains a {C:attention}numerical Straight{}",
                    "without an {C:attention}Ace{} card",
                }
            },
            loc_vars = function(self, info_queue, card)
                return {vars = {card.ability.extra.Xmult}}
            end,
            calculate = function(card, context)
                if SMODS.end_calculate_context(context) then
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
    end

    --- Ninja Joker ---

    if config.j_sdm_ninja_joker then
        SMODS.Joker{
            key = "ninja_joker",
            name = "Ninja Joker",
            rarity = 2,
            discovered = true,
            blueprint_compat = true,
            pos = {x = 9, y = 1},
            cost = 6,
            config = {extra = {can_dupe = true, active = "Active", inactive = ""}},
            loc_txt = {
                name = "Ninja Joker",
                text = {
                    "Creates a {C:dark_edition}Negative{C:attention} Tag",
                    "if a card is {C:attention}destroyed{}, reactivates",
                    "when a {C:attention}playing card{} is added",
                    "{C:inactive}(Currently {C:attention}#1#{C:inactive}#2#{C:inactive})"
                }
            },
            loc_vars = function(self, info_queue, card)
                return {vars = {card.ability.extra.active, card.ability.extra.inactive}}
            end,
            calculate = function(card, context)
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
    end

    --- Reach The Stars ---

    if config.j_sdm_reach_the_stars then
        SMODS.Joker{
            key = "reach_the_stars",
            name = "Reach The Stars",
            rarity = 1,
            discovered = true,
            blueprint_compat = true,
            pos = {x = 0, y = 2},
            cost = 5,
            config = {extra = {num_card1 = 1, num_card2 = 5, rts_scored = 0, remaining = 2, c1_scored = false, c2_scored = false}},
            loc_txt = {
                name = "Reach The Stars",
                text = {
                    "Scoring {C:attention}#1#{} and {C:attention}#2#{} cards",
                    "creates a random {C:planet}Planet{} card,",
                    "changes at end of round",
                    "{C:inactive}(Must have room)",
                }
            },
            loc_vars = function(self, info_queue, card)
                return {vars = {card.ability.extra.num_card1, card.ability.extra.num_card2}}
            end,
            set_ability = function(card, initial, delay_sprites)
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
            calculate = function(card, context)
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
    end

    --- Crooked Joker ---

    if config.j_sdm_crooked_joker then
        SMODS.Joker{
            key = "crooked_joker",
            name = "Crooked Joker",
            rarity = 1,
            discovered = true,
            pos = {x = 1, y = 2},
            cost = 6,
            config = {extra = 1},
            loc_txt = {
                name = "Crooked Joker",
                text = {
                    "{C:attention}Doubles{} added {C:attention}Joker{}",
                    "or {C:red}destroys{} it",
                    "and gain {C:money}$#1#",
                    "{C:inactive}(Must have room)"
                }
            },
            loc_vars = function(self, info_queue, card)
                return {vars = {card.ability.extra}}
            end,
            calculate = function(card, context)
                if context.sdm_adding_card and not context.blueprint then
                    if context.card and context.card ~= card and context.card.ability.set == 'Joker' then
                        do_dupe = pseudorandom(pseudoseed('sword_of_damocles'), 0, 1)
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
                            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, func = function()
                                card_eval_status_text(card, 'extra', nil, nil, nil, {
                                    message = localize('$') .. card.ability.extra,
                                    colour = G.C.MONEY
                                })
                                ease_dollars(card.ability.extra)
                            return true end }))
                        end
                    end
                end
            end,
            atlas = "sdm_jokers"
        }
    end

    --- Property Damage ---

    if config.j_sdm_property_damage then
        SMODS.Joker{
            key = "property_damage",
            name = "Property Damage",
            rarity = 2,
            discovered = true,
            pos = {x = 2, y = 2},
            cost = 7,
            loc_txt = {
                name = "Property Damage",
                text = {
                    "Discarded {C:attention}Full House{} cards",
                    "become {C:attention}Stone{} cards"
                }
            },
            calculate = function(card, context)
                if context.pre_discard and not context.blueprint then
                    if G.FUNCS.get_poker_hand_info(G.hand.highlighted) == "Full House" then
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = localize("k_stone"),
                            colour = G.C.GREY
                        })
                        for _, v in ipairs(G.hand.highlighted) do
                            v:set_ability(G.P_CENTERS.m_stone, nil)
                            v:juice_up()
                        end
                    end
                end
            end,
            atlas = "sdm_jokers"
        }
    end

    --- Rock'N'Roll ---

    if config.j_sdm_rock_n_roll then
        SMODS.Joker{
            key = "rock_n_roll",
            name = "Rock'N'Roll",
            rarity = 2,
            discovered = true,
            blueprint_compat = true,
            pos = {x = 3, y = 2},
            cost = 6,
            config = {extra = 1},
            loc_txt = {
                name = "Rock'N'Roll",
                text = {
                    "Retrigger all played",
                    "{C:attention}Wild{} and {C:attention}Stone{} cards",
                }
            },
            calculate = function(card, context)
                if context.repetition and not context.individual and context.cardarea == G.play then
                    if context.other_card.ability.effect == "Wild Card" or context.other_card.ability.effect == "Stone Card" then
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
    end

    --- Contract ---

    if config.j_sdm_contract then
        SMODS.Joker{
            key = "contract",
            name = "Contract",
            rarity = 2,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = false,
            pos = {x = 4, y = 2},
            cost = 6,
            config = {extra = {Xmult = 3, dollars = 0, dollars_mod = 15, registered = false, breached = false}},
            loc_txt = {
                name = "Contract",
                text = {
                    "{X:red,C:white}X#1#{} Mult",
                    "when {C:attention}Blind{} is selected,",
                    "register current money,",
                    "destroyed if out of range",
                    "{C:inactive}({C:money}$#3#{C:inactive} - {C:money}$#4#{C:inactive})"
                }
            },
            loc_vars = function(self, info_queue, card)
                return {vars = {card.ability.extra.Xmult, card.ability.extra.dollars_mod,
                (card.ability.extra.registered and card.ability.extra.dollars) or "?",
                (card.ability.extra.registered and card.ability.extra.dollars + card.ability.extra.dollars_mod) or "?+" .. card.ability.extra.dollars_mod}}
            end,
            calculate = function(card, context)
                if context.setting_blind and not (card.getting_sliced or card.breached) and not card.ability.extra.registered then
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = localize('k_signed_ex'),
                        colour = G.C.FILTER
                    })
                    card.ability.extra.dollars = G.GAME.dollars
                    card.ability.extra.registered = true
                end
                if SMODS.end_calculate_context(context) then
                    return {
                        message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
                        Xmult_mod = card.ability.extra.Xmult
                    }
                end
            end,
            atlas = "sdm_jokers"
        }
    end

    --- Cupidon ---

    if config.j_sdm_cupidon then
        SMODS.Joker{
            key = "cupidon",
            name = "Cupidon",
            rarity = 1,
            discovered = true,
            blueprint_compat = true,
            pos = {x = 5, y = 2},
            cost = 5,
            config = {extra = 15},
            loc_txt = {
                name = "Cupidon",
                text = {
                    "{C:red}+#1#{} Mult if scored hand",
                    "contains a {C:attention}King{} and {C:attention}Queen{}",
                    "card of the same {C:attention}suit",
                }
            },
            loc_vars = function(self, info_queue, card)
                return {vars = {card.ability.extra}}
            end,
            calculate = function(card, context)
                if SMODS.end_calculate_context(context) and context.scoring_hand then
                    local king_suit = {}
                    local queen_suit = {}
                    local wild_king = 0
                    local wild_queen = 0
                    local couple = false
                    for k, v in ipairs(context.scoring_hand) do
                        if v:get_id() == 12 then
                            if v.ability.name == 'Wild Card' then
                                wild_king = wild_king + 1
                            else
                                table.insert(king_suit, v.base.suit)
                            end
                        elseif v:get_id() == 13 then
                            if v.ability.name == 'Wild Card' then
                                wild_queen = wild_queen + 1
                            else
                                table.insert(queen_suit, v.base.suit)
                            end
                        end
                    end
                    if (wild_king > 0 and #queen_suit > 0) or (wild_queen > 0 and #king_suit > 0) or (wild_king > 0 and wild_queen > 0) then
                        couple = true
                    end
                    if not couple and #king_suit > 0 and #queen_suit > 0 then
                        for _, v in ipairs(king_suit) do
                            for _, vv in ipairs(queen_suit) do
                                if v == vv then
                                    couple = true
                                end
                            end
                        end
                    end
                    if couple then
                        return {
                            message = localize{type='variable',key='a_mult',vars={card.ability.extra}},
                            mult_mod = card.ability.extra
                        }
                    end
                end
            end,
            atlas = "sdm_jokers"
        }
    end

    --- Pizza ---

    if config.j_sdm_pizza then
        SMODS.Joker{
            key = "pizza",
            name = "Pizza",
            rarity = 1,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = false,
            pos = {x = 6, y = 2},
            cost = 5,
            config = {extra = {hands = 4, hand_mod = 1}},
            loc_txt = {
                name = "Pizza",
                text = {
                    "When {C:attention}Blind{} is selected,",
                    "{C:blue}+#1#{} #3#, reduces by",
                    "{C:red}#2#{} every round"
                }
            },
            loc_vars = function(self, info_queue, card)
                return {vars = {card.ability.extra.hands, card.ability.extra.hand_mod, (card.ability.extra.hands > 1 and "hands") or "hand"}}
            end,
            calculate = function(card, context)
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
    end

    --- Treasure Chest ---

    if config.j_sdm_treasure_chest then
        SMODS.Joker{
            key = "treasure_chest",
            name = "Treasure Chest",
            rarity = 1,
            discovered = true,
            eternal_compat = false,
            pos = {x = 7, y = 2},
            cost = 4,
            config = {extra = 2},
            loc_txt = {
                name = "Treasure Chest",
                text = {
                    "Gains {C:money}$#1#{} of",
                    "{C:attention}sell value{} per",
                    "{C:attention}consumable{} sold"
                }
            },
            loc_vars = function(self, info_queue, card)
                return {vars = {card.ability.extra}}
            end,
            calculate = function(card, context)
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
    end

    --- Bullet Train ---

    if config.j_sdm_bullet_train then
        SMODS.Joker{
            key = "bullet_train",
            name = "Bullet Train",
            rarity = 1,
            discovered = true,
            blueprint_compat = true,
            pos = {x = 8, y = 2},
            cost = 6,
            config = {extra = 150},
            loc_txt = {
                name = "Bullet Train",
                text = {
                    "{C:chips}+#1#{} Chips on your",
                    "{C:attention}first hand{} if no discards",
                    "were used this round",
                }
            },
            loc_vars = function(self, info_queue, card)
                return {vars = {card.ability.extra}}
            end,
            calculate = function(card, context)
                if SMODS.end_calculate_context(context) and G.GAME.current_round.hands_played == 0 and G.GAME.current_round.discards_used == 0 then
                    return {
                        message = localize{type='variable',key='a_chips',vars={card.ability.extra}},
                        chip_mod = card.ability.extra
                    }
                end
            end,
            atlas = "sdm_jokers"
        }
    end

    --- Chaos Theory ---

    if config.j_sdm_chaos_theory then
        SMODS.Joker{
            key = "chaos_theory",
            name = "Chaos Theory",
            rarity = 3,
            discovered = true,
            blueprint_compat = true,
            pos = {x = 9, y = 2},
            cost = 8,
            config = {extra = {chips = 0, chip_mod = 2}},
            loc_txt = {
                name = "Chaos Theory",
                text = {
                    "{C:chips}+#1#{} Chips per existing",
                    "numerical value",
                    "{s:0.8,C:inactive}(Except round score, score goal,",
                    "{s:0.8,C:inactive}hand level and descriptions)",
                    "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)"
                }
            },
            loc_vars = function(self, info_queue, card)
                return {vars = {card.ability.extra.chip_mod, card.ability.extra.chips}}
            end,
            calculate = function(card, context)
                if SMODS.end_calculate_context(context) then
                    return {
                        message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
                        chip_mod = card.ability.extra.chips
                    }
                end
            end,
            atlas = "sdm_jokers"
        }
    end

    --- Archibald ---

    if config.j_sdm_archibald then
        SMODS.Joker{
            key = "archibald",
            name = "Archibald",
            rarity = 4,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = false,
            pos = {x = 0, y = 3},
            cost = 20,
            loc_txt = {
                name = "Archibald",
                text = {
                    "On {C:attention}Joker{} card added,",
                    "creates a {C:dark_edition}Negative{} copy",
                    "{C:inactive}(Copy start selling for {C:money}$0{C:inactive})"
                }
            },
            calculate = function(card, context)
                if context.buying_card then
                    if context.card.ability.set == 'Joker' then
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {
                            message = localize('k_plus_joker'),
                            colour = G.C.BLUE,
                        })
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                new_card = create_card('Joker', G.jokers, nil, nil, nil, nil, context.card.config.center.key, nil)
                                new_card:set_edition({negative = true}, true)
                                new_card.sell_cost = 0
                                new_card:add_to_deck2()
                                G.jokers:emplace(new_card)
                                new_card:start_materialize()
                                return true
                            end
                        }))
                    end
                end
            end,
            atlas = "sdm_jokers",
            soul_pos = {x = 0, y = 4}
        }
    end
end

return