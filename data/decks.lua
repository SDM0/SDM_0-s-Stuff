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
        calculate = function(self, back, context)
            if context.context == 'eval' and G.GAME.last_blind and G.GAME.last_blind.boss then
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('timpani')
                            SMODS.add_card({set = "SDM_0s_consus", area = G.consumeables, key_append = 'bzr'})
                            G.GAME.consumeable_buffer = 0
                            return true
                        end
                    }))
                end
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
                for k, v in pairs(G.GAME.probabilities) do
                    G.GAME.probabilities[k] = v*2
                end
                return true
            end
        }))
    end,
    atlas = "sdm_enhancers"
}

--- DNA Deck

SMODS.Back{
    key = "dna",
    pos = {x = 1, y = 1},
    calculate = function(self, back, context)
        if context.context == "final_scoring_step" then
            if G.GAME.chips + context.chips * context.mult > G.GAME.blind.chips and (G.play and G.play.cards) then
                G.E_MANAGER:add_event(Event({func = function()
                    G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                    local card_to_copy = G.play.cards[#G.play.cards]
                    if card_to_copy then
                        local _card = copy_card(card_to_copy, nil, nil, G.playing_card)
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
        G.E_MANAGER:add_event(Event({
            func = function()
                local cards_to_copy = {}
                for k, v in ipairs(G.deck.cards) do
                    cards_to_copy[#cards_to_copy+1] = v
                end
                for k, v in ipairs(cards_to_copy) do
                    G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                    local _card = copy_card(v)
                    _card:add_to_deck()
                    G.deck.config.card_limit = G.deck.config.card_limit + 1
                    table.insert(G.playing_cards, _card)
                    G.deck:emplace(_card)
                end
                G.GAME.starting_deck_size = #G.playing_cards
            return true
        end}))
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
        or ((G.GAME.selected_sleeve and G.GAME.selected_sleeve == "sleeve_cry_antimatter_sleeve")
        or (G.GAME.viewed_sleeve and G.GAME.viewed_sleeve == "sleeve_cry_antimatter_sleeve")) then
            for _, v in pairs(G.P_CENTER_POOLS["Joker"]) do
                if not v.original_key or (v.class_prefix..'_'..v.original_key == v.key) and (not Tsunami or (Tsunami and v.key ~= "j_splash")) then
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
        if context.retrigger_joker_check and not context.retrigger_joker then
            if SDM_0s_Stuff_Config.retrigger_on_deck then
                return {
                    repetitions = self.config.retrigger,
                    message = localize('k_again_ex'),
                }
            else
                return {
                    repetitions = self.config.retrigger,
                    remove_default_message = true,
                    func = function()
                        card_eval_status_text(context.other_card, 'extra', nil, nil, nil, {
                            message = localize('k_again_ex'),
                        })
                    end
                }
            end
        end
    end,
    atlas = "sdm_enhancers"
}

--- Roguelike Deck

SMODS.Back{
    key = "roguelike",
    pos = {x = 0, y = 3},
    config = {booster_slot = 1, vouchers = {"v_overstock_norm"}},
    loc_vars = function(self)
        return {vars = {localize{type = 'name_text', key = 'v_overstock_norm', set = 'Voucher'}, self.config.booster_slot}}
    end,
    apply = function(self)
        G.GAME.modifiers.sdm_no_reroll = true   -- No reroll effect in utils.lua overrides
        SMODS.change_booster_limit(self.config.booster_slot)
    end,
    atlas = "sdm_enhancers"
}

--- Baker's Deck

if SDM_0s_Stuff_Config.sdm_bakery then

    SMODS.Back{
        key = "bakers",
        pos = {x = 2, y = 2},
        config = {voucher = 'v_sdm_bakery_stall', consumable_slot = 1},
        loc_vars = function(self)
            return {vars = {localize{type = 'name_text', key = 'v_sdm_bakery_stall', set = 'Voucher'}, self.config.consumable_slot}}
        end,
        atlas = "sdm_enhancers"
    }

end

--- Deck Of Dreams

SMODS.Back{
    key = "deck_of_dreams",
    pos = {x = 1, y = 3},
    config = {spectral_rate = 2, consumables = {'c_ankh'}, extra_discard_bonus = 3, vouchers = {(SDM_0s_Stuff_Config.sdm_bakery and "v_sdm_bakery_stall") or nil, "v_overstock_norm"}, joker_slot = 2, consumable_slot = 1, retrigger = 1, booster_slot = 1},
    apply = function(self)
        SMODS.change_booster_limit(self.config.booster_slot)
        G.E_MANAGER:add_event(Event({
            func = function()
                for i = #G.playing_cards, 1, -1 do
                    if G.playing_cards[i].base.id == 7 then
                        G.playing_cards[i]:set_ability(G.P_CENTERS.m_lucky)
                    end
                end
                for k, v in pairs(G.GAME.probabilities) do
                    G.GAME.probabilities[k] = v*2
                end
                return true
            end
        }))
    end,
    calculate = function(self, back, context)
        if context.context == 'eval' and G.GAME.last_blind and G.GAME.last_blind.boss and SDM_0s_Stuff_Config.sdm_consus then
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('timpani')
                        SMODS.add_card({set = "SDM_0s_consus", area = G.consumeables, key_append = 'dod'})
                        G.GAME.consumeable_buffer = 0
                        return true
                    end
                }))
            end
        end
        if context.retrigger_joker_check and not context.retrigger_joker then
            if SDM_0s_Stuff_Config.retrigger_on_deck then
                return {
                    repetitions = self.config.retrigger,
                    message = localize('k_again_ex'),
                }
            else
                return {
                    repetitions = self.config.retrigger,
                    remove_default_message = true,
                    func = function()
                        card_eval_status_text(context.other_card, 'extra', nil, nil, nil, {
                            message = localize('k_again_ex'),
                        })
                    end
                }
            end
        end
    end,
    atlas = "sdm_enhancers"
}

--- Deck Of Nightmares

SMODS.Back{
    key = "deck_of_nightmares",
    pos = {x = 2, y = 3},
    config = {no_interest = true, joker_slot = -2},
    apply = function(self)
        -- SDM_0's Deck and Modder's Deck effect in "lovely.toml"
        if Cryptid and ((G.GAME.selected_sleeve and G.GAME.selected_sleeve == "sleeve_cry_equilibrium_sleeve")
        or (G.GAME.viewed_sleeve and G.GAME.viewed_sleeve == "sleeve_cry_equilibrium_sleeve"))
        or ((G.GAME.selected_sleeve and G.GAME.selected_sleeve == "sleeve_cry_antimatter_sleeve")
        or (G.GAME.viewed_sleeve and G.GAME.viewed_sleeve == "sleeve_cry_antimatter_sleeve")) then
            for _, v in pairs(G.P_CENTER_POOLS["Joker"]) do
                if not v.original_key or (v.class_prefix..'_'..v.original_key == v.key) then
                    v.no_doe = true
                end
            end
        end
        G.GAME.win_ante = 10
        G.GAME.modifiers.no_extra_hand_money = true
        G.GAME.modifiers.sdm_no_reroll = true   -- No reroll effect in utils.lua overrides
        G.E_MANAGER:add_event(Event({
            func = function()
                local cards_to_copy = {}
                for k, v in ipairs(G.deck.cards) do
                    cards_to_copy[#cards_to_copy+1] = v
                end
                for k, v in ipairs(cards_to_copy) do
                    G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                    local _card = copy_card(v)
                    _card:add_to_deck()
                    G.deck.config.card_limit = G.deck.config.card_limit + 1
                    table.insert(G.playing_cards, _card)
                    G.deck:emplace(_card)
                end
                G.GAME.starting_deck_size = #G.playing_cards
            return true
        end}))
    end,
    calculate = function(self, back, context)
        if context.context == "final_scoring_step" then
            if G.GAME.chips + context.chips * context.mult > G.GAME.blind.chips and (G.play and G.play.cards) then
                G.E_MANAGER:add_event(Event({func = function()
                    G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                    local card_to_copy = G.play.cards[#G.play.cards]
                    if card_to_copy then
                        local _card = copy_card(card_to_copy, nil, nil, G.playing_card)
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

--- Deck Of Stuff

SMODS.Back{
    key = "deck_of_stuff",
    pos = {x = 0, y = 1},
    config = {spectral_rate = 2, consumables = {'c_ankh'}, extra_discard_bonus = 3, no_interest = true, vouchers = {(SDM_0s_Stuff_Config.sdm_bakery and "v_sdm_bakery_stall") or nil, "v_overstock_norm"}, consumable_slot = 1, retrigger = 1, booster_slot = 1},
    apply = function(self)
        -- SDM_0's Deck and Modder's Deck effect in "lovely.toml"
        if Cryptid and ((G.GAME.selected_sleeve and G.GAME.selected_sleeve == "sleeve_cry_equilibrium_sleeve")
        or (G.GAME.viewed_sleeve and G.GAME.viewed_sleeve == "sleeve_cry_equilibrium_sleeve"))
        or ((G.GAME.selected_sleeve and G.GAME.selected_sleeve == "sleeve_cry_antimatter_sleeve")
        or (G.GAME.viewed_sleeve and G.GAME.viewed_sleeve == "sleeve_cry_antimatter_sleeve")) then
            for _, v in pairs(G.P_CENTER_POOLS["Joker"]) do
                if not v.original_key or (v.class_prefix..'_'..v.original_key == v.key) then
                    v.no_doe = true
                end
            end
        end
        G.GAME.win_ante = 10
        G.GAME.modifiers.no_extra_hand_money = true
        G.GAME.modifiers.sdm_no_reroll = true   -- No reroll effect in utils.lua overrides
        SMODS.change_booster_limit(self.config.booster_slot)
        G.E_MANAGER:add_event(Event({
            func = function()
                for i = #G.playing_cards, 1, -1 do
                    if G.playing_cards[i].base.id == 7 then
                        G.playing_cards[i]:set_ability(G.P_CENTERS.m_lucky)
                    end
                end
                for k, v in pairs(G.GAME.probabilities) do
                    G.GAME.probabilities[k] = v*2
                end
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            func = function()
                local cards_to_copy = {}
                for k, v in ipairs(G.deck.cards) do
                    cards_to_copy[#cards_to_copy+1] = v
                end
                for k, v in ipairs(cards_to_copy) do
                    G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                    local _card = copy_card(v)
                    _card:add_to_deck()
                    G.deck.config.card_limit = G.deck.config.card_limit + 1
                    table.insert(G.playing_cards, _card)
                    G.deck:emplace(_card)
                end
                G.GAME.starting_deck_size = #G.playing_cards
            return true
        end}))
    end,
    calculate = function(self, back, context)
        if context.context == 'eval' and G.GAME.last_blind and G.GAME.last_blind.boss and SDM_0s_Stuff_Config.sdm_consus then
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('timpani')
                        SMODS.add_card({set = "SDM_0s_consus", area = G.consumeables, key_append = 'dos'})
                        G.GAME.consumeable_buffer = 0
                        return true
                    end
                }))
            end
        elseif context.context == "final_scoring_step" then
            if G.GAME.chips + context.chips * context.mult > G.GAME.blind.chips and (G.play and G.play.cards) then
                G.E_MANAGER:add_event(Event({func = function()
                    G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                    local card_to_copy = G.play.cards[#G.play.cards]
                    if card_to_copy then
                        local _card = copy_card(card_to_copy, nil, nil, G.playing_card)
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
        if context.retrigger_joker_check and not context.retrigger_joker then
            if SDM_0s_Stuff_Config.retrigger_on_deck then
                return {
                    repetitions = self.config.retrigger,
                    message = localize('k_again_ex'),
                }
            else
                return {
                    repetitions = self.config.retrigger,
                    remove_default_message = true,
                    func = function()
                        card_eval_status_text(context.other_card, 'extra', nil, nil, nil, {
                            message = localize('k_again_ex'),
                        })
                    end
                }
            end
        end
    end,
    atlas = "sdm_enhancers"
}