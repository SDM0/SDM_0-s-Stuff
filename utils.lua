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

-- Faster way to decrease food/bakery consumables remaining counter
function decrease_remaining_food(G, card)
    if card.ability.set == "Bakery" and G.GAME.used_vouchers.v_sdm_bakery_acclimator then return end
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
function get_scry_info(card, is_compact)
    if card.ability.name == 'Stone Card' then return (is_compact and "SC") or "Stone Card" end
    local rank = (is_compact and SMODS.Ranks[card.base.value].card_key) or SMODS.Ranks[card.base.value].key
    if rank == "T" then rank = "10" end
    local suit = (is_compact and SMODS.Suits[card.base.suit].card_key) or SMODS.Suits[card.base.suit].key
    return (is_compact and rank .. suit) or rank .. " of " .. suit
end

-- Get n cards from SDM_0's Stuff
function get_random_sdm_modded_card(prefix, n)
    if G.GAME then
        local modded_elem = {}
        local random_elem = {}

        for k, v in pairs(SDM_0s_Stuff_Mod.modded_objects) do
            if string.sub(k, 1, #prefix) == prefix then
                if string.sub(prefix, 1, 2) == "j_" then
                    if k ~= "j_sdm_archibald" and k ~= "j_sdm_0" and k ~= "j_sdm_trance_the_devil" then
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

-- Initialization of the random "Reach the Stars" condition values
function rts_init()
    local valid_nums = {1, 2, 3, 4, 5}
    local c1 = pseudorandom_element(valid_nums, pseudoseed('rts'))
    table.remove(valid_nums, c1)
    local c2 = pseudorandom_element(valid_nums, pseudoseed('rts'))
    local num_card1 = (c1 > c2 and c2) or c1
    local num_card2 = (c1 > c2 and c1) or c2
    return num_card1, num_card2
end

-- Faster way to write non-BP/retrigger check
function no_bp_retrigger(context)
    if not context then return false end
    return not (context.blueprint or context.retrigger_joker)
end

--- "Crooked Joker" failsafe
local atd = Card.add_to_deck
function Card:add_to_deck2(debuff)
    self.not_crooked = true
    return atd(self, debuff)
end

--- Talisman compat
to_big = to_big or function(num)
    return num
end