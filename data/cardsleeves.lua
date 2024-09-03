SMODS.Atlas{
    key = "sdm_sleeves",
    path = "sdm_sleeves.png",
    px = 71,
    py = 95
}

--- SDM_0's Sleeve

if sdm_config.sdm_jokers then
    CardSleeves.Sleeve {
        key = "sdm_0_s",
        atlas = "sdm_sleeves",
        pos = { x = 0, y = 0 },
        config = {extra = 2},
        loc_vars = function(self)
            return {vars = {self.config.extra}}
        end,
        unlocked = true,
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
    }
end

--- Bazaar Sleeve

if sdm_config.sdm_consus then
    CardSleeves.Sleeve {
        key = "bazaar",
        atlas = "sdm_sleeves",
        pos = { x = 1, y = 0 },
        config = {extra = 2},
        loc_vars = function(self)
            return {vars = {self.config.extra}}
        end,
        unlocked = true,
        apply = function(self)
            G.E_MANAGER:add_event(Event({
                func = function()
                    rand_cons = get_random_sdm_modded_card("c_", self.config.extra)
                    for i = 1, #rand_cons do
                        local card = create_card('Tarot' or 'Spectral', G.consumeables, nil, nil, nil, nil, "c_sdm_" .. rand_cons[i], 'bzr')
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                    end
                    return true
                end
            }))
        end,
    }
end

--- Sandbox Sleeve

CardSleeves.Sleeve {
    key = "sandbox",
    atlas = "sdm_sleeves",
    pos = { x = 2, y = 0 },
    config = {joker_slot = 2, extra_ante = 2},
    loc_vars = function(self)
        return {vars = {self.config.joker_slot, self.config.extra_ante}}
    end,
    unlocked = true,
    apply = function(self)
        G.GAME.starting_params.joker_slots = G.GAME.starting_params.joker_slots + self.config.joker_slot
        G.GAME.win_ante = G.GAME.win_ante + self.config.extra_ante
    end,
}

--- Lucky 7 Sleeve

if sdm_config.sdm_jokers then
    CardSleeves.Sleeve {
        key = "lucky_7",
        atlas = "sdm_sleeves",
        pos = { x = 3, y = 0 },
        unlocked = true,
        loc_vars = function(self)
            if self.get_current_deck_name() == "b_sdm_lucky_7" then
                return {key = self.key .. '_alt', vars = {}}
            end
        end,
        apply = function(self)
            G.E_MANAGER:add_event(Event({
                func = function()
                    for i = #G.playing_cards, 1, -1 do
                        if G.playing_cards[i].base.id == 7 then
                            G.playing_cards[i]:set_ability(G.P_CENTERS.m_lucky)
                        end
                    end
                    if self.get_current_deck_name() ~= "b_sdm_lucky_7" then
                        add_joker("j_sdm_lucky_joker", nil, true, true)
                    else
                        if G.jokers.cards and #G.jokers.cards > 0 then
                            G.jokers.cards[1]:set_edition({["negative"] = true}, true, true)
                        end
                        for k, v in pairs(G.GAME.probabilities) do 
                            G.GAME.probabilities[k] = v*2
                        end
                    end
                    return true
                end
            }))
        end,
    }
end

--- DNA Sleeve

CardSleeves.Sleeve {
    key = "dna",
    atlas = "sdm_sleeves",
    pos = { x = 4, y = 0 },
    unlocked = true,
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
}

--- Hieroglyph Sleeve

CardSleeves.Sleeve {
    key = "hieroglyph",
    atlas = "sdm_sleeves",
    pos = { x = 0, y = 1 },
    unlocked = true,
    loc_vars = function(self)
        local key
        local vars = {}
        if self.get_current_deck_name() == "Ghost Deck" then
            key = self.key .. "_ghost"
            self.config = { spectral_rate = 4, consumables = { 'c_ankh' } }
            vars[#vars+1] = localize{type = 'name_text', key = self.config.consumables[1], set = 'Tarot'}
        elseif self.get_current_deck_name() == "b_sdm_hieroglyph" then
            key = self.key .. "_alt"
            self.config = { spectral_rate = 4, spectral_more_options = 2 }
            vars[#vars+1] = self.config.spectral_more_options
        else
            key = self.key
            self.config = { spectral_rate = 2, consumables = { 'c_ankh' } }
            vars[#vars+1] = localize{type = 'name_text', key = self.config.consumables[1], set = 'Tarot'}
        end
        return { key = key, vars = vars }
    end,
    trigger_effect = function(self, args)
        local is_spectral_pack = args.context["card"] and args.context.card.ability.set == "Booster" and args.context.card.ability.name:find("Spectral")
        if args.context["create_booster"] and is_spectral_pack and self.config.spectral_more_options then
            args.context.card.ability.extra = args.context.card.ability.extra + self.config.spectral_more_options
        end
    end,
}

--- XXL Sleeve

CardSleeves.Sleeve {
    key = "xxl",
    atlas = "sdm_sleeves",
    pos = { x = 1, y = 1 },
    unlocked = true,
    apply = function(self)
        local extra_cards = {}
        if G.GAME.starting_params.erratic_suits_and_ranks then
            for k, _ in pairs(G.P_CARDS) do
                if string.sub(k,1,4) ~= 'bunc' then -- Avoid giving exotic cards from "Bunco"
                    _, k = pseudorandom_element(G.P_CARDS, pseudoseed('erratic'))
                    local s, r = k:match("^(.*)_(.-)$")
                    extra_cards[#extra_cards+1] = {s = s, r = r}
                end
            end
        else
            for k, _ in pairs(G.P_CARDS) do
                if string.sub(k,1,4) ~= 'bunc' then -- Avoid giving exotic cards from "Bunco"
                    local s, r = k:match("^(.*)_(.-)$")
                    if not (G.GAME.starting_params.no_faces and (r == 'K' or r == 'Q' or r == 'J')) then
                        extra_cards[#extra_cards + 1] = {s = s, r = r}
                        if self.get_current_deck_name() == "b_sdm_xxl" then
                            extra_cards[#extra_cards + 1] = {s = s, r = r}
                        end
                    end
                end
            end
        end
        if G.GAME.starting_params.extra_cards and #G.GAME.starting_params.extra_cards > 0 then
            for _, v in ipairs(extra_cards) do
                G.GAME.starting_params.extra_cards[#G.GAME.starting_params.extra_cards+1] = v
            end
        else
            G.GAME.starting_params.extra_cards = extra_cards
        end
    end,
}

--- Hoarder Sleeve

CardSleeves.Sleeve {
    key = "hoarder",
    atlas = "sdm_sleeves",
    pos = { x = 2, y = 1 },
    config = {extra_discard_bonus = 3, no_interest = true},
    unlocked = true,
    loc_vars = function(self)
        local key
        if self.get_current_deck_name() == "Green Deck" then
            key = self.key .. "_alt"
            self.config = {extra_discard_bonus = 2, no_interest = true}
            return {key = key, vars = {self.config.extra_discard_bonus}}
        end
        return {vars = {self.config.extra_discard_bonus}}
    end,
    apply = function(self)
        if self.get_current_deck_name() ~= "Green Deck" then
            G.GAME.modifiers.no_extra_hand_money = true
        end
    end,
}