local function has_joker(e)
	for k, v in pairs(G.jokers.cards) do
		if v.ability.set == 'Joker' and v.config.center.key == e then 
			return k
		end
	end
	return -1
end

function JokerEvolution.evolutions:add_evolution(joker, evolved_joker, req_type, req_amount)
    table.insert(self,  {key = joker, evo = evolved_joker, type = type, req = {type = req_type, amount = req_amount}})
end

function has_evo(c)
	for _, joker in ipairs(JokerEvolution.evolutions) do
		if c.key == joker.key then
			return true
		end
	end
	return false
end

function Card:can_evolve_card()
	for _, joker in ipairs(JokerEvolution.evolutions) do
		local exists = false
		local all_jokers = true
		if not (has_joker(joker.key) > -1) then
			all_jokers = false
		end
		if joker.key == self.config.center.key then
			exists = true
		end
		if exists and all_jokers and (self.ability.req and self.ability.req.amount >= joker.req.amount) then
			return true
		end
	end 
    return false
end

function Card:get_card_evolution()
	for _, evo in ipairs(JokerEvolution.evolutions) do
		if evo.key == self.config.center.key then
			return evo
		end
	end 
    return false
end

function Card:evolve_card()
	G.CONTROLLER.locks.selling_card = true
    stop_use()
    local area = self.area
    G.CONTROLLER:save_cardarea_focus('jokers')

    if self.children.use_button then self.children.use_button:remove(); self.children.use_button = nil end
    if self.children.sell_button then self.children.sell_button:remove(); self.children.sell_button = nil end

	local final_evo = nil
	for _, joker in ipairs(JokerEvolution.evolutions) do
		if joker.key == self.config.center.key then
			final_evo = joker
			break
		end
	end

	if final_evo ~= nil then
		G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.2, func = function()
			play_sound('whoosh1')
			self:juice_up(0.3, 0.4)
			return true
		end}))
		delay(0.2)
		G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function()
			local j_evo = create_card('Joker', G.jokers, nil, nil, nil, nil, final_evo.evo, nil)

			self:start_dissolve({G.C.GOLD})
			
			delay(0.1)

			j_evo:add_to_deck()
			G.jokers:emplace(j_evo)
			play_sound('explosion_release1')

			delay(0.1)
			G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3, blocking = false,
			func = function()
				G.E_MANAGER:add_event(Event({trigger = 'immediate',
				func = function()
					G.E_MANAGER:add_event(Event({trigger = 'immediate',
					func = function()
						G.CONTROLLER.locks.selling_card = nil
						G.CONTROLLER:recall_cardarea_focus(area == G.jokers and 'jokers' or 'consumeables')
					return true
					end}))
				return true
				end}))
			return true
			end}))
			return true
		end}))
	end

	G.CONTROLLER.locks.selling_card = nil
	G.CONTROLLER:recall_cardarea_focus('jokers')
end


function Card:calculate_evo(context)
	if self:get_card_evolution() then
		evo = self:get_card_evolution()
		if context == evo.req.type then
			self.ability.req.amount = self.ability.req.amount + 1
		end
	end
end

function set_evo_tooltip(_c)
	for _, joker in ipairs(JokerEvolution.evolutions) do
		if _c.key == joker.key then
			if G.jokers and G.jokers.cards then
				for i = 1, #G.jokers.cards do
					if G.jokers.cards[i].config.center_key == joker.key and joker.req.type == "boss" then
						sendDebugMessage(G.jokers.cards[i].ability.req.amount)
						return {key = "je_boss", set = "Other", vars = {joker.req.amount, math.min(G.jokers.cards[i].ability.req.amount, joker.req.amount) or 0}}
					end
				end
			end
			if joker.req.type == "boss" then
				return {key = "je_boss", set = "Other", vars = {joker.req.amount, 0}}
			end
		end
	end
	return {}
end

G.FUNCS.evolve_card = function(e)
    local card = e.config.ref_table
    card:evolve_card()
end

G.FUNCS.can_evolve_card = function(e)
    if e.config.ref_table:can_evolve_card() then 
        e.config.colour = G.C.EDITION
        e.config.button = 'evolve_card'
    else
      	e.config.colour = G.C.UI.BACKGROUND_INACTIVE
      	e.config.button = nil
    end
end

return