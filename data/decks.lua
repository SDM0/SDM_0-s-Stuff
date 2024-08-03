SMODS.Atlas{
    key = "sdm_enhancers",
    path = "sdm_enhancers.png",
    px = 71,
    py = 95
}

if sdm_config.sdm_decks then

    --- SDM_0's Deck

    if sdm_config.sdm_jokers then
        SMODS.Back{
            key = "b_sdm_0_s",
            name = "SDM_0's Deck",
            pos = {x = 0, y = 0},
            loc_txt = {
                name = "SDM_0's Deck",
                text = {
                    "Start run with",
                    "{C:attention}2{} random {C:eternal}Eternal non-{C:legendary}legendary",
                    "{C:attention}SDM_0's Stuff{} jokers",
                },
            },
            apply = function(back)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        rand_jokers = get_random_sdm_modded_card("j_sdm", 2)
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
            key = "b_bazaar",
            name = "Bazaar Deck",
            pos = {x = 1, y = 0},
            loc_txt = {
                name = "Bazaar Deck",
                text = {
                    "Start run with",
                    "{C:attention}2{} random {C:attention}SDM_0's Stuff{}",
                    "consumables",
                },
            },
            apply = function(back)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        rand_cons = get_random_sdm_modded_card("c_", 2)
                        for i = 1, #rand_cons do
                            local card = create_card('Tarot' or 'Spectral', G.consumeables, nil, nil, nil, nil, "c_sdm_" .. rand_cons[i], 'bzr')
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
        key = "b_sandbox",
        name = "Sandbox Deck",
        pos = {x = 2, y = 0},
        config = {joker_slot = 2},
        loc_txt = {
            name = "Sandbox Deck",
            text = {
                "{C:attention}+2{} Joker Slots",
                "Win at Ante {C:attention}10",
            }
        },
        apply = function(back)
            G.GAME.win_ante = 10
        end,
        atlas = "sdm_enhancers"
    }

    --- Lucky 7 Deck

    if sdm_config.sdm_jokers then
        SMODS.Back{
            key = "b_lucky_7",
            name = "Lucky 7 Deck",
            pos = {x = 3, y = 0},
            loc_txt = {
                name = "Lucky 7 Deck",
                text = {
                    "Start run with",
                    "an {C:eternal}Eternal{} {C:attention}Lucky Joker",
                    "Every {C:attention}7{} is a {C:attention,T:m_lucky}Lucky{} card",
                }
            },
            apply = function(back)
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
        key = "b_dna",
        name = "DNA Deck",
        pos = {x = 1, y = 1},
        loc_txt = {
            name = "DNA Deck",
            text = {
                "Scored cards from",
                "{C:attention}winning poker hand{}",
                "are {C:blue}dupli{C:red}cated{}",
            }
        },
        trigger_effect = function(args)
            if hand_chips and mult then
                if G.GAME.chips + hand_chips * mult > G.GAME.blind.chips then
                    local text, loc_disp_text, poker_hands, scoring_hand, disp_text = G.FUNCS.get_poker_hand_info(G.play.cards)
                    G.E_MANAGER:add_event(Event({func = function()
                        local new_cards = {}
                        for _, v in ipairs(scoring_hand) do
                            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                            local _card = copy_card(v, nil, nil, G.playing_card)
                            table.insert(new_cards, _card)
                            _card:add_to_deck()
                            G.deck.config.card_limit = G.deck.config.card_limit + 1
                            table.insert(G.playing_cards, _card)
                            G.hand:emplace(_card)
                            _card.states.visible = nil
                            _card:start_materialize()
                        end
                        playing_card_joker_effects(new_cards)
                        return true
                    end}))
                end
            end
        end,
        atlas = "sdm_enhancers"
    }

    --- Hieroglyph Deck

    SMODS.Back{
        key = "b_hieroglyph",
        name = "Hieroglyph Deck",
        pos = {x = 2, y = 1},
        config = {spectral_rate = 2, consumables = {'c_ankh'}, joker_slot = -1},
        loc_txt = {
            name = "Hieroglyph Deck",
            text = {
                "{C:spectral}Spectral{} cards may",
                "appear in the shop,",
                "start with an {C:spectral,T:c_ankh}Ankh{} card",
                "{C:red}-1{} Joker Slot",
            }
        },
        atlas = "sdm_enhancers"
    }

    --- XXL Deck

    SMODS.Back{
        key = "b_xxl",
        name = "XXL Deck",
        pos = {x = 3, y = 1},
        loc_txt = {
            name = "XXL Deck",
            text = {
                "Start with {C:attention}double{}",
                "the deck size",
            }
        },
        apply = function(back)
            local extra_cards = {}
            for k, _ in pairs(G.P_CARDS) do
                if string.sub(k,1,4) ~= 'bunc' then -- Avoid giving exotic cards from "Bunco"
                    local s, r = k:match("^(.*)_(.-)$")
                    extra_cards[#extra_cards + 1] = {s = s, r = r}
                end
            end
            G.GAME.starting_params.extra_cards = extra_cards
        end,
        atlas = "sdm_enhancers"
    }

    --- Deck Of Stuff

    SMODS.Back{
        key = "deck_of_stuff",
        name = "Deck of Stuff",
        pos = {x = 0, y = 1},
        config = {spectral_rate = 2, consumables = {'c_ankh'}, joker_slot = 1},
        loc_txt = {
            name = "Deck of Stuff",
            text = {
                "Combines every",
                "{C:attention}SDM_0's Stuff{}",
                "deck effect"
            }
        },
        apply = function(back)
            local extra_cards = {}
            for k, v in pairs(G.P_CARDS) do
                local temp = {}
                for s, r in string.gmatch(k, "([^_]+)_([^_]+)") do
                    temp.s = s
                    temp.r = r
                end
                extra_cards[#extra_cards + 1] = temp
            end
            G.GAME.starting_params.extra_cards = extra_cards
            G.GAME.win_ante = 10
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
                            local card = create_card('Tarot' or 'Spectral', G.consumeables, nil, nil, nil, nil, "c_sdm_" .. rand_cons[i], 'bzr')
                            card:add_to_deck()
                            G.consumeables:emplace(card)
                        end
                    end
                    return true
                end
            }))
        end,
        trigger_effect = function(args)
            if hand_chips and mult then
                if G.GAME.chips + hand_chips * mult > G.GAME.blind.chips then
                    local text, loc_disp_text, poker_hands, scoring_hand, disp_text = G.FUNCS.get_poker_hand_info(G.play.cards)
                    G.E_MANAGER:add_event(Event({func = function()
                        local new_cards = {}
                        for _, v in ipairs(scoring_hand) do
                            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                            local _card = copy_card(v, nil, nil, G.playing_card)
                            table.insert(new_cards, _card)
                            _card:add_to_deck()
                            G.deck.config.card_limit = G.deck.config.card_limit + 1
                            table.insert(G.playing_cards, _card)
                            G.hand:emplace(_card)
                            _card.states.visible = nil
                            _card:start_materialize()
                        end
                        playing_card_joker_effects(new_cards)
                        return true
                    end}))
                end
            end
        end,
        atlas = "sdm_enhancers"
    }
end

return