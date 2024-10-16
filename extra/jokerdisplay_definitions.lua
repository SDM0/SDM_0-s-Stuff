--- JokerDisplay integration

local jd_def = JokerDisplay.Definitions

jd_def["j_sdm_burger"] = { -- Burger
    text = {
        { text = "+",                       colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "chips", colour = G.C.CHIPS },
        { text = " +",                      colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult",  colour = G.C.MULT },
    },
    extra = {
        {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.ability.extra", ref_value = "Xmult" }
                }
            }
        },
    },
    reminder_text = {
        { text = '(', },
        { ref_table = "card.ability.extra", ref_value = "remaining" },
        { text = '/5)', },
    }
}
jd_def["j_sdm_bounciest_ball"] = { -- Bounciest Ball
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "chips" },
    },
    text_config = { colour = G.C.CHIPS },
    calc_function = function(card)
        local hand = G.hand.highlighted
        local text, _, _ = JokerDisplay.evaluate_hand(hand)
        local hand_exists = #hand > 0 and text ~= 'Unknown' and G.GAME and G.GAME.hands and G.GAME.hands[text]
        local is_most_played_hand = false
        if hand_exists then
            -- Sadly the util function doesn't work because we need to calculate before the hand is played
            is_most_played_hand = true
            local played_more_than = G.GAME.hands[text].played + 1
            local order = G.GAME.hands[text].order
            for _, poker_hand_stats in pairs(G.GAME.hands) do
                if (poker_hand_stats.played > played_more_than) or (poker_hand_stats.played == played_more_than and poker_hand_stats.played > 0 and poker_hand_stats.order < order) and poker_hand_stats.visible then
                    is_most_played_hand = false
                    break
                end
            end
        end

        card.joker_display_values.chips = hand_exists and (is_most_played_hand and
                card.ability.extra.chips + card.ability.extra.chip_mod or math.floor(card.ability.extra.chips / 2)) or
            card.ability.extra.chips
    end
}
jd_def["j_sdm_lucky_joker"] = { -- Lucky Joker
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        if held_in_hand then return 0 end
        return playing_card:get_id() == 7 and joker_card.ability.extra.repetition or 0
    end
}
jd_def["j_sdm_iconic_icon"] = { -- Iconic Icon
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "mult" },
    },
    text_config = { colour = G.C.MULT },
}
jd_def["j_sdm_mult_n_chips"] = { -- Mult'N'Chips
    text = {
        { text = "+",                              colour = G.C.CHIPS },
        { ref_table = "card.joker_display_values", ref_value = "chips", colour = G.C.CHIPS },
        { text = " +",                             colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult",  colour = G.C.MULT },
    },
    calc_function = function(card)
        local chips = 0
        local mult = 0
        local text, poker_hands, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= "Unknown" then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card.ability.effect and scoring_card.ability.effect == "Bonus Card" then
                    mult = mult + card.ability.extra.mult *
                        JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                elseif scoring_card.ability.effect and scoring_card.ability.effect == "Mult Card" then
                    chips = chips + card.ability.extra.chips *
                        JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.chips = chips
        card.joker_display_values.mult = mult
    end
}
jd_def["j_sdm_moon_base"] = { -- Moon Base

}
jd_def["j_sdm_shareholder_joker"] = { -- Shareholder Joker
    text = {
        { text = "+$" },
        { ref_table = "card.ability.extra", ref_value = "min" },
        { text = "-" },
        { ref_table = "card.ability.extra", ref_value = "max" },
    },
    text_config = { colour = G.C.GOLD },
    reminder_text = {
        { ref_table = "card.joker_display_values", ref_value = "localized_text" },
    },
    calc_function = function(card)
        card.joker_display_values.localized_text = "(" .. localize("k_round") .. ")"
    end
}
jd_def["j_sdm_magic_hands"] = { -- Magic Hands
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "x_mult" }
            }
        }
    },
    calc_function = function(card)
        local is_magic_hands_hand = false
        local text, poker_hands, scoring_hand = JokerDisplay.evaluate_hand()
        if #JokerDisplay.current_hand > 0 and text ~= "Unknown" then
            local cards_id = {}
            for _, scoring_card in pairs(scoring_hand) do
                table.insert(cards_id, scoring_card:get_id())
            end
            local max_card = count_max_occurence(cards_id) or 0
            is_magic_hands_hand = (G.GAME.current_round.hands_left + (next(G.play.cards) and 1 or 0)) == max_card
        end
        card.joker_display_values.x_mult = is_magic_hands_hand and card.ability.extra or 1
    end
}
jd_def["j_sdm_tip_jar"] = { -- Tip Jar
    text = {
        { text = "+$" },
        { ref_table = "card.joker_display_values", ref_value = "dollars" },
    },
    text_config = { colour = G.C.GOLD },
    reminder_text = {
        { ref_table = "card.joker_display_values", ref_value = "localized_text" },
    },
    calc_function = function(card)
        local highest = 0
        for digit in tostring(math.abs(G.GAME.dollars)):gmatch("%d") do
            highest = math.max(highest, tonumber(digit))
        end
        card.joker_display_values.dollars = highest
        card.joker_display_values.localized_text = "(" .. localize("k_round") .. ")"
    end
}
jd_def["j_sdm_wandering_star"] = { -- Wandering Star
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = " in " },
            { ref_table = "card.ability",              ref_value = "extra" },
            { text = ")" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        card.joker_display_values.odds = G.GAME and G.GAME.probabilities.normal or 1
    end
}

jd_def["j_sdm_ouija_board"] = { -- Ouija Board
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "localized_text_rare" },
        { text = "/" },
        { ref_table = "card.joker_display_values", ref_value = "localized_text_secret" },
        { text = "/" },
        { ref_table = "card.joker_display_values", ref_value = "localized_text_spectral" },
        { text = ")" },
    },
    calc_function = function(card)
        card.joker_display_values.localized_text_rare = localize("k_rare")
        card.joker_display_values.localized_text_secret = "Secret"
        card.joker_display_values.localized_text_spectral = localize("k_spectral")
    end,
    style_function = function(card, text, reminder_text, extra)
        if reminder_text then
            if reminder_text.children[2] then
                reminder_text.children[2].config.colour = card.ability.extra.sold_rare and G.C.ORANGE or
                    G.C.UI.TEXT_INACTIVE
            end
            if reminder_text.children[4] then
                reminder_text.children[4].config.colour = card.ability.extra.scored_secret and G.C.ORANGE or
                    G.C.UI.TEXT_INACTIVE
            end
            if reminder_text.children[6] then
                reminder_text.children[6].config.colour = card.ability.extra.used_spectral and G.C.ORANGE or
                    G.C.UI.TEXT_INACTIVE
            end
        end
        return false
    end
}
jd_def["j_sdm_la_revolution"] = { -- La Révolution

}
jd_def["j_sdm_clown_bank"] = { -- Clown Bank
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult" }
            }
        }
    },
    reminder_text = {
        { text = "(" },
        { text = "$",                       colour = G.C.GOLD },
        { ref_table = "card.ability.extra", ref_value = "dollars", colour = G.C.GOLD },
        { text = ")" },
    }
}
jd_def["j_sdm_furnace"] = { -- Furnace

}
jd_def["j_sdm_warehouse"] = { -- Warehouse

}
jd_def["j_sdm_zombie_joker"] = { -- Zombie Joker
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = " in " },
            { ref_table = "card.ability",              ref_value = "extra" },
            { text = ")" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        card.joker_display_values.odds = G.GAME and G.GAME.probabilities.normal or 1
    end
}
jd_def["j_sdm_mystery_joker"] = { -- Mystery Joker

}
jd_def["j_sdm_infinite_staircase"] = { -- Infinite Staircase
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "x_mult" }
            }
        }
    },
    calc_function = function(card)
        local is_infinite_staircase_hand = false
        local text, poker_hands, scoring_hand = JokerDisplay.evaluate_hand()
        if #JokerDisplay.current_hand > 0 and text ~= "Unknown" and poker_hands["Straight"] and next(poker_hands["Straight"]) then
            is_infinite_staircase_hand = true
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card:is_face() or scoring_card:get_id() == 14 then
                    is_infinite_staircase_hand = false
                end
            end
        end
        card.joker_display_values.x_mult = is_infinite_staircase_hand and card.ability.extra.Xmult or 1
    end
}
jd_def["j_sdm_ninja_joker"] = { -- Ninja Joker
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" },
    },
    calc_function = function(card)
        card.joker_display_values.active = card.ability.extra.can_dupe and localize("k_active_ex") or "Inactive"
    end,
    style_function = function(card, text, reminder_text, extra)
        if reminder_text and reminder_text.children[2] then
            reminder_text.children[2].config.colour = card.ability.extra.can_dupe and G.C.ORANGE or
                G.C.UI.TEXT_INACTIVE
        end
        return false
    end
}
jd_def["j_sdm_reach_the_stars"] = { -- Reach The Stars
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "count" },
    },
    text_config = { colour = G.C.SECONDARY_SET.Planet },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.ability.extra", ref_value = "num_card1" },
        { text = " & " },
        { ref_table = "card.ability.extra", ref_value = "num_card2" },
        { text = ")" },
    },
    calc_function = function(card)
        local text, poker_hands, scoring_hand = JokerDisplay.evaluate_hand()
        card.joker_display_values.count = text ~= 'Unknown' and
            ((#scoring_hand == card.ability.extra.num_card1 and card.ability.extra.c2_scored) or (#scoring_hand == card.ability.extra.num_card2 and card.ability.extra.c1_scored)) and
            1 or 0
    end,
    style_function = function(card, text, reminder_text, extra)
        if reminder_text then
            if reminder_text.children[2] then
                reminder_text.children[2].config.colour = card.ability.extra.c1_scored and G.C.ORANGE or
                    G.C.UI.TEXT_INACTIVE
            end
            if reminder_text.children[4] then
                reminder_text.children[4].config.colour = card.ability.extra.c2_scored and G.C.ORANGE or
                    G.C.UI.TEXT_INACTIVE
            end
        end
        return false
    end
}
jd_def["j_sdm_crooked_joker"] = { -- Crooked Joker

}
jd_def["j_sdm_property_damage"] = { -- Property Damage
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult" }
            }
        }
    },
}
jd_def["j_sdm_rock_n_roll"] = { -- Rock'N'Roll
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        if held_in_hand then return 0 end
        return playing_card.ability.effect ~= "Base" and joker_card.ability.extra or 0
    end
}
jd_def["j_sdm_contract"] = { -- Contract
    text = {
        {
            text = "+$",
            colour = G.C.MONEY
        },
        { ref_table = "card.ability.extra", ref_value = "money", colour = G.C.MONEY },
        { text = " " },
        { ref_table = "card.ability.extra", ref_value = "blind_req", colour = G.C.RED },
        {
            text = "X",
            colour = G.C.RED
        },
    },
}
jd_def["j_sdm_cupidon"] = {} -- Cupidon
jd_def["j_sdm_pizza"] = { -- Pizza
    reminder_text = {
        { text = "(+" },
        { ref_table = "card.ability.extra", ref_value = "hands" },
        { text = ")" },
    },
}
jd_def["j_sdm_treasure_chest"] = { -- Treasure Chest
    reminder_text = {
        { text = "(" },
        { text = "$",         colour = G.C.GOLD },
        { ref_table = "card", ref_value = "sell_cost", colour = G.C.GOLD },
        { text = ")" },
    },
    reminder_text_config = { scale = 0.35 }
}
jd_def["j_sdm_bullet_train"] = { -- Bullet Train
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "chips" },
    },
    text_config = { colour = G.C.CHIPS },
    calc_function = function(card)
        card.joker_display_values.chips = G.GAME.current_round.hands_played == 0 and
            G.GAME.current_round.discards_used == 0 and card.ability.extra or 0
    end
}
jd_def["j_sdm_chaos_theory"] = { -- Chaos Theory
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "chips" },
    },
    text_config = { colour = G.C.CHIPS },
}
jd_def["j_sdm_jambo"] = { -- Jambo

}
jd_def["j_sdm_water_slide"] = { -- Water Slide
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "chips" }
    },
    text_config = { colour = G.C.CHIPS },
}
jd_def["j_sdm_joker_voucher"] = { -- Joker Voucher
    text = {
        {
            border_nodes = {
                { text = "X", colour = G.C.WHITE },
                { ref_table = "card.joker_display_values", ref_value = "x_mult", colour = G.C.WHITE }
            },
            border_colour = G.C.MULT
        }
    },
    text_config = { colour = G.C.MULT },
    calc_function = function(card)
        local has_voucher = false
        local used_voucher = 0
        for _, _ in pairs(G.GAME.used_vouchers) do
            has_voucher = true
            used_voucher = used_voucher + 1
        end
        card.joker_display_values.x_mult = (has_voucher and 1 + used_voucher * card.ability.extra.Xmult_mod) or 1
    end
}
jd_def["j_sdm_free_pass"] = { -- Free Pass
    text = {
        { ref_table = "card.joker_display_values", ref_value = "extra", colour = G.C.FILTER},
    },
    calc_function = function(card)
        local valid_pass = G.GAME and G.GAME.current_round.discards_used == 0 and
        G.GAME.current_round.discards_left > 0 and G.GAME.current_round.hands_played == 0 and
        G.GAME.current_round.hands_left > 0
        card.joker_display_values.active = valid_pass
        card.joker_display_values.extra = card.joker_display_values.active and
            ("+" .. (valid_pass and card.ability.extra and JokerDisplay.number_format(card.ability.extra) or 0)) or
            "-"
    end,
    style_function = function(card, text, reminder_text, extra)
        if text and text.children[1] then
            text.children[1].config.colour = card.joker_display_values.active and G.C.FILTER or
                G.C.UI.TEXT_INACTIVE
        end
        return false
    end
}
jd_def["j_sdm_legionary_joker"] = { -- Legionary Joker
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" },
    },
    text_config = { colour = G.C.MULT },
    calc_function = function(card)
        local playing_hand = next(G.play.cards)
        local mult = 0
        for _, playing_card in ipairs(G.hand.cards) do
            if playing_hand or not playing_card.highlighted then
                if playing_card.facing and not (playing_card.facing == 'back') and not playing_card.debuff and (playing_card:is_suit("Diamonds", nil, true) or playing_card:is_suit("Spades", nil, true)) then
                    mult = mult + card.ability.extra * JokerDisplay.calculate_card_triggers(playing_card, nil, true)
                end
            end
        end
        card.joker_display_values.mult = mult
    end
}

jd_def["j_sdm_jack_a_dit"] = { -- Jack a Dit
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
    calc_function = function(card)
        local has_jack = false
        local text, poker_hands, scoring_hand = JokerDisplay.evaluate_hand()
        local is_jack_a_dit_poker_hand = text == card.ability.jack_poker_hand
        if #JokerDisplay.current_hand > 0 and text ~= "Unknown" then
            for _, scoring_card in pairs(scoring_hand) do
                if not scoring_card.debuff and scoring_card.base.value == "Jack" then
                    has_jack = true
                    break
                end
            end
        end
        card.joker_display_values.mult = has_jack and is_jack_a_dit_poker_hand and card.ability.extra or 0
    end
}

jd_def["j_sdm_set_in_stone"] = {   -- Set in Stone
}

jd_def["j_sdm_consolation_prize"] = { -- Consolation Prize
}

jd_def["j_sdm_astrology"] = { -- Consolation Prize
}

jd_def["j_sdm_roulette"] = { -- Roulette
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = " in " },
            { ref_table = "card.ability",              ref_value = "extra" },
            { text = ")" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        card.joker_display_values.odds = G.GAME and G.GAME.probabilities.normal or 1
    end
}

jd_def["j_sdm_carcinization"] = { -- Carcinization
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT }
}

jd_def["j_sdm_foresight"] = { -- Foresight TODO
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "card" },
        { text = ")" },
    },
    calc_function = function(card)
        local text = ""
        if G.deck and G.deck.cards then
            for i = 1, math.min(card.ability.extra, #G.deck.cards) do
                local info = get_scry_info(G.deck.cards[#G.deck.cards-(i-1)], true)
                if info ~= "" then
                    text = text .. info .. ', '
                end
            end
            text = text:sub(1, -3)
        end
        card.joker_display_values.card = text
    end,
}

jd_def["j_sdm_wormhole"] = { -- Wormhole
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" },
    },
    calc_function = function(card)
        card.joker_display_values.active = card.ability.extra.repetition and localize("k_active_ex") or "Inactive"
    end,
    style_function = function(card, text, reminder_text, extra)
        if reminder_text and reminder_text.children[2] then
            reminder_text.children[2].config.colour = card.ability.extra.repetition and G.C.ORANGE or
                G.C.UI.TEXT_INACTIVE
        end
        return false
    end
}

jd_def["j_sdm_mimic_coin"] = { -- Mimic Coin
    reminder_text = {
        { text = "(" },
        { text = "$",         colour = G.C.GOLD },
        { ref_table = "card", ref_value = "sell_cost", colour = G.C.GOLD },
        { text = ")" },
    },
    reminder_text_config = { scale = 0.35 }
}

jd_def["j_sdm_archibald"] = { -- Archibald
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" },
    },
    calc_function = function(card)
        card.joker_display_values.active = card.ability.extra.can_copy and localize("k_active_ex") or "Inactive"
    end,
    style_function = function(card, text, reminder_text, extra)
        if reminder_text and reminder_text.children[2] then
            reminder_text.children[2].config.colour = card.ability.extra.can_copy and G.C.ORANGE or
                G.C.UI.TEXT_INACTIVE
        end
        return false
    end
}
jd_def["j_sdm_0"] = { -- SDM_0
    reminder_text = {
        { text = "(+" },
        { ref_table = "card.ability.extra", ref_value = "jkr_slots", colour = G.C.DARK_EDITION },
        { text = ")" },
    },
}
jd_def["j_sdm_trance_the_devil"] = { -- Trance The Devil
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult" }
            }
        }
    }
}
