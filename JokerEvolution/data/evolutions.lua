JokerEvolution.evolutions = {
	{
		key = 'j_space',
		evo = 'j_evo_astronaut',
		req = {
			type = "boss",
			amount = 1,
		}
	},
}

local debug = false
if debug then
	for _, evo in ipairs(JokerEvolution.evolutions) do
		evo.req.amount = 0
	end
end

return