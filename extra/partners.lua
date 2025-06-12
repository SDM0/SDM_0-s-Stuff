SMODS.Atlas{
    key = "sdm_partners",
    path = "sdm_partners.png",
    px = 46,
    py = 58,
}

--- Luck ---

Partner_API.Partner{
    key = "lucky_joker",
    name = "Lucky Joker Partner",
    unlocked = false,
    discovered = true,
    individual_quips = true,
    pos = {x = 0, y = 0},
    atlas = "sdm_partners",
    config = {extra = {repetitions = 1}},
    link_config = {j_sdm_lucky_joker = 1},
    loc_vars = function(self, info_queue, card)
        local benefits = (next(SMODS.find_card("j_sdm_lucky_joker")) and 2) or 1
        return { vars = {card.ability.extra.repetitions*benefits} }
    end,
    calculate = function(self, card, context)
        if not context.end_of_round and context.repetition and context.cardarea == G.play and context.other_card then
            if context.other_card:get_id() == 7 and not card.ability.first_seven_scored then
                card.ability.first_seven_scored = true
                local benefits = (next(SMODS.find_card("j_sdm_lucky_joker")) and 2) or 1
                return {
                    repetitions = card.ability.extra.repetitions * benefits,
                    card = card
                }
            end
        end
        if context.partner_after and card.ability.first_seven_scored then
            card.ability.first_seven_scored = nil
        end
    end,
    check_for_unlock = function(self, args)
        for _, v in pairs(G.P_CENTER_POOLS["Joker"]) do
            if v.key == "j_sdm_lucky_joker" then
                if get_joker_win_sticker(v, true) >= 8 then
                    return true
                end
                break
            end
        end
    end,
}

--- Stonks ---

Partner_API.Partner{
    key = "shareholder_joker",
    name = "Shareholder Joker Partner",
    unlocked = false,
    discovered = true,
    individual_quips = true,
    pos = {x = 1, y = 0},
    atlas = "sdm_partners",
    config = {extra = {min = 1, max = 4}},
    link_config = {j_sdm_shareholder_joker = 1},
    loc_vars = function(self, info_queue, card)
        local benefits = ((next(SMODS.find_card("j_sdm_shareholder_joker")) and 2) or 0)
        local max = card.ability.extra.max + benefits
        return { vars = {card.ability.extra.min, max} }
    end,
    calculate_cash = function(self, card)
        local benefits = ((next(SMODS.find_card("j_sdm_shareholder_joker")) and 2) or 0)
        local rand_dollar = pseudorandom(pseudoseed('stock'), card.ability.extra.min, card.ability.extra.max + benefits)
        return rand_dollar
    end,
    check_for_unlock = function(self, args)
        for _, v in pairs(G.P_CENTER_POOLS["Joker"]) do
            if v.key == "j_sdm_shareholder_joker" then
                if get_joker_win_sticker(v, true) >= 8 then
                    return true
                end
                break
            end
        end
    end,
}

--- Spirit ---

Partner_API.Partner{
    key = "ouija_board",
    name = "Ouija Board Partner",
    unlocked = false,
    discovered = true,
    no_quips = true,
    pos = {x = 2, y = 0},
    atlas = "sdm_partners",
    config = {extra = {amount = 1, rounds = 0, remaining = 6}},
    link_config = {j_sdm_ouija_board = 1},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_TAGS.tag_rare
        local benefits = ((next(SMODS.find_card("j_sdm_ouija_board")) and 3) or 0)
        return { vars = {card.ability.extra.remaining - benefits , card.ability.extra.amount, card.ability.extra.rounds} }
    end,
    calculate = function(self, card, context)
        if context.partner_end_of_round then
            if card.ability.extra.rounds < card.ability.extra.remaining then
                local benefits = (next(SMODS.find_card("j_sdm_ouija_board")) and 3) or 0
                card.ability.extra.rounds = math.min(card.ability.extra.rounds + 1, card.ability.extra.remaining)
                if card.ability.extra.rounds <= card.ability.extra.remaining - benefits then
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = card.ability.extra.rounds .. "/" .. card.ability.extra.remaining})
                end
                if card.ability.extra.rounds >= card.ability.extra.remaining - benefits then
                    card.ability.extra.rounds = 0
                    G.E_MANAGER:add_event(Event({
                    func = (function()
                        add_tag(Tag('tag_rare'))
                        card:juice_up(0.3, 0.4)
                        play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                        play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                        return true
                    end)
                }))
                end
            end
        end
    end,
    check_for_unlock = function(self, args)
        for _, v in pairs(G.P_CENTER_POOLS["Joker"]) do
            if v.key == "j_sdm_ouija_board" then
                if get_joker_win_sticker(v, true) >= 8 then
                    return true
                end
                break
            end
        end
    end,
}

--- Gacha ---

Partner_API.Partner{
    key = "mystery_joker",
    name = "Mystery Joker Partner",
    unlocked = false,
    discovered = true,
    individual_quips = true,
    pos = {x = 3, y = 0},
    atlas = "sdm_partners",
    config = {extra = {amount = 1}},
    link_config = {j_sdm_mystery_joker = 1},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_TAGS.tag_uncommon
        local benefits = ((next(SMODS.find_card("j_sdm_mystery_joker")) and 1) or 0)
        return { vars = {card.ability.extra.amount + benefits} }
    end,
    calculate = function(self, card, context)
        if context.partner_end_of_round then
            if G.GAME.blind.boss then
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        local benefits = ((next(SMODS.find_card("j_sdm_mystery_joker")) and 1) or 0)
                        for i = 1, card.ability.extra.amount + benefits do
                            add_tag(Tag('tag_uncommon'))
                            card:juice_up(0.3, 0.4)
                            play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                            play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                        end
                        return true
                    end)
                }))
            end
        end
    end,
    check_for_unlock = function(self, args)
        for _, v in pairs(G.P_CENTER_POOLS["Joker"]) do
            if v.key == "j_sdm_mystery_joker" then
                if get_joker_win_sticker(v, true) >= 8 then
                    return true
                end
                break
            end
        end
    end,
}

--- Twist ---

Partner_API.Partner{
    key = "crooked_joker",
    name = "Crooked Joker",
    unlocked = false,
    discovered = true,
    individual_quips = true,
    pos = {x = 0, y = 1},
    atlas = "sdm_partners",
    config = {extra = {shop_slots = 1, pos_change = 0}},
    link_config = {j_sdm_crooked_joker = 1},
    loc_vars = function(self, info_queue, card)
        local benefits = ((next(SMODS.find_card("j_sdm_crooked_joker")) and 1) or 0)
        return { vars = {card.ability.extra.shop_slots + benefits} }
    end,
    calculate = function(self, card, context)
        if context.partner_starting_shop then
            local benefits = ((next(SMODS.find_card("j_sdm_crooked_joker")) and 1) or 0)
            local mod = pseudorandom(pseudoseed('crkp'), 0, 1)
            if mod == 1 then
                change_shop_size(card.ability.extra.shop_slots + benefits)
                card.ability.extra.pos_change = card.ability.extra.shop_slots + benefits
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = localize{type = 'variable', key = 'a_shop_slot', vars = {card.ability.extra.pos_change}},
                    colour = G.C.FILTER
                })
            else
                change_shop_size(-(card.ability.extra.shop_slots + benefits))
                card.ability.extra.pos_change = -(card.ability.extra.shop_slots + benefits)
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = localize{type = 'variable', key = 'a_shop_slot_minus', vars = {-card.ability.extra.pos_change}},
                    colour = G.C.RED
                })
            end
        end
        if context.partner_ending_shop then
            card_eval_status_text(card, 'extra', nil, nil, nil, {
                message = localize('k_reset'),
                colour = G.C.FILTER
            })
        end
        if context.partner_setting_blind then
            change_shop_size(-card.ability.extra.pos_change)
        end
    end,
    check_for_unlock = function(self, args)
        for _, v in pairs(G.P_CENTER_POOLS["Joker"]) do
            if v.key == "j_sdm_crooked_joker" then
                if get_joker_win_sticker(v, true) >= 8 then
                    return true
                end
                break
            end
        end
    end,
}

--- Joke ---

Partner_API.Partner{
    key = "jambo",
    name = "Jambo Partner",
    unlocked = false,
    discovered = true,
    individual_quips = true,
    pos = {x = 1, y = 1},
    atlas = "sdm_partners",
    config = {extra = {mult_mod = 1}},
    link_config = {j_sdm_jambo = 1},
    loc_vars = function(self, info_queue, card)
        local benefits = ((next(SMODS.find_card("j_sdm_jambo")) and 2) or 1)
        local min = (G.discard and G.discard.cards[1] and G.discard.cards[1].base.nominal) or 0
        if G.discard and #G.discard.cards > 0 then
            for k, v in ipairs(G.discard.cards) do
                if not v.debuff then
                    if v.base.nominal < min then
                        min = v.base.nominal
                    end
                end
            end
        end
        return { vars = {card.ability.extra.mult_mod * benefits, min * benefits} }
    end,
    calculate = function(self, card, context)
        if context.partner_main and (G.discard and #G.discard.cards > 0) then
            local benefits = ((next(SMODS.find_card("j_sdm_jambo")) and 2) or 1)
            local min = G.discard.cards[1].base.nominal
            for k, v in ipairs(G.discard.cards) do
                if not v.debuff then
                    if v.base.nominal < min then
                        min = v.base.nominal
                    end
                end
            end
            if min then
                local mlt = card.ability.extra.mult_mod * benefits * min
                if mlt ~= 0 then
                    return {
                        mult = mlt
                    }
                end
            end
        end
    end,
    check_for_unlock = function(self, args)
        for _, v in pairs(G.P_CENTER_POOLS["Joker"]) do
            if v.key == "j_sdm_jambo" then
                if get_joker_win_sticker(v, true) >= 8 then
                    return true
                end
                break
            end
        end
    end,
}

--- Ticket ---

Partner_API.Partner{
    key = "free_pass",
    name = "Free Pass Partner",
    unlocked = false,
    discovered = true,
    no_quips = true,
    pos = {x = 2, y = 1},
    atlas = "sdm_partners",
    link_config = {j_sdm_free_pass = 1},
    loc_vars = function(self, info_queue, card)
        local benefits = next(SMODS.find_card("j_sdm_free_pass"))
        return { vars = {(benefits and "and") or "or"} }
    end,
    calculate = function(self, card, context)
        if context.partner_before then
            if (G.GAME and G.GAME.blind.boss) and (next(SMODS.find_card("j_sdm_free_pass")) and not card.ability.sdm_ticket_hand_triggered) or (G.GAME.current_round.discards_used == 0 and G.GAME.current_round.hands_played == 0) then
                card.ability.sdm_ticket_hand_triggered = true
                G.E_MANAGER:add_event(Event({
                    func = function()
                        ease_hands_played(1)
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_hand', vars = {1}}, colour = G.C.BLUE})
                        return true
                    end
                }))
            end
        elseif context.partner_pre_discard then
            if (G.GAME and G.GAME.blind and G.GAME.blind.boss) and (next(SMODS.find_card("j_sdm_free_pass")) and not card.ability.sdm_ticket_discard_triggered) or (G.GAME.current_round.discards_used == 0 and G.GAME.current_round.hands_played == 0) then
                card.ability.sdm_ticket_discard_triggered = true
                G.E_MANAGER:add_event(Event({
                    func = function()
                        ease_discard(1)
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_discard', vars = {1}}, colour = G.C.RED})
                        return true
                    end
                }))
            end
        end
        if context.end_of_round and not (context.individual or context.repetition) then
            card.ability.sdm_ticket_hand_triggered = nil
            card.ability.sdm_ticket_discard_triggered = nil
        end
    end,
    check_for_unlock = function(self, args)
        for _, v in pairs(G.P_CENTER_POOLS["Joker"]) do
            if v.key == "j_sdm_free_pass" then
                if get_joker_win_sticker(v, true) >= 8 then
                    return true
                end
                break
            end
        end
    end,
}

--- Goop ---

Partner_API.Partner{
    key = "ditto_joker",
    name = "Ditto Joker",
    unlocked = false,
    discovered = true,
    no_quips = true,
    pos = {x = 3, y = 1},
    atlas = "sdm_partners",
    link_config = {j_sdm_ditto_joker = 1},
    calculate = function(self, card, context)
        if context.partner_setting_blind then
            local unlocked_partners = {}
            for _, v in pairs(G.P_CENTER_POOLS["Partner"]) do
                if v.key ~= 'pnr_sdm_ditto_joker' and v:is_unlocked() then
                    unlocked_partners[#unlocked_partners+1] = v
                end
            end
            if unlocked_partners[1] then
                local old_card = card
                local chosen_partner = pseudorandom_element(unlocked_partners, pseudoseed('dtp'))
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card:set_ability(G.P_CENTERS[chosen_partner.key])
                        card.ability.sdm_is_partner_ditto = true
                        card.ability.sdm_partner_ditto_ante = 0
                    return true
                end}))
                card_eval_status_text(old_card, 'extra', nil, nil, nil, {
                    message = localize('k_ditto_ex'),
                    colour = HEX('f06bf2'),
                })
            end
        end
    end,
    check_for_unlock = function(self, args)
        for _, v in pairs(G.P_CENTER_POOLS["Joker"]) do
            if v.key == "j_sdm_ditto_joker" then
                if get_joker_win_sticker(v, true) >= 8 then
                    return true
                end
                break
            end
        end
    end,
}