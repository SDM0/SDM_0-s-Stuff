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
function SDM_0s_Stuff_Funcs.index_elem(table, value)
    for k, v in ipairs(table) do
        if v == value then
            return k
        end
    end
    return nil
end

function SDM_0s_Stuff_Funcs.is_bakery_good(card)
    return card.ability.set == "Bakery" or card.ability.name == "Wedding Cake"
end

-- Faster way to decrease food/bakery consumables remaining counter
function SDM_0s_Stuff_Funcs.decrease_remaining_food(card)
    if card.ability.extra.remaining - 1 <= 0 then
        local is_bakery = card.ability.set == "Bakery"
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
                        if is_bakery then SMODS.calculate_context({sdm_bakery_consumed = true}) end
                    return true
                end}))
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

function SDM_0s_Stuff_Funcs.proba_check(card, odds, seed)
    local _odds = odds or 1
    local _seed = (seed and pseudoseed(seed)) or pseudoseed('default')
    return SMODS.pseudorandom_probability(card, _seed, 1, _odds)
end

--- Get the most and best played poker hand
function SDM_0s_Stuff_Funcs.get_most_played_better_hand()
    local hand = "High Card"
    local played_more_than = 0
    local order = 999
    if G.GAME.hands then
        for k, v in pairs(G.GAME.hands) do
            if (v.played > played_more_than) or (v.played == played_more_than and v.played > 0 and v.order < order) and SMODS.is_poker_hand_visible(k) then
                played_more_than = v.played
                order = v.order
                hand = k
            end
        end
    end
    return hand
end

--- Counts how many Carcinization there is
function SDM_0s_Stuff_Funcs.get_crab_count()
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
function SDM_0s_Stuff_Funcs.sum_incremental(n)
    if G.jokers then
        local sum_inc = ((G.GAME.current_round.discards_left + G.GAME.current_round.hands_left + #G.jokers.cards + G.jokers.config.card_limit + G.GAME.round
        + (G.GAME.round_resets and G.GAME.round_resets.blind_ante or 0) + (G.hand and #G.hand.cards or 0) + (math.min(G.hand.config.card_limit, G.hand and #G.hand.cards or 0)) + #G.deck.cards + #G.playing_cards + G.consumeables.config.card_limit +
        #G.consumeables.cards + (type(G.GAME.dollars) ~= "table" and G.GAME.dollars or to_number(G.GAME.dollars)) + G.GAME.win_ante) * n) or 0
        if sum_inc ~= sum_inc or sum_inc == math.huge or sum_inc > 1e300 then
            sum_inc = 1e300
        end
        return sum_inc
    end
    return 0
end

-- Initialization of the random "Reach the Stars" condition values
function SDM_0s_Stuff_Funcs.rts_init()
    local valid_nums = {}
    for i = 1, math.min(G.hand and G.hand.config.card_limit or 8, G.hand and G.hand.config.highlighted_limit or 5) do
        valid_nums[#valid_nums+1] = i
    end
    local c1 = pseudorandom_element(valid_nums, pseudoseed('rts'))
    table.remove(valid_nums, c1)
    local c2 = pseudorandom_element(valid_nums, pseudoseed('rts'))
    local num_card1, num_card2 = math.min(c1, c2), math.max(c1, c2)
    return num_card1, num_card2
end

-- Faster way to write non-BP/retrigger check
function SDM_0s_Stuff_Funcs.no_bp_retrigger(context)
    if not context then return false end
    return not (context.blueprint or context.retrigger_joker or context.retrigger_joker_check)
end

-- Overrides

local gfcr = G.FUNCS.can_reroll
function G.FUNCS.can_reroll(e)
	if G.GAME.modifiers.sdm_no_reroll or (G.shop_jokers and G.shop_jokers.config.card_limit == 0) then  -- Roguelike Deck and Crooked Partner + Joker combo
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	else
		return gfcr(e)
	end
end

local gfcfbs = G.FUNCS.check_for_buy_space
G.FUNCS.check_for_buy_space = function(card)
  if card.ability.name == "Wedding Cake" and card.ability.extra and card.ability.extra.amount > 0 then
    return true
  end
  return gfcfbs(card)
end

local gfcsc = G.FUNCS.can_select_card
G.FUNCS.can_select_card = function(e)
  if e.config.ref_table.ability.name == "Wedding Cake" and e.config.ref_table.ability.extra and e.config.ref_table.ability.extra.amount > 0 then
    e.config.colour = G.C.GREEN
    e.config.button = 'use_card'
  else
    gfcsc(e)
  end
end

local cj = Card.calculate_joker
function Card:calculate_joker(context)
    if context.setting_blind and not self.getting_sliced and SDM_0s_Stuff_Funcs.no_bp_retrigger(context) then
        if self.ability and self.ability.sdm_is_ditto then
            G.E_MANAGER:add_event(Event({
                func = function()
                    self:juice_up(0.3, 0.5)
                    self:set_ability(G.P_CENTERS["j_sdm_ditto_joker"], true)
                    self.ability.sdm_is_ditto = nil
                    return true
                end
            }))
            local valid_jokers = {}
            if G.jokers and G.jokers.cards and #G.jokers.cards > 1 then
                for i = 1, #G.jokers.cards do
                    if not G.jokers.cards[i].debuff and G.jokers.cards[i] ~= self and G.jokers.cards[i].config.center.key ~= "j_sdm_ditto_joker" then
                        valid_jokers[#valid_jokers+1] = G.jokers.cards[i]
                    end
                end
            end
            if #valid_jokers > 0 then
                local old_card = self
                local chosen_joker = pseudorandom_element(valid_jokers, pseudoseed('ditto'))
                delay(1)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        self:set_ability(G.P_CENTERS[chosen_joker.config.center.key], true)
                        self:set_cost()
                        for k, v in pairs(chosen_joker.ability) do
                            if type(v) == 'table' then
                                self.ability[k] = copy_table(v)
                            elseif not SMODS.Stickers[k] then
                                self.ability[k] = v
                            end
                        end
                        self.ability.fusion = nil -- FusionJokers compat to remove fuse button
                        self.ability.sdm_is_ditto = true
                        return true
                    end
                }))
                card_eval_status_text(old_card, 'extra', nil, nil, nil, {
                    message = localize('k_ditto_ex'),
                    colour = HEX('f06bf2'),
                })
            end
        end
    end
    return cj(self, context)
end

local cpnr = Card.calculate_partner
function Card:calculate_partner(context)
    if context.partner_end_of_round and SDM_0s_Stuff_Funcs.no_bp_retrigger(context) then
        if (G.GAME and G.GAME.blind.boss) and self.ability and self.ability.sdm_is_partner_ditto and self.ability.sdm_partner_ditto_ante then
            self.ability.sdm_partner_ditto_ante = self.ability.sdm_partner_ditto_ante + 1
            card_eval_status_text(self, 'extra', nil, nil, nil, {
                        message = {self.ability.sdm_partner_ditto_ante .. "/2"},
                        colour = G.C.FILTER
            })
            if self.ability.sdm_partner_ditto_ante >= 2 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        self:juice_up(0.3, 0.5)
                        self:set_ability(G.P_CENTERS["pnr_sdm_ditto_joker"], true)
                        self.ability.sdm_is_ditto = nil
                        return true
                    end
                }))
                local unlocked_partners = {}
                for _, v in pairs(G.P_CENTER_POOLS["Partner"]) do
                    if v.key ~= 'pnr_sdm_ditto_joker' and v.key ~= self.config.center.key and v:is_unlocked() then
                        unlocked_partners[#unlocked_partners+1] = v
                    end
                end
                if unlocked_partners[1] then
                    local old_card = self
                    local chosen_partner = pseudorandom_element(unlocked_partners, pseudoseed('dtp'))
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            self:set_ability(G.P_CENTERS[chosen_partner.key])
                            self.ability.sdm_is_partner_ditto = true
                            self.ability.sdm_partner_ditto_ante = 2
                        return true
                    end}))
                    card_eval_status_text(old_card, 'extra', nil, nil, nil, {
                        message = localize('k_ditto_ex'),
                        colour = HEX('f06bf2'),
                    })
                end
            end
        end
    end
    return cpnr(self, context)
end

local co = Card.open
function Card:open()
    co(self)
    if self.config and self.config.center and self.config.center.kind and self.config.center.kind == "Bakery" then
        G.E_MANAGER:add_event(Event({
            func = function()
                play_sound('sdm_bakery_doorbell')
            return true
        end}))
    end
end

--- Talisman compat
to_big = to_big or function(num)
    return num
end

to_number = to_number or function(num)
    return num
end