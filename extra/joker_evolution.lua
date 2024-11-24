SMODS.Joker{
	key = "mishmash",
	name = "Mishmash",
	rarity = "evo",
	blueprint_compat = true,
	pos = {x = 0, y = 0},
	cost = 10,
	config = {extra = {chips = 30, mult = 4, Xmult = 1.5, dollars = 3}},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_bonus
        info_queue[#info_queue+1] = G.P_CENTERS.m_mult
        info_queue[#info_queue+1] = G.P_CENTERS.m_gold
        info_queue[#info_queue+1] = G.P_CENTERS.m_steel
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
                G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
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

SMODS.Joker{
	key = "ceo_joker",
	name = "CEO Joker",
	rarity = "evo",
    pos = {x = 0, y = 0},
	cost = 10,
    config = {extra = {min = 1, max = 8, dollar = 0, dollar_mod = 2}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.min, card.ability.extra.max, card.ability.extra.dollar_mod, card.ability.extra.min + card.ability.extra.dollar, card.ability.extra.max + card.ability.extra.dollar}}
    end,
    calc_dollar_bonus = function(self, card)
        local rand_dollar = pseudorandom(pseudoseed('ceo'), card.ability.extra.min + card.ability.extra.dollar, card.ability.extra.max + card.ability.extra.dollar)
        return rand_dollar
    end,
	calculate_evo = function(self, card, context)
		if context.selling_card then
            if context.card.ability.set == 'Joker' then
                local rarity = context.card.config.center.rarity
                if type(rarity) == "number" and rarity >= 3 or type(rarity) ~= "number" then
                    card:decrement_evo_condition()
                end
            end
		end
	end,
    update = function(self, card, dt)
        local rare_jokers = 0
        if G.jokers and G.jokers.cards then
            if #G.jokers.cards > 0 then
                for i = 1, #G.jokers.cards do
                    local rarity = G.jokers.cards[i].config.center.rarity
                    if (type(rarity) == "number" and rarity == 1) then
                        rare_jokers = rare_jokers + 1
                    end
                end
            end
        end
        card.ability.extra.dollar = rare_jokers * card.ability.extra.dollar_mod
    end,
    atlas = "sdm_jokers"
}

JokerEvolution.evolutions:add_evolution("j_sdm_shareholder_joker", "j_sdm_ceo_joker", 3)