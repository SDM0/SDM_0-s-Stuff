local parameters = NFS.load(SDM_0s_Stuff_Mod.path.."config.lua")()
local config = parameters.config

if config.decks then

    if config.jokers and get_random_sdm_modded_jokers(2, true) then
        SMODS.Back{
            name = "SDM_0's Deck",
            key = "sdm_0_s_deck",
            pos = {x = 5, y = 2},
            config = {b_sdm_sdm_0_s_deck = true},
            loc_txt = {
                name ="SDM_0's Deck",
                text ={
                    "Start run with",
                    "{C:attention}2{} random {C:eternal}Eternal non-{C:legendary}legendary",
                    "{C:attention}SDM_0's Stuff{} jokers",
                },
            }
        }
    end

    SMODS.Back{
        name = "Sandbox Deck",
        key = "sandbox_deck",
        pos = {x = 5, y = 2},
        config = {b_sdm_sandbox_deck = true, joker_slot = 2},
        loc_txt = {
            name ="Sandbox Deck",
            text ={
            "{C:attention}+2{} Joker slots",
            "Win at Ante {C:attention}10",
            }
        }
    }
end

return