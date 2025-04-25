--- Quicker way to print elements
function sdm_debug(elem)
    if not elem then return sendDebugMessage("[SDM0's Stuff] DEBUG: This element doesn't exist") end
    if type(elem) == "boolean" then
        return (elem and sendDebugMessage("[SDM0's Stuff] DEBUG: true")) or sendDebugMessage("[SDM0's Stuff] DEBUG: false")
    end
    if type(elem) == "table" then
        return sendDebugMessage("[SDM0's Stuff] DEBUG: " .. inspect(elem))
    else
        return sendDebugMessage("[SDM0's Stuff] DEBUG: " .. elem)
    end
end

--- Get a value's index in a table
function index_elem(table, value)
    for k, v in ipairs(table) do
        if v == value then
            return k
        end
    end
    return nil
end

-- Faster way to decrease food/bakery consumables remaining counter
function decrease_remaining_food(card)
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
                        -- This function is only used by jokers and bakery goods so I ignore other areas
                        if card.ability.set == "Joker" then
                            G.jokers:remove_card(card)
                        else
                            G.consumeables:remove_card(card)
                        end
                        card:remove()
                        card = nil
                    return true; end}))
            return true
        end}))
        card_eval_status_text(card, 'extra', nil, nil, nil, {
            message = localize('k_eaten_ex'),
            colour = G.C.FILTER
        })
    else
        card.ability.extra.remaining = card.ability.extra.remaining - 1
        G.E_MANAGER:add_event(Event({
            func = function()
            card_eval_status_text(card, 'extra', nil, nil, nil, {
                message = card.ability.extra.remaining..'',
                colour = G.C.FILTER
            })
            return true
        end}))
    end
end

--- Get the most and best played poker hand
function get_most_played_better_hand()
    local hand = "High Card"
    local played_more_than = 0
    local order = 999
    if G.GAME.hands then
        for k, v in pairs(G.GAME.hands) do
            if (v.played > played_more_than) or (v.played == played_more_than and v.played > 0 and v.order < order) and v.visible then
                played_more_than = v.played
                order = v.order
                hand = k
            end
        end
    end
    return hand
end

--- Counts how many Carcinization there is
function get_crab_count()
    local crab_count = 0
    if G.jokers and G.jokers.cards then
        if #G.jokers.cards > 0 then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.name == "Carcinization" and not G.jokers.cards[i].debuff then
                    crab_count = crab_count + 1
                end
            end
        end
    end
    return crab_count
end

--- Get the sum of (almost) all existing numbers (capped at 1e300)
function sum_incremental(n)
    if G.jokers then
        local sum_inc = ((G.GAME.current_round.discards_left + G.GAME.current_round.hands_left + #G.jokers.cards + G.jokers.config.card_limit + G.GAME.round
        + G.GAME.round_resets.blind_ante + G.hand.config.card_limit + #G.deck.cards + #G.playing_cards + G.consumeables.config.card_limit +
        #G.consumeables.cards + (type(G.GAME.dollars) ~= "table" and G.GAME.dollars or to_number(G.GAME.dollars)) + G.GAME.win_ante) * n) or 0
        if to_big(sum_inc) > to_big(1e300) then
            sum_inc = 1e300
        end
        return sum_inc
    end
    return 0
end

-- Initialization of the random "Reach the Stars" condition values
function rts_init()
    local valid_nums = {}
    for i = 1, (G.hand and G.hand.config.highlighted_limit or 5) do
        valid_nums[#valid_nums+1] = i
    end
    local c1 = pseudorandom_element(valid_nums, pseudoseed('rts'))
    table.remove(valid_nums, c1)
    local c2 = pseudorandom_element(valid_nums, pseudoseed('rts'))
    local num_card1, num_card2 = math.min(c1, c2), math.max(c1, c2)
    return num_card1, num_card2
end

-- Faster way to write non-BP/retrigger check
function no_bp_retrigger(context)
    if not context then return false end
    return not (context.blueprint or context.retrigger_joker or context.retrigger_joker_check)
end

-- Overrides

--- "Crooked Joker" failsafe
local atd = Card.add_to_deck
function Card:add_to_deck2(debuff)
    self.not_crooked = true
    return atd(self, debuff)
end

local gfcr = G.FUNCS.can_reroll
function G.FUNCS.can_reroll(e)
	if G.GAME.modifiers.sdm_no_reroll then
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	else
		return gfcr(e)
	end
end

--- Talisman compat
to_big = to_big or function(num)
    return num
end

to_number = to_number or function(num)
    return num
end