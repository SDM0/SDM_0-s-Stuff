SMODS.Atlas{
    key = "sdm_sleeves",
    path = "sdm_sleeves.png",
    px = 73,
    py = 95
}

--- SDM_0's Sleeve

if SDM_0s_Stuff_Config.sdm_jokers then
    CardSleeves.Sleeve {
        key = "sdm_0_s",
        atlas = "sdm_sleeves",
        pos = { x = 0, y = 0 },
        config = {extra = 2},
        loc_vars = function(self)
            return {vars = {self.config.extra}}
        end,
        unlocked = true,
        -- Sleeve effect in "lovely.toml"
    }
end

--- Bazaar Sleeve

if SDM_0s_Stuff_Config.sdm_consus then

    CardSleeves.Sleeve {
        key = "bazaar",
        atlas = "sdm_sleeves",
        pos = { x = 1, y = 0 },
        config = {extra = 1},
        loc_vars = function(self)
            return {vars = {self.config.extra}}
        end,
        unlocked = true,
        trigger_effect = function(self, args)
            if args.context == 'eval' and G.GAME.last_blind and G.GAME.last_blind.boss then
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


CardSleeves.Sleeve {
    key = "lucky_7",
    atlas = "sdm_sleeves",
    pos = { x = 3, y = 0 },
    config = {ante_scaling = 1.5},
    unlocked = true,
    loc_vars = function(self)
        if self.get_current_deck_key() == "b_sdm_lucky_7" or self.get_current_deck_key() == "b_sdm_deck_of_stuff" or self.get_current_deck_key() == "b_sdm_deck_of_dreams" then
            if SDM_0s_Stuff_Config and SDM_0s_Stuff_Config.sdm_jokers then
                return {key = self.key .. '_alt_' .. (SDM_0s_Stuff_Config and SDM_0s_Stuff_Config.sdm_jokers and '1' or '2'), vars = {self.config.ante_scaling}}
            else
                return {key = self.key .. '_alt_2', vars = {self.config.ante_scaling}}
            end
        else
            return {vars = {self.config.ante_scaling}}
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
                G.GAME.starting_params.ante_scaling = (G.GAME.starting_params.ante_scaling or 1) * self.config.ante_scaling
                for k, v in pairs(G.GAME.probabilities) do
                    G.GAME.probabilities[k] = v*2
                end
                if self.get_current_deck_key() == "b_sdm_lucky_7" or self.get_current_deck_key() == "b_sdm_deck_of_stuff" or self.get_current_deck_key() == "b_sdm_deck_of_dreams" then
                    add_joker((SDM_0s_Stuff_Config and SDM_0s_Stuff_Config.sdm_jokers and "j_sdm_lucky_joker" or "j_oops"), nil, true, true)
                end
                return true
            end
        }))
    end,
}

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
        if self.get_current_deck_key() == "b_ghost" then
            key = self.key .. "_ghost"
            self.config = { spectral_rate = 4, consumables = { 'c_ankh' } }
            vars[#vars+1] = localize{type = 'name_text', key = self.config.consumables[1], set = 'Tarot'}
        elseif self.get_current_deck_key() == "b_sdm_hieroglyph" or self.get_current_deck_key() == "b_sdm_deck_of_stuff" or self.get_current_deck_key() == "b_sdm_deck_of_dreams" then
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
        local is_spectral_pack = args.context and args.context["card"] and args.context.card.ability.set == "Booster" and args.context.card.ability.name:find("Spectral")
        if args.context and args.context["create_booster"] and is_spectral_pack and self.config.spectral_more_options then
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
}

--- Hoarder Sleeve

CardSleeves.Sleeve {
    key = "hoarder",
    atlas = "sdm_sleeves",
    pos = { x = 2, y = 1 },
    config = {extra_discard_bonus = 3},
    unlocked = true,
    loc_vars = function(self)
        local key
        if self.get_current_deck_key() == "b_green" then
            key = self.key .. "_alt"
            self.config = {extra_discard_bonus = 2}
            return {key = key, vars = {self.config.extra_discard_bonus}}
        end
        return {vars = {self.config.extra_discard_bonus}}
    end,
    apply = function(self)
        G.GAME.modifiers.no_interest = true
        G.GAME.modifiers.money_per_discard = (G.GAME.modifiers.money_per_discard or 0) + self.config.extra_discard_bonus
        if self.get_current_deck_key() ~= "b_green" then
            G.GAME.modifiers.no_extra_hand_money = true
        end
    end,
}

--- Modder's Sleeve

CardSleeves.Sleeve {
    key = "modders",
    atlas = "sdm_sleeves",
    pos = { x = 3, y = 1 },
    unlocked = true,
    apply = function(self)
        -- Vanilla pool changes applied in "lovely.toml"
        if Cryptid and self.get_current_deck_key() == "b_cry_equilibrium" or self.get_current_deck_key() == "b_cry_antimatter" then
            for _, v in pairs(G.P_CENTER_POOLS["Joker"]) do
                if not v.original_key or (v.class_prefix..'_'..v.original_key == v.key) then
                    v.no_doe = true
                end
            end
        end
    end,
}

--- Reverb Sleeve

CardSleeves.Sleeve {
    key = "reverb",
    atlas = "sdm_sleeves",
    pos = { x = 0, y = 2 },
    unlocked = true,
    loc_vars = function(self)
        local key
        local vars = {}
        if self.get_current_deck_key() == "b_sdm_reverb" or self.get_current_deck_key() == "b_sdm_deck_of_stuff" or self.get_current_deck_key() == "b_sdm_deck_of_dreams" then
            key = self.key .. "_alt"
            self.config = {retrigger = 1}
            vars = {self.config.retrigger}
        else
            key = self.key
            self.config = {joker_slot = -2, retrigger = 1}
            vars = {self.config.joker_slot, self.config.retrigger}
        end
        return { key = key, vars = vars }
    end,
    calculate = function(self, sleeve, context)
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
}

--- Roguelike Sleeve

CardSleeves.Sleeve {
    key = "roguelike",
    atlas = "sdm_sleeves",
    pos = { x = 1, y = 2 },
    unlocked = true,
    loc_vars = function(self)
        local key
        local vars = {}
        if self.get_current_deck_key() == "b_sdm_roguelike" or self.get_current_deck_key() == "b_sdm_deck_of_stuff" or self.get_current_deck_key() == "b_sdm_deck_of_dreams" then
            key = self.key .. "_alt"
            self.config = {extra_slot = 1, vouchers = {'v_overstock_plus'}}
            vars = {localize{type = 'name_text', key = 'v_overstock_plus', set = 'Voucher'}, self.config.extra_slot}
        else
            key = self.key
            self.config = {extra_slot = 1, vouchers = {'v_overstock_norm'}}
            vars = {localize{type = 'name_text', key = 'v_overstock_norm', set = 'Voucher'}, self.config.extra_slot}
        end
        return { key = key, vars = vars }
    end,
    apply = function(self)
        G.GAME.modifiers.sdm_no_reroll = true   -- No reroll effect in utils.lua overrides
        for _, v in pairs(self.config.vouchers) do
            G.GAME.used_vouchers[v] = true
            G.GAME.starting_voucher_count = (G.GAME.starting_voucher_count or 0) + 1
            G.E_MANAGER:add_event(Event({
                func = function()
                    Card.apply_to_run(nil, G.P_CENTERS[v])
                    return true
                end
            }))
        end
        if self.get_current_deck_key() == "b_sdm_roguelike" or self.get_current_deck_key() == "b_sdm_deck_of_stuff" or self.get_current_deck_key() == "b_sdm_deck_of_dreams" then
            SMODS.change_voucher_limit(self.config.extra_slot)
        else
            SMODS.change_booster_limit(self.config.extra_slot)
        end
    end,
}

--- Baker's Sleeve

if SDM_0s_Stuff_Config.sdm_bakery then

    CardSleeves.Sleeve {
        key = "bakers",
        atlas = "sdm_sleeves",
        pos = { x = 4, y = 1 },
        unlocked = true,
        loc_vars = function(self)
            local key
            local vars = {}
            if self.get_current_deck_key() == "b_sdm_bakers" or self.get_current_deck_key() == "b_sdm_deck_of_stuff" or self.get_current_deck_key() == "b_sdm_deck_of_dreams" then
                key = self.key .. "_alt"
                self.config = {vouchers = {'v_sdm_bakery_shop'}}
                vars = {localize{type = 'name_text', key = 'v_sdm_bakery_shop', set = 'Voucher'}}
            else
                key = self.key
                self.config = {voucher = 'v_sdm_bakery_stall', consumable_slot = 1}
                vars = {localize{type = 'name_text', key = 'v_sdm_bakery_stall', set = 'Voucher'}, self.config.consumable_slot}
            end
            return { key = key, vars = vars }
        end
    }

end