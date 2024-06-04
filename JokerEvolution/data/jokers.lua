SMODS.Joker{
	key = "astronaut",
	name = "Astronaut Joker",
	rarity = "evo",
	blueprint_compat = true,
	pos = {x = 3, y = 5},
	cost = 5,
	config = {extra = 2},
	loc_txt = {
		name = "Astronaut Joker",
		text = {
            "{C:green}#1# in #2#{} chance to",
            "upgrade level of",
            "played {C:attention}poker hand{}"
        }
	},
	loc_vars = function(self, info_queue, card)
		return {vars = {''..(G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra}}
	end,
	calculate = function(self, card, context)
		if context.cardarea == G.jokers and context.before then
            if pseudorandom('astronaut') < G.GAME.probabilities.normal/card.ability.extra then
                return {
                    card = card,
                    level_up = true,
                    message = localize('k_level_up_ex')
                }
            end
		end
	end,
}

return