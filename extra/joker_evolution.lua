SMODS.Joker{
	key = "mishmash",
	name = "Mishmash",
	rarity = "evo",
	blueprint_compat = true,
	pos = {x = 0, y = 0},
	cost = 10,
	config = {extra = {Xmult = 1.5, dollars = 3}},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {
            set = "Joker",
            key = "j_sdm_mult_n_chips",
            specific_vars = {G.P_CENTERS.j_sdm_mult_n_chips.config.extra.mult, G.P_CENTERS.j_sdm_mult_n_chips.config.extra.chips},
        }
        info_queue[#info_queue+1] = G.P_CENTERS.m_gold
        info_queue[#info_queue+1] = G.P_CENTERS.m_steel
        return {vars = {card.ability.extra.Xmult,card.ability.extra.dollars}}
    end,
	calculate = function(self, card, context)
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