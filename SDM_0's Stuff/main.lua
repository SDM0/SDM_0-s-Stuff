--- STEAMODDED HEADER
--- MOD_NAME: SDM_0's Stuff
--- MOD_ID: sdm0sstuff
--- MOD_AUTHOR: [SDM_0]
--- MOD_DESCRIPTION: Bunch of stuff I've modded into Balatro. Includes plenty of jokers, decks and challenges. Enjoy!
--- BADGE_COLOUR: c20000
--- DISPLAY_NAME: SDM_0's Stuff
--- PREFIX: sdm
--- VERSION: 1.5.0
--- LOADER_VERSION_GEQ: 1.0.0 

----------------------------------------------
------------MOD CODE -------------------------

SDM_0s_Stuff_Mod = SMODS.current_mod

local parameters = NFS.load(SDM_0s_Stuff_Mod.path.."config.lua")()
local config, space_jokers = parameters.config, parameters.space_jokers

local sj_list = {}
for k, v in pairs(parameters.space_jokers) do
    if v.enable then table.insert(sj_list, "{C:inactive}" .. v.name) end
end

function SDM_0s_Stuff_Mod.process_loc_text()
    G.localization.misc.dictionary.k_halved_ex = "Halved!"
    G.localization.misc.dictionary.k_stone = "Stone"
    G.localization.misc.dictionary.k_signed_ex = "Signed!"
    G.localization.misc.dictionary.k_breached_ex = "Breached!"
    G.localization.misc.dictionary.k_shared_ex = "Shared!"
    G.localization.misc.v_dictionary.a_hand = "+#1# Hand"
    G.localization.descriptions.Other.space_jokers = {
        name = "Space Jokers",
        text = sj_list
    }
end

NFS.load(SDM_0s_Stuff_Mod.path.."utils.lua")()
NFS.load(SDM_0s_Stuff_Mod.path.."overrides.lua")()

NFS.load(SDM_0s_Stuff_Mod.path.."data/jokers.lua")()
NFS.load(SDM_0s_Stuff_Mod.path.."data/challenges.lua")()
NFS.load(SDM_0s_Stuff_Mod.path.."data/decks.lua")()

SMODS.Atlas{
    key = "modicon",
    path = "sdm_modicon.png",
    px = 34,
    py = 34,
}

----------------------------------------------
------------MOD CODE END----------------------