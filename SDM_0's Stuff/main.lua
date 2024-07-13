--- STEAMODDED HEADER
--- MOD_NAME: SDM_0's Stuff
--- MOD_ID: sdm0sstuff
--- MOD_AUTHOR: [SDM_0]
--- MOD_DESCRIPTION: Bunch of stuff I've modded into Balatro. Includes plenty of jokers, decks and challenges. Enjoy!
--- BADGE_COLOUR: c20000
--- DISPLAY_NAME: SDM_0's Stuff
--- PREFIX: sdm
--- VERSION: 1.5.0h
--- LOADER_VERSION_GEQ: 1.0.0 

----------------------------------------------
------------MOD CODE -------------------------

SDM_0s_Stuff_Mod = SMODS.current_mod

NFS.load(SDM_0s_Stuff_Mod.path.."config.lua")()
NFS.load(SDM_0s_Stuff_Mod.path.."localization.lua")()
NFS.load(SDM_0s_Stuff_Mod.path.."utils.lua")()
NFS.load(SDM_0s_Stuff_Mod.path.."overrides.lua")()

NFS.load(SDM_0s_Stuff_Mod.path.."data/jokers.lua")()
NFS.load(SDM_0s_Stuff_Mod.path.."data/challenges.lua")()
NFS.load(SDM_0s_Stuff_Mod.path.."data/consumables.lua")()
NFS.load(SDM_0s_Stuff_Mod.path.."data/decks.lua")()

SMODS.Atlas{
    key = "modicon",
    path = "sdm_modicon.png",
    px = 34,
    py = 34,
}

----------------------------------------------
------------MOD CODE END----------------------