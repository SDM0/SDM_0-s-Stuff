SDM_0s_Stuff_Funcs.get_chicken_head()

SMODS.PokerHand({
	key = "Chicken Head",
	chips = 25,
	mult = 3,
	l_chips = 25,
	l_mult = 3,
	example = {
		{ "S_8", true },
		{ "D_4", true },
		{ "C_3", true },
		{ "S_J", false },
		{ "H_3", false },
	},
	evaluate = function(parts, hand)
		return SDM_0s_Stuff_Funcs.get_chicken_head(hand)
	end,
})