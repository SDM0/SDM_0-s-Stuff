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

local sdm_mod_path = SMODS.current_mod.path

function SMODS.current_mod.process_loc_text()
    G.localization.misc.dictionary.k_stone = "Stone"
    G.localization.misc.dictionary.k_signed_ex = "Signed!"
    G.localization.misc.dictionary.k_breached_ex = "Breached!"
    G.localization.misc.dictionary.k_shared_ex = "Shared!"
    G.localization.misc.v_dictionary.a_hand = "+#1# Hand"
end

NFS.load(sdm_mod_path.."utils.lua")()
NFS.load(sdm_mod_path.."overrides.lua")()

NFS.load(sdm_mod_path.."data/jokers.lua")()
NFS.load(sdm_mod_path.."data/challenges.lua")()
NFS.load(sdm_mod_path.."data/decks.lua")()

SMODS.Atlas{
    key = "modicon",
    path = "sdm_modicon.png",
    px = 34,
    py = 34,
}

----------------------------------------------
------------MOD CODE END----------------------