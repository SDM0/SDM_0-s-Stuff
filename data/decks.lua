SMODS.Atlas{
    key = "sdm_enhancers",
    path = "sdm_enhancers.png",
    px = 71,
    py = 95
}

--- SDM_0's Deck

if SDM_0s_Stuff_Config.sdm_jokers then
    SMODS.Back{
        key = "sdm_0_s",
        pos = {x = 0, y = 0},
        -- Deck effect in "lovely.toml"
        atlas = "sdm_enhancers"
    }
end

--- Bazaar Deck

if SDM_0s_Stuff_Config.sdm_consus then
    SMODS.Back{
        key = "bazaar",
        pos = {x = 1, y = 0},
        config = {extra = 1},
        loc_vars = function(self)
            return {vars = {self.config.extra}}
        end,
        calculate = function(self, back, context)
            if context.context == 'eval' and G.GAME.last_blind and G.GAME.last_blind.boss then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local rand_cons = get_random_sdm_modded_card("c_", self.config.extra)
                        for i = 1, #rand_cons do
                            play_sound('timpani')
                            local card = create_card('Tarot' or 'Spectral', G.consumeables, nil, nil, nil, nil, rand_cons[i], 'bzr')
                            card:add_to_deck()
                            G.consumeables:emplace(card)
                        end
                        return true
                    end
                }))
            end
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
        G.GAME.win_ante = G.GAME.win_ante + self.config.extra_ante
    end,
    atlas = "sdm_enhancers"
}

--- Lucky 7 Deck

if SDM_0s_Stuff_Config.sdm_jokers then
    SMODS.Back{
        key = "lucky_7",
        pos = {x = 3, y = 0},
        config = {ante_scaling = 1.5},
        loc_vars = function(self)
            return {vars = {self.config.ante_scaling}}
        end,
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
    calculate = function(self, back, context)
        if context.context == "final_scoring_step" then
            if G.GAME.chips + context.chips * context.mult > G.GAME.blind.chips and (G.play and G.play.cards) then
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

--- Modder's Deck

SMODS.Back{
    key = "modders",
    pos = {x = 1, y = 2},
    apply = function()
        -- Vanilla pool changes applied in "lovely.toml"
        if Cryptid and ((G.GAME.selected_sleeve and G.GAME.selected_sleeve == "sleeve_cry_equilibrium_sleeve")
        or (G.GAME.viewed_sleeve and G.GAME.viewed_sleeve == "sleeve_cry_equilibrium_sleeve"))
        or ((G.GAME.selected_sleeve and G.GAME.selected_sleeve == "sleeve_cry_antimatter_sleeve") -- In case Antimatter Sleeve ever gets added to Cryptid
        or (G.GAME.viewed_sleeve and G.GAME.viewed_sleeve == "sleeve_cry_antimatter_sleeve")) then
            for _, v in pairs(G.P_CENTER_POOLS["Joker"]) do
                if not v.original_key or (v.class_prefix..'_'..v.original_key == v.key) then
                    v.no_doe = true
                end
            end
        end
    end,
    atlas = "sdm_enhancers"
}

--- Reverb Deck

SMODS.Back{
    key = "reverb",
    pos = {x = 3, y = 2},
    config = {joker_slot = -2, retrigger = 1},
    loc_vars = function(self)
        return {vars = {self.config.joker_slot, self.config.retrigger}}
    end,
    calculate = function(self, back, context)
        if context.repetition_only or context.retrigger_joker_check then
            return {
                repetitions = self.config.retrigger,
                message = localize('k_again_ex')
            }
        end
    end,
    atlas = "sdm_enhancers"
}

--- Baker's Deck

SMODS.Back{
    key = "bakers",
    pos = {x = 2, y = 2},
    config = {voucher = 'v_sdm_bakery_stall', consumable_slot = 1},
    loc_vars = function(self)
        return {vars = {localize{type = 'name_text', key = 'v_sdm_bakery_stall', set = 'Voucher'}, self.config.consumable_slot}}
    end,
    atlas = "sdm_enhancers"
}

--- Deck Of Stuff

SMODS.Back{
    key = "deck_of_stuff",
    pos = {x = 0, y = 1},
    config = {spectral_rate = 2, consumables = {'c_ankh'}, extra_discard_bonus = 3, no_interest = true, voucher = 'v_sdm_bakery_stall', consumable_slot = 1, retrigger = 1},
    apply = function()
        -- SDM_0's Deck and Modder's Deck effect in "lovely.toml"
        if Cryptid and ((G.GAME.selected_sleeve and G.GAME.selected_sleeve == "sleeve_cry_equilibrium_sleeve")
        or (G.GAME.viewed_sleeve and G.GAME.viewed_sleeve == "sleeve_cry_equilibrium_sleeve"))
        or ((G.GAME.selected_sleeve and G.GAME.selected_sleeve == "sleeve_cry_antimatter_sleeve") -- In case Antimatter Sleeve ever gets added to Cryptid
        or (G.GAME.viewed_sleeve and G.GAME.viewed_sleeve == "sleeve_cry_antimatter_sleeve")) then
            for _, v in pairs(G.P_CENTER_POOLS["Joker"]) do
                if not v.original_key or (v.class_prefix..'_'..v.original_key == v.key) then
                    v.no_doe = true
                end
            end
        end
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
                if SDM_0s_Stuff_Config.sdm_jokers then
                    for i = #G.playing_cards, 1, -1 do
                        if G.playing_cards[i].base.id == 7 then
                            G.playing_cards[i]:set_ability(G.P_CENTERS.m_lucky)
                        end
                    end
                    add_joker("j_sdm_lucky_joker", nil, true, true)
                end
                return true
            end
        }))
    end,
    calculate = function(self, back, context)
        if context.context == 'eval' and G.GAME.last_blind and G.GAME.last_blind.boss then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local rand_cons = get_random_sdm_modded_card("c_", self.config.extra)
                    for i = 1, #rand_cons do
                        play_sound('timpani')
                        local card = create_card('Tarot' or 'Spectral', G.consumeables, nil, nil, nil, nil, rand_cons[i], 'bzr')
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                    end
                    return true
                end
            }))
        elseif context.context == "final_scoring_step" then
            if G.GAME.chips + context.chips * context.mult > G.GAME.blind.chips and (G.play and G.play.cards) then
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
        if context.repetition_only or context.retrigger_joker_check then
            return {
                repetitions = self.config.retrigger,
                message = localize('k_again_ex')
            }
        end
    end,
    atlas = "sdm_enhancers"
}