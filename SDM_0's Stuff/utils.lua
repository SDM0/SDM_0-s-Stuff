local parameters = NFS.load(SMODS.current_mod.path.."config.lua")()
local config = parameters.config

--- Get the amount of time a consumable has been used
function get_count(card)
    if G.GAME.consumeable_usage[card] and G.GAME.consumeable_usage[card].count then
        return G.GAME.consumeable_usage[card].count
    else
        return 0
    end
end

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

-- Get n jokers from SDM_0's Stuff
function get_random_sdm_modded_jokers(n, no_legend)
    local modded_jokers = {}
    local random_jokers = {}

    for k,v in pairs(config) do
        if v and string.sub(k, 1, 1) == "j" then
            if no_legend and k ~= "j_sdm_archibald" then
                table.insert(modded_jokers, k)
            end
        end
    end

    if modded_jokers and #modded_jokers >= n then
        while n > 0 do
            if G.GAME then
                r_joker = modded_jokers[pseudorandom("deck_create", 1, #modded_jokers)]
            end
            table.insert(random_jokers, r_joker)
            for i = 1, #modded_jokers do
                if modded_jokers[i] == r_joker then
                    table.remove(modded_jokers, i)
                end
            end
            n = n - 1
        end
        return random_jokers
    else
        return nil
    end
end

--- Custom eval func
function eval_this(_card, effects)
    if effects then
        local extras = {mult = false, hand_chips = false}
        if effects.mult_mod then mult = mod_mult(mult + effects.mult_mod);extras.mult = true end
        if effects.chip_mod then hand_chips = mod_chips(hand_chips + effects.chip_mod);extras.hand_chips = true end
        if effects.Xmult_mod then mult = mod_mult(mult*effects.Xmult_mod);extras.mult = true  end
        update_hand_text({delay = 0}, {chips = extras.hand_chips and hand_chips, mult = extras.mult and mult})
        if effects.message then
            card_eval_status_text(_card, 'jokers', nil, nil, nil, effects)
        end
    end
end

--- Creates the most played hand planet card
--[[
function create_most_played_planet(card, context)
    if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
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
    return ((G.GAME.current_round.discards_left + G.GAME.current_round.hands_left + #G.jokers.cards + G.jokers.config.card_limit + G.GAME.round
    + G.GAME.round_resets.blind_ante + G.hand.config.card_limit + #G.deck.cards + #G.playing_cards + G.consumeables.config.card_limit +
    #G.consumeables.cards + G.GAME.dollars + G.GAME.win_ante) * n) or 0
end

--- Second "add_to_deck" to prevent context.sdm_adding_card to loop ---
function Card:add_to_deck2(from_debuff)
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