SMODS.Atlas{
    key = "sdm_consumables",
    path = "sdm_consumables.png",
    px = 71,
    py = 95
}

--- Sphinx ---

SMODS.Consumable{
    key = 'sphinx',
    set = 'Tarot',
    pos = {x = 0, y = 0},
    cost = 3,
    config = {extra = 2},
    loc_vars = function(self, info_queue, card)
        return {vars = {''..(G.GAME and G.GAME.probabilities.normal or 1), self.config.extra}}
    end,
    can_use = function(self, card, area, copier)
        if G.STATE ~= G.STATES.HAND_PLAYED and G.STATE ~= G.STATES.DRAW_TO_HAND and G.STATE ~= G.STATES.PLAY_TAROT or area then
            if G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.PLANET_PACK then
                local valid_card = {}
                for i = 1, #G.hand.cards do
                    if not G.hand.cards[i].edition then
                        table.insert(valid_card, G.hand.cards[i])
                    end
                end
                return G.hand and #G.hand.cards > 0 and #valid_card > 0
            end
        end
        return false
    end,
    use = function(self, card)
        local used_tarot = card or self
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            local valid_card = {}
            for i = 1, #G.hand.cards do
                if not G.hand.cards[i].edition then
                    table.insert(valid_card, G.hand.cards[i])
                end
            end
            local edition = poll_edition('wheel_of_fortune', nil, true, true)
            local random_card = valid_card[pseudorandom('sphinx', 1, #valid_card)]
            random_card:set_edition(edition, true)
            used_tarot:juice_up(0.3, 0.5)
            return true
        end }))
    end,
    atlas = "sdm_consumables"
}

SDM_0s_Stuff_Mod.modded_objects.c_sdm_sphinx = "Sphinx"

--- Sacrifice ---

SMODS.Consumable{
    key = 'sacrifice',
    set = 'Spectral',
    pos = {x = 1, y = 0},
    cost = 4,
    config = {extra = {jkr_slot = 1, hand = 1, discard = 1}},
    loc_txt = {
        name = "Sacrifice",
        text = {
            "{C:attention}+#1#{} Joker Slot,",
            "{C:red}-#2#{} hand,",
            "{C:red}-#3#{} discard"
        }
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {self.config.extra.jkr_slot, self.config.extra.hand, self.config.extra.discard}}
    end,
    can_use = function(self, card, area, copier)
        return G.GAME.round_resets.discards >= card.ability.extra.discard and G.GAME.round_resets.hands > card.ability.extra.hand
    end,
    use = function(self, card)
        local used_tarot = card or self
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('tarot1')
            used_tarot:juice_up(0.3, 0.5)
            G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.jkr_slot
            G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hand
            ease_hands_played(-1)
            G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.discard
            ease_discard(-1)
        return true end }))
    end,
    atlas = "sdm_consumables"
}

SDM_0s_Stuff_Mod.modded_objects.c_sdm_sacrifice = "Sacrifice"

--- Morph ---

SMODS.Consumable{
    key = 'morph',
    set = 'Spectral',
    pos = {x = 2, y = 0},
    cost = 4,
    config = {extra = 1},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = "resources", set = "Other"}
        return {vars = {self.config.extra, (self.config.extra > 1 and "resources") or "resource"}}
    end,
    can_use = function(self, card, area, copier)
        return G.GAME.round_resets.hands > card.ability.extra or G.GAME.round_resets.discards > 0 or G.GAME.dollars > 0
        or G.hand.config.card_limit > card.ability.extra or G.jokers.config.card_limit > 0 or G.consumeables.config.card_limit > 0
    end,
    use = function(self, card)
        local resource = {"hand", "discard", "dollar", "handsize", "joker_slot", "consumable_slot"}
        local taken = {}
        if G.GAME.round_resets.hands > card.ability.extra then
            table.insert(taken, "hand")
        end
        if G.GAME.round_resets.discards > 0 then
            table.insert(taken, "discard")
        end
        if G.GAME.dollars > 0 then
            table.insert(taken, "dollar")
        end
        if G.hand.config.card_limit > card.ability.extra then
            table.insert(taken, "handsize")
        end
        if G.jokers.config.card_limit > 0 then
            table.insert(taken, "joker_slot")
        end
        if G.consumeables.config.card_limit > 0 then
            table.insert(taken, "consumable_slot")
        end
        local removed_ind = pseudorandom("tmtt_removed", 1, #taken)
        local removed = taken[removed_ind]
        table.remove(resource, (index_elem(resource, removed) or "dollar"))
        local added = resource[pseudorandom("tmtt_added", 1, #resource)]
        local morph_funcs = {
            hand = function(extra, sign)
                G.GAME.round_resets.hands = G.GAME.round_resets.hands + (sign * extra)
                ease_hands_played(sign * extra)
            end,
            discard = function(extra, sign)
                G.GAME.round_resets.discards = G.GAME.round_resets.discards + (sign * extra)
                ease_discard(sign * extra)
            end,
            dollar = function(extra, sign)
                ease_dollars(sign * extra)
            end,
            handsize = function(extra, sign)
                G.hand:change_size(sign * extra)
            end,
            joker_slot = function(extra, sign)
                G.jokers.config.card_limit = G.jokers.config.card_limit + (sign * extra)
            end,
            consumable_slot = function(extra, sign)
                G.consumeables.config.card_limit = G.consumeables.config.card_limit + (sign * extra)
            end
        }
        local used_tarot = card or self
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, func = function()
            play_sound('tarot1')
            used_tarot:juice_up(0.3, 0.5)
            removed_result = {
                hand = localize{type = 'variable', key = 'a_hand_minus', vars = {card.ability.extra}},
                discard = localize{type = 'variable', key = 'a_discard_minus', vars = {card.ability.extra}},
                dollar = "-$" .. card.ability.extra,
                handsize = localize{type = 'variable', key = 'a_handsize_minus', vars = {card.ability.extra}},
                joker_slot = localize{type = 'variable', key = 'a_joker_slot_minus', vars = {card.ability.extra}},
                consumable_slot = localize{type = 'variable', key = 'a_consumable_slot_minus', vars = {card.ability.extra}},
            }
            morph_funcs[removed](card.ability.extra, -1)
            attention_text({
                text = removed_result[removed],
                scale = 1,
                hold = 1,
                major = used_tarot,
                backdrop_colour = G.C.RED,
                align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and 'tm' or 'cm',
                offset = {x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and -0.2 or 0},
                silent = true
            })
        return true end }))
        delay(0.8)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, func = function()
            play_sound('tarot1')
            used_tarot:juice_up(0.3, 0.5)
            added_result = {
                hand = localize{type = 'variable', key = 'a_hand', vars = {card.ability.extra}},
                discard = localize{type = 'variable', key = 'a_discard', vars = {card.ability.extra}},
                dollar = "$" .. card.ability.extra,
                handsize = localize{type = 'variable', key = 'a_handsize', vars = {card.ability.extra}},
                joker_slot = localize{type = 'variable', key = 'a_joker_slot', vars = {card.ability.extra}},
                consumable_slot = localize{type = 'variable', key = 'a_consumable_slot', vars = {card.ability.extra}},
            }
            morph_funcs[added](card.ability.extra, 1)
            attention_text({
                text = added_result[added],
                scale = 1,
                hold = 1,
                major = used_tarot,
                backdrop_colour = G.C.BLUE,
                align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and 'tm' or 'cm',
                offset = {x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and -0.2 or 0},
                silent = true
            })
        return true end }))
        delay(0.6)
    end,
    atlas = "sdm_consumables"
}

SDM_0s_Stuff_Mod.modded_objects.c_sdm_morph = "Morph"

return