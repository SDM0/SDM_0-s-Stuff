--- STEAMODDED HEADER
--- MOD_NAME: Joker Evolution
--- MOD_ID: joker_evolution
--- MOD_AUTHOR: [SDM_0]
--- MOD_DESCRIPTION: Lets you evolve your joker cards into stronger ones!
--- PRIORITY: -1000
--- BADGE_COLOUR: 18cadc
--- DISPLAY_NAME: Joker Evolution
--- PREFIX: evo
--- VERSION: 0.0.1a
--- LOADER_VERSION_GEQ: 1.0.0 

----------------------------------------------
------------MOD CODE -------------------------

JokerEvolution_Mod = SMODS.current_mod

JokerEvolution = {}

function JokerEvolution_Mod.process_loc_text()
	G.localization.misc.dictionary["k_evolution_ex"] = "Evolution!"
	G.localization.misc.dictionary["b_evolve"] = "EVOLVE"
	G.localization.descriptions.Other.je_boss = {
        name = "Evolution",
        text = {
            "Defeat {C:attention}#1#{} boss blind",
			"{C:inactive}({C:attention}#2#{C:inactive}/#1#)"
        }
    }
end

NFS.load(JokerEvolution_Mod.path.."data/jokers.lua")()
NFS.load(JokerEvolution_Mod.path.."data/evolutions.lua")()

NFS.load(JokerEvolution_Mod.path.."overrides.lua")()
NFS.load(JokerEvolution_Mod.path.."functions.lua")()

----------------------------------------------
------------MOD CODE END----------------------