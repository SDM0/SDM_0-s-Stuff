local parameters = NFS.load(SDM_0s_Stuff_Mod.path.."config.lua")()
local config = parameters.config

SMODS.Atlas{
    key = "sdm_enhancers",
    path = "sdm_enhancers.png",
    px = 71,
    py = 95
}

if config.decks then

    --- SDM_0's Deck

    if config.jokers and count_sdm_modded_card("j_", true) > 1 then
        SMODS.Back{
            key = "sdm_0_s_deck",
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
                        rand_jokers = get_random_sdm_modded_card("j_", 2, true)
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

    if config.consumables and count_sdm_modded_card("c_") > 1 then
        SMODS.Back{
            key = "bazaar_deck",
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
        key = "sandbox_deck",
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

    SMODS.Back{
        key = "lucky_7_deck",
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
                    add_joker2("j_sdm_lucky_joker", nil, true, true)
                    return true
                end
            }))
        end,
        atlas = "sdm_enhancers"
    }

    --- Deck Of Stuff

    SMODS.Back{
        key = "deck_of_stuff",
        name = "Deck of Stuff",
        pos = {x = 0, y = 1},
        config = {joker_slot = 2},
        loc_txt = {
            name = "Deck of Stuff",
            text = {
            "Combines every",
            "{C:attention}SDM_0's Stuff{}",
            "deck effect"
            }
        },
        apply = function(back)
            G.GAME.win_ante = 10
            G.E_MANAGER:add_event(Event({
                func = function()
                    for i = #G.playing_cards, 1, -1 do
                        if G.playing_cards[i].base.id == 7 then
                            G.playing_cards[i]:set_ability(G.P_CENTERS.m_lucky)
                        end
                    end
                    rand_jokers = get_random_sdm_modded_card("j_", 2, true)
                    for i = 1, #rand_jokers do
                        add_joker2(rand_jokers[i], nil, true, true)
                    end
                    add_joker2("j_sdm_lucky_joker", nil, true, true)
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

return