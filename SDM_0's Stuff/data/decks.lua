local config = SDM_0s_Stuff_Config.config

SMODS.Atlas{
    key = "sdm_enhancers",
    path = "sdm_enhancers.png",
    px = 71,
    py = 95
}

if config.decks then

    --- SDM_0's Deck

    if config.b_sdm_0_s and config.jokers and count_sdm_modded_card("j_sdm", true) > 1 then
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
                        rand_jokers = get_random_sdm_modded_card("j_sdm", 2, true)
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

    if config.b_bazaar and config.consumables and count_sdm_modded_card("c_") > 1 then
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

    if config.b_sandbox then
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
    end

    --- Lucky 7 Deck

    if config.b_lucky_7 then
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

    if config.b_dna then
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
            -- Effect in "overrides.lua"
            atlas = "sdm_enhancers"
        }
    end

    --- Deck Of Stuff

    if config.b_stuff and (config.b_sdm_0_s or config.b_bazaar or config.b_sandbox or config.b_lucky_7) then
        SMODS.Back{
            key = "deck_of_stuff",
            name = "Deck of Stuff",
            pos = {x = 0, y = 1},
            config = {joker_slot = (config.b_sandbox and 2) or 0},
            loc_txt = {
                name = "Deck of Stuff",
                text = {
                "Combines every",
                "{C:attention}SDM_0's Stuff{}",
                "deck effect"
                }
            },
            apply = function(back)
                if config.b_sandbox then
                    G.GAME.win_ante = 10
                end
                G.E_MANAGER:add_event(Event({
                    func = function()
                        if config.b_lucky_7 then
                            for i = #G.playing_cards, 1, -1 do
                                if G.playing_cards[i].base.id == 7 then
                                    G.playing_cards[i]:set_ability(G.P_CENTERS.m_lucky)
                                end
                            end
                            add_joker2("j_sdm_lucky_joker", nil, true, true)
                        end
                        if config.b_sdm_0_s then
                            rand_jokers = get_random_sdm_modded_card("j_sdm", 2, true)
                            for i = 1, #rand_jokers do
                                add_joker2(rand_jokers[i], nil, true, true)
                            end
                        end
                        if config.b_bazaar then
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
            atlas = "sdm_enhancers"
        }
    end
end

return