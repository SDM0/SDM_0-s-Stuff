SMODS.Atlas{
    key = "sdm_consumables",
    path = "sdm_consumables.png",
    px = 71,
    py = 95
}

--- Sphinx ---

SMODS.Consumable{
    key = 'sphinx',
    name = 'Sphinx',
    set = 'Tarot',
    pos = {x = 0, y = 0},
    cost = 3,
    config = {extra = 2},
    loc_vars = function(self, info_queue, card)
        return {vars = {''..(G.GAME and G.GAME.probabilities.normal or 1), self.config.extra}}
    end,
    can_use = function(self, card, area, copier)
        if G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.PLANET_PACK then
            local valid_cards = {}
            for i = 1, #G.hand.cards do
                if not G.hand.cards[i].edition then
                    table.insert(valid_cards, G.hand.cards[i])
                end
            end
            return G.hand and #G.hand.cards > 0 and #valid_cards > 0
        end
        return false
    end,
    use = function(self, card)
        local used_tarot = card or self
        if pseudorandom('sphinx') < G.GAME.probabilities.normal/card.ability.extra then
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                local valid_cards = {}
                for i = 1, #G.hand.cards do
                    if not G.hand.cards[i].edition then
                        table.insert(valid_cards, G.hand.cards[i])
                    end
                end
                local edition = poll_edition('wheel_of_fortune', nil, true, true)
                local random_card = valid_cards[pseudorandom('sphinx', 1, #valid_cards)]
                random_card:set_edition(edition, true)
                used_tarot:juice_up(0.3, 0.5)
                return true
            end }))
        else
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                attention_text({
                    text = localize('k_nope_ex'),
                    scale = 1.3, 
                    hold = 1.4,
                    major = used_tarot,
                    backdrop_colour = G.C.SECONDARY_SET.Tarot,
                    align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and 'tm' or 'cm',
                    offset = {x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and -0.2 or 0},
                    silent = true
                    })
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                        play_sound('tarot2', 0.76, 0.4);return true end}))
                    play_sound('tarot2', 1, 0.4)
                    used_tarot:juice_up(0.3, 0.5)
            return true end }))
        end
    end,
    atlas = "sdm_consumables"
}

SDM_0s_Stuff_Mod.modded_objects.c_sdm_sphinx = "Sphinx"

--- Mother ---

SMODS.Consumable{
    key = 'mother',
    name = 'Mother',
    set = 'Tarot',
    pos = {x = 0, y = 0},
    cost = 3,
    config = {extra = {max_highlighted = 2, chip_mod = 10}},
    loc_vars = function(self, info_queue, card)
        return {vars = {self.config.extra.max_highlighted, self.config.extra.chip_mod}}
    end,
    can_use = function(self, card, area, copier)
        if G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.PLANET_PACK then
            if self.config.extra.max_highlighted then
                if self.config.extra.max_highlighted >= #G.hand.highlighted and #G.hand.highlighted >= 1 then
                    return true
                end
            end
        end
        return false
    end,
    use = function(self, card)
        for i=1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                local _card = G.hand.highlighted[i]
                _card.ability.perma_bonus = _card.ability.perma_bonus or 0
                _card.ability.perma_bonus = _card.ability.perma_bonus + self.config.extra.chip_mod
                card_eval_status_text(_card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_chips', vars = {self.config.extra.chip_mod}}, colour = G.C.CHIPS})
            return true end }))
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() play_sound('tarot2', percent, 0.6);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
        end
        G.hand:unhighlight_all()
        delay(0.5)
    end,
    atlas = "sdm_consumables"
}

SDM_0s_Stuff_Mod.modded_objects.c_sdm_mother = "Mother"

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

SDM_0s_Stuff_Mod.modded_objects.c_sdm_sacrifice = "Sacrifice"

--- Morph ---

SMODS.Consumable{
    key = 'morph',
    name = 'Morph',
    set = 'Spectral',
    pos = {x = 2, y = 0},
    cost = 4,
    can_use = function(self, card, area, copier)
        return G.GAME.round_resets.hands > 1 and G.GAME.round_resets.discards > 1
    end,
    use = function(self, card)
        local used_tarot = card or self
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, func = function()
            play_sound('tarot1')
            used_tarot:juice_up(0.3, 0.5)
            local prev_hands = G.GAME.round_resets.hands
            local prev_discards = G.GAME.round_resets.discards
            local total = prev_hands + prev_discards

            repeat
                G.GAME.round_resets.hands = pseudorandom(pseudoseed("morph"), 1, total - 1)
                G.GAME.round_resets.discards = total - G.GAME.round_resets.hands
            until G.GAME.round_resets.hands ~= prev_hands and G.GAME.round_resets.discards ~= prev_discards

            ease_hands_played(G.GAME.round_resets.hands - prev_hands)
            ease_discard(G.GAME.round_resets.discards - prev_discards)
        return true end }))
    end,
    atlas = "sdm_consumables"
}

SDM_0s_Stuff_Mod.modded_objects.c_sdm_morph = "Morph"

return