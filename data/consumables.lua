SMODS.Atlas{
    key = "sdm_consumables",
    path = "sdm_consumables.png",
    px = 71,
    py = 95
}

--- The Sphinx ---

SMODS.Consumable{
    key = 'sphinx',
    name = 'The Sphinx',
    set = 'Tarot',
    pos = {x = 0, y = 0},
    cost = 3,
    config = {extra = {max_highlighted = 1, odds = 2}},
    loc_vars = function(self, info_queue, card)
        return {vars = {''..(G.GAME and G.GAME.probabilities.normal or 1), self.config.extra.odds, self.config.extra.max_highlighted}}
    end,
    can_use = function(self, card, area, copier)
        if G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.SMODS_BOOSTER_OPENED then
            return G.hand and G.hand.highlighted and #G.hand.highlighted <= card.ability.extra.max_highlighted and #G.hand.highlighted >= 1
        end
        return false
    end,
    use = function(self, card)
        local used_tarot = card or self
        if SDM_0s_Stuff_Funcs.proba_check(card.ability.extra.odds, 'sphinx') then
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                for i = 1, #G.hand.highlighted do
                    local edition = poll_edition('wheel_of_fortune', nil, true, true)
                    G.hand.highlighted[i]:set_edition(edition, true)
                end
                used_tarot:juice_up(0.3, 0.5)
                return true
            end}))
        else
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                attention_text({
                    text = localize('k_nope_ex'),
                    scale = 1.3,
                    hold = 1.4,
                    major = used_tarot,
                    backdrop_colour = G.C.SECONDARY_SET.Tarot,
                    align = (G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and 'tm' or 'cm',
                    offset = {x = 0, y = (G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and -0.2 or 0},
                    silent = true
                    })
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                        play_sound('tarot2', 0.76, 0.4);return true end}))
                    play_sound('tarot2', 1, 0.4)
                    used_tarot:juice_up(0.3, 0.5)
            return true end}))
        end
    end,
    atlas = "sdm_consumables"
}

SDM_0s_Stuff_Mod.modded_consumables.c_sdm_sphinx = "Sphinx"

--- The Mother ---

SMODS.Consumable{
    key = 'mother',
    name = 'The Mother',
    set = 'Tarot',
    pos = {x = 3, y = 0},
    cost = 3,
    config = {extra = {max_highlighted = 2, chip_mod = 15}},
    loc_vars = function(self, info_queue, card)
        return {vars = {self.config.extra.max_highlighted, self.config.extra.chip_mod}}
    end,
    can_use = function(self, card, area, copier)
        if G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.SMODS_BOOSTER_OPENED then
            if G.hand and G.hand.highlighted then
                return card.ability.extra.max_highlighted >= #G.hand.highlighted and #G.hand.highlighted >= 1
            end
        end
        return false
    end,
    use = function(self, card)
        local used_tarot = card or self
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('tarot1')
            used_tarot:juice_up(0.3, 0.5)
            return true end
        }))
        for i=1, #G.hand.highlighted do
            local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() play_sound('card1', percent);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
        end
        delay(0.05)
        for i=1, #G.hand.highlighted do
            card_eval_status_text(G.hand.highlighted[i], 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_chips', vars = {self.config.extra.chip_mod}}, colour = G.C.CHIPS})
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function()
                local _card = G.hand.highlighted[i]
                _card.ability.perma_bonus = _card.ability.perma_bonus or 0
                _card.ability.perma_bonus = _card.ability.perma_bonus + card.ability.extra.chip_mod
                return true end }))
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
        end
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
        delay(0.5)
    end,
    atlas = "sdm_consumables"
}

SDM_0s_Stuff_Mod.modded_consumables.c_sdm_mother = "Mother"

--- Sacrifice ---

SMODS.Consumable{
    key = 'sacrifice',
    name = 'Sacrifice',
    set = 'Spectral',
    pos = {x = 1, y = 0},
    cost = 4,
    config = {extra = {jkr_slot = 1, hand = 1, discard = 1}},
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

SDM_0s_Stuff_Mod.modded_consumables.c_sdm_sacrifice = "Sacrifice"

--- Morph ---

SMODS.Consumable{
    key = 'morph',
    set = 'Spectral',
    pos = {x = 2, y = 0},
    cost = 4,
    config = {extra = {add = 2, remove = 1}},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = "morph_list", set = "Other"}
        return {vars = {self.config.extra.remove, self.config.extra.add}}
    end,
    can_use = function(self, card, area, copier)
        return G.GAME.round_resets.hands > card.ability.extra.remove or G.GAME.round_resets.discards > 0 or to_big(G.GAME.dollars) > to_big(0)
        or G.hand.config.card_limit > card.ability.extra.remove or G.jokers.config.card_limit > 0 or G.consumeables.config.card_limit > 0
    end,
    use = function(self, card)
        local resource = {"hand", "discard", "handsize", "joker_slot", "consumable_slot"}
        local taken = {}
        if G.GAME.round_resets.hands > card.ability.extra.remove then
            table.insert(taken, "hand")
        end
        if G.GAME.round_resets.discards > 0 then
            table.insert(taken, "discard")
        end
        if G.hand.config.card_limit > card.ability.extra.remove then
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
        table.remove(resource, (SDM_0s_Stuff_Funcs.index_elem(resource, removed) or "hand"))
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
                hand = localize{type = 'variable', key = 'a_hand_minus', vars = {card.ability.extra.remove}},
                discard = localize{type = 'variable', key = 'a_discard_minus', vars = {card.ability.extra.remove}},
                handsize = localize{type = 'variable', key = 'a_handsize_minus', vars = {card.ability.extra.remove}},
                joker_slot = localize{type = 'variable', key = 'a_joker_slot_minus', vars = {card.ability.extra.remove}},
                consumable_slot = localize{type = 'variable', key = 'a_consumable_slot_minus', vars = {card.ability.extra.remove}},
            }
            morph_funcs[removed](card.ability.extra.remove, -1)
            attention_text({
                text = removed_result[removed],
                scale = 1,
                hold = 1,
                major = used_tarot,
                backdrop_colour = G.C.RED,
                align = (G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and 'tm' or 'cm',
                offset = {x = 0, y = (G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and -0.2 or 0},
                silent = true
            })
        return true end }))
        delay(0.8)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, func = function()
            play_sound('tarot1')
            used_tarot:juice_up(0.3, 0.5)
            added_result = {
                hand = localize{type = 'variable', key = 'a_hand', vars = {card.ability.extra.add}},
                discard = localize{type = 'variable', key = 'a_discard', vars = {card.ability.extra.add}},
                handsize = localize{type = 'variable', key = 'a_handsize', vars = {card.ability.extra.add}},
                joker_slot = localize{type = 'variable', key = 'a_joker_slot', vars = {card.ability.extra.add}},
                consumable_slot = localize{type = 'variable', key = 'a_consumable_slot', vars = {card.ability.extra.add}},
            }
            morph_funcs[added](card.ability.extra.add, 1)
            attention_text({
                text = added_result[added],
                scale = 1,
                hold = 1,
                major = used_tarot,
                backdrop_colour = G.C.BLUE,
                align = (G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and 'tm' or 'cm',
                offset = {x = 0, y = (G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and -0.2 or 0},
                silent = true
            })
        return true end }))
        delay(0.6)
    end,
    atlas = "sdm_consumables"
}

SDM_0s_Stuff_Mod.modded_consumables.c_sdm_morph = "Morph"

--- Bind ---

SMODS.Consumable{
    key = 'bind',
    name = 'Bind',
    set = 'Spectral',
    pos = {x = 0, y = 1},
    cost = 4,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'eternal', set = 'Other'}
    end,
    can_use = function(self, card, area, copier)
        if #G.jokers.highlighted >= 1 then
            local joker = G.jokers.highlighted[1]
            return joker.ability.eternal or (joker.config.center.eternal_compat and not joker.ability.perishable)
        end
        return false
    end,
    use = function(self, card)
        local used_tarot = card or self
        local joker = G.jokers.highlighted[1]
        G.E_MANAGER:add_event(Event({func = function()
            play_sound('tarot1')
            used_tarot:juice_up(0.3, 0.5)
            return true end
        }))
        if not joker.ability.eternal then
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                joker:set_eternal(true)
                joker:juice_up(0.3, 0.3)
                return true end
            }))
        else
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                joker.ability.eternal = false
                joker:juice_up(0.3, 0.3)
                return true end
            }))
        end
        delay(0.5)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.jokers:unhighlight_all(); return true end }))
    end,
    atlas = "sdm_consumables"
}

SDM_0s_Stuff_Mod.modded_consumables.c_sdm_bind = "Bind"

--- Doppelgänger ---

SMODS.Consumable{
    key = 'doppelganger',
    name = 'Doppelgänger',
    set = 'Spectral',
    pos = {x = 1, y = 1},
    cost = 4,
    can_use = function(self, card, area, copier)
        if G.jokers and G.jokers.cards then
            if #G.jokers.cards <= 1 then return false end
            local eternal_count = 0
            for _, v in ipairs(G.jokers.cards) do
                if v.ability.eternal then eternal_count = eternal_count + 1 end
            end
            return eternal_count < #G.jokers.cards
        else
            return false
        end
    end,
    use = function(self, card)
        local selected_joker = G.jokers.cards[pseudorandom_element({1, #G.jokers.cards}, pseudoseed('dpgg'))]
        local replacable_jokers = {}
        for _, v in ipairs(G.jokers.cards) do
            if not (v.ability.eternal or v == selected_joker) then replacable_jokers[#replacable_jokers + 1] = v end
        end
        local chosen_joker = pseudorandom_element(replacable_jokers, pseudoseed('dpgg'))
        G.E_MANAGER:add_event(Event({trigger = 'before', delay = 0.75, func = function()
            chosen_joker:start_dissolve()
        return true end }))
        G.E_MANAGER:add_event(Event({trigger = 'before', delay = 0.4, func = function()
            if #G.jokers.cards <= G.jokers.config.card_limit then
                local _card = copy_card(selected_joker)
                _card:start_materialize()
                _card:add_to_deck()
                G.jokers:emplace(_card)
            end
        return true end }))
    end,
    atlas = "sdm_consumables"
}

SDM_0s_Stuff_Mod.modded_consumables.c_sdm_doppelganger = "Doppelgänger"