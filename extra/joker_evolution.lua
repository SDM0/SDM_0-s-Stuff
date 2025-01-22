--- Mishmash ---

SMODS.Joker{
    key = "mishmash",
    name = "Mishmash",
    rarity = "evo",
    blueprint_compat = true,
    pos = {x = 0, y = 0},
    cost = 10,
    config = {extra = {chips = 30, mult = 4, Xmult = 1.5, dollars = 3}},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bonus
        info_queue[#info_queue + 1] = G.P_CENTERS.m_mult
        info_queue[#info_queue + 1] = G.P_CENTERS.m_gold
        info_queue[#info_queue + 1] = G.P_CENTERS.m_steel
        return {vars = {card.ability.extra.mult, card.ability.extra.chips, card.ability.extra.Xmult, card.ability.extra.dollars}}
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
        if context.cardarea == G.hand and context.individual then
            if not context.end_of_round and context.other_card.ability.effect == "Gold Card" then
                return {
                    x_mult = card.ability.extra.Xmult,
                    colour = G.C.RED,
                    card = card
                }
            elseif context.end_of_round and context.other_card.ability.effect == "Steel Card" then
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
                G.E_MANAGER:add_event(Event({func = (function()
                    G.GAME.dollar_buffer = 0;
                    return true
                end)}))
                return {
                    dollars = card.ability.extra.dollars,
                    card = card
                }
            end
        end
    end,
    calculate_evo = function(self, card, context)
        if context.joker_main and context.scoring_hand then
            for i = 1, #context.scoring_hand do
                local _card = context.scoring_hand[i]
                if not _card.debuff and _card.ability.effect == "Bonus Card" or
                    _card.ability.effect == "Mult Card" then
                    card:decrement_evo_condition()
                end
            end
        end
    end,
    atlas = "sdm_jokers"
}

JokerEvolution.evolutions:add_evolution("j_sdm_mult_n_chips", "j_sdm_mishmash", 10)

--- CEO Joker ---

SMODS.Joker{
    key = "ceo_joker",
    name = "CEO Joker",
    rarity = "evo",
    pos = {x = 0, y = 0},
    cost = 10,
    config = {extra = {min = 5, max = 10}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.min, card.ability.extra.max}}
    end,
    calc_dollar_bonus = function(self, card)
        local rand_dollar = pseudorandom(pseudoseed('ceo'), card.ability.extra.min, card.ability.extra.max)
        return rand_dollar
    end,
    calculate_evo = function(self, card, context)
        if context.selling_card then
            if context.card.ability.set == 'Joker' then
                local rarity = context.card.config.center.rarity
                if rarity == 1 then card:decrement_evo_condition() end
            end
        end
    end,
    atlas = "sdm_jokers"
}

JokerEvolution.evolutions:add_evolution("j_sdm_shareholder_joker", "j_sdm_ceo_joker", 10)

--- Maglev Train ---

SMODS.Joker{
    key = "maglev_train",
    name = "Maglev Train",
    rarity = "evo",
    pos = {x = 0, y = 0},
    cost = 12,
    config = {extra = 30},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra}}
    end,
    calculate = function(self, card, context)
        if context.joker_main and G.GAME.current_round.hands_played == 0 and G.GAME.current_round.discards_used == 0 then
            return {
                message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra}},
                mult_mod = card.ability.extra
            }
        end
    end,
    calculate_evo = function(self, card, context)
        if context.end_of_round and not (context.individual or context.repetition) then
            if G.GAME.current_round.hands_played == 1 then
                card:decrement_evo_condition()
            end
        end
    end,
    atlas = "sdm_jokers"
}

JokerEvolution.evolutions:add_evolution("j_sdm_bullet_train", "j_sdm_maglev_train", 5)

--- Joker Voucher Voucher ---

SMODS.Joker{
    key = "joker_voucher_voucher",
    name = "Joker Voucher Voucher",
    rarity = "evo",
    pos = {x = 0, y = 0},
    cost = 16,
    calculate_evo = function(self, card, context)
        if context.buying_card then
            if context.card and context.card.ability.set == 'Voucher' then
                card:decrement_evo_condition()
            end
        end
    end,
    atlas = "sdm_jokers"
}

JokerEvolution.evolutions:add_evolution("j_sdm_joker_voucher", "j_sdm_joker_voucher_voucher", 3)

-- TODO:
-- Joker Voucher evolution: After it evolved, destroy said Joker, pop up "Redeemed" message, redeem voucher "Joker Voucher" (same effect)
-- (V) JV = the voucher; (J) JV = the joker
-- (V) JV must not appear in the shop voucher slot at all,
-- (J) JV must not be in the joker pool anymore if (V) JV is redeemed