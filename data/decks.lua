SMODS.Atlas{
    key = "sdm_enhancers",
    path = "sdm_enhancers.png",
    px = 71,
    py = 95
}

--- SDM_0's Deck

if sdm_config.sdm_jokers then
    SMODS.Back{
        key = "sdm_0_s",
        pos = {x = 0, y = 0},
        config = {extra = 2},
        loc_vars = function(self)
            return {vars = {self.config.extra}}
        end,
        apply = function(self)
            G.E_MANAGER:add_event(Event({
                func = function()
                    rand_jokers = get_random_sdm_modded_card("j_sdm", self.config.extra)
                    for i = 1, #rand_jokers do
                        add_joker2(rand_jokers[i], nil, true, true)
                    end
                    return true
                end
            }))
        end,
        atlas = "sdm_enhancers"
    }
end

--- Bazaar Deck

if sdm_config.sdm_consus then
    SMODS.Back{
        key = "bazaar",
        pos = {x = 1, y = 0},
        config = {extra = 2},
        loc_vars = function(self)
            return {vars = {self.config.extra}}
        end,
        apply = function(back)
            G.E_MANAGER:add_event(Event({
                func = function()
                    rand_cons = get_random_sdm_modded_card("c_", self.config.extra)
                    for i = 1, #rand_cons do
                        local card = create_card('Tarot' or 'Spectral', G.consumeables, nil, nil, nil, nil, rand_cons[i], 'bzr')
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                    end
                    return true
                end
            }))
        end,
        atlas = "sdm_enhancers"
    }
end

--- Sandbox Deck

SMODS.Back{
    key = "sandbox",
    pos = {x = 2, y = 0},
    config = {joker_slot = 2, extra_ante = 2},
    loc_vars = function(self)
        return {vars = {self.config.joker_slot, self.config.extra_ante}}
    end,
    apply = function(self)
        G.GAME.starting_params.joker_slots = G.GAME.starting_params.joker_slots + self.config.joker_slot
        G.GAME.win_ante = G.GAME.win_ante + self.config.extra_ante
    end,
    atlas = "sdm_enhancers"
}

--- Lucky 7 Deck

if sdm_config.sdm_jokers then
    SMODS.Back{
        key = "lucky_7",
        pos = {x = 3, y = 0},
        apply = function(self)
            G.E_MANAGER:add_event(Event({
                func = function()
                    for i = #G.playing_cards, 1, -1 do
                        if G.playing_cards[i].base.id == 7 then
                            G.playing_cards[i]:set_ability(G.P_CENTERS.m_lucky)
                        end
                    end
                    add_joker("j_sdm_lucky_joker", nil, true, true)
                    return true
                end
            }))
        end,
        atlas = "sdm_enhancers"
    }
end

--- DNA Deck

SMODS.Back{
    key = "dna",
    pos = {x = 1, y = 1},
    trigger_effect = function(self, args)
        if args.context == "final_scoring_step" then
            if G.GAME.chips + args.chips * args.mult > G.GAME.blind.chips and (G.play and G.play.cards) then
                G.E_MANAGER:add_event(Event({func = function()
                    G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                    local chosen_card = pseudorandom_element(G.play.cards, pseudoseed('dna_deck'))
                    if chosen_card then
                        local _card = copy_card(chosen_card, nil, nil, G.playing_card)
                        _card:add_to_deck()
                        G.deck.config.card_limit = G.deck.config.card_limit + 1
                        table.insert(G.playing_cards, _card)
                        G.hand:emplace(_card)
                        _card.states.visible = nil
                        _card:start_materialize()
                        playing_card_joker_effects({true})
                    end
                    return true
                end}))
            end
        end
    end,
    atlas = "sdm_enhancers"
}

--- Hieroglyph Deck

SMODS.Back{
    key = "hieroglyph",
    pos = {x = 2, y = 1},
    config = {spectral_rate = 2, consumables = {'c_ankh'}},
    atlas = "sdm_enhancers"
}

--- XXL Deck

SMODS.Back{
    key = "xxl",
    pos = {x = 3, y = 1},
    apply = function()
        local extra_cards = {}
        for k, _ in pairs(G.P_CARDS) do
            if string.sub(k,1,4) ~= 'bunc' and string.sub(k,1,4) ~= 'cere' then -- Avoid giving exotic cards from other mods
                local s, r = k:match("^(.*)_(.-)$")
                extra_cards[#extra_cards + 1] = {s = s, r = r}
            end
        end
        G.GAME.starting_params.extra_cards = extra_cards
    end,
    atlas = "sdm_enhancers"
}

--- Hoarder Deck

SMODS.Back{
    key = "hoarder",
    pos = {x = 0, y = 2},
    config = {extra_discard_bonus = 3, no_interest = true},
    loc_vars = function(self)
        return {vars = {self.config.extra_discard_bonus}}
    end,
    apply = function()
        G.GAME.modifiers.no_extra_hand_money = true
    end,
    atlas = "sdm_enhancers"
}

--- Deck Of Stuff

SMODS.Back{
    key = "deck_of_stuff",
    pos = {x = 0, y = 1},
    config = {spectral_rate = 2, consumables = {'c_ankh'}, joker_slot = 2, extra_discard_bonus = 3, no_interest = true},
    apply = function()
        local extra_cards = {}
        for k, _ in pairs(G.P_CARDS) do
            if string.sub(k,1,4) ~= 'bunc' and string.sub(k,1,4) ~= 'cere' then -- Avoid giving exotic cards from other mods
                local s, r = k:match("^(.*)_(.-)$")
                extra_cards[#extra_cards + 1] = {s = s, r = r}
            end
        end
        G.GAME.starting_params.extra_cards = extra_cards
        G.GAME.win_ante = 10
        G.GAME.modifiers.no_extra_hand_money = true
        G.E_MANAGER:add_event(Event({
            func = function()
                if sdm_config.sdm_jokers then
                    for i = #G.playing_cards, 1, -1 do
                        if G.playing_cards[i].base.id == 7 then
                            G.playing_cards[i]:set_ability(G.P_CENTERS.m_lucky)
                        end
                    end
                    add_joker2("j_sdm_lucky_joker", nil, true, true)
                    rand_jokers = get_random_sdm_modded_card("j_sdm", 2)
                    for i = 1, #rand_jokers do
                        add_joker2(rand_jokers[i], nil, true, true)
                    end
                end
                if sdm_config.sdm_consus then
                    rand_cons = get_random_sdm_modded_card("c_", 2)
                    for i = 1, #rand_cons do
                        local card = create_card('Tarot' or 'Spectral', G.consumeables, nil, nil, nil, nil, rand_cons[i], 'bzr')
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                    end
                end
                return true
            end
        }))
    end,
    trigger_effect = function(self, args)
        if args.context == "final_scoring_step" then
            if G.GAME.chips + args.chips * args.mult > G.GAME.blind.chips and (G.play and G.play.cards) then
                G.E_MANAGER:add_event(Event({func = function()
                    G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                    local chosen_card = pseudorandom_element(G.play.cards, pseudoseed('dos_deck'))
                    if chosen_card then
                        local _card = copy_card(chosen_card, nil, nil, G.playing_card)
                        _card:add_to_deck()
                        G.deck.config.card_limit = G.deck.config.card_limit + 1
                        table.insert(G.playing_cards, _card)
                        G.hand:emplace(_card)
                        _card.states.visible = nil
                        _card:start_materialize()
                        playing_card_joker_effects({true})
                    end
                    return true
                end}))
            end
        end
    end,
    atlas = "sdm_enhancers"
}

return