--- Get the max occurence of a card in a hand
function count_max_occurence(table)
    local max_card = 0
    local counts = {}
    for _, value in ipairs(table) do
        counts[value] = (counts[value] or 0) + 1
    end

    for _, v in pairs(counts) do
        if v > max_card then
            max_card = v
        end
    end
    return max_card
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

--- Check if Ouija effect can trigger
function ouija_check(card, context)
    if card.ability.extra.remaining < card.ability.extra.rounds then
        card_eval_status_text(card, 'extra', nil, nil, nil, {
            message = card.ability.extra.remaining ..'/'.. card.ability.extra.rounds,
            colour = G.C.FILTER
        })
    else
        G.E_MANAGER:add_event(Event({
            func = (function()
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = localize('k_active_ex'),
                    colour = G.C.FILTER
                })
                G.E_MANAGER:add_event(Event({
                    func = function() 
                        local eval = function(card) return not card.REMOVED end
                        juice_card_until(card, eval, true)
                        return true
                    end}))
            return true
        end)}))
    end
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

--- Get the rank and suit of a card
function get_scry_info(card)
    if card.ability.name == 'Stone Card' then return "Stone Card" end
    local rank = card.base.value
    local suit = card.base.suit
    local new_suit = string.match(suit, "_(.*)")
    if new_suit then
        new_suit = string.upper(string.sub(new_suit, 1, 1)) .. string.sub(new_suit, 2)
        return rank .. " of " .. new_suit
    end
    return rank .. " of " .. suit
end

-- Get n cards from SDM_0's Stuff
function get_random_sdm_modded_card(prefix, n)
    if G.GAME then
        local modded_elem = {}
        local random_elem = {}

        for k, v in pairs(SDM_0s_Stuff_Mod.modded_objects) do
            if string.sub(k, 1, #prefix) == prefix then
                if string.sub(prefix, 1, 2) == "j_" then
                    if k ~= "j_sdm_archibald" and k ~= "j_sdm_sdm_0" then
                        table.insert(modded_elem, k)
                    end
                else
                    table.insert(modded_elem, k)
                end
            end
        end

        if modded_elem and #modded_elem >= n then
            while n > 0 do
                local r_num = pseudorandom("deck_create", 1, #modded_elem)
                local r_elem = modded_elem[r_num]
                table.insert(random_elem, r_elem)
                table.remove(modded_elem, r_num)
                n = n - 1
            end
            return random_elem
        end
    return nil
    end
end

--- Creates the most played hand planet card
--[[
function create_most_played_planet(card, context, ignore_limit)
    if ignore_limit or (#G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit) then
        G.GAME.consumeable_buffer = (ignore_limit and 0) or G.GAME.consumeable_buffer + 1
        G.E_MANAGER:add_event(Event({
            trigger = 'before',
            delay = 0.0,
            func = (function()
                local _planet, _hand, _tally = nil, nil, 0
                for k, v in ipairs(G.handlist) do
                    if G.GAME.hands[v].visible and G.GAME.hands[v].played > _tally then
                        _hand = v
                        _tally = G.GAME.hands[v].played
                    end
                end
                if _hand then
                    for k, v in pairs(G.P_CENTER_POOLS.Planet) do
                        if v.config.hand_type == _hand then
                            _planet = v.key
                        end
                    end
                end
                _card = create_card("Planet", G.pack_cards, nil, nil, true, true, _planet, 'pl1')
                _card:add_to_deck()
                G.consumeables:emplace(_card)
                G.GAME.consumeable_buffer = 0
                return true
            end)}))
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet})
    end
end
]]--

--- Get the sum of (almost) all existing numbers
function sum_incremental(n)
    if G.jokers then
        return ((G.GAME.current_round.discards_left + G.GAME.current_round.hands_left + #G.jokers.cards + G.jokers.config.card_limit + G.GAME.round
        + G.GAME.round_resets.blind_ante + G.hand.config.card_limit + #G.deck.cards + #G.playing_cards + G.consumeables.config.card_limit +
        #G.consumeables.cards + G.GAME.dollars + G.GAME.win_ante) * n) or 0
    end
    return 0
end

-- Get the amount of redeemed voucher in the game
function redeemed_voucher_count()
    if G.GAME and G.GAME.used_vouchers then
        local used_voucher = 0
        for k, _ in pairs(G.GAME.used_vouchers) do
            used_voucher = used_voucher + 1
        end
        if used_voucher > 0 then
            return used_voucher
        end
    end
    return 0
end

--- Second "add_to_deck" to prevent context.sdm_adding_card to loop ---
function Card:add_to_deck2(from_debuff)
    local obj = self.config.center
    if obj and obj.add_to_deck and type(obj.add_to_deck) == 'function' then
	    obj:add_to_deck(self, from_debuff)
    end
    if not self.config.center.discovered then
        discover_card(self.config.center)
    end
    if not self.added_to_deck then
        self.added_to_deck = true
        if self.ability.set == 'Enhanced' or self.ability.set == 'Default' then 
            if self.ability.name == 'Gold Card' and self.seal == 'Gold' and self.playing_card then 
                check_for_unlock({type = 'double_gold'})
            end
            return 
        end

        if self.edition then
            if not G.P_CENTERS['e_'..(self.edition.type)].discovered then 
                discover_card(G.P_CENTERS['e_'..(self.edition.type)])
            end
        else
            if not G.P_CENTERS['e_base'].discovered then 
                discover_card(G.P_CENTERS['e_base'])
            end
        end
        if self.ability.h_size ~= 0 then
            G.hand:change_size(self.ability.h_size)
        end
        if self.ability.d_size > 0 then
            G.GAME.round_resets.discards = G.GAME.round_resets.discards + self.ability.d_size
            ease_discard(self.ability.d_size)
        end
        if self.ability.name == 'Credit Card' then
            G.GAME.bankrupt_at = G.GAME.bankrupt_at - self.ability.extra
        end
        if self.ability.name == 'Chicot' and G.GAME.blind and G.GAME.blind.boss and not G.GAME.blind.disabled then
            G.GAME.blind:disable()
            play_sound('timpani')
            card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize('ph_boss_disabled')})
        end
        if self.ability.name == 'Chaos the Clown' then
            G.GAME.current_round.free_rerolls = G.GAME.current_round.free_rerolls + 1
            calculate_reroll_cost(true)
        end
        if self.ability.name == 'Turtle Bean' then
            G.hand:change_size(self.ability.extra.h_size)
        end
        if self.ability.name == 'Oops! All 6s' then
            for k, v in pairs(G.GAME.probabilities) do 
                G.GAME.probabilities[k] = v*2
            end
        end
        if self.ability.name == 'To the Moon' then
            G.GAME.interest_amount = G.GAME.interest_amount + self.ability.extra
        end
        if self.ability.name == 'Astronomer' then 
            G.E_MANAGER:add_event(Event({func = function()
                for k, v in pairs(G.I.CARD) do
                    if v.set_cost then v:set_cost() end
                end
                return true
            end }))
        end
        if self.ability.name == 'Troubadour' then
            G.hand:change_size(self.ability.extra.h_size)
            G.GAME.round_resets.hands = G.GAME.round_resets.hands + self.ability.extra.h_plays
        end
        if self.ability.name == 'Stuntman' then
            G.hand:change_size(-self.ability.extra.h_size)
        end
        if self.edition and self.edition.negative then 
            if from_debuff then 
                self.ability.queue_negative_removal = nil
            else
                if self.ability.consumeable then
                    G.consumeables.config.card_limit = G.consumeables.config.card_limit + 1
                else
                    G.jokers.config.card_limit = G.jokers.config.card_limit + 1
                end
            end
        end
        if G.GAME.blind then G.E_MANAGER:add_event(Event({ func = function() G.GAME.blind:set_blind(nil, true, nil); return true end })) end
    end
end

--- Second "add_joker" to prevent some behaviors
function add_joker2(joker, edition, silent, eternal)
    local _area = G.P_CENTERS[joker].consumeable and G.consumeables or G.jokers
    local _T = _area and _area.T or {x = G.ROOM.T.w/2 - G.CARD_W/2, y = G.ROOM.T.h/2 - G.CARD_H/2}
    local card = Card(_T.x, _T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, G.P_CENTERS[joker],{discover = true, bypass_discovery_center = true, bypass_discovery_ui = true, bypass_back = G.GAME.selected_back.pos })
    card:start_materialize(nil, silent)
    if _area then card:add_to_deck2() end
    if edition then card:set_edition{[edition] = true} end
    if eternal then card:set_eternal(true) end
    if _area and card.ability.set == 'Joker' then _area:emplace(card)
    elseif G.consumeables then G.consumeables:emplace(card) end
    card.created_on_pause = nil
    return card
end

return