SMODS.PokerHand({
	key = "Chicken Head",
	visible = false,
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
		local has_8 = nil
        local has_4 = nil
        local has_3 = nil
        local result = {}
		for _, card in ipairs(hand) do
            if card.base.id == 8 and not has_8 then
                has_8 = true
                result[#result+1] = card
            elseif card.base.id == 4 and not has_4 then
                has_4 = true
                result[#result+1] = card
            elseif card.base.id == 3 and not has_3 then
                has_3 = true
                result[#result+1] = card
            end
		end
        return (has_8 and has_4 and has_3) and { result } or {}
	end,
})